# Cloudera Secure Hadoop Cluster - Complete Architecture & Setup Guide

## Table of Contents
1. [Executive Summary](#executive-summary)
2. [System Architecture](#system-architecture)
3. [Infrastructure Design](#infrastructure-design)
4. [Security Architecture](#security-architecture)
5. [Installation & Configuration](#installation--configuration)
6. [Service Configuration](#service-configuration)
7. [Authentication & Authorization](#authentication--authorization)
8. [Data Management](#data-management)
9. [Monitoring & Maintenance](#monitoring--maintenance)
10. [Troubleshooting](#troubleshooting)
11. [Best Practices](#best-practices)

---

## Executive Summary

This document provides a comprehensive guide for deploying a production-ready Cloudera Hadoop cluster with enterprise-grade security features including Kerberos authentication, Active Directory integration, and TLS encryption.

### Key Features
- **High Availability**: Multi-node cluster with redundancy
- **Security**: Kerberos + Active Directory + TLS encryption
- **Scalability**: Distributed architecture with horizontal scaling
- **Management**: Centralized administration via Cloudera Manager
- **Data Processing**: Hive, HDFS, YARN integration

---

## System Architecture

### 1. High-Level Architecture

```
┌─────────────────────────────────────────────────────────────────────────────────┐
│                           CLOUDERA HADOOP ECOSYSTEM                             │
├─────────────────────────────────────────────────────────────────────────────────┤
│                                                                                 │
│  ┌─────────────────┐    ┌─────────────────┐    ┌─────────────────┐             │
│  │   CLIENT TIER   │    │  MANAGEMENT     │    │   SECURITY      │             │
│  │                 │    │     TIER        │    │     TIER        │             │
│  │ • Hue Browser   │    │ • Cloudera Mgr  │    │ • Kerberos KDC  │             │
│  │ • Beeline       │    │ • Ambari        │    │ • Active Dir    │             │
│  │ • HDFS Client   │    │ • Monitoring    │    │ • TLS/SSL       │             │
│  └─────────────────┘    └─────────────────┘    └─────────────────┘             │
│                                                                                 │
├─────────────────────────────────────────────────────────────────────────────────┤
│                            DISTRIBUTED PROCESSING LAYER                        │
├─────────────────────────────────────────────────────────────────────────────────┤
│                                                                                 │
│  ┌─────────────────┐    ┌─────────────────┐    ┌─────────────────┐             │
│  │  MASTER NODE    │    │  WORKER NODE 1  │    │  WORKER NODE 2  │             │
│  │                 │    │                 │    │                 │             │
│  │ • NameNode      │    │ • DataNode      │    │ • DataNode      │             │
│  │ • ResourceMgr   │    │ • NodeManager   │    │ • NodeManager   │             │
│  │ • HiveServer2   │    │ • TaskTracker   │    │ • TaskTracker   │             │
│  │ • Metastore     │    │ • RegionServer  │    │ • RegionServer  │             │
│  │ • ZooKeeper     │    │                 │    │                 │             │
│  └─────────────────┘    └─────────────────┘    └─────────────────┘             │
│                                                                                 │
├─────────────────────────────────────────────────────────────────────────────────┤
│                              STORAGE LAYER                                     │
├─────────────────────────────────────────────────────────────────────────────────┤
│                                                                                 │
│  ┌─────────────────┐    ┌─────────────────┐    ┌─────────────────┐             │
│  │   HDFS BLOCK    │    │   HDFS BLOCK    │    │   HDFS BLOCK    │             │
│  │   STORAGE 1     │    │   STORAGE 2     │    │   STORAGE 3     │             │
│  │                 │    │                 │    │                 │             │
│  │ • Data Blocks   │    │ • Data Blocks   │    │ • Data Blocks   │             │
│  │ • Metadata      │    │ • Metadata      │    │ • Metadata      │             │
│  │ • Replication   │    │ • Replication   │    │ • Replication   │             │
│  └─────────────────┘    └─────────────────┘    └─────────────────┘             │
│                                                                                 │
└─────────────────────────────────────────────────────────────────────────────────┘
```

### 2. Network Architecture

```
┌─────────────────────────────────────────────────────────────────────────────────┐
│                            NETWORK TOPOLOGY                                    │
├─────────────────────────────────────────────────────────────────────────────────┤
│                                                                                 │
│                        ┌─────────────────────┐                                 │
│                        │    INTERNET         │                                 │
│                        │    GATEWAY          │                                 │
│                        └──────────┬──────────┘                                 │
│                                   │                                            │
│                        ┌─────────────────────┐                                 │
│                        │     VPC/VNET        │                                 │
│                        │   172.16.0.0/16     │                                 │
│                        └──────────┬──────────┘                                 │
│                                   │                                            │
│       ┌───────────────────────────┼───────────────────────────┐                │
│       │                           │                           │                │
│ ┌─────▼─────┐              ┌─────▼─────┐              ┌─────▼─────┐            │
│ │    AZ-A   │              │    AZ-B   │              │    AZ-C   │            │
│ │172.16.1.0/│              │172.16.2.0/│              │172.16.3.0/│            │
│ │    24     │              │    24     │              │    24     │            │
│ └─────┬─────┘              └─────┬─────┘              └─────┬─────┘            │
│       │                          │                          │                  │
│ ┌─────▼─────┐              ┌─────▼─────┐              ┌─────▼─────┐            │
│ │  Master   │              │ Worker-1  │              │ Worker-2  │            │
│ │   Node    │              │   Node    │              │   Node    │            │
│ │.1.10:7180 │              │ .2.10:8020│              │ .3.10:8020│            │
│ └───────────┘              └───────────┘              └───────────┘            │
│                                                                                 │
│                        ┌─────────────────────┐                                 │
│                        │   SECURITY ZONE     │                                 │
│                        │                     │                                 │
│                        │ • Kerberos KDC      │                                 │
│                        │ • Active Directory  │                                 │
│                        │ • Certificate Auth  │                                 │
│                        └─────────────────────┘                                 │
│                                                                                 │
└─────────────────────────────────────────────────────────────────────────────────┘
```

---

## Infrastructure Design

### 3. Node Specifications

| Node Type | Role | CPU | Memory | Storage | Network |
|-----------|------|-----|--------|---------|---------|
| **Master Node** | Cloudera Manager, NameNode, ResourceManager | 8 vCPU | 32 GB | 500 GB SSD | 10 Gbps |
| **Worker Node 1** | DataNode, NodeManager, HiveServer2 | 4 vCPU | 16 GB | 1 TB HDD | 1 Gbps |
| **Worker Node 2** | DataNode, NodeManager, Metastore | 4 vCPU | 16 GB | 1 TB HDD | 1 Gbps |
| **Worker Node 3** | DataNode, NodeManager, ZooKeeper | 4 vCPU | 16 GB | 1 TB HDD | 1 Gbps |

### 4. Service Distribution Matrix

| Service | Master | Worker-1 | Worker-2 | Worker-3 |
|---------|--------|----------|----------|----------|
| **Cloudera Manager** | ✓ | | | |
| **NameNode** | ✓ | | | |
| **ResourceManager** | ✓ | | | |
| **DataNode** | | ✓ | ✓ | ✓ |
| **NodeManager** | | ✓ | ✓ | ✓ |
| **HiveServer2** | | ✓ | | |
| **Hive Metastore** | | | ✓ | |
| **ZooKeeper** | | | | ✓ |
| **Hue** | ✓ | | | |

---

## Security Architecture

### 5. Security Layers

```
┌─────────────────────────────────────────────────────────────────────────────────┐
│                            SECURITY ARCHITECTURE                               │
├─────────────────────────────────────────────────────────────────────────────────┤
│                                                                                 │
│  ┌─────────────────────────────────────────────────────────────────────────┐   │
│  │                        APPLICATION SECURITY                             │   │
│  │                                                                         │   │
│  │  ┌─────────────┐  ┌─────────────┐  ┌─────────────┐  ┌─────────────┐    │   │
│  │  │    RBAC     │  │    ACLs     │  │ Authorization│  │ Audit Logs  │    │   │
│  │  │  (Role-     │  │  (Access    │  │   Policies   │  │  (Activity  │    │   │
│  │  │   Based)    │  │   Control)  │  │              │  │   Tracking) │    │   │
│  │  └─────────────┘  └─────────────┘  └─────────────┘  └─────────────┘    │   │
│  └─────────────────────────────────────────────────────────────────────────┘   │
│                                                                                 │
│  ┌─────────────────────────────────────────────────────────────────────────┐   │
│  │                       AUTHENTICATION LAYER                             │   │
│  │                                                                         │   │
│  │  ┌─────────────┐  ┌─────────────┐  ┌─────────────┐  ┌─────────────┐    │   │
│  │  │  Kerberos   │  │Active Dir/  │  │    LDAP     │  │    SAML     │    │   │
│  │  │    KDC      │  │    LDAP     │  │   Backend   │  │Integration  │    │   │
│  │  │(Ticket Auth)│  │ (User Mgmt) │  │             │  │             │    │   │
│  │  └─────────────┘  └─────────────┘  └─────────────┘  └─────────────┘    │   │
│  └─────────────────────────────────────────────────────────────────────────┘   │
│                                                                                 │
│  ┌─────────────────────────────────────────────────────────────────────────┐   │
│  │                        ENCRYPTION LAYER                                │   │
│  │                                                                         │   │
│  │  ┌─────────────┐  ┌─────────────┐  ┌─────────────┐  ┌─────────────┐    │   │
│  │  │  TLS/SSL    │  │  Data-at-   │  │  Data-in-   │  │  Key Mgmt   │    │   │
│  │  │(Wire Encryp)│  │   Rest      │  │  Transit    │  │  (KMS/HSM)  │    │   │
│  │  │             │  │ Encryption  │  │ Encryption  │  │             │    │   │
│  │  └─────────────┘  └─────────────┘  └─────────────┘  └─────────────┘    │   │
│  └─────────────────────────────────────────────────────────────────────────┘   │
│                                                                                 │
│  ┌─────────────────────────────────────────────────────────────────────────┐   │
│  │                         NETWORK SECURITY                               │   │
│  │                                                                         │   │
│  │  ┌─────────────┐  ┌─────────────┐  ┌─────────────┐  ┌─────────────┐    │   │
│  │  │  Firewall   │  │   Network   │  │    VPN      │  │  Security   │    │   │
│  │  │   Rules     │  │ Segmentation│  │  Gateway    │  │   Groups    │    │   │
│  │  │             │  │             │  │             │  │             │    │   │
│  │  └─────────────┘  └─────────────┘  └─────────────┘  └─────────────┘    │   │
│  └─────────────────────────────────────────────────────────────────────────┘   │
│                                                                                 │
└─────────────────────────────────────────────────────────────────────────────────┘
```

### 6. Kerberos Authentication Flow

```
┌─────────────────────────────────────────────────────────────────────────────────┐
│                        KERBEROS AUTHENTICATION FLOW                            │
├─────────────────────────────────────────────────────────────────────────────────┤
│                                                                                 │
│  Client                  KDC                   HiveServer2                      │
│    |                     |                         |                           │
│    |  1. kinit request    |                         |                           │
│    |-------------------->|                         |                           │
│    |                     |                         |                           │
│    |  2. TGT (Ticket     |                         |                           │
│    |     Granting Ticket)|                         |                           │
│    |<--------------------|                         |                           │
│    |                     |                         |                           │
│    |  3. Service Ticket  |                         |                           │
│    |     Request (TGS)   |                         |                           │
│    |-------------------->|                         |                           │
│    |                     |                         |                           │
│    |  4. Service Ticket  |                         |                           │
│    |<--------------------|                         |                           │
│    |                     |                         |                           │
│    |  5. Authenticated Request                     |                           │
│    |    (with Service Ticket)                      |                           │
│    |------------------------------------------>    |                           │
│    |                     |                         |                           │
│    |  6. Service Response                          |                           │
│    |<------------------------------------------|    |                           │
│    |                     |                         |                           │
│                                                                                 │
│  Principal Examples:                                                            │
│  • cm/admin@HADOOPSECURITY.COM                                                  │
│  • hive/worker1.hadoopsecurity.com@HADOOPSECURITY.COM                          │
│  • hdfs/master.hadoopsecurity.com@HADOOPSECURITY.COM                           │
│                                                                                 │
└─────────────────────────────────────────────────────────────────────────────────┘
```

---

## Installation & Configuration

### 7. Prerequisites & System Preparation

#### 7.1 System Requirements
```bash
# Operating System
RHEL/CentOS 7.x or Ubuntu 18.04+

# Java Version
OpenJDK 1.8.0 or Oracle JDK 1.8

# Hardware Minimum
CPU: 4 cores per node
RAM: 8GB per node
Storage: 100GB+ per node
Network: 1Gbps
```

#### 7.2 Network Configuration
```bash
# Configure /etc/hosts on all nodes
echo "172.16.1.10 master.hadoopsecurity.com master" >> /etc/hosts
echo "172.16.2.10 worker1.hadoopsecurity.com worker1" >> /etc/hosts
echo "172.16.3.10 worker2.hadoopsecurity.com worker2" >> /etc/hosts
echo "172.16.4.10 kdc-mit.hadoopsecurity.com kdc-mit" >> /etc/hosts

# Configure DNS resolution
echo "search hadoopsecurity.com" >> /etc/resolv.conf
echo "nameserver 172.16.1.10" >> /etc/resolv.conf

# Time synchronization
sudo yum install -y ntp
sudo systemctl enable ntpd
sudo systemctl start ntpd
```

#### 7.3 SSH Key Distribution
```bash
# Generate SSH keys on master node
ssh-keygen -t rsa -b 2048 -f ~/.ssh/id_rsa

# Copy public key to all nodes
ssh-copy-id ec2-user@worker1.hadoopsecurity.com
ssh-copy-id ec2-user@worker2.hadoopsecurity.com
ssh-copy-id ec2-user@worker3.hadoopsecurity.com

# Test passwordless SSH
ssh ec2-user@worker1.hadoopsecurity.com "hostname"
```

### 8. Cloudera Manager Installation

#### 8.1 Repository Setup
```bash
# Download and install Cloudera Manager repository
wget https://archive.cloudera.com/cm7/7.4.4/repo-as-tarball/cm7.4.4-redhat7.tar.gz
tar -xzf cm7.4.4-redhat7.tar.gz
sudo mv cm7.4.4 /opt/cloudera/cm-repo

# Create repository file
sudo tee /etc/yum.repos.d/cloudera-manager.repo << EOF
[cloudera-manager]
name=Cloudera Manager
baseurl=file:///opt/cloudera/cm-repo
enabled=1
gpgcheck=0
EOF
```

#### 8.2 Database Setup (PostgreSQL)
```bash
# Install PostgreSQL
sudo yum install -y postgresql-server postgresql-jdbc

# Initialize database
sudo postgresql-setup initdb
sudo systemctl enable postgresql
sudo systemctl start postgresql

# Create Cloudera databases
sudo -u postgres psql << EOF
CREATE DATABASE scm;
CREATE DATABASE amon;
CREATE DATABASE rman;
CREATE DATABASE hue;
CREATE DATABASE metastore;
CREATE DATABASE sentry;
CREATE DATABASE nav;
CREATE DATABASE navms;
CREATE DATABASE oozie;

CREATE USER scm WITH PASSWORD 'scm_password';
GRANT ALL PRIVILEGES ON DATABASE scm TO scm;
EOF
```

#### 8.3 Cloudera Manager Server Installation
```bash
# Install Cloudera Manager Server
sudo yum install -y cloudera-manager-server

# Initialize SCM database
sudo /opt/cloudera/cm/schema/scm_prepare_database.sh postgresql scm scm scm_password

# Start Cloudera Manager
sudo systemctl enable cloudera-scm-server
sudo systemctl start cloudera-scm-server

# Monitor startup
sudo tail -f /var/log/cloudera-scm-server/cloudera-scm-server.log

# Verify service is running
sudo ss -ltp | grep 7180
```

---

## Service Configuration

### 9. Core Hadoop Services

#### 9.1 HDFS Configuration
```xml
<!-- hdfs-site.xml -->
<configuration>
  <property>
    <name>dfs.nameservices</name>
    <value>hdfs-cluster</value>
  </property>
  
  <property>
    <name>dfs.ha.namenodes.hdfs-cluster</name>
    <value>nn1,nn2</value>
  </property>
  
  <property>
    <name>dfs.namenode.rpc-address.hdfs-cluster.nn1</name>
    <value>master.hadoopsecurity.com:8020</value>
  </property>
  
  <property>
    <name>dfs.replication</name>
    <value>3</value>
  </property>
  
  <property>
    <name>dfs.block.size</name>
    <value>134217728</value>
  </property>
  
  <property>
    <name>dfs.datanode.data.dir</name>
    <value>/data/hdfs/datanode</value>
  </property>
</configuration>
```

#### 9.2 YARN Configuration
```xml
<!-- yarn-site.xml -->
<configuration>
  <property>
    <name>yarn.resourcemanager.hostname</name>
    <value>master.hadoopsecurity.com</value>
  </property>
  
  <property>
    <name>yarn.nodemanager.resource.memory-mb</name>
    <value>12288</value>
  </property>
  
  <property>
    <name>yarn.scheduler.maximum-allocation-mb</name>
    <value>12288</value>
  </property>
  
  <property>
    <name>yarn.nodemanager.resource.cpu-vcores</name>
    <value>8</value>
  </property>
</configuration>
```

#### 9.3 Hive Configuration
```xml
<!-- hive-site.xml -->
<configuration>
  <property>
    <name>javax.jdo.option.ConnectionURL</name>
    <value>jdbc:postgresql://master.hadoopsecurity.com:5432/metastore</value>
  </property>
  
  <property>
    <name>javax.jdo.option.ConnectionDriverName</name>
    <value>org.postgresql.Driver</value>
  </property>
  
  <property>
    <name>javax.jdo.option.ConnectionUserName</name>
    <value>hive</value>
  </property>
  
  <property>
    <name>javax.jdo.option.ConnectionPassword</name>
    <value>hive_password</value>
  </property>
  
  <property>
    <name>hive.server2.authentication</name>
    <value>KERBEROS</value>
  </property>
  
  <property>
    <name>hive.server2.authentication.kerberos.principal</name>
    <value>hive/_HOST@HADOOPSECURITY.COM</value>
  </property>
  
  <property>
    <name>hive.server2.authentication.kerberos.keytab</name>
    <value>/etc/security/keytabs/hive.service.keytab</value>
  </property>
</configuration>
```

---

## Authentication & Authorization

### 10. Kerberos Setup (MIT KDC)

#### 10.1 KDC Installation & Configuration
```bash
# Install MIT Kerberos on dedicated server
sudo yum install -y krb5-server krb5-libs krb5-workstation

# Configure /etc/krb5.conf
sudo tee /etc/krb5.conf << EOF
[libdefaults]
    default_realm = HADOOPSECURITY.COM
    dns_lookup_realm = false
    dns_lookup_kdc = false
    ticket_lifetime = 24h
    renew_lifetime = 7d
    forwardable = true

[realms]
    HADOOPSECURITY.COM = {
        kdc = kdc-mit.hadoopsecurity.com:88
        admin_server = kdc-mit.hadoopsecurity.com:749
    }

[domain_realm]
    .hadoopsecurity.com = HADOOPSECURITY.COM
    hadoopsecurity.com = HADOOPSECURITY.COM
EOF

# Configure KDC database
sudo kdb5_util create -s -r HADOOPSECURITY.COM

# Configure KDC ACL
sudo tee /var/kerberos/krb5kdc/kadm5.acl << EOF
*/admin@HADOOPSECURITY.COM    *
cm/admin@HADOOPSECURITY.COM   *
EOF

# Start KDC services
sudo systemctl enable krb5kdc
sudo systemctl enable kadmin
sudo systemctl start krb5kdc
sudo systemctl start kadmin
```

#### 10.2 Principal Creation
```bash
# Create admin principal
sudo kadmin.local << EOF
addprinc cm/admin@HADOOPSECURITY.COM
addprinc hdfs/master.hadoopsecurity.com@HADOOPSECURITY.COM
addprinc yarn/master.hadoopsecurity.com@HADOOPSECURITY.COM
addprinc hive/worker1.hadoopsecurity.com@HADOOPSECURITY.COM
addprinc HTTP/master.hadoopsecurity.com@HADOOPSECURITY.COM
addprinc HTTP/worker1.hadoopsecurity.com@HADOOPSECURITY.COM
addprinc HTTP/worker2.hadoopsecurity.com@HADOOPSECURITY.COM
quit
EOF

# Generate keytabs
sudo kadmin.local << EOF
ktadd -k /etc/security/keytabs/hdfs.headless.keytab hdfs/master.hadoopsecurity.com@HADOOPSECURITY.COM
ktadd -k /etc/security/keytabs/yarn.service.keytab yarn/master.hadoopsecurity.com@HADOOPSECURITY.COM
ktadd -k /etc/security/keytabs/hive.service.keytab hive/worker1.hadoopsecurity.com@HADOOPSECURITY.COM
ktadd -k /etc/security/keytabs/spnego.service.keytab HTTP/master.hadoopsecurity.com@HADOOPSECURITY.COM
quit
EOF
```

### 11. Active Directory Integration

#### 11.1 LDAP Configuration
```bash
# Configure LDAP client
sudo yum install -y openldap-clients

# Test LDAP connectivity
ldapsearch -H ldaps://ad.company.com:636 -D "CN=hadoop-svc,OU=Service Accounts,DC=company,DC=com" -W -b "DC=company,DC=com" "(sAMAccountName=testuser)"
```

#### 11.2 Hue LDAP Configuration
```ini
# Configure Hue for LDAP authentication
[desktop]
[[auth]]
backend=desktop.auth.backend.LdapBackend

[[[ldap]]]
ldap_url=ldaps://ad.company.com:636
bind_dn=CN=hadoop-svc,OU=Service Accounts,DC=company,DC=com
bind_password=ServiceAccountPassword
base_dn=DC=company,DC=com
user_filter=(&(objectClass=user)(sAMAccountName={username}))
user_name_attr=sAMAccountName
group_filter=(&(objectClass=group)(member={dn}))
group_name_attr=cn
```

---

## Data Management

### 12. HDFS Data Architecture

#### 12.1 Directory Structure
```
/
├── user/
│   ├── hive/
│   │   └── warehouse/
│   │       ├── database1.db/
│   │       └── database2.db/
│   ├── spark/
│   │   └── eventlog/
│   └── admin/
│       └── scripts/
├── tmp/
│   └── hive/
├── data/
│   ├── raw/
│   ├── processed/
│   └── archive/
└── logs/
    ├── application/
    └── audit/
```

#### 12.2 Data Management Commands
```bash
# Create directory structure
hdfs dfs -mkdir -p /user/hive/warehouse
hdfs dfs -mkdir -p /data/{raw,processed,archive}
hdfs dfs -mkdir -p /logs/{application,audit}

# Set permissions
hdfs dfs -chown -R hive:hive /user/hive
hdfs dfs -chmod -R 755 /user/hive/warehouse
hdfs dfs -chmod -R 777 /tmp

# Monitor HDFS health
hdfs dfsadmin -report
hdfs fsck / -files -blocks -locations
```

### 13. Hive Data Warehouse

#### 13.1 Database Creation & Management
```sql
-- Create databases
CREATE DATABASE sales_db
COMMENT 'Sales data warehouse'
LOCATION '/user/hive/warehouse/sales_db.db';

CREATE DATABASE marketing_db
COMMENT 'Marketing analytics database'
LOCATION '/user/hive/warehouse/marketing_db.db';

-- Create external table
CREATE EXTERNAL TABLE sales_db.customer_data (
    customer_id BIGINT,
    first_name STRING,
    last_name STRING,
    email STRING,
    registration_date DATE,
    status STRING
)
PARTITIONED BY (year INT, month INT)
STORED AS PARQUET
LOCATION '/data/processed/customer_data/';

-- Create managed table
CREATE TABLE sales_db.transactions (
    transaction_id BIGINT,
    customer_id BIGINT,
    product_id BIGINT,
    quantity INT,
    amount DECIMAL(10,2),
    transaction_date TIMESTAMP
)
PARTITIONED BY (transaction_year INT)
STORED AS ORC
TBLPROPERTIES ('orc.compress'='SNAPPY');
```

#### 13.2 Data Loading Strategies
```sql
-- Load data from local file
LOAD DATA LOCAL INPATH '/home/ec2-user/customer_data.csv'
INTO TABLE sales_db.customer_data
PARTITION (year=2024, month=1);

-- Load data from HDFS
LOAD DATA INPATH '/data/raw/transactions/2024/01/'
INTO TABLE sales_db.transactions
PARTITION (transaction_year=2024);

-- Insert data using SQL
INSERT INTO TABLE sales_db.transactions
PARTITION (transaction_year=2024)
SELECT 
    transaction_id,
    customer_id,
    product_id,
    quantity,
    amount,
    transaction_date
FROM staging_db.raw_transactions
WHERE year(transaction_date) = 2024;
```

---

## Monitoring & Maintenance

### 14. Cluster Monitoring

#### 14.1 Cloudera Manager Monitoring

```bash
# Key Monitoring URLs
Cloudera Manager:     http://master.hadoopsecurity.com:7180
NameNode UI:          http://master.hadoopsecurity.com:9870
ResourceManager UI:   http://master.hadoopsecurity.com:8088
Hue Interface:        http://master.hadoopsecurity.com:8888
HiveServer2:          http://worker1.hadoopsecurity.com:10002

# Health Check Commands
# Check all services status
curl -u admin:admin http://master.hadoopsecurity.com:7180/api/v19/clusters/cluster/services

# Monitor HDFS health
hdfs dfsadmin -report
hdfs dfsadmin -safemode get

# Check YARN applications
yarn application -list -appStates ALL
yarn node -list -all

# Hive service status
beeline -u "jdbc:hive2://worker1.hadoopsecurity.com:10000/default;principal=hive/worker1.hadoopsecurity.com@HADOOPSECURITY.COM"
```

#### 14.2 Performance Monitoring

```bash
# System Resource Monitoring
# CPU and Memory usage
top -u hdfs,yarn,hive
htop

# Disk I/O monitoring
iotop
iostat -x 1

# Network monitoring
iftop
netstat -i

# JVM Monitoring
jps -v  # List Java processes
jstat -gc <pid>  # Garbage collection stats
jmap -histo <pid>  # Memory histogram

# HDFS Performance
hdfs dfsadmin -printTopology
hdfs dfsadmin -metasave /tmp/metasave.out
```

#### 14.3 Log Management

```bash
# Important Log Locations
/var/log/cloudera-scm-server/        # Cloudera Manager logs
/var/log/hadoop-hdfs/                # HDFS logs
/var/log/hadoop-yarn/                # YARN logs
/var/log/hive/                       # Hive logs
/var/log/hue/                        # Hue logs
/var/log/krb5/                       # Kerberos logs

# Log Analysis Commands
# Check for errors in Cloudera Manager
sudo tail -f /var/log/cloudera-scm-server/cloudera-scm-server.log | grep ERROR

# Monitor HDFS NameNode logs
sudo tail -f /var/log/hadoop-hdfs/hadoop-hdfs-namenode-*.log

# Check Hive errors
sudo grep -i error /var/log/hive/*.log

# Kerberos authentication issues
sudo tail -f /var/log/krb5kdc.log
sudo tail -f /var/log/kadmind.log
```

#### 14.4 Automated Monitoring Scripts

```bash
#!/bin/bash
# cluster-health-check.sh

echo "=== Cluster Health Check - $(date) ==="

# Check Cloudera Manager service
if systemctl is-active --quiet cloudera-scm-server; then
    echo "✓ Cloudera Manager: Running"
else
    echo "✗ Cloudera Manager: Stopped"
fi

# Check HDFS health
HDFS_HEALTH=$(hdfs dfsadmin -report 2>/dev/null | grep "Live datanodes" | awk '{print $3}')
echo "✓ HDFS Live DataNodes: $HDFS_HEALTH"

# Check YARN ResourceManager
YARN_HEALTH=$(yarn node -list 2>/dev/null | grep -c "RUNNING")
echo "✓ YARN Active Nodes: $YARN_HEALTH"

# Check Hive connectivity
if beeline -u "jdbc:hive2://worker1:10000" -e "SHOW DATABASES;" &>/dev/null; then
    echo "✓ Hive Server: Accessible"
else
    echo "✗ Hive Server: Connection Failed"
fi

# Check Kerberos tickets
if klist &>/dev/null; then
    echo "✓ Kerberos: Active tickets found"
else
    echo "⚠ Kerberos: No active tickets"
fi

echo "=== End Health Check ==="
```

### 15. Backup & Recovery

#### 15.1 HDFS Backup Strategy

```bash
# Full HDFS Backup using DistCp
hadoop distcp hdfs://source-cluster:8020/user/hive/warehouse \
                hdfs://backup-cluster:8020/backup/$(date +%Y%m%d)/

# Incremental backup
hadoop distcp -update -delete \
    hdfs://source-cluster:8020/user/hive/warehouse \
    hdfs://backup-cluster:8020/backup/incremental/

# Metadata backup (NameNode)
sudo cp -r /var/lib/hadoop-hdfs/cache/hdfs/dfs/name \
    /backup/namenode-backup-$(date +%Y%m%d)/

# Export HDFS directory listing
hdfs dfs -ls -R / > /backup/hdfs-listing-$(date +%Y%m%d).txt
```

#### 15.2 Database Backup

```bash
# PostgreSQL backup for Hive Metastore
pg_dump -h master.hadoopsecurity.com -U hive metastore > \
    /backup/metastore-backup-$(date +%Y%m%d).sql

# Cloudera Manager database backup
pg_dump -h master.hadoopsecurity.com -U scm scm > \
    /backup/cm-backup-$(date +%Y%m%d).sql

# Automated backup script
#!/bin/bash
BACKUP_DIR="/backup/$(date +%Y%m%d)"
mkdir -p $BACKUP_DIR

# Backup all databases
for db in scm metastore hue oozie; do
    pg_dump -h master.hadoopsecurity.com -U $db $db > $BACKUP_DIR/$db-backup.sql
done
```

#### 15.3 Configuration Backup

```bash
# Backup Cloudera Manager configurations
curl -u admin:admin \
    "http://master.hadoopsecurity.com:7180/api/v19/clusters/cluster/export" \
    > /backup/cm-config-$(date +%Y%m%d).json

# Backup Kerberos keytabs
sudo tar -czf /backup/keytabs-$(date +%Y%m%d).tar.gz /etc/security/keytabs/

# Backup configuration files
sudo tar -czf /backup/configs-$(date +%Y%m%d).tar.gz \
    /etc/hadoop/conf \
    /etc/hive/conf \
    /etc/hue/conf \
    /etc/krb5.conf
```

### 16. Maintenance Procedures

#### 16.1 Rolling Updates

```bash
# Update process for worker nodes
# 1. Drain node of running applications
yarn rmadmin -transitionToStandby rm1

# 2. Stop services on the node
sudo systemctl stop cloudera-scm-agent

# 3. Perform system updates
sudo yum update -y

# 4. Restart services
sudo systemctl start cloudera-scm-agent

# 5. Verify node health
yarn node -list | grep worker1
```

#### 16.2 Certificate Renewal

```bash
# Generate new SSL certificates
openssl req -new -x509 -days 365 -nodes \
    -out /etc/ssl/certs/hadoop.crt \
    -keyout /etc/ssl/private/hadoop.key \
    -subj "/C=US/ST=CA/L=SF/O=Company/CN=*.hadoopsecurity.com"

# Update Cloudera Manager with new certificates
# Via CM UI: Administration > Settings > Security > TLS/SSL
```

#### 16.3 Performance Tuning

```bash
# HDFS Performance Tuning
# Increase block size for large files
hdfs dfsadmin -setDefaultBlockSize 268435456  # 256MB

# YARN Memory Tuning
# Configure container memory
yarn.nodemanager.resource.memory-mb=14336
yarn.scheduler.maximum-allocation-mb=14336
yarn.app.mapreduce.am.resource.mb=2048

# Hive Performance Tuning
# Enable vectorization
set hive.vectorized.execution.enabled=true;
set hive.vectorized.execution.reduce.enabled=true;

# Enable cost-based optimizer
set hive.cbo.enable=true;
set hive.compute.query.using.stats=true;
set hive.stats.fetch.column.stats=true;
```

---

## Troubleshooting

### 17. Common Issues & Solutions

#### 17.1 Kerberos Authentication Issues

```bash
# Issue: Kerberos ticket expired
# Symptoms: Authentication failures, "GSSException" errors
# Solution:
kdestroy  # Clear existing tickets
kinit cm/admin@HADOOPSECURITY.COM  # Get new ticket
klist     # Verify active tickets

# Issue: Clock skew between KDC and client
# Symptoms: "krb_ap_rep_enc_part time too far from now"
# Solution:
sudo ntpdate -s time.nist.gov  # Sync system time
sudo systemctl restart ntpd

# Issue: SPN not found in Kerberos database
# Symptoms: "Server not found in Kerberos database"
# Solution:
sudo kadmin.local
kadmin.local: listprincs hive*  # List Hive principals
kadmin.local: addprinc hive/worker1.hadoopsecurity.com@HADOOPSECURITY.COM
```

#### 17.2 HDFS Issues

```bash
# Issue: HDFS in Safe Mode
# Symptoms: Cannot write to HDFS
# Solution:
hdfs dfsadmin -safemode get      # Check safe mode status
hdfs dfsadmin -safemode leave    # Exit safe mode manually
hdfs fsck / -files -blocks      # Check filesystem consistency

# Issue: DataNode not starting
# Symptoms: DataNode process fails to start
# Solution:
# Check logs
sudo tail -f /var/log/hadoop-hdfs/hadoop-hdfs-datanode-*.log

# Clear DataNode data if corrupted
sudo rm -rf /var/lib/hadoop-hdfs/cache/hdfs/dfs/data/current/*
sudo systemctl restart hadoop-hdfs-datanode

# Issue: Low disk space on DataNodes
# Solution:
hdfs dfsadmin -report | grep "DFS Used%"  # Check disk usage
hdfs dfs -du -h /                         # Check directory sizes
hdfs dfs -rm -r /tmp/old_data             # Clean up old data
```

#### 17.3 Hive Issues

```bash
# Issue: Hive Metastore connection failure
# Symptoms: "MetaException(message:Could not connect to meta store)"
# Solution:
# Check PostgreSQL service
sudo systemctl status postgresql
sudo systemctl start postgresql

# Test database connectivity
psql -h master.hadoopsecurity.com -U hive -d metastore -c "SELECT 1;"

# Restart Hive Metastore
sudo systemctl restart hive-metastore

# Issue: HiveServer2 memory issues
# Symptoms: Out of memory errors, slow queries
# Solution:
# Increase HiveServer2 heap size
export HADOOP_HEAPSIZE=4096  # 4GB heap
sudo systemctl restart hive-server2

# Issue: Hive query hanging
# Symptoms: Queries stuck in RUNNING state
# Solution:
# Check YARN application logs
yarn logs -applicationId application_1234567890123_0001

# Kill hanging application
yarn application -kill application_1234567890123_0001
```

#### 17.4 Network & Connectivity Issues

```bash
# Issue: DNS resolution problems
# Symptoms: "Unknown host" errors
# Solution:
nslookup master.hadoopsecurity.com
dig @172.16.1.10 worker1.hadoopsecurity.com

# Update /etc/hosts if needed
echo "172.16.2.10 worker1.hadoopsecurity.com worker1" >> /etc/hosts

# Issue: Port connectivity problems
# Symptoms: Connection timeouts
# Solution:
# Test port connectivity
telnet master.hadoopsecurity.com 7180  # Cloudera Manager
telnet worker1.hadoopsecurity.com 10000  # HiveServer2

# Check firewall rules
sudo firewall-cmd --list-all
sudo firewall-cmd --permanent --add-port=7180/tcp
sudo firewall-cmd --reload
```

### 18. Diagnostic Commands

```bash
# System Health Diagnostics
#!/bin/bash
echo "=== Hadoop Cluster Diagnostics ==="

# 1. Check all Java processes
echo "Java Processes:"
jps -v | grep -E "(NameNode|DataNode|ResourceManager|NodeManager|HiveServer2)"

# 2. Check service status
echo -e "\nService Status:"
for service in cloudera-scm-server hadoop-hdfs-namenode hadoop-hdfs-datanode \
               hadoop-yarn-resourcemanager hadoop-yarn-nodemanager hive-server2; do
    status=$(systemctl is-active $service 2>/dev/null || echo "not-installed")
    echo "$service: $status"
done

# 3. Check network connectivity
echo -e "\nNetwork Connectivity:"
for host in master worker1 worker2; do
    if ping -c 1 $host.hadoopsecurity.com &>/dev/null; then
        echo "$host: ✓ Reachable"
    else
        echo "$host: ✗ Unreachable"
    fi
done

# 4. Check HDFS health
echo -e "\nHDFS Health:"
hdfs dfsadmin -report 2>/dev/null | head -20

# 5. Check Kerberos tickets
echo -e "\nKerberos Status:"
klist 2>/dev/null || echo "No active tickets"

# 6. Check disk space
echo -e "\nDisk Usage:"
df -h | grep -E "(hadoop|hdfs|/data)"
```

---

## Best Practices

### 19. Security Best Practices

#### 19.1 Authentication & Authorization
- **Strong Authentication**: Always use Kerberos for cluster authentication
- **Service Principals**: Create dedicated service principals for each Hadoop service
- **Keytab Security**: Protect keytab files with appropriate permissions (600)
- **Ticket Renewal**: Implement automatic ticket renewal for long-running services
- **LDAP Integration**: Use centralized directory services for user management

#### 19.2 Network Security
- **TLS Encryption**: Enable TLS for all web UIs and service communications
- **Network Segmentation**: Isolate Hadoop cluster in dedicated network segments
- **Firewall Rules**: Implement strict firewall rules allowing only necessary ports
- **VPN Access**: Require VPN for external access to cluster resources

#### 19.3 Data Protection
- **Encryption at Rest**: Enable HDFS transparent encryption for sensitive data
- **Encryption in Transit**: Use SSL/TLS for all data transfers
- **Access Controls**: Implement fine-grained access controls using Apache Ranger
- **Data Classification**: Classify data based on sensitivity and apply appropriate controls

### 20. Performance Best Practices

#### 20.1 Hardware Optimization
- **Storage**: Use SSDs for NameNode metadata, HDDs for DataNode storage
- **Memory**: Allocate sufficient heap memory for NameNode (1GB per million blocks)
- **Network**: Use 10Gbps network for master nodes, 1Gbps minimum for workers
- **CPU**: Balance CPU cores with memory and storage capacity

#### 20.2 Configuration Optimization
```bash
# HDFS Optimization
dfs.block.size=268435456                    # 256MB blocks for large files
dfs.replication=3                           # Standard replication factor
dfs.namenode.handler.count=100              # NameNode RPC threads

# YARN Optimization  
yarn.nodemanager.resource.memory-mb=14336   # 14GB container memory
yarn.scheduler.maximum-allocation-mb=14336  # Maximum container size
yarn.nodemanager.resource.cpu-vcores=8     # CPU cores per node

# Hive Optimization
hive.exec.dynamic.partition=true            # Enable dynamic partitioning
hive.vectorized.execution.enabled=true     # Enable vectorization
hive.cbo.enable=true                        # Cost-based optimizer
```

#### 20.3 Data Management Best Practices
- **Partitioning**: Partition large tables by date or other logical dimensions
- **File Formats**: Use columnar formats (Parquet, ORC) for analytical workloads
- **Compression**: Enable compression (Snappy, GZIP) to reduce storage and I/O
- **Data Lifecycle**: Implement data retention policies and archival strategies

### 21. Operational Best Practices

#### 21.1 Monitoring & Alerting
- **Proactive Monitoring**: Monitor key metrics (CPU, memory, disk, network)
- **Alert Thresholds**: Set appropriate alert thresholds for critical metrics
- **Log Aggregation**: Centralize log collection and analysis
- **Capacity Planning**: Monitor growth trends and plan for capacity expansion

#### 21.2 Backup & Recovery
- **Regular Backups**: Implement automated backup procedures for data and metadata
- **Backup Testing**: Regularly test backup and recovery procedures
- **Multi-site Replication**: Consider cross-site replication for disaster recovery
- **Documentation**: Maintain detailed recovery procedures and contact information

#### 21.3 Change Management
- **Testing Environment**: Maintain separate development/testing clusters
- **Rolling Updates**: Use rolling update procedures to minimize downtime
- **Configuration Management**: Use version control for configuration changes
- **Rollback Procedures**: Maintain rollback procedures for failed deployments

---

## Appendices

### 22. Port Reference

| Service | Port | Protocol | Description |
|---------|------|----------|-------------|
| Cloudera Manager | 7180 | HTTP | Web UI |
| Cloudera Manager | 7183 | HTTPS | Secure Web UI |
| NameNode | 9870 | HTTP | Web UI |
| NameNode | 9820 | RPC | Client communication |
| DataNode | 9864 | HTTP | Web UI |
| DataNode | 9866 | TCP | Data transfer |
| ResourceManager | 8088 | HTTP | Web UI |
| ResourceManager | 8032 | RPC | Client communication |
| NodeManager | 8042 | HTTP | Web UI |
| HiveServer2 | 10000 | TCP | JDBC/ODBC |
| HiveServer2 | 10002 | HTTP | Web UI |
| Hue | 8888 | HTTP | Web UI |
| Kerberos KDC | 88 | TCP/UDP | Authentication |
| Kerberos Admin | 749 | TCP | Administration |

### 23. Command Reference

#### 23.1 HDFS Commands
```bash
# Basic operations
hdfs dfs -ls /                              # List directory
hdfs dfs -mkdir /user/testdir               # Create directory
hdfs dfs -put localfile /user/testdir/      # Upload file
hdfs dfs -get /user/testdir/file localfile  # Download file
hdfs dfs -rm -r /user/testdir               # Remove directory

# Administration
hdfs dfsadmin -report                       # Cluster report
hdfs dfsadmin -safemode get                 # Check safe mode
hdfs fsck / -files -blocks -locations       # Filesystem check
hdfs balancer                               # Balance data across nodes
```

#### 23.2 YARN Commands
```bash
# Application management
yarn application -list                      # List applications
yarn application -kill <app_id>            # Kill application
yarn logs -applicationId <app_id>          # View application logs

# Node management
yarn node -list                            # List nodes
yarn node -status <node_id>                # Node status
```

#### 23.3 Hive Commands
```bash
# Beeline connection
beeline -u "jdbc:hive2://worker1:10000/default;principal=hive/worker1@REALM"

# Basic SQL operations
SHOW DATABASES;                            # List databases
USE database_name;                         # Switch database
SHOW TABLES;                               # List tables
DESCRIBE table_name;                       # Table schema
```

#### 23.4 Kerberos Commands
```bash
# Authentication
kinit username@REALM                       # Get ticket
klist                                      # List tickets
kdestroy                                   # Destroy tickets

# Administration
kadmin.local                               # Admin console
kadmin.local: listprincs                   # List principals
kadmin.local: addprinc username@REALM      # Add principal
```

---

## Conclusion

This comprehensive guide provides a complete reference for deploying, configuring, and maintaining a secure Cloudera Hadoop cluster. The architecture and procedures outlined here follow enterprise best practices and provide a solid foundation for production deployments.

Key takeaways:
- **Security First**: Always implement proper authentication, authorization, and encryption
- **Monitoring**: Proactive monitoring is essential for cluster health and performance
- **Documentation**: Maintain detailed documentation for all procedures and configurations
- **Testing**: Regular testing of backup, recovery, and failover procedures is critical
- **Continuous Improvement**: Regularly review and optimize cluster performance and security

For additional support and updates, refer to the official Cloudera documentation and community resources.