# 🔐 Enterprise-Grade Secure Hadoop Cluster Deployment with Active Directory Integration

## 🎯 Goal of the Task

Deploy a **highly secure and enterprise-ready Hadoop cluster** with:

- Integration with **Active Directory (AD)** using **Kerberos (KDC)**
- Protection against **internal threats** (packet sniffing, unauthorized access)
- **Data-at-rest** and **data-in-motion encryption**
- **Multi-AZ deployment** (AZ-1, AZ-2, AZ-3) with **Spine-Leaf network routing**
- **Role-based access control (RBAC)** and **user-level permission enforcement**

## 📈 Architecture Overview

### 🔧 Core Components

| Component | Purpose |
|-----------|---------|
| **Active Directory Domain** | `HADOOPSECURITY.LOCAL` - Central authentication |
| **Kerberos Server (KDC)** | Authentication server for secure access |
| **Cloudera Manager** | Centralized Hadoop cluster management |
| **MySQL** | Backend database for Cloudera services |
| **Hadoop HDFS** | Distributed data storage layer |
| **WireShark** | Network monitoring for threat detection |

### 🌐 Network Architecture

- **Multi-AZ Deployment**: AZ-1, AZ-2, AZ-3
- **Connectivity**: Spine Network Router
- **Security**: TLS encryption, firewall protection

## 🔐 Security Framework

### 🛡️ Threat Protection

**Internal Threats:**
- Packet sniffing protection via WireShark monitoring
- Network traffic encryption
- User-level audit trails
- Authorization checks with `sudo`, `chown`, `groupmod`

**Encryption Layers:**
- **At-Rest**: HDFS replication with permission model
- **In-Motion**: TLS/Kerberos between nodes
- **JVM Encryption**: For sensitive services

### ✅ Security Best Practices

- Enable **Auto-TLS** for certificate-based encryption
- Use **`openssl s_client`** for connection verification
- Configure **firewalls and SSH hardening**
- Implement **role-based access control**

## 📋 Step-by-Step Setup Procedure

### 1️⃣ Initial Configuration

```bash
# Configure hostname resolution
sudo nano /etc/hosts
# Add: hadoop-ad.hadoopsecurity.local
```

### 2️⃣ Install Required Packages

```bash
# Install Kerberos client components
./clustercmd.sh sudo yum install krb5-workstation -y
./clustercmd.sh sudo yum install krb5-libs -y
```

### 3️⃣ Kerberos Configuration

Create `/etc/krb5.conf`:

```ini
[libdefaults]
default_realm = HADOOPSECURITY.LOCAL
dns_lookup_realm = true
dns_lookup_kdc = true
ticket_lifetime = 24h
renew_lifetime = 7d
forwardable = true
rdns = false
default_ccache_name = KEYRING:persistent:%{uid}
```

### 4️⃣ Service Verification

```bash
# Check MySQL service
sudo service mysql status

# Verify Cloudera Manager port
ss -tlp | grep 7180
```

### 5️⃣ HDFS Access Setup

```bash
# Switch to HDFS user
sudo su
sudo su dfs
cd /dfs/nameservice/current/finalize
```

### 6️⃣ User Management

```bash
# Create new user
sudo useradd jinga
sudo passwd jinga

# Setup user HDFS directory
sudo su jinga
hadoop fs -mkdir /user/jinga
hadoop fs -chown -R jinga:supergroup /user/jinga
```

### 7️⃣ Data Operations

```bash
# Create and upload test data
vi dataatrest
hdfs dfs -put ~/dataatrest /user/jinga

# Inspect data blocks
ls -i dataatrest
cat blk_1123839
```

### 8️⃣ Network Monitoring

```bash
# Install WireShark for monitoring
sudo yum install wireshark-gtk -y

# Monitor network traffic
ip addr
sudo dumpcap -i eth0
```

## 🔧 Advanced Configurations

### Active Directory Integration

**Setup Process:**
1. Use `Add Roles and Features` in Windows Server
2. Install `Active Directory Domain Services`
3. Synchronize `krb5.conf` with KDC
4. Use `kinit` for Kerberos authentication

### Machine Roles

| Role | Function |
|------|----------|
| **Orchestration Node** | Service deployment and management |
| **Gateway Machine** | Data interface and access point |
| **Worker Nodes** | Job execution and data processing |

