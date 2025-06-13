#!/bin/bash

# Hadoop Single Node Cluster Setup with S3 Integration, Hive, and Spark
# Optimized for micro instances
# This script sets up a complete Hadoop 3.3.6 single node cluster with AWS S3 integration

set -e

# Variables
HADOOP_VERSION=3.3.6
HADOOP_HOME=/opt/hadoop
HADOOP_USER=ec2-user
HADOOP_GROUP=ec2-user
HADOOP_DATA_DIR=/usr/data/hadoop/hdfs/namenode
HADOOP_TMP_DIR=/usr/data/hadoop/tmp
JAVA_VERSION=1.8.0
HOSTNAME=$(hostname -f)
HADOOP_DOWNLOAD_URL="https://downloads.apache.org/hadoop/common/hadoop-${HADOOP_VERSION}/hadoop-${HADOOP_VERSION}.tar.gz"

# Hive and Spark versions
HIVE_VERSION=3.1.3
SPARK_VERSION=3.4.1
HIVE_HOME=/opt/hive
SPARK_HOME=/opt/spark
HIVE_DOWNLOAD_URL="https://dlcdn.apache.org/hive/hive-4.0.1/apache-hive-4.0.1-bin.tar.gz"
SPARK_DOWNLOAD_URL="https://dlcdn.apache.org/spark/spark-3.5.5/spark-3.5.5-bin-hadoop3.tgz"

# AWS S3 Configuration - Replace with your actual values
AWS_ACCESS_KEY="YOUR_ACCESS_KEY"
AWS_SECRET_KEY="YOUR_SECRET_KEY"
AWS_REGION="us-east-1"
S3_ENDPOINT="s3.amazonaws.com"

# Colors for better readability
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Log function
log() {
  echo -e "${GREEN}[$(date +'%Y-%m-%d %H:%M:%S')] $1${NC}"
}

error() {
  echo -e "${RED}[$(date +'%Y-%m-%d %H:%M:%S')] ERROR: $1${NC}" >&2
}

warn() {
  echo -e "${YELLOW}[$(date +'%Y-%m-%d %H:%M:%S')] WARNING: $1${NC}"
}

info() {
  echo -e "${BLUE}[$(date +'%Y-%m-%d %H:%M:%S')] INFO: $1${NC}"
}

# Check if running as root
if [ "$(id -u)" -ne 0 ]; then
  error "This script must be run as root"
  exit 1
fi

# Detect OS
if [ -f /etc/os-release ]; then
  . /etc/os-release
  OS=$NAME
  VER=$VERSION_ID
else
  error "Cannot detect OS"
  exit 1
fi

# Get system memory
TOTAL_MEM_KB=$(grep MemTotal /proc/meminfo | awk '{print $2}')
TOTAL_MEM_MB=$((TOTAL_MEM_KB / 1024))
info "Total system memory: ${TOTAL_MEM_MB}MB"

# Calculate memory settings for micro instance
# For micro instances, we'll use conservative memory settings
# Assuming t2.micro with 1GB RAM
YARN_MEM_MB=$((TOTAL_MEM_MB * 70 / 100)) # 70% of total memory for YARN
YARN_MEM_MB=$((YARN_MEM_MB < 768 ? 768 : YARN_MEM_MB)) # Minimum 768MB
YARN_MEM_MB=$((YARN_MEM_MB > 1024 ? 1024 : YARN_MEM_MB)) # Maximum 1024MB for micro

# Get CPU cores
CPU_CORES=$(grep -c ^processor /proc/cpuinfo)
YARN_CORES=$((CPU_CORES - 1 > 0 ? CPU_CORES - 1 : 1)) # Leave 1 core for OS

info "Configuring for micro instance with ${YARN_MEM_MB}MB RAM and ${YARN_CORES} cores for YARN"

log "Starting Hadoop $HADOOP_VERSION single node cluster setup with S3 integration, Hive, and Spark"
info "OS detected: $OS $VER"
info "Hostname: $HOSTNAME"

# System preparation
log "Updating system and installing dependencies..."
if [[ "$OS" == *"Ubuntu"* ]] || [[ "$OS" == *"Debian"* ]]; then
  export DEBIAN_FRONTEND=noninteractive
  apt-get update -y
  apt-get install -y openjdk-8-jdk wget vim openssh-server chrony rsync net-tools python3 python3-pip
elif [[ "$OS" == *"CentOS"* ]] || [[ "$OS" == *"Red Hat"* ]] || [[ "$OS" == *"Amazon"* ]]; then
  dnf update -y
  dnf install -y java-${JAVA_VERSION}-openjdk java-${JAVA_VERSION}-openjdk-devel wget vim openssh-server chrony rsync net-tools python3 python3-pip
else
  error "Unsupported OS: $OS"
  exit 1
fi

# Ensure user and group exist
log "Ensuring user and group exist..."
if ! getent group $HADOOP_GROUP > /dev/null; then
  groupadd $HADOOP_GROUP
fi

if ! id -u $HADOOP_USER &>/dev/null; then
  useradd -m -g $HADOOP_GROUP $HADOOP_USER
fi

# Disable firewall
log "Checking and disabling firewall..."
if [[ "$OS" == *"Ubuntu"* ]] || [[ "$OS" == *"Debian"* ]]; then
  if systemctl list-unit-files | grep -q ufw.service; then
    systemctl disable --now ufw
  else
    info "Firewall not installed."
  fi
