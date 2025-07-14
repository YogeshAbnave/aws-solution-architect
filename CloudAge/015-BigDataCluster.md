# Complete Cloudera CDH 7 Setup on RHEL 8 EC2 with MySQL Backend

## Table of Contents
1. [Introduction](#introduction)
2. [Prerequisites](#prerequisites)
3. [AWS Infrastructure Setup](#aws-infrastructure-setup)
4. [MySQL Database Installation](#mysql-database-installation)
5. [Cloudera Manager Installation](#cloudera-manager-installation)
6. [Cluster Configuration](#cluster-configuration)
7. [Service Configuration](#service-configuration)
8. [Administration & Monitoring](#administration--monitoring)
9. [Security & Best Practices](#security--best-practices)
10. [Troubleshooting](#troubleshooting)

## Introduction

This comprehensive guide walks you through setting up a production-ready Cloudera CDH 7 cluster on AWS EC2 instances using Red Hat Enterprise Linux 8 and MySQL as the backend database.

### Why Cloudera CDH 7 on AWS EC2?

- **Distributed Processing**: Handle massive datasets across multiple machines
- **Centralized Management**: Simplified administration through Cloudera Manager
- **Reliable Backend**: MySQL provides stable metadata storage
- **Cloud Scalability**: Leverage AWS EC2 for flexible compute resources
- **Enterprise Ready**: Production-grade setup for Big Data workloads

### Architecture Overview

```
┌─────────────────┐    ┌─────────────────┐    ┌─────────────────┐
│   Cloudera      │    │     Master      │    │    Worker       │
│   Manager       │    │     Nodes       │    │    Nodes        │
│   + MySQL       │    │  NameNode/RM    │    │  DataNode/NM    │
└─────────────────┘    └─────────────────┘    └─────────────────┘
```

## Prerequisites

### Required Knowledge
- Basic Linux administration
- Understanding of AWS EC2
- Familiarity with SSH and networking concepts

### AWS Account Requirements
- AWS account with EC2 access
- Ability to create VPCs, subnets, and security groups
- SSH key pair for instance access

### Recommended Cluster Topology
- **Cloudera Manager + MySQL**: 1 x c4.extralarge
- **Master Nodes**: 2 x c4.extralarge
- **Worker Nodes**: 3-5 x c4.extralarge
- **Gateway Nodes**: 1-2 x c4.extralarge

## AWS Infrastructure Setup

### Step 1: Create VPC and Networking

#### 1.1 Create Virtual Private Cloud (VPC)
```bash
# VPC Configuration
Name: my-vpc
CIDR Block: 10.0.0.0/16
```

#### 1.2 Create Public Subnet
```bash
# Subnet Configuration
Name: public-subnet
CIDR Block: 10.0.1.0/24
Auto-assign Public IP: Enabled
```

#### 1.3 Create and Attach Internet Gateway
```bash
# Internet Gateway Configuration
Name: my-igw
Attach to: my-vpc
```

#### 1.4 Configure Route Table
```bash
# Add route for internet access
Destination: 0.0.0.0/0
Target: my-igw
```

### Step 2: Launch EC2 Instances

#### 2.1 Instance Configuration
```bash
# Base Configuration
AMI: Red Hat Enterprise Linux 8 (HVM) - x86_64
Instance Type: c4.extralarge
Subnet: public-subnet
Key Pair: Your existing .pem key
```

#### 2.2 Security Group Rules
Create a security group with the following rules:

| Type | Protocol | Port Range | Source | Description |
|------|----------|------------|---------|-------------|
| SSH | TCP | 22 | 0.0.0.0/0 | SSH access |
| HTTP | TCP | 80 | 0.0.0.0/0 | Web services |
| Custom TCP | TCP | 7180 | 0.0.0.0/0 | Cloudera Manager UI |
| MySQL/Aurora | TCP | 3306 | VPC CIDR | MySQL access |
| Custom TCP | TCP | 7182 | VPC CIDR | CM Agent communication |

#### 2.3 Instance Launch Plan
Launch instances according to your cluster topology:

1. **Cloudera Manager/Database Host**: 1 instance
2. **Master Nodes**: 2 instances
3. **Worker Nodes**: 3-5 instances
4. **Gateway Nodes**: 1-2 instances

#### 2.4 Connect to Instances
```bash
# Set correct permissions for SSH key
chmod 400 your-key.pem

# Connect to Cloudera Manager host
ssh -i "your-key.pem" ec2-user@<CM-Public-IP>
```

## MySQL Database Installation

### Step 3: Install MySQL 8 on Database Host

```bash
# Install wget
sudo yum install wget -y

# Download MySQL 8 repository
wget https://dev.mysql.com/get/mysql80-community-release-el8-8.noarch.rpm

# Install MySQL repository
sudo rpm -ivh mysql80-community-release-el8-8.noarch.rpm

# Install MySQL development tools
sudo yum install mysql-devel -y

# Install MySQL Server
sudo yum install --nogpgcheck mysql-server -y

# Start and enable MySQL service
sudo systemctl start mysqld
sudo systemctl enable mysqld

# Check MySQL status
sudo systemctl status mysqld

# Get temporary root password
sudo grep 'temporary password' /var/log/mysqld.log

# Secure MySQL installation
sudo mysql_secure_installation
```

### Step 4: Configure MySQL for Cloudera Manager

#### 4.1 Create SCM Database
```sql
-- Connect to MySQL
mysql -u root -p

-- Create Cloudera Manager database
CREATE DATABASE scm DEFAULT CHARACTER SET utf8 DEFAULT COLLATE utf8_general_ci;

-- Create SCM user
CREATE USER 'scm'@'%' IDENTIFIED BY 'YourStrongPassword';

-- Grant privileges
GRANT ALL ON scm.* TO 'scm'@'%';

-- Verify database creation
SHOW DATABASES;

-- Exit MySQL
exit;
```

#### 4.2 Create Service Databases
```sql
-- Connect to MySQL as root
mysql -u root -p

-- Hive Metastore Database
CREATE DATABASE hive DEFAULT CHARACTER SET utf8;
GRANT ALL ON hive.* TO 'hive'@'%' IDENTIFIED BY 'YourStrongPassword';

-- Hue Database
CREATE DATABASE hue DEFAULT CHARACTER SET utf8;
GRANT ALL ON hue.* TO 'hue'@'%' IDENTIFIED BY 'YourStrongPassword';

-- Oozie Database
CREATE DATABASE oozie DEFAULT CHARACTER SET utf8;
GRANT ALL ON oozie.* TO 'oozie'@'%' IDENTIFIED BY 'YourStrongPassword';

-- Activity Monitor Database
CREATE DATABASE actmo DEFAULT CHARACTER SET utf8;
GRANT ALL ON actmo.* TO 'actmo'@'%' IDENTIFIED BY 'YourStrongPassword';

-- Sentry Database (if using)
CREATE DATABASE sentry DEFAULT CHARACTER SET utf8;
GRANT ALL ON sentry.* TO 'sentry'@'%' IDENTIFIED BY 'YourStrongPassword';

-- Navigator Audit Server Database
CREATE DATABASE navs DEFAULT CHARACTER SET utf8;
GRANT ALL ON navs.* TO 'navs'@'%' IDENTIFIED BY 'YourStrongPassword';

-- Navigator Metadata Server Database
CREATE DATABASE navms DEFAULT CHARACTER SET utf8;
GRANT ALL ON navms.* TO 'navms'@'%' IDENTIFIED BY 'YourStrongPassword';

-- Exit MySQL
exit;
```

## Cloudera Manager Installation

### Step 5: Configure Cloudera Manager Repository

```bash
# Create Cloudera Manager repository file
sudo tee /etc/yum.repos.d/cloudera-manager.repo > /dev/null <<EOF
[cloudera-manager]
name=Cloudera Manager
baseurl=https://archive.cloudera.com/cm7/7.4.4/redhat8/yum/
gpgkey=https://archive.cloudera.com/cm7/7.4.4/redhat8/yum/RPM-GPG-KEY-cloudera
gpgcheck=1
enabled=1
EOF

# Update crypto policies if needed
sudo update-crypto-policies --set LEGACY

# Import Cloudera GPG key
sudo rpm --import https://archive.cloudera.com/cm7/7.4.4/redhat8/yum/RPM-GPG-KEY-cloudera

# Clean and rebuild yum cache
sudo yum clean all && sudo yum makecache
```

### Step 6: Install Cloudera Manager Components

```bash
# Install Cloudera Manager packages
sudo yum install cloudera-manager-daemons cloudera-manager-server cloudera-manager-agent -y

# Start and enable services
sudo systemctl start cloudera-scm-agent
sudo systemctl enable cloudera-scm-agent

sudo systemctl start cloudera-scm-server
sudo systemctl enable cloudera-scm-server

# Check service status
sudo systemctl status cloudera-scm-server
sudo systemctl status cloudera-scm-agent
```

### Step 7: Install MySQL Connector on All Hosts

#### 7.1 Prepare SSH Key for Cluster Operations
```bash
# Set correct permissions for SSH key
chmod 400 pemfile.ppk
```

#### 7.2 Install Prerequisites on All Machines
```bash
# Install wget on all cluster hosts using cluster script
sudo sh cluster.sh sudo yum install wget -y

# Install Java on all hosts
sudo sh cluster.sh sudo dnf install java-11-openjdk-headless -y
```

#### 7.3 Install MySQL JDBC Driver on All Hosts
```bash
# Download MySQL Connector/J on all hosts
sudo sh cluster.sh wget https://dev.mysql.com/get/Downloads/Connector-J/mysql-connector-j-9.3.0-1.el8.noarch.rpm

# Install MySQL Connector on all hosts
sudo sh cluster.sh sudo rpm -ivh mysql-connector-j-9.3.0-1.el8.noarch.rpm

# Verify JAR file exists on all hosts
sudo sh cluster.sh ls /usr/share/java/mysql-connector-java.jar
```

**Important**: You should see the mysql-connector-java.jar file present on every host in the cluster.

#### 7.4 Test Database Connection
```bash
# Test MySQL connectivity from each host
mysql -u scm -p -h <MySQL-Server-IP>

# Verify connection from application
java -cp /usr/share/java/mysql-connector-java.jar com.mysql.cj.jdbc.Driver
```

### Step 8: Initialize SCM Database Schema

```bash
# Prepare SCM database schema
sudo /opt/cloudera/cm/schema/scm_prepare_database.sh mysql -h <MySQL-Server-IP> scm scm YourStrongPassword
```

Replace `<MySQL-Server-IP>` with your MySQL server's private IP address.

## Cluster Configuration

### Step 9: Access Cloudera Manager Web UI

1. Open your web browser
2. Navigate to: `http://<CM-Server-Public-IP>:7180`
3. Default credentials: `admin/admin`
4. Change the password when prompted

### Step 10: Add Hosts to Cluster

#### 10.1 Add New Hosts
1. In CM UI, go to **Hosts** → **All Hosts** → **Add New Hosts**
2. Enter private IP addresses of all cluster nodes
3. Provide SSH credentials (ec2-user and your .pem key)

#### 10.2 Install Agents and Parcels
1. Select installation method (parcels recommended)
2. Choose CDH 7 parcel repository:
   ```
   https://archive.cloudera.com/cdh7/7.3.1.0/parcels/
   ```
3. Install JDK and Cloudera agents on all hosts
4. Wait for installation to complete

#### 10.3 Host Inspector
Run the host inspector to verify:
- Network connectivity
- Hardware requirements
- Software prerequisites
- Clock synchronization

## Service Configuration

### Step 11: Select Services

Choose services based on your requirements:

#### Core Services
- **HDFS**: Hadoop Distributed File System
- **YARN**: Resource management and job scheduling
- **ZooKeeper**: Coordination service

#### Additional Services
- **Hive**: Data warehouse software
- **Spark**: Fast analytics engine
- **Hue**: Web interface for Hadoop
- **Oozie**: Workflow scheduler
- **Sqoop**: Data transfer tool

### Step 12: Assign Service Roles

#### Master Node Assignments
- **NameNode**: Primary HDFS master (1 instance)
- **Secondary NameNode**: HDFS checkpoint service (1 instance)
- **ResourceManager**: YARN master (1 instance)
- **JobHistory Server**: Job tracking service (1 instance)

#### Worker Node Assignments
- **DataNode**: HDFS data storage (all worker nodes)
- **NodeManager**: YARN worker service (all worker nodes)

#### Gateway Node Assignments
- **Hue Server**: Web interface (1 instance)
- **Hive Gateway**: Client configuration (gateway nodes)

#### ZooKeeper Configuration
ZooKeeper requires an odd number of instances for proper quorum:
- **1 Leader**: Handles all write operations
- **2 Followers**: Serve read requests and participate in voting
- **Minimum 3 nodes**: For production clusters
- **Recommended 5 nodes**: For high availability

```bash
# ZooKeeper role assignment
# Assign ZooKeeper Server roles to 3 or 5 different hosts
# Ensure they are distributed across different failure domains
```

#### Role Assignment Best Practices
1. **Separate Master Services**: Don't co-locate NameNode and ResourceManager
2. **Dedicated ZooKeeper**: Use separate hosts for ZooKeeper when possible
3. **Gateway Isolation**: Keep gateway services on dedicated nodes
4. **Worker Node Scaling**: Add DataNode/NodeManager roles together

### Step 14: Setup Database Configuration in Cloudera Manager

#### 14.1 Configure Service Databases
For each service requiring a database:

1. Select **Use Custom Database**
2. Enter database details:
   - **Database Type**: MySQL
   - **Hostname**: Your MySQL server IP
   - **Port**: 3306
   - **Database Name**: Respective service database
   - **Username**: Service-specific user
   - **Password**: Your configured password

#### 14.2 Test Database Connections
Cloudera Manager will test each database connection during setup. Ensure all connections succeed before proceeding.

### Step 15: Review Configuration and Remember Paths

#### 15.1 HDFS Data Paths
**Important**: Remember and verify these critical paths:

- **NameNode Metadata**: `/dfs/nn`
- **DataNode Storage**: `/dfs/dn`
- **Secondary NameNode**: `/dfs/snn`

```bash
# Verify HDFS directories exist
sudo ls /dfs/
# Expected output: dn, nn, snn directories

# Check DataNode directory
ls /dfs/dn/

# Switch to root for administrative tasks
sudo su

# Navigate to HDFS directories
cd /dfs
cd /dfs/dn  # DataNode storage location
```

#### 15.2 Important Path Configurations
- **Log Directories**: `/var/log/hadoop-*`
- **Configuration Files**: `/etc/hadoop/conf`
- **Parcel Installation**: `/opt/cloudera/parcels`

### Step 16: Deploy and Start Services

1. Review all configurations
2. Adjust memory and resource allocations as needed
3. **Verify all paths are correctly configured**
4. Start the deployment process
5. Monitor for any errors and resolve them

## Administration & Monitoring

### Cloudera Manager Access
Access your Cloudera Manager at:
```
http://10.0.31.63:7180
```
Or replace with your actual CM server IP.

### Service Management Commands

```bash
# Restart Cloudera Manager Server
sudo systemctl restart cloudera-scm-server

# Restart Cloudera Manager Agent
sudo systemctl restart cloudera-scm-agent

# Check service status
sudo systemctl status cloudera-scm-server
sudo systemctl status cloudera-scm-agent

# Check network connections and listening ports
ss -tlp | grep 7180

# Alternative network check
ss -tlp
```

### Cloudera Management Services Configuration

#### ISRO Service Configuration (Custom Service)
If using a custom service like ISRO:
```bash
# Allocate 6GB memory for ISRO service
# Configure in Cloudera Manager UI:
# 1. Go to Clusters > Service > Configuration
# 2. Set Java Heap Size: 6GB
# 3. Apply changes and restart service
```

#### Cloudera Management Services
Configure the following management services:

1. **Host Monitor**: Hardware and OS metrics monitoring
2. **Service Monitor**: Service-specific metrics collection  
3. **Activity Monitor**: Job and query monitoring
4. **Alert Publisher**: Notification management
5. **Report Manager**: Historical reporting and analytics

```bash
# Check management services status
# Access via CM UI: Administration > Settings > Cloudera Management Service
```

### Data Collection and Monitoring

#### Netrix Data Collection
Set up enterprise monitoring integration:

```bash
# Configure data collection agents
# 1. Install monitoring agents on all hosts
# 2. Configure data export to external monitoring systems
# 3. Set up alerting thresholds
# 4. Create monitoring dashboards
```

### Cluster Administration Tasks

#### HDFS Administration
```bash
# Check HDFS filesystem
sudo ls /dfs/

# Access as HDFS superuser
sudo su hdfs

# Navigate to HDFS directories
cd /dfs

# Check DataNode directories
ls /dfs/dn/

# Final verification
cd /dfs
ls -la
```

#### User Access Management
**Important Security Principle**: Data is always accessed through gateway/access nodes

```bash
# Create read-only user for data access
sudo useradd -g hadoop readonly_user

# Set read-only permissions for data access
sudo chmod 644 /dfs/dn/*
sudo chown hdfs:hadoop /dfs/dn/*

# Grant read-only access to specific directories
sudo -u hdfs hdfs dfs -chmod 644 /user/data
sudo -u hdfs hdfs dfs -setfacl -m user:readonly_user:r-- /user/data
```

**Access Control Rules**:
- **One user per application**: Assign dedicated service accounts
- **Read-only permissions**: Default to minimal required access
- **Gateway access only**: All data access through designated gateway machines

### Cluster Shutdown Procedures

#### Graceful Service Shutdown
```bash
# 1. Stop all services via Cloudera Manager UI (recommended)
#    Go to: Clusters > Actions > Stop

# 2. Stop individual services via command line
sudo service hadoop-hdfs-namenode stop
sudo service hadoop-yarn-resourcemanager stop
sudo service hadoop-hdfs-datanode stop
sudo service hadoop-yarn-nodemanager stop

# 3. Stop Cloudera Manager services
sudo systemctl stop cloudera-scm-server
```

#### Stop Agents on All Machines
```bash
# Stop agents on all cluster hosts
sudo sh cluster.sh sudo systemctl stop cloudera-scm-agent

# Verify agents are stopped
sudo sh cluster.sh sudo systemctl status cloudera-scm-agent

# Alternative individual host commands
sudo systemctl stop cloudera-scm-agent  # Run on each host
```

#### Complete Cluster Shutdown
```bash
# 1. Stop all Hadoop services (via CM UI or commands above)
# 2. Stop Cloudera Management Services
# 3. Stop all agents across cluster
sudo sh cluster.sh sudo systemctl stop cloudera-scm-agent

# 4. Stop Cloudera Manager Server
sudo systemctl stop cloudera-scm-server

# 5. Shutdown all EC2 instances
sudo sh cluster.sh sudo shutdown -h now

# Or shutdown individual machines
sudo shutdown -h now  # Run on each host
```

### Hadoop Version Verification
```bash
# Check Hadoop version
hadoop version

# Check CDH version
cat /opt/cloudera/parcels/CDH/meta/parcel.json | grep version

# Verify all components
/opt/cloudera/parcels/CDH/bin/hadoop version
/opt/cloudera/parcels/CDH/bin/hive --version
/opt/cloudera/parcels/CDH/bin/spark-submit --version
```

### Cluster Monitoring

#### Key Metrics to Monitor
- **Cluster Health**: Overall service status
- **HDFS Usage**: Storage utilization
- **YARN Resources**: CPU and memory usage
- **Service Logs**: Error detection

#### Cloudera Manager Features
- **Host Monitor**: Hardware and OS metrics
- **Service Monitor**: Service-specific metrics
- **Alert Publisher**: Notification management
- **Report Manager**: Historical reporting

### Backup and Maintenance

```bash
# Backup Cloudera Manager database
mysqldump -u scm -p scm > scm_backup.sql

# Backup service databases
mysqldump -u hive -p hive > hive_backup.sql
mysqldump -u hue -p hue > hue_backup.sql

# Cluster restart sequence (via CM UI)
# 1. Stop all services
# 2. Stop Cloudera Management Service
# 3. Restart when needed
```

## Security & Best Practices

### Network Security
- Use VPC private subnets for cluster communication
- Restrict security group rules to necessary ports
- Enable CloudTrail for API logging

### Access Control
- Implement least privilege access principles
- Use Sentry or Ranger for authorization
- Regular user access audits

### Data Security

#### Gateway Machine Access Pattern
**Key Principle**: All data access must go through designated gateway/access nodes

```bash
# Gateway machines serve as access points for:
# - User queries and data access
# - Application connections
# - External system integrations
# - Security policy enforcement

# Gateway services typically include:
# - Hue Server (Web interface)
# - Hive Gateway (SQL access)
# - Spark Gateway (Analytics access)
# - Sqoop Gateway (Data transfer)
```

#### Access Control Implementation
```bash
# Create read-only data access user
sudo useradd -g hadoop data_reader

# Set restrictive permissions on HDFS
sudo -u hdfs hdfs dfs -chmod 750 /user
sudo -u hdfs hdfs dfs -chmod 644 /user/data

# Assign read-only permissions to specific user
sudo -u hdfs hdfs dfs -setfacl -m user:data_reader:r-x /user/data

# Verify permissions
sudo -u hdfs hdfs dfs -getfacl /user/data
```

**Security Best Practices**:
- **Single User Principle**: One service account per application
- **Minimal Permissions**: Start with read-only, grant write access only when needed
- **Gateway Access Only**: Block direct access to DataNodes from external networks
- **Audit Trail**: Enable logging for all data access attempts

### HDFS Permissions
```bash
# Check HDFS directories
sudo -u hdfs hdfs dfs -ls /

# Set proper permissions
sudo -u hdfs hdfs dfs -chmod 755 /user
sudo -u hdfs hdfs dfs -chown hdfs:hadoop /tmp
```

## Troubleshooting

### Common Issues and Solutions

#### 1. Agent Connection Issues
```bash
# Check agent logs
sudo tail -f /var/log/cloudera-scm-agent/cloudera-scm-agent.log

# Restart agent
sudo systemctl restart cloudera-scm-agent

# Check connectivity
telnet <cm-server-ip> 7182
```

#### 2. Database Connection Problems
```bash
# Test MySQL connectivity
mysql -u scm -p -h <mysql-server-ip>

# Check MySQL is listening
netstat -tlpn | grep 3306

# Verify user permissions
mysql -u root -p
SHOW GRANTS FOR 'scm'@'%';
```

#### 3. Memory Issues
- Increase heap sizes for services
- Adjust YARN memory allocation
- Monitor GC logs for optimization

#### 4. Disk Space Issues
```bash
# Check disk usage
df -h

# Clean up logs
sudo find /var/log -name "*.log" -type f -mtime +7 -delete

# HDFS balancer for data distribution
sudo -u hdfs hdfs balancer
```

### Log Locations
```bash
# Cloudera Manager Server logs
/var/log/cloudera-scm-server/

# Cloudera Manager Agent logs
/var/log/cloudera-scm-agent/

# Service logs (example for HDFS)
/var/log/hadoop-hdfs/

# MySQL logs
/var/log/mysqld.log
```

## Data Transfer with Rclone (Optional)

For efficient data transfer to/from cloud storage:

```bash
# Install rclone
curl https://rclone.org/install.sh | sudo bash

# Configure rclone
rclone config

# Example: Copy data from S3 to HDFS
rclone copy s3:my-bucket/data/ /tmp/data/
sudo -u hdfs hdfs dfs -put /tmp/data/ /user/data/
```

## Conclusion

This guide provides a comprehensive setup for Cloudera CDH 7 on AWS EC2 with RHEL 8 and MySQL. The resulting cluster is production-ready and scalable for Big Data workloads.

### Next Steps
1. Configure additional services as needed
2. Implement security hardening
3. Set up monitoring and alerting
4. Plan for disaster recovery
5. Optimize performance based on workload patterns

### Key Takeaways
- Always follow the proper service startup/shutdown order
- Monitor cluster health regularly
- Keep databases backed up
- Plan for capacity growth
- Document any customizations for future reference

For additional support, consult the [Cloudera Documentation](https://docs.cloudera.com/) and consider Cloudera support subscriptions for production environments.

---









---

### **Question 1**

**Q:** For public cloud deployments, which cloud providers are supported by Cloudera Data Platform (CDP)?

* A) Amazon Web Services (AWS) and Google Cloud Platform (GCP) ✅
* B) Microsoft Office 365 and IBM Cloud
* C) Oracle Cloud and Alibaba Cloud
* D) None, CDP is only available for on-premises deployments.
  **Answer:** A) AWS and GCP
  **Explanation:** CDP supports both AWS and GCP for public cloud deployments, enabling hybrid and multi-cloud architectures.

---

### **Question 2**

**Q:** In Hadoop, what role does Apache Tez play?

* A) It serves as a distributed file system.
* B) It manages cluster resource allocation.
* C) It processes data in a directed acyclic graph (DAG) fashion. ✅
* D) It provides data storage and retrieval services.
  **Answer:** C)
  **Explanation:** Apache Tez is a DAG-based execution engine that optimizes performance over MapReduce.

---

### **Question 3**

**Q:** What is the role of the data catalogue in CDP?

* A) A programming language
* B) Provides data visualization tools
* C) Manages metadata and data lineage ✅
* D) Manages cloud infrastructure
  **Answer:** C)
  **Explanation:** The CDP Data Catalog helps manage metadata, classify data, and ensure governance and lineage tracking.

---

### **Question 4**

**Q:** What does Cloudera Manager do?

* A) Manages cloud resources
* B) Manages and monitors clusters and services ✅
* C) Provides data analytics
* D) Manages network security
  **Answer:** B)
  **Explanation:** Cloudera Manager provides centralized management and monitoring of clusters and Hadoop services.

---

### **Question 5**

**Q:** External firewalls in cloud computing are called:

* A) Safety gates
* B) Network barriers
* C) Security groups ✅
* D) Data encryption
  **Answer:** C)
  **Explanation:** In AWS and other clouds, "security groups" act as virtual firewalls controlling inbound/outbound traffic.

---

### **Question 6**

**Q:** What does CDP Private Cloud offer?

* A) Public cloud services
* B) Web hosting
* C) On-premises big data solutions ✅
* D) DBMS tools
  **Answer:** C)
  **Explanation:** CDP Private Cloud extends CDP functionality to on-premises data centers for hybrid data management.

---

### **Question 7**

**Q:** What does FQDN stand for?

* A) Fully Qualified Data Node
* B) Fully Qualified Distributed Network
* C) Fully Qualified Domain Node
* D) Fully Qualified Domain Name ✅
  **Answer:** D)
  **Explanation:** FQDN is the complete domain name specifying exact location within the DNS hierarchy.