### Trust Relationships

- **One-Way Trust**: AD to cluster (recommended for security)
- **Two-Way Trust**: Full bidirectional authentication

## 🔍 Verification and Maintenance

### System Health Checks

```bash
# Verify HDFS status
hdfs dfs -ls /

# Check Cloudera Manager
ss -tlp | grep 7180

# File system check
hdfs fsck /user/jinga/dataatrest
```

### User Management

```bash
# Remove users when needed
sudo userdel jinga

# Verify cleanup
hdfs fsck /user/jinga/dataatrest
```

## 🚀 Deployment Best Practices

### Network Configuration
- Deploy using **static IP addresses**
- Implement **enterprise-grade TLS** (ZeroSSL or internal CA)
- Configure **multi-AZ redundancy**

### Security Hardening
- Enable **Auto-TLS** across all services
- Implement **network segmentation**
- Regular **security audits** and **penetration testing**
- **Certificate rotation** policies

### Monitoring and Alerting
- **Real-time threat detection**
- **Performance monitoring**
- **Audit log analysis**
- **Automated incident response**

## 📊 Architecture Diagram

```
┌─────────────────────────────────────────────────────────────┐
│                    SPINE NETWORK ROUTER                     │
└─────────────────────┬───────────────────┬───────────────────┘
                      │                   │
              ┌───────▼──────┐    ┌───────▼──────┐    ┌───────▼──────┐
              │     AZ-1     │    │     AZ-2     │    │     AZ-3     │
              │              │    │              │    │              │
              │ ┌──────────┐ │    │ ┌──────────┐ │    │ ┌──────────┐ │
              │ │Namenode  │ │    │ │Datanode  │ │    │ │Datanode  │ │
              │ │Cloudera  │ │    │ │Worker    │ │    │ │Worker    │ │
              │ │Manager   │ │    │ │Node      │ │    │ │Node      │ │
              │ └──────────┘ │    │ └──────────┘ │    │ └──────────┘ │
              └──────────────┘    └──────────────┘    └──────────────┘
                      │                   │                   │
                      └───────────────────┼───────────────────┘
                                          │
                              ┌───────────▼──────────┐
                              │   Active Directory   │
                              │   Kerberos KDC      │
                              │ HADOOPSECURITY.LOCAL │
                              └─────────────────────┘
```

## 📋 Troubleshooting Checklist

### Common Issues
- [ ] Kerberos ticket expiration
- [ ] Network connectivity between AZs
- [ ] Certificate validation failures
- [ ] Permission denied errors
- [ ] Service startup failures

### Verification Commands
```bash
# Check Kerberos tickets
klist

# Verify network connectivity
ping hadoop-ad.hadoopsecurity.local

# Test HDFS operations
hdfs dfs -ls /

# Check service status
systemctl status cloudera-scm-server
```

## 📝 Summary

This comprehensive guide provides a complete framework for deploying an enterprise-grade Hadoop cluster with:

- **Multi-layered security** through AD integration and Kerberos
- **High availability** across multiple availability zones
- **Comprehensive monitoring** and threat detection
- **Scalable architecture** for enterprise workloads







# 🔐 Complete Enterprise Hadoop Deployment Guide
## Secure CDH Setup with AWS, Active Directory, MySQL & S3 Integration

---

## 🎯 Project Overview

Deploy a **production-ready, enterprise-grade Hadoop cluster** with:

- **AWS Cloud Infrastructure** (Multi-AZ deployment)
- **Active Directory (AD)** integration with **Kerberos (KDC)**
- **Cloudera Manager** for centralized management
- **MySQL** backend database
- **S3 integration** for scalable storage
- **Complete security framework** (encryption, RBAC, threat protection)
- **High Availability (HA)** configuration

---

## 🏗️ Complete Architecture