elif [[ "$OS" == *"CentOS"* ]] || [[ "$OS" == *"Red Hat"* ]] || [[ "$OS" == *"Amazon"* ]]; then
  if systemctl list-unit-files | grep -q firewalld.service; then
    systemctl disable --now firewalld
  else
    info "Firewall not installed."
  fi
fi

# Disable SELinux
log "Disabling SELinux..."
if [ -f /etc/selinux/config ]; then
  sed -i 's/^SELINUX=.*/SELINUX=disabled/' /etc/selinux/config
  setenforce 0 || info "SELinux already disabled."
fi

# Disable Transparent Huge Pages (THP)
log "Disabling Transparent Huge Pages (THP)..."
cat <<EOF > /etc/systemd/system/disable-thp.service
[Unit]
Description=Disable Transparent Huge Pages (THP)
After=network.target

[Service]
Type=simple
ExecStart=/bin/bash -c "echo never > /sys/kernel/mm/transparent_hugepage/enabled && echo never > /sys/kernel/mm/transparent_hugepage/defrag"

[Install]
WantedBy=multi-user.target
EOF

systemctl daemon-reexec
systemctl daemon-reload
systemctl enable --now disable-thp.service

# Enable time synchronization
log "Enabling time synchronization..."
systemctl enable --now chronyd

# Apply kernel tuning
log "Applying kernel tuning for micro instance..."
cat <<EOF > /etc/sysctl.d/99-hadoop.conf
vm.swappiness = 1
net.core.somaxconn = 512
net.ipv4.ip_local_port_range = 10000 65000
net.ipv4.tcp_tw_reuse = 1
fs.file-max = 65536
EOF

sysctl -p /etc/sysctl.d/99-hadoop.conf

# Set user limits
log "Setting user limits for micro instance..."
cat <<EOF > /etc/security/limits.d/hadoop.conf
$HADOOP_USER soft nofile 32768
$HADOOP_USER hard nofile 32768
$HADOOP_USER soft nproc 16384
$HADOOP_USER hard nproc 16384
EOF

# Download and setup Hadoop
log "Downloading and setting up Hadoop..."
cd /opt
if [ -d hadoop-${HADOOP_VERSION} ] || [ -L hadoop ]; then
  warn "Hadoop directory already exists. Removing..."
  rm -rf hadoop hadoop-${HADOOP_VERSION}
fi

wget -q $HADOOP_DOWNLOAD_URL -O hadoop.tar.gz
tar -xzf hadoop.tar.gz
mv hadoop-${HADOOP_VERSION} hadoop
chown -R $HADOOP_USER:$HADOOP_GROUP hadoop
rm -f hadoop.tar.gz

# Create necessary directories
log "Creating HDFS and temporary directories..."
mkdir -p $HADOOP_DATA_DIR
mkdir -p $HADOOP_TMP_DIR
chown -R $HADOOP_USER:$HADOOP_GROUP $(dirname $HADOOP_DATA_DIR)
chown -R $HADOOP_USER:$HADOOP_GROUP $HADOOP_TMP_DIR

# Setup environment variables
log "Setting up environment variables for $HADOOP_USER..."
cat <<EOF > /home/$HADOOP_USER/.bashrc
export JAVA_HOME=\$(dirname \$(dirname \$(readlink -f \$(which javac))))
export HADOOP_HOME=$HADOOP_HOME
export HADOOP_CONF_DIR=\$HADOOP_HOME/etc/hadoop
export HIVE_HOME=$HIVE_HOME
export SPARK_HOME=$SPARK_HOME
export PATH=\$PATH:\$HADOOP_HOME/bin:\$HADOOP_HOME/sbin:\$HIVE_HOME/bin:\$SPARK_HOME/bin
export HADOOP_OPTS="-Djava.library.path=\$HADOOP_HOME/lib/native"
export HADOOP_HEAPSIZE=256
export HADOOP_NAMENODE_OPTS="-Xmx256m"
export HDFS_DATANODE_OPTS="-Xmx256m"
export YARN_RESOURCEMANAGER_HEAPSIZE=256
export YARN_NODEMANAGER_HEAPSIZE=256
EOF

# Setup passwordless SSH
log "Setting up passwordless SSH for $HADOOP_USER..."
SSH_DIR="/home/$HADOOP_USER/.ssh"
mkdir -p $SSH_DIR
chown $HADOOP_USER:$HADOOP_GROUP $SSH_DIR
chmod 700 $SSH_DIR

if [ ! -f "$SSH_DIR/id_rsa" ]; then
  su - $HADOOP_USER -c "ssh-keygen -t rsa -P '' -f ~/.ssh/id_rsa"
fi

su - $HADOOP_USER -c "cat ~/.ssh/id_rsa.pub >> ~/.ssh/authorized_keys"
su - $HADOOP_USER -c "chmod 600 ~/.ssh/authorized_keys"
su - $HADOOP_USER -c "ssh-keyscan -H localhost >> ~/.ssh/known_hosts"
su - $HADOOP_USER -c "ssh-keyscan -H 0.0.0.0 >> ~/.ssh/known_hosts"
su - $HADOOP_USER -c "ssh-keyscan -H 127.0.0.1 >> ~/.ssh/known_hosts"
su - $HADOOP_USER -c "ssh-keyscan -H $HOSTNAME >> ~/.ssh/known_hosts"