---

### **Question 8**

**Q:** SELinux "permissive" mode allows:

* A) Enforcing policies
* B) Logging violations without enforcement ✅
* C) Blocking network
* D) Enabling firewalls
  **Answer:** B)
  **Explanation:** In permissive mode, SELinux logs policy violations but doesn’t block actions.

---

### **Question 9**

**Q:** What does "dsh" stand for?

* A) Distributed Shell ✅
* B) Dancing Shell
* C) Data Storage Hadoop
* D) Distributed Software Hosting
  **Answer:** A)
  **Explanation:** `dsh` executes shell commands across multiple remote machines simultaneously.

---

### **Question 10**

**Q:** What does `getenforce` show in Linux?

* A) Firewall rules
* B) SELinux status ✅
* C) Network connections
* D) Memory stats
  **Answer:** B)
  **Explanation:** `getenforce` returns whether SELinux is in Enforcing, Permissive, or Disabled mode.

---

### **Question 11**

**Q:** What does the “swappiness” parameter control in Linux?

* A) Network traffic
* B) Memory allocation
* C) Disk storage
* D) Tendency to swap memory pages to disk ✅
  **Answer:** D)
  **Explanation:** Lower swappiness means less use of swap space; higher values use swap more aggressively.

---

### **Question 12**

**Q:** What is Apache Tez designed for?

* A) Data storage
* B) Real-time processing
* C) Data analysis and querying ✅
* D) Data encryption
  **Answer:** C)
  **Explanation:** Tez accelerates data processing using DAGs and is used by Hive and Pig.

---

### **Question 13**

**Q:** What is Spark mainly used for?

* A) Data storage
* B) Resource management
* C) Parallel computing
* D) Data processing and analytics ✅
  **Answer:** D)
  **Explanation:** Apache Spark provides in-memory computing for high-speed analytics.

---

### **Question 14**

**Q:** Key data structure in Apache Tez DAGs?

* A) Linked List
* B) Tree
* C) Stack
* D) Vertex ✅
  **Answer:** D)
  **Explanation:** Each node (or task) in a DAG is called a vertex in Tez.

---

### **Question 15**

**Q:** Advantage of Apache Tez over MapReduce?

* A) Simplicity
* B) Real-time support
* C) Performance via optimized DAG processing ✅
* D) Enhanced storage
  **Answer:** C)
  **Explanation:** Tez significantly improves performance by avoiding intermediate writes between steps.

---

### **Question 16**

**Q:** CDP DataHub (CDP-DH) focuses on:

* A) Storage
* B) Real-time stream
* C) Data integration and movement ✅
* D) Governance
  **Answer:** C)
  **Explanation:** CDP DataHub supports scalable, integrated data movement and pipelines.

---

### **Question 17**

**Q:** Primary function of YARN?

* A) Data storage
* B) Resource management ✅
* C) Querying
* D) Networking
  **Answer:** B)
  **Explanation:** YARN manages compute resources across applications in a Hadoop cluster.

---

### **Question 18**

**Q:** What does `iptables` do in Linux?

* A) Memory management
* B) Encryption
* C) Packet filtering and NAT ✅
* D) Data analytics
  **Answer:** C)
  **Explanation:** `iptables` manages network traffic rules, including firewall settings.

---

### **Question 19**

**Q:** Primary purpose of `pdsh`?

* A) Send to single remote
* B) Local commands
* C) Send to multiple remotes in parallel ✅
* D) Hadoop job management
  **Answer:** C)
  **Explanation:** `pdsh` is used for parallel command execution across many servers.

---

### **Question 20**

**Q:** CDP-DE is used for:

* A) Reporting
* B) Storage
* C) Real-time processing
* D) Data prep and transformation ✅
  **Answer:** D)
  **Explanation:** CDP-DE focuses on preparing and transforming data before analytics.

---

### **Question 21**

**Q:** Purpose of "Tuned" service in Linux?

* A) Encryption
* B) Performance optimization ✅
* C) Memory defrag
* D) Storage
  **Answer:** B)
  **Explanation:** `tuned` dynamically adjusts system settings for performance profiles.