```
┌─────────────────────────────────────────────────────────────────────────────────┐
│                              AWS CLOUD INFRASTRUCTURE                            │
│                                                                                  │
│  ┌─────────────────────────────────────────────────────────────────────────────┐ │
│  │                          SPINE NETWORK ROUTER                               │ │
│  │                      (VPC with NAT Gateway & IGW)                           │ │
│  └─────────────────────┬──────────────────┬──────────────────┬─────────────────┘ │
│                        │                  │                  │                   │
│  ┌─────────────────────▼──────┐  ┌────────▼────────┐  ┌──────▼───────────────┐   │
│  │         AZ-1               │  │      AZ-2       │  │        AZ-3          │   │
│  │  ┌─────────────────────┐   │  │  ┌─────────────┐│  │  ┌─────────────────┐ │   │
│  │  │   Master Node       │   │  │  │ Worker Node ││  │  │   Worker Node   │ │   │
│  │  │ • Cloudera Manager  │   │  │  │ • DataNode  ││  │  │   • DataNode    │ │   │
│  │  │ • NameNode (Active) │   │  │  │ • NodeManager│  │  │   • NodeManager │ │   │
│  │  │ • ResourceManager   │   │  │  │ • RegionServer│ │  │   • RegionServer│ │   │
│  │  │ • MySQL Database    │   │  │  │             ││  │  │                 │ │   │
│  │  │ • ZooKeeper         │   │  │  └─────────────┘│  │  └─────────────────┘ │   │
│  │  └─────────────────────┘   │  └─────────────────┘  └─────────────────────┘   │
│  │                            │                                                 │
│  │  ┌─────────────────────┐   │  ┌─────────────────┐  ┌─────────────────────┐   │
│  │  │  NameNode (Standby) │   │  │   ZooKeeper     │  │    Gateway Node     │   │
│  │  │  • HDFS HA          │   │  │   • Failover    │  │  • Client Access    │   │
│  │  │  • JournalNode      │   │  │   • Coordination│  │  • Edge Services    │   │
│  │  └─────────────────────┘   │  └─────────────────┘  └─────────────────────┘   │
│  └────────────────────────────┘                       └─────────────────────────┘   
│                                                                                 │
│  ┌────────────────────────────────────────────────────────────────────────────┐ │
│  │                           EXTERNAL INTEGRATIONS                            │ │
│  │                                                                            │ │
│  │  ┌─────────────────┐  ┌─────────────────┐  ┌─────────────────────────────┐ │ │
│  │  │   Amazon S3     │  │ Active Directory│  │        Monitoring           │ │ │
│  │  │ • Data Storage  │  │ • Authentication│  │  • WireShark (Security)     │ │ │
│  │  │ • Backup/Archive│  │ • Kerberos KDC  │  │  • CloudWatch (AWS)         │ │ │
│  │  │ • Data Lake     │  │ • LDAP Services │  │  • Cloudera Manager         │ │ │
│  │  └─────────────────┘  │ HADOOPSECURITY  │  └─────────────────────────────┘ │ │
│  │                       │     .LOCAL      │                                  │ │
│  │                       └─────────────────┘                                  │ │
│  └────────────────────────────────────────────────────────────────────────────┘ │
└─────────────────────────────────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────────────────────────────────┐
│                              SECURITY LAYERS                                    │
│                                                                                 │
│  ┌─────────────────┐  ┌─────────────────┐  ┌─────────────────┐                  │
│  │   Network       │  │  Authentication │  │   Encryption    │                  │
│  │ • VPC/Subnets   │  │ • Kerberos      │  │ • TLS/SSL       │                  │
│  │ • Security Grps │  │ • Active Dir    │  │ • Data-at-Rest  │                  │
│  │ • NACLs         │  │ • RBAC/IAM      │  │ • Data-in-Motion│                  │
│  │ • SSH Keys      │  │ • Service Princ │  │ • Certificate   │                  │
│  └─────────────────┘  └─────────────────┘  └─────────────────┘                  │
└─────────────────────────────────────────────────────────────────────────────────┘
```

---

## 📋 Infrastructure Requirements

### 💰 AWS Resource Specifications

| Component | Instance Type | RAM | Storage | Quantity |
|-----------|---------------|-----|---------|----------|
| **Master Node** | m5.xlarge | 16GB | 120GB SSD | 1 |
| **Standby NameNode** | m5.large | 8GB | 80GB SSD | 1 |
| **Worker Nodes** | m5.xlarge | 16GB | 120GB SSD | 3+ |
| **Gateway Node** | t3.large | 8GB | 40GB SSD | 1 |
| **ZooKeeper** | t3.medium | 4GB | 40GB SSD | 3 |