# Configure Hadoop
log "Configuring Hadoop..."
HADOOP_ETC_DIR=$HADOOP_HOME/etc/hadoop

# Configure hadoop-env.sh
log "Configuring hadoop-env.sh..."
cat <<EOF >> $HADOOP_ETC_DIR/hadoop-env.sh

# Set JAVA_HOME
export JAVA_HOME=\$(dirname \$(dirname \$(readlink -f \$(which javac))))

# Add AWS SDK and Hadoop-AWS jars to the classpath
export HADOOP_CLASSPATH=\$HADOOP_CLASSPATH:\$HADOOP_HOME/share/hadoop/tools/lib/*

# Ensure the AWS SDK and Hadoop-AWS jars are available to MapReduce jobs
export HADOOP_USER_CLASSPATH_FIRST=true

# Set AWS region as environment variable
export AWS_REGION=$AWS_REGION

# Memory settings for micro instance
export HADOOP_HEAPSIZE=256
export HADOOP_NAMENODE_OPTS="-Xmx256m"
export HDFS_DATANODE_OPTS="-Xmx256m"
EOF

# Configure core-site.xml
log "Configuring core-site.xml with S3 integration..."
cat <<EOF > $HADOOP_ETC_DIR/core-site.xml
<?xml version="1.0" encoding="UTF-8"?>
<?xml-stylesheet type="text/xsl" href="configuration.xsl"?>
<configuration>
  <!-- Basic Hadoop Configuration -->
  <property>
    <name>fs.defaultFS</name>
    <value>hdfs://$HOSTNAME:9000</value>
  </property>
  
  <property>
    <name>hadoop.tmp.dir</name>
    <value>$HADOOP_TMP_DIR</value>
  </property>
  
  <!-- S3A Filesystem Implementation -->
  <property>
    <name>fs.s3a.impl</name>
    <value>org.apache.hadoop.fs.s3a.S3AFileSystem</value>
  </property>
  
  <!-- AWS S3 Connector Configuration -->
  <property>
    <name>fs.s3a.access.key</name>
    <value>$AWS_ACCESS_KEY</value>
  </property>
  
  <property>
    <name>fs.s3a.secret.key</name>
    <value>$AWS_SECRET_KEY</value>
  </property>
  
  <property>
    <name>fs.s3a.endpoint</name>
    <value>$S3_ENDPOINT</value>
  </property>
  
  <property>
    <name>fs.s3a.region</name>
    <value>$AWS_REGION</value>
  </property>
  
  <!-- Connection Configuration -->
  <property>
    <name>fs.s3a.connection.maximum</name>
    <value>15</value>
  </property>
  
  <property>
    <name>fs.s3a.connection.timeout</name>
    <value>200000</value>
  </property>
  
  <!-- Performance Tuning -->
  <property>
    <name>fs.s3a.threads.max</name>
    <value>5</value>
  </property>
  
  <property>
    <name>fs.s3a.connection.establish.timeout</name>
    <value>5000</value>
  </property>
  
  <property>
    <name>fs.s3a.attempts.maximum</name>
    <value>10</value>
  </property>
  
  <!-- Read/Write Performance -->
  <property>
    <name>fs.s3a.readahead.range</name>
    <value>64K</value>
  </property>
  
  <property>
    <name>fs.s3a.multipart.size</name>
    <value>5M</value>
  </property>
  
  <property>
    <name>fs.s3a.multipart.threshold</name>
    <value>5M</value>
  </property>
  
  <!-- Fast Upload Configuration -->
  <property>
    <name>fs.s3a.fast.upload</name>
    <value>true</value>
  </property>
  
  <property>
    <name>fs.s3a.fast.upload.buffer</name>
    <value>array</value>
  </property>
  
  <!-- AWS SDK Connection Settings -->
  <property>
    <name>fs.s3a.connection.ssl.enabled</name>
    <value>true</value>
  </property>
  
  <!-- For Hive/Spark Integration -->
  <property>
    <name>fs.s3a.buffer.dir</name>
    <value>$HADOOP_TMP_DIR/s3a</value>
  </property>
  
  <!-- Input Strategy for Hive/Spark -->
  <property>
    <name>fs.s3a.experimental.input.fadvise</name>
    <value>sequential</value>
  </property>
  
  <!-- Committer Configuration for Spark/Hive -->
  <property>
    <name>fs.s3a.committer.name</name>
    <value>magic</value>
  </property>
  
  <!-- Retry Configuration -->
  <property>
    <name>fs.s3a.retry.limit</name>
    <value>5</value>
  </property>
  
  <property>
    <name>fs.s3a.retry.interval</name>
    <value>500ms</value>
  </property>
</configuration>
EOF

# Configure hdfs-site.xml
log "Configuring hdfs-site.xml..."
cat <<EOF > $HADOOP_ETC_DIR/hdfs-site.xml
<?xml version="1.0" encoding="UTF-8"?>
<?xml-stylesheet type="text/xsl" href="configuration.xsl"?>
<configuration>
  <property>
    <name>dfs.replication</name>
    <value>1</value>
  </property>
  
  <property>
    <name>dfs.namenode.name.dir</name>
    <value>file://$HADOOP_DATA_DIR</value>
  </property>
  
  <property>
    <name>dfs.datanode.data.dir</name>
    <value>file://$HADOOP_TMP_DIR/datanode</value>
  </property>
  
  <property>
    <name>dfs.permissions.enabled</name>
    <value>true</value>
  </property>
  
  <property>
    <name>dfs.webhdfs.enabled</name>
    <value>true</value>
  </property>
  
  <!-- Memory optimizations for micro instance -->
  <property>
    <name>dfs.namenode.handler.count</name>
    <value>5</value>
  </property>
  
  <property>
    <name>dfs.datanode.handler.count</name>
    <value>5</value>
  </property>
  
  <property>
    <name>dfs.namenode.secondary.http-address</name>
    <value>$HOSTNAME:9868</value>
  </property>
</configuration>
EOF

# Configure mapred-site.xml
log "Configuring mapred-site.xml..."
cat <<EOF > $HADOOP_ETC_DIR/mapred-site.xml
<?xml version="1.0" encoding="UTF-8"?>
<?xml-stylesheet type="text/xsl" href="configuration.xsl"?>
<configuration>
  <property>
    <name>mapreduce.framework.name</name>
    <value>yarn</value>
  </property>
  
  <property>
    <name>mapreduce.application.classpath</name>
    <value>\$HADOOP_MAPRED_HOME/share/hadoop/mapreduce/*:\$HADOOP_MAPRED_HOME/share/hadoop/mapreduce/lib/*:\$HADOOP_MAPRED_HOME/share/hadoop/tools/lib/*</value>
  </property>
  
  <property>
    <name>yarn.app.mapreduce.am.env</name>
    <value>HADOOP_MAPRED_HOME=\$HADOOP_HOME</value>
  </property>
  
  <property>
    <name>mapreduce.map.env</name>
    <value>HADOOP_MAPRED_HOME=\$HADOOP_HOME</value>
  </property>
  
  <property>
    <name>mapreduce.reduce.env</name>
    <value>HADOOP_MAPRED_HOME=\$HADOOP_HOME</value>
  </property>
  
  <!-- Memory optimizations for micro instance -->
  <property>
    <name>mapreduce.map.memory.mb</name>
    <value>256</value>
  </property>
  
  <property>
    <name>mapreduce.reduce.memory.mb</name>
    <value>512</value>
  </property>
  
  <property>
    <name>mapreduce.map.java.opts</name>
    <value>-Xmx204m</value>
  </property>
  
  <property>
    <name>mapreduce.reduce.java.opts</name>
    <value>-Xmx409m</value>
  </property>
  
  <property>
    <name>mapreduce.job.reduces</name>
    <value>1</value>
  </property>
  
  <property>
    <name>mapreduce.tasktracker.map.tasks.maximum</name>
    <value>2</value>
  </property>
  
  <property>
    <name>mapreduce.tasktracker.reduce.tasks.maximum</name>
    <value>1</value>
  </property>
</configuration>
EOF

# Configure yarn-site.xml
log "Configuring yarn-site.xml..."
cat <<EOF > $HADOOP_ETC_DIR/yarn-site.xml
<?xml version="1.0" encoding="UTF-8"?>
<?xml-stylesheet type="text/xsl" href="configuration.xsl"?>
<configuration>
  <property>
    <name>yarn.nodemanager.aux-services</name>
    <value>mapreduce_shuffle</value>
  </property>
  
  <property>
    <name>yarn.nodemanager.env-whitelist</name>
    <value>JAVA_HOME,HADOOP_COMMON_HOME,HADOOP_HDFS_HOME,HADOOP_CONF_DIR,CLASSPATH_PREPEND_DISTCACHE,HADOOP_YARN_HOME,HADOOP_MAPRED_HOME</value>
  </property>
  
  <!-- Memory optimizations for micro instance -->
  <property>
    <name>yarn.nodemanager.resource.memory-mb</name>
    <value>${YARN_MEM_MB}</value>
  </property>
  
  <property>
    <name>yarn.scheduler.maximum-allocation-mb</name>
    <value>${YARN_MEM_MB}</value>
  </property>
  
  <property>
    <name>yarn.scheduler.minimum-allocation-mb</name>
    <value>128</value>
  </property>
  
  <property>
    <name>yarn.nodemanager.resource.cpu-vcores</name>
    <value>${YARN_CORES}</value>
  </property>
  
  <property>
    <name>yarn.nodemanager.vmem-check-enabled</name>
    <value>false</value>
  </property>
  
  <property>
    <name>yarn.nodemanager.pmem-check-enabled</name>
    <value>false</value>
  </property>
  
  <property>
    <name>yarn.scheduler.capacity.root.queues</name>
    <value>default</value>
  </property>
  
  <property>
    <name>yarn.scheduler.capacity.root.default.capacity</name>
    <value>100</value>
  </property>
</configuration>
EOF

# Copy AWS SDK and Hadoop-AWS jars to the Hadoop classpath
log "Ensuring AWS SDK and Hadoop-AWS jars are available..."
mkdir -p $HADOOP_HOME/share/hadoop/tools/lib/
if [ ! -f "$HADOOP_HOME/share/hadoop/tools/lib/hadoop-aws-$HADOOP_VERSION.jar" ]; then
  # Try to find the jar in the existing installation
  if [ -f "$HADOOP_HOME/share/hadoop/common/lib/hadoop-aws-$HADOOP_VERSION.jar" ]; then
    cp $HADOOP_HOME/share/hadoop/common/lib/hadoop-aws-$HADOOP_VERSION.jar $HADOOP_HOME/share/hadoop/tools/lib/
  else
    warn "hadoop-aws-$HADOOP_VERSION.jar not found. You may need to download it separately."
  fi
fi

if [ ! -f "$HADOOP_HOME/share/hadoop/tools/lib/aws-java-sdk-bundle-*.jar" ]; then
  # Try to find the jar in the existing installation
  AWS_SDK_JAR=$(find $HADOOP_HOME -name "aws-java-sdk-bundle-*.jar" | head -1)
  if [ -n "$AWS_SDK_JAR" ]; then
    # Check if source and destination are different before copying
    AWS_SDK_JAR_DEST="$HADOOP_HOME/share/hadoop/tools/lib/$(basename $AWS_SDK_JAR)"
    if [ "$AWS_SDK_JAR" != "$AWS_SDK_JAR_DEST" ]; then
      cp $AWS_SDK_JAR $HADOOP_HOME/share/hadoop/tools/lib/
    else
      info "AWS SDK jar already in the correct location: $AWS_SDK_JAR"
    fi
  else
    warn "aws-java-sdk-bundle jar not found. You may need to download it separately."
  fi
fi

# Install Hive
log "Installing Apache Hive..."
cd /opt
if [ -d apache-hive-${HIVE_VERSION}-bin ] || [ -L hive ]; then
  warn "Hive directory already exists. Removing..."
  rm -rf hive apache-hive-${HIVE_VERSION}-bin
fi

log "Downloading Hive from $HIVE_DOWNLOAD_URL..."
wget --progress=dot:giga $HIVE_DOWNLOAD_URL -O hive.tar.gz || { error "Failed to download Hive. Please check your internet connection and the URL."; exit 1; }
tar -xzf hive.tar.gz
mv apache-hive-${HIVE_VERSION}-bin hive
chown -R $HADOOP_USER:$HADOOP_GROUP hive
rm -f hive.tar.gz

# Configure Hive
log "Configuring Hive..."
mkdir -p $HIVE_HOME/conf
cat <<EOF > $HIVE_HOME/conf/hive-site.xml
<?xml version="1.0" encoding="UTF-8" standalone="no"?>
<?xml-stylesheet type="text/xsl" href="configuration.xsl"?>
<configuration>
  <property>
    <name>javax.jdo.option.ConnectionURL</name>
    <value>jdbc:derby:;databaseName=/opt/hive/metastore_db;create=true</value>
    <description>JDBC connect string for a JDBC metastore</description>
  </property>
  
  <property>
    <name>javax.jdo.option.ConnectionDriverName</name>
    <value>org.apache.derby.jdbc.EmbeddedDriver</value>
    <description>Driver class name for a JDBC metastore</description>
  </property>
  
  <property>
    <name>hive.metastore.warehouse.dir</name>
    <value>/user/hive/warehouse</value>
    <description>location of default database for the warehouse</description>
  </property>
  
  <property>
    <name>hive.metastore.uris</name>
    <value/>
    <description>Thrift URI for the remote metastore</description>
  </property>
  
  <property>
    <name>hive.server2.enable.doAs</name>
    <value>false</value>
  </property>
  
  <!-- S3 Integration -->
  <property>
    <name>fs.s3a.access.key</name>
    <value>$AWS_ACCESS_KEY</value>
  </property>
  
  <property>
    <name>fs.s3a.secret.key</name>
    <value>$AWS_SECRET_KEY</value>
  </property>
  
  <property>
    <name>fs.s3a.endpoint</name>
    <value>$S3_ENDPOINT</value>
  </property>
  
  <!-- Memory optimizations for micro instance -->
  <property>
    <name>hive.metastore.client.socket.timeout</name>
    <value>300</value>
  </property>
  
  <property>
    <name>hive.metastore.warehouse.dir</name>
    <value>/user/hive/warehouse</value>
  </property>
  
  <property>
    <name>hive.exec.scratchdir</name>
    <value>/tmp/hive</value>
  </property>
  
  <property>
    <name>hive.exec.reducers.max</name>
    <value>1</value>
  </property>
  
  <property>
    <name>hive.execution.engine</name>
    <value>mr</value>
  </property>
  
  <property>
    <name>hive.vectorized.execution.enabled</name>
    <value>false</value>
  </property>
</configuration>
EOF

# Create Hive directories in HDFS
log "Creating Hive directories..."
mkdir -p /tmp/hive
chown -R $HADOOP_USER:$HADOOP_GROUP /tmp/hive

# Install Spark
log "Installing Apache Spark..."
cd /opt
if [ -d spark-${SPARK_VERSION}-bin-hadoop3 ] || [ -L spark ]; then
  warn "Spark directory already exists. Removing..."
  rm -rf spark spark-${SPARK_VERSION}-bin-hadoop3
fi

wget -q $SPARK_DOWNLOAD_URL -O spark.tgz
tar -xzf spark.tgz
mv spark-${SPARK_VERSION}-bin-hadoop3 spark
chown -R $HADOOP_USER:$HADOOP_GROUP spark
rm -f spark.tgz

# Configure Spark
log "Configuring Spark..."
cp $SPARK_HOME/conf/spark-defaults.conf.template $SPARK_HOME/conf/spark-defaults.conf
cat <<EOF >> $SPARK_HOME/conf/spark-defaults.conf
# Memory settings for micro instance
spark.driver.memory 512m
spark.executor.memory 512m
spark.yarn.am.memory 512m
spark.executor.instances 1
spark.executor.cores 1
spark.driver.cores 1

# S3 configuration
spark.hadoop.fs.s3a.impl org.apache.hadoop.fs.s3a.S3AFileSystem
spark.hadoop.fs.s3a.access.key ${AWS_ACCESS_KEY}
spark.hadoop.fs.s3a.secret.key ${AWS_SECRET_KEY}
spark.hadoop.fs.s3a.endpoint ${S3_ENDPOINT}
spark.hadoop.fs.s3a.connection.maximum 15
spark.hadoop.fs.s3a.fast.upload true

# Performance optimizations
spark.serializer org.apache.spark.serializer.KryoSerializer
spark.speculation false
spark.shuffle.service.enabled false
spark.dynamicAllocation.enabled false
EOF

cp $SPARK_HOME/conf/spark-env.sh.template $SPARK_HOME/conf/spark-env.sh
cat <<EOF >> $SPARK_HOME/conf/spark-env.sh
#!/usr/bin/env bash
export JAVA_HOME=\$(dirname \$(dirname \$(readlink -f \$(which javac))))
export HADOOP_HOME=$HADOOP_HOME
export HADOOP_CONF_DIR=$HADOOP_HOME/etc/hadoop
export SPARK_HOME=$SPARK_HOME
export SPARK_DIST_CLASSPATH=\$(hadoop classpath)
export SPARK_MASTER_HOST=$HOSTNAME
export SPARK_LOCAL_IP=$HOSTNAME
export SPARK_WORKER_MEMORY=512m
export SPARK_DRIVER_MEMORY=512m
export SPARK_EXECUTOR_MEMORY=512m
export SPARK_DAEMON_MEMORY=512m
export SPARK_WORKER_CORES=1
export SPARK_EXECUTOR_CORES=1
export SPARK_DRIVER_CORES=1
EOF

# Copy necessary jars for S3 integration
log "Copying AWS jars to Hive and Spark..."
mkdir -p $HIVE_HOME/lib/
mkdir -p $SPARK_HOME/jars/

# Copy AWS jars to Hive
if [ -f "$HADOOP_HOME/share/hadoop/tools/lib/hadoop-aws-$HADOOP_VERSION.jar" ]; then
  cp $HADOOP_HOME/share/hadoop/tools/lib/hadoop-aws-$HADOOP_VERSION.jar $HIVE_HOME/lib/
fi

AWS_SDK_JAR=$(find $HADOOP_HOME -name "aws-java-sdk-bundle-*.jar" | head -1)
if [ -n "$AWS_SDK_JAR" ]; then
  cp $AWS_SDK_JAR $HIVE_HOME/lib/
fi

# Copy AWS jars to Spark
if [ -f "$HADOOP_HOME/share/hadoop/tools/lib/hadoop-aws-$HADOOP_VERSION.jar" ]; then
  cp $HADOOP_HOME/share/hadoop/tools/lib/hadoop-aws-$HADOOP_VERSION.jar $SPARK_HOME/jars/
fi

if [ -n "$AWS_SDK_JAR" ]; then
  cp $AWS_SDK_JAR $SPARK_HOME/jars/
fi

# Format HDFS namenode
log "Formatting HDFS namenode..."
su - $HADOOP_USER -c "$HADOOP_HOME/bin/hdfs namenode -format -force"

# Initialize Hive metastore
log "Initializing Hive metastore..."
su - $HADOOP_USER -c "$HIVE_HOME/bin/schematool -dbType derby -initSchema"

# Create start and stop scripts
log "Creating start and stop scripts..."

cat <<EOF > /home/$HADOOP_USER/start-hadoop.sh
#!/bin/bash
echo "Starting Hadoop services..."
$HADOOP_HOME/sbin/start-dfs.sh
$HADOOP_HOME/sbin/start-yarn.sh
echo "Hadoop services started."

# Create HDFS directories for Hive if they don't exist
echo "Creating HDFS directories for Hive..."
$HADOOP_HOME/bin/hadoop fs -mkdir -p /tmp
$HADOOP_HOME/bin/hadoop fs -mkdir -p /user/hive/warehouse
$HADOOP_HOME/bin/hadoop fs -chmod g+w /tmp
$HADOOP_HOME/bin/hadoop fs -chmod g+w /user/hive/warehouse

echo "To check if services are running:"
echo "  jps"
echo "To access web interfaces:"
echo "  NameNode: http://$HOSTNAME:9870"
echo "  ResourceManager: http://$HOSTNAME:8088"
EOF

cat <<EOF > /home/$HADOOP_USER/start-hive.sh
#!/bin/bash
echo "Starting Hive Metastore..."
nohup $HIVE_HOME/bin/hive --service metastore > /home/$HADOOP_USER/hive_metastore.log 2>&1 &
echo "Starting HiveServer2..."
nohup $HIVE_HOME/bin/hiveserver2 > /home/$HADOOP_USER/hiveserver2.log 2>&1 &
echo "Hive services started."
echo "To connect to Hive:"
echo "  $HIVE_HOME/bin/beeline -u jdbc:hive2://localhost:10000"
EOF

cat <<EOF > /home/$HADOOP_USER/start-spark.sh
#!/bin/bash
echo "Starting Spark Master..."
$SPARK_HOME/sbin/start-master.sh
echo "Starting Spark Worker..."
$SPARK_HOME/sbin/start-worker.sh spark://$HOSTNAME:7077
echo "Spark services started."
echo "To access Spark web interface:"
echo "  Spark Master: http://$HOSTNAME:8080"
EOF

cat <<EOF > /home/$HADOOP_USER/stop-hadoop.sh
#!/bin/bash
echo "Stopping Hadoop services..."
$HADOOP_HOME/sbin/stop-yarn.sh
$HADOOP_HOME/sbin/stop-dfs.sh
echo "Hadoop services stopped."
EOF

cat <<EOF > /home/$HADOOP_USER/stop-hive.sh
#!/bin/bash
echo "Stopping Hive services..."
pkill -f org.apache.hive.service.server.HiveServer2
pkill -f org.apache.hadoop.hive.metastore.HiveMetaStore
echo "Hive services stopped."
EOF

cat <<EOF > /home/$HADOOP_USER/stop-spark.sh
#!/bin/bash
echo "Stopping Spark services..."
$SPARK_HOME/sbin/stop-worker.sh
$SPARK_HOME/sbin/stop-master.sh
echo "Spark services stopped."
EOF

cat <<EOF > /home/$HADOOP_USER/stop-all.sh
#!/bin/bash
echo "Stopping all services..."
$HOME/stop-spark.sh
$HOME/stop-hive.sh
$HOME/stop-hadoop.sh
echo "All services stopped."
EOF

cat <<EOF > /home/$HADOOP_USER/test-s3.sh
#!/bin/bash
echo "Testing S3 connectivity..."
echo "Listing S3 buckets:"
hadoop fs -ls s3a://
echo ""
echo "If you see an error above, check your AWS credentials and S3 configuration."
echo "If successful, you should see a list of your S3 buckets."
EOF

cat <<EOF > /home/$HADOOP_USER/test-hive-s3.sh
#!/bin/bash
echo "Testing Hive with S3..."
echo "Creating a test table in Hive that points to S3..."
$HIVE_HOME/bin/hive -e "
CREATE EXTERNAL TABLE IF NOT EXISTS s3_test (
  id INT,
  name STRING
)
ROW FORMAT DELIMITED
FIELDS TERMINATED BY ','
STORED AS TEXTFILE
LOCATION 's3a://your-bucket/hive-test/';

SHOW TABLES;
"
echo ""
echo "If successful, you should see 's3_test' in the list of tables."
echo "Remember to replace 'your-bucket' with your actual S3 bucket name."
EOF

cat <<EOF > /home/$HADOOP_USER/test-spark-s3.sh
#!/bin/bash
echo "Testing Spark with S3..."
echo "Creating a test Spark application that reads from S3..."
cat > /home/$HADOOP_USER/spark_s3_test.py << 'PYEOF'
from pyspark.sql import SparkSession

# Initialize Spark session with S3 support
spark = SparkSession.builder \
    .appName("S3 Test") \
    .config("spark.hadoop.fs.s3a.impl", "org.apache.hadoop.fs.s3a.S3AFileSystem") \
    .getOrCreate()

# Replace with your bucket name
bucket = "your-bucket"
try:
    # List files in the S3 bucket
    files = spark.sparkContext._jvm.org.apache.hadoop.fs.FileSystem.get(
        spark.sparkContext._jsc.hadoopConfiguration()
    ).listStatus(
        spark.sparkContext._jvm.org.apache.hadoop.fs.Path(f"s3a://{bucket}/")
    )
    
    print("Files in S3 bucket:")
    for file in files:
        print(file.getPath())
    
    print("S3 connection successful!")
except Exception as e:
    print(f"Error connecting to S3: {str(e)}")

spark.stop()
PYEOF

echo "Running the Spark application..."
$SPARK_HOME/bin/spark-submit --master local[1] /home/$HADOOP_USER/spark_s3_test.py
echo ""
echo "Remember to replace 'your-bucket' in the script with your actual S3 bucket name."
EOF

chmod +x /home/$HADOOP_USER/start-hadoop.sh
chmod +x /home/$HADOOP_USER/start-hive.sh
chmod +x /home/$HADOOP_USER/start-spark.sh
chmod +x /home/$HADOOP_USER/stop-hadoop.sh
chmod +x /home/$HADOOP_USER/stop-hive.sh
chmod +x /home/$HADOOP_USER/stop-spark.sh
chmod +x /home/$HADOOP_USER/stop-all.sh
chmod +x /home/$HADOOP_USER/test-s3.sh
chmod +x /home/$HADOOP_USER/test-hive-s3.sh
chmod +x /home/$HADOOP_USER/test-spark-s3.sh
chown $HADOOP_USER:$HADOOP_GROUP /home/$HADOOP_USER/start-hadoop.sh
chown $HADOOP_USER:$HADOOP_GROUP /home/$HADOOP_USER/start-hive.sh
chown $HADOOP_USER:$HADOOP_GROUP /home/$HADOOP_USER/start-spark.sh
chown $HADOOP_USER:$HADOOP_GROUP /home/$HADOOP_USER/stop-hadoop.sh
chown $HADOOP_USER:$HADOOP_GROUP /home/$HADOOP_USER/stop-hive.sh
chown $HADOOP_USER:$HADOOP_GROUP /home/$HADOOP_USER/stop-spark.sh
chown $HADOOP_USER:$HADOOP_GROUP /home/$HADOOP_USER/stop-all.sh
chown $HADOOP_USER:$HADOOP_GROUP /home/$HADOOP_USER/test-s3.sh
chown $HADOOP_USER:$HADOOP_GROUP /home/$HADOOP_USER/test-hive-s3.sh
chown $HADOOP_USER:$HADOOP_GROUP /home/$HADOOP_USER/test-spark-s3.sh
chown $HADOOP_USER:$HADOOP_GROUP /home/$HADOOP_USER/spark_s3_test.py

# Create verification script
log "Creating verification script..."
cat <<EOF > /home/$HADOOP_USER/verify-all.sh
#!/bin/bash
echo "Verifying Hadoop, Hive, and Spark installation..."
echo ""
echo "Java version:"
java -version
echo ""
echo "Hadoop version:"
hadoop version
echo ""
echo "Hive version:"
hive --version
echo ""
echo "Spark version:"
spark-submit --version
echo ""
echo "JAVA_HOME: \$JAVA_HOME"
echo "HADOOP_HOME: \$HADOOP_HOME"
echo "HIVE_HOME: \$HIVE_HOME"
echo "SPARK_HOME: \$SPARK_HOME"
echo ""
echo "Running processes:"
jps
echo ""
echo "HDFS report:"
hdfs dfsadmin -report
echo ""
echo "YARN node status:"
yarn node -list
echo ""
echo "Testing HDFS:"
echo "test" > /tmp/test.txt
hadoop fs -put /tmp/test.txt /test.txt
hadoop fs -ls /
hadoop fs -cat /test.txt
hadoop fs -rm /test.txt
echo ""
echo "Verification complete."
EOF

chmod +x /home/$HADOOP_USER/verify-all.sh
chown $HADOOP_USER:$HADOOP_GROUP /home/$HADOOP_USER/verify-all.sh

# Create a README file
log "Creating README file..."
cat <<EOF > /home/$HADOOP_USER/README.txt
Hadoop Single Node Cluster with S3 Integration, Hive, and Spark
==============================================================

This Hadoop cluster has been set up with AWS S3 integration, Hive, and Spark.
It is optimized for micro instances with limited memory and CPU resources.

Important Directories:
- Hadoop Home: $HADOOP_HOME
- Hadoop Config: $HADOOP_HOME/etc/hadoop
- HDFS Namenode: $HADOOP_DATA_DIR
- Hadoop Temp: $HADOOP_TMP_DIR
- Hive Home: $HIVE_HOME
- Spark Home: $SPARK_HOME

Starting Services:
1. Start Hadoop:
   ./start-hadoop.sh

2. Start Hive:
   ./start-hive.sh

3. Start Spark:
   ./start-spark.sh

Stopping Services:
1. Stop Hadoop:
   ./stop-hadoop.sh

2. Stop Hive:
   ./stop-hive.sh

3. Stop Spark:
   ./stop-spark.sh

4. Stop All Services:
   ./stop-all.sh

Testing and Verification:
1. Verify All Components:
   ./verify-all.sh

2. Test S3 Connectivity:
   ./test-s3.sh

3. Test Hive with S3:
   ./test-hive-s3.sh

4. Test Spark with S3:
   ./test-spark-s3.sh

5. Check running services:
   jps

Web Interfaces:
- NameNode: http://$HOSTNAME:9870
- ResourceManager: http://$HOSTNAME:8088
- NodeManager: http://$HOSTNAME:8042
- Spark Master: http://$HOSTNAME:8080

Using Hive:
1. Start Hive CLI:
   hive

2. Start Beeline (JDBC client):
   beeline -u jdbc:hive2://localhost:10000

Using Spark:
1. Start Spark Shell:
   spark-shell

2. Start PySpark:
   pyspark

3. Submit Spark Application:
   spark-submit --master local[1] your_application.py

Note: Replace 'your-bucket' with your actual S3 bucket name in the test scripts.

Memory Optimization:
This setup is optimized for micro instances with limited resources.
- YARN memory: ${YARN_MEM_MB}MB
- YARN cores: ${YARN_CORES}
- Spark memory: 512MB per component
EOF

chown $HADOOP_USER:$HADOOP_GROUP /home/$HADOOP_USER/README.txt

# Final setup
log "Setting correct permissions..."
chown -R $HADOOP_USER:$HADOOP_GROUP $HADOOP_HOME
chown -R $HADOOP_USER:$HADOOP_GROUP $HIVE_HOME
chown -R $HADOOP_USER:$HADOOP_GROUP $SPARK_HOME
chown -R $HADOOP_USER:$HADOOP_GROUP $HADOOP_DATA_DIR
chown -R $HADOOP_USER:$HADOOP_GROUP $HADOOP_TMP_DIR

log "Hadoop $HADOOP_VERSION single node cluster setup with S3 integration, Hive, and Spark completed successfully!"
log "This setup is optimized for micro instances with limited resources."
log "Please update the AWS credentials in core-site.xml with your actual values."
log "Login as: su - $HADOOP_USER"
log "Start Hadoop using: ./start-hadoop.sh"
log "Start Hive using: ./start-hive.sh"
log "Start Spark using: ./start-spark.sh"
log "Verify installation using: ./verify-all.sh"
log "Test S3 connectivity using: ./test-s3.sh"