---

### **Question 22**

**Q:** CDP-DW is used for:

* A) Real-time streams
* B) Machine learning
* C) Large-scale data storage
* D) High-performance data warehousing ✅
  **Answer:** D)
  **Explanation:** CDP-DW enables scalable, secure, and optimized data warehouse queries.

---

### **Question 23**

**Q:** What is Transparent Huge Pages (THP)?

* A) Security feature
* B) Network protocol
* C) Memory management ✅
* D) Encryption
  **Answer:** C)
  **Explanation:** THP optimizes memory usage for large pages but can impact performance in Hadoop.

---

### **Question 24**

**Q:** Command for distributed shell execution?

* A) pdsh ✅
* B) dshell
* C) pshell
* D) parashell
  **Answer:** A)
  **Explanation:** `pdsh` allows simultaneous command execution across nodes.

---

### **Question 25**

**Q:** Hybrid platform for on-prem, cloud, edge data?

* A) CDP ✅
* B) Hadoop
* C) Hive
* D) Spark
  **Answer:** A)
  **Explanation:** Cloudera Data Platform supports unified analytics across all environments.

---

### **Question 26**

**Q:** Feature included in Cloudera Runtime?

* A) Python
* B) Impala ✅
* C) MySQL
* D) PostgreSQL
  **Answer:** B)
  **Explanation:** Impala is Cloudera’s MPP SQL query engine for Hadoop.