### 🌐 Network Configuration

- **VPC**: Multi-AZ deployment across 3 availability zones
- **NAT Gateway**: For outbound internet access
- **Internet Gateway**: For public subnet access
- **Security Groups**: Layered security with specific port access
- **Elastic IPs**: For consistent external access

---

## 🚀 Phase 1: AWS Infrastructure Setup

### 1️⃣ Launch EC2 Instances

```bash
# Configure AWS CLI
aws configure
# Enter: Access Key, Secret Key, Region (e.g., ap-south-1)

# Verify configuration
aws sts get-caller-identity
```

### 2️⃣ Automated SSH Connection Script

Create `connectoid_multi.sh`:

```bash
#!/bin/bash
KEY_PATH="/path/to/your/security.pem"
REGION="ap-south-1"

echo "🔍 Fetching running EC2 instances..."
aws ec2 describe-instances \
  --region "$REGION" \
  --filters Name=instance-state-name,Values=running \
  --query 'Reservations[*].Instances[*].[InstanceId, Tags[?Key==`Name`]|[0].Value, PublicIpAddress]' \
  --output table

read -p "Enter the IP address to connect: " IP
echo "🔗 Connecting to $IP..."
ssh -i "$KEY_PATH" ec2-user@$IP
```

Usage:
```bash
chmod +x connectoid_multi.sh
./connectoid_multi.sh
```

### 3️⃣ Security Group Configuration

```bash
# Create security group for Hadoop cluster
aws ec2 create-security-group \
  --group-name hadoop-cluster-sg \
  --description "Security group for Hadoop cluster"

# Add rules for Hadoop services
aws ec2 authorize-security-group-ingress \
  --group-name hadoop-cluster-sg \
  --protocol tcp \
  --port 22 \
  --cidr 0.0.0.0/0  # SSH access

aws ec2 authorize-security-group-ingress \
  --group-name hadoop-cluster-sg \
  --protocol tcp \
  --port 7180 \
  --cidr 10.0.0.0/8  # Cloudera Manager

# Add more ports as needed (8020, 50070, 8088, etc.)
```

---

## 🔐 Phase 2: Security Foundation

### 1️⃣ Host Configuration

```bash
# Configure hostname resolution on all nodes
sudo nano /etc/hosts
# Add entries:
# 10.0.1.10 hadoop-master.hadoopsecurity.local
# 10.0.2.10 hadoop-worker1.hadoopsecurity.local
# 10.0.3.10 hadoop-worker2.hadoopsecurity.local
# 192.168.1.100 hadoop-ad.hadoopsecurity.local
```

### 2️⃣ Install Security Packages

```bash
# On all cluster nodes
sudo yum update -y
sudo yum install -y krb5-workstation krb5-libs openssl
```

### 3️⃣ Kerberos Configuration

Create `/etc/krb5.conf`:

```ini
[logging]
default = FILE:/var/log/krb5libs.log
kdc = FILE:/var/log/krb5kdc.log
admin_server = FILE:/var/log/kadmind.log

[libdefaults]
default_realm = HADOOPSECURITY.LOCAL
dns_lookup_realm = true
dns_lookup_kdc = true
ticket_lifetime = 24h
renew_lifetime = 7d
forwardable = true
rdns = false
default_ccache_name = KEYRING:persistent:%{uid}

[realms]
HADOOPSECURITY.LOCAL = {
  kdc = hadoop-ad.hadoopsecurity.local
  admin_server = hadoop-ad.hadoopsecurity.local
}

[domain_realm]
.hadoopsecurity.local = HADOOPSECURITY.LOCAL
hadoopsecurity.local = HADOOPSECURITY.LOCAL
```

---

## 🗄️ Phase 3: Database Setup

### 1️⃣ Install and Configure MySQL

```bash
# Install MySQL 8
sudo yum install -y mysql-server
sudo systemctl start mysqld
sudo systemctl enable mysqld

# Get temporary root password
sudo grep 'temporary password' /var/log/mysqld.log
```

### 2️⃣ Secure MySQL Installation

```bash
# Login with temporary password
mysql -u root -p

# Change root password and create service databases
```

```sql
-- Secure root user
ALTER USER 'root'@'localhost' IDENTIFIED WITH mysql_native_password BY 'P@ssw0rd123!';
FLUSH PRIVILEGES;

-- Create Cloudera Manager database
CREATE DATABASE scm DEFAULT CHARACTER SET utf8 DEFAULT COLLATE utf8_general_ci;
CREATE USER 'scm'@'%' IDENTIFIED BY 'P@ssw0rd123!';
GRANT ALL ON scm.* TO 'scm'@'%';

-- Create databases for Hadoop services
CREATE DATABASE hive DEFAULT CHARACTER SET utf8 DEFAULT COLLATE utf8_general_ci;
CREATE USER 'hive'@'%' IDENTIFIED BY 'P@ssw0rd123!';
GRANT ALL ON hive.* TO 'hive'@'%';

CREATE DATABASE hue DEFAULT CHARACTER SET utf8 DEFAULT COLLATE utf8_general_ci;
CREATE USER 'hue'@'%' IDENTIFIED BY 'P@ssw0rd123!';
GRANT ALL ON hue.* TO 'hue'@'%';

CREATE DATABASE oozie DEFAULT CHARACTER SET utf8 DEFAULT COLLATE utf8_general_ci;
CREATE USER 'oozie'@'%' IDENTIFIED BY 'P@ssw0rd123!';
GRANT ALL ON oozie.* TO 'oozie'@'%';

CREATE DATABASE ranger DEFAULT CHARACTER SET utf8 DEFAULT COLLATE utf8_general_ci;
CREATE USER 'ranger'@'%' IDENTIFIED BY 'P@ssw0rd123!';
GRANT ALL ON ranger.* TO 'ranger'@'%';

FLUSH PRIVILEGES;
```

### 3️⃣ Download MySQL JDBC Driver

```bash
# Download MySQL JDBC driver
cd /tmp
wget https://dev.mysql.com/get/Downloads/Connector-J/mysql-connector-java-8.0.33.tar.gz
tar -xzf mysql-connector-java-8.0.33.tar.gz
sudo cp mysql-connector-java-8.0.33/mysql-connector-java-8.0.33.jar /usr/share/java/mysql-connector-java.jar
```

---

## ☁️ Phase 4: Cloudera Manager Installation

### 1️⃣ Install Cloudera Manager

```bash
# Add Cloudera repository
sudo wget https://archive.cloudera.com/cm7/7.4.4/redhat7/yum/cloudera-manager.repo -P /etc/yum.repos.d/

# Import GPG key
sudo rpm --import https://archive.cloudera.com/cm7/7.4.4/redhat7/yum/RPM-GPG-KEY-cloudera

# Install Cloudera Manager
sudo yum install -y cloudera-manager-daemons cloudera-manager-agent cloudera-manager-server
```

### 2️⃣ Initialize Cloudera Manager Database

```bash
# Initialize SCM database
sudo /opt/cloudera/cm/schema/scm_prepare_database.sh mysql scm scm P@ssw0rd123!
```

### 3️⃣ Start Cloudera Manager Services

```bash
# Start Cloudera Manager Server
sudo systemctl start cloudera-scm-server
sudo systemctl enable cloudera-scm-server

# Start Cloudera Manager Agents on all nodes
sudo systemctl start cloudera-scm-agent
sudo systemctl enable cloudera-scm-agent

# Check status
sudo systemctl status cloudera-scm-server
sudo systemctl status cloudera-scm-agent
```

### 4️⃣ Access Cloudera Manager

```bash
# Check if service is running
ss -tlp | grep 7180

# Access via browser: http://your-master-node-ip:7180
# Default credentials: admin/admin
```

---

## 🔧 Phase 5: Hadoop Cluster Configuration

### 1️⃣ HDFS Setup and User Management

```bash
# Create HDFS directories for users
sudo su - hdfs
hdfs dfs -mkdir /user/ec2-user
hdfs dfs -chown ec2-user:ec2-user /user/ec2-user

# Create additional users
sudo useradd jinga
sudo passwd jinga
hdfs dfs -mkdir /user/jinga
hdfs dfs -chown jinga:supergroup /user/jinga
exit
```

### 2️⃣ High Availability Configuration