---

### **Question 27**

**Q:** Key CDP component?

* A) Hadoop ✅
* B) Kubernetes
* C) Apache HTTP
* D) Microsoft Office
  **Answer:** A)
  **Explanation:** CDP builds on Hadoop ecosystem with integrated tools.

---

### **Question 28**

**Q:** Language commonly used in CDP data processing?

* A) Java
* B) Python ✅
* C) C++
* D) Ruby
  **Answer:** B)
  **Explanation:** Python is widely used for Spark, Hive, and pipeline scripting.

---

### **Question 29**

**Q:** Apache Tez apps are written in:

* A) Java and Python ✅
* B) JS and Ruby
* C) C++ and PHP
* D) Swift and Kotlin
  **Answer:** A)
  **Explanation:** Tez APIs are Java-based, with some Python wrappers available.

---

### **Question 30**

**Q:** CDP Data Catalog is for:

* A) Real-time streaming
* B) ML deployment
* C) Metadata management and governance ✅
* D) BI and dashboards
  **Answer:** C)

---

### **Question 31**

**Q:** CDP Data Flow is used for:

* A) Machine learning
* B) Real-time analytics ✅
* C) On-premises only
* D) Data governance
  **Answer:** B)

---

### **Question 32**

**Q:** Correct CDP statement:

* A) Only on-prem
* B) Cloud-only
* C) Unified platform for on-prem and cloud ✅
* D) ML-only
  **Answer:** C)

---

### **Question 33**

**Q:** Technology for containerization?

* A) Virtualization
* B) Hadoop
* C) Docker ✅
* D) Spark
  **Answer:** C)

---