**Via Cloudera Manager UI:**

1. Navigate to **HDFS Service** → **Actions** → **Enable High Availability**
2. Select **Standby NameNode** host
3. Configure **ZooKeeper** for coordination
4. Set up **JournalNodes** (minimum 3, odd number)
5. Configure **Automatic Failover**

**Manual Verification:**

```bash
# Check NameNode status
hdfs haadmin -getServiceState nn1
hdfs haadmin -getServiceState nn2

# Test failover (if needed)
hdfs haadmin -failover nn1 nn2
```

### 3️⃣ ZooKeeper Configuration

```bash
# ZooKeeper configuration is typically handled by Cloudera Manager
# Verify ZooKeeper is running
echo ruok | nc localhost 2181
# Should respond with "imok"
```

---

## 📦 Phase 6: S3 Integration

### 1️⃣ Configure S3 Access

```bash
# Create S3 bucket
aws s3 mb s3://your-hadoop-data-bucket --region ap-south-1

# Set bucket policy for secure access
aws s3api put-bucket-policy --bucket your-hadoop-data-bucket --policy '{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "AWS": "arn:aws:iam::YOUR-ACCOUNT-ID:role/hadoop-s3-role"
      },
      "Action": "s3:*",
      "Resource": [
        "arn:aws:s3:::your-hadoop-data-bucket",
        "arn:aws:s3:::your-hadoop-data-bucket/*"
      ]
    }
  ]
}'
```

### 2️⃣ Configure Hadoop S3 Connector

Add to `core-site.xml` via Cloudera Manager:

```xml
<property>
  <name>fs.s3a.access.key</name>
  <value>YOUR_ACCESS_KEY</value>
</property>
<property>
  <name>fs.s3a.secret.key</name>
  <value>YOUR_SECRET_KEY</value>
</property>
<property>
  <name>fs.s3a.endpoint</name>
  <value>s3.ap-south-1.amazonaws.com</value>
</property>
<property>
  <name>fs.s3a.connection.ssl.enabled</name>
  <value>true</value>
</property>
<property>
  <name>fs.s3a.fast.upload</name>
  <value>true</value>
</property>
```

### 3️⃣ Test S3 Connectivity

```bash
# Test S3 access from Hadoop
hdfs dfs -ls s3a://your-hadoop-data-bucket/

# Copy data to S3
echo "Test data for S3 integration" > testfile.txt
hdfs dfs -put testfile.txt /user/ec2-user/
hdfs dfs -cp /user/ec2-user/testfile.txt s3a://your-hadoop-data-bucket/

# Verify in S3
aws s3 ls s3://your-hadoop-data-bucket/
```

---

## 🔍 Phase 7: Security Monitoring & Threat Detection

### 1️⃣ Install Network Monitoring Tools

```bash
# Install Wireshark for packet analysis
sudo yum install -y wireshark-gtk tcpdump

# Monitor network traffic
sudo tcpdump -i eth0 -w network_capture.pcap

# Analyze captured packets
sudo dumpcap -i eth0 -f "port 7180 or port 8020"
```

### 2️⃣ Enable TLS/SSL Encryption

**Via Cloudera Manager:**

1. Navigate to **Administration** → **Security**
2. Click **Enable Auto-TLS**
3. Configure **Certificate Authority** settings
4. **Restart all services** with TLS enabled

**Manual SSL Verification:**

```bash
# Test SSL connectivity
openssl s_client -connect your-master-node:7183 -servername your-master-node

# Check certificate details
openssl x509 -in /opt/cloudera/security/pki/server.pem -text -noout
```

### 3️⃣ Audit and Compliance

```bash
# Enable audit logging
sudo mkdir -p /var/log/hadoop-audit
sudo chown hdfs:hadoop /var/log/hadoop-audit

# Monitor user activities
hdfs dfs -ls /user/*/
hdfs fsck / -files -blocks -locations
```

---

## 🔧 Phase 8: Performance Optimization

### 1️⃣ Kernel Tuning

```bash
# Edit system limits
sudo nano /etc/security/limits.conf
```

Add:
```
* soft nofile 65536
* hard nofile 65536
* soft nproc 32768
* hard nproc 32768
```

```bash
# Edit sysctl configuration
sudo nano /etc/sysctl.conf
```

Add:
```
# Network optimizations
net.core.rmem_max = 134217728
net.core.wmem_max = 134217728
net.ipv4.tcp_rmem = 4096 87380 134217728
net.ipv4.tcp_wmem = 4096 65536 134217728

# Memory management
vm.swappiness = 1
vm.overcommit_memory = 1
```

Apply changes:
```bash
sudo sysctl -p
```

### 2️⃣ JVM Tuning

Configure via Cloudera Manager:
- **NameNode**: 8GB heap, G1GC
- **DataNode**: 4GB heap
- **ResourceManager**: 8GB heap
- **NodeManager**: 4GB heap

---

## 📊 Phase 9: Monitoring and Maintenance

### 1️⃣ Health Checks

```bash
# HDFS health check
hdfs dfsadmin -report
hdfs fsck /

# YARN health check
yarn node -list
yarn application -list

# Service status
sudo systemctl status cloudera-scm-server
sudo systemctl status cloudera-scm-agent
```

### 2️⃣ Automated Monitoring Script

Create `cluster_health.sh`:

```bash
#!/bin/bash
LOG_FILE="/var/log/cluster_health.log"
DATE=$(date '+%Y-%m-%d %H:%M:%S')

echo "[$DATE] Starting cluster health check..." >> $LOG_FILE

# Check Cloudera Manager
if systemctl is-active --quiet cloudera-scm-server; then
    echo "[$DATE] ✅ Cloudera Manager Server: Running" >> $LOG_FILE
else
    echo "[$DATE] ❌ Cloudera Manager Server: Not Running" >> $LOG_FILE
fi

# Check HDFS
HDFS_STATUS=$(hdfs dfsadmin -report | grep "Live datanodes" | wc -l)
if [ $HDFS_STATUS -gt 0 ]; then
    echo "[$DATE] ✅ HDFS: Healthy" >> $LOG_FILE
else
    echo "[$DATE] ❌ HDFS: Issues detected" >> $LOG_FILE
fi

# Check disk space
DISK_USAGE=$(df -h / | awk 'NR==2 {print $5}' | sed 's/%//')
if [ $DISK_USAGE -lt 80 ]; then
    echo "[$DATE] ✅ Disk Usage: ${DISK_USAGE}% (Normal)" >> $LOG_FILE
else
    echo "[$DATE] ⚠️ Disk Usage: ${DISK_USAGE}% (High)" >> $LOG_FILE
fi

echo "[$DATE] Health check completed." >> $LOG_FILE
```

Set up cron job:
```bash
# Add to crontab
crontab -e
# Add: */15 * * * * /path/to/cluster_health.sh
```

---

## 📋 Administrative Commands Reference

### Cloudera Manager
```bash
# Service management
sudo systemctl start|stop|restart|status cloudera-scm-server
sudo systemctl start|stop|restart|status cloudera-scm-agent

# Check port availability
ss -tlp | grep 7180
netstat -tlnp | grep :7180
```

### HDFS Operations
```bash
# Basic operations
hdfs dfs -ls /
hdfs dfs -mkdir /path/to/directory
hdfs dfs -put localfile /hdfs/path/
hdfs dfs -get /hdfs/path/file localfile
hdfs dfs -rm /hdfs/path/file

# Administrative operations
hdfs dfsadmin -report
hdfs dfsadmin -safemode get
hdfs fsck / -files -blocks -locations
```

### User Management
```bash
# System users
sudo useradd username
sudo passwd username
sudo usermod -aG hadoop username

# HDFS user directories
sudo su - hdfs
hdfs dfs -mkdir /user/username
hdfs dfs -chown username:username /user/username
```

### Security Operations
```bash
# Kerberos operations
kinit username@HADOOPSECURITY.LOCAL
klist
kdestroy

# Certificate verification
openssl x509 -in certificate.pem -text -noout
openssl verify -CAfile ca.pem certificate.pem
```

---

## 🎯 Key Concepts Reference

| Term | Description |
|------|-------------|
| **High Availability (HA)** | Ensures services remain available despite node failures |
| **Fault Tolerance (FT)** | System's ability to continue operating despite component failures |
| **Split Brain** | Dangerous scenario where multiple nodes believe they are active |
| **ZooKeeper** | Coordination service for distributed applications |
| **Kerberos** | Network authentication protocol for secure communication |
| **Active Directory** | Microsoft's directory service for Windows networks |
| **RBAC** | Role-Based Access Control for fine-grained permissions |
| **TLS/SSL** | Encryption protocols for secure data transmission |
| **AMI** | Amazon Machine Image for easy cluster replication |
| **NAT Gateway** | AWS service for outbound internet connectivity |

---

## 🚨 Troubleshooting Guide

### Common Issues and Solutions

**1. Cloudera Manager Not Starting**
```bash
# Check logs
sudo tail -f /var/log/cloudera-scm-server/cloudera-scm-server.log

# Common fixes
sudo systemctl restart cloudera-scm-server
sudo /opt/cloudera/cm/schema/scm_prepare_database.sh mysql scm scm P@ssw0rd123!
```

**2. HDFS SafeMode Issues**
```bash
# Check safemode status
hdfs dfsadmin -safemode get

# Force leave safemode (use with caution)
hdfs dfsadmin -safemode leave
```

**3. Kerberos Authentication Failures**
```bash
# Check ticket status
klist

# Renew tickets
kinit -R

# Check time synchronization
ntpdate -s time.nist.gov
```

**4. S3 Connectivity Issues**
```bash
# Test AWS CLI
aws s3 ls s3://your-bucket-name/

# Check IAM permissions
aws iam get-user
aws sts get-caller-identity
```

**5. Network Connectivity**
```bash
# Test connectivity between nodes
telnet hostname 7180
nc -zv hostname 8020

# Check firewall rules
sudo iptables -L
```

---

## 🔄 Backup and Disaster Recovery

### 1️⃣ Create AMI Snapshots

```bash
# Create AMI from running instance
aws ec2 create-image \
  --instance-id i-1234567890abcdef0 \
  --name "hadoop-cluster-backup-$(date +%Y%m%d)" \
  --description "Hadoop cluster backup"
```

### 2️⃣ HDFS Backup Strategy

```bash
# Backup HDFS metadata
hdfs dfsadmin -saveNamespace

# Backup critical data to S3
hdfs distcp /important/data s3a://backup-bucket/hdfs-backup/$(date +%Y%m%d)/
```

### 3️⃣ Configuration Backup

```bash
# Backup Cloudera Manager configuration
curl -X GET -u admin:admin "http://localhost:7180/api/v19/clusters/cluster/services" > cm_config_backup.json

# Backup important config files
tar -czf config_backup_$(date +%Y%m%d).tar.gz \
  /etc/krb5.conf \
  /etc/hosts \
  /opt/cloudera/parcels/CDH/etc/hadoop/conf.dist/
```

---

## 📈 Final Deployment Checklist

### Pre-Production Validation
- [ ] All services healthy in Cloudera Manager
- [ ] HDFS HA properly configured and tested
- [ ] Kerberos authentication working
- [ ] S3 integration tested
- [ ] SSL/TLS encryption enabled
- [ ] Network security groups configured
- [ ] Monitoring and alerting setup
- [ ] Backup strategy implemented
- [ ] Performance benchmarks completed
- [ ] Security scan performed

### Production Readiness
- [ ] AMI snapshots created
- [ ] Disaster recovery plan documented
- [ ] Runbook created for common operations
- [ ] Team training completed
- [ ] Change management process defined
- [ ] Monitoring dashboards configured
- [ ] Capacity planning completed
- [ ] Compliance requirements met

---

## 🎉 Conclusion

This comprehensive guide provides a complete framework for deploying an enterprise-grade Hadoop cluster with:

- **Robust Security**: Multi-layered security with AD, Kerberos, and encryption
- **High Availability**: Zero-downtime operations with automated failover
- **Cloud Integration**: Seamless AWS and S3 integration
- **Scalability**: Architecture designed for enterprise workloads
- **Monitoring**: Complete observability and threat detection
- **Maintenance**: Automated operations and backup strategies

The deployment ensures **enterprise compliance**, **operational excellence**, and **data security** for production big data environments.

---

*This guide represents a production-ready deployment suitable for enterprise environments requiring the highest levels of security, availability, and performance.*