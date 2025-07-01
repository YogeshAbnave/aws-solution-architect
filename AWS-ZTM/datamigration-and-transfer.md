
# 📘 Database Migration and Data Transfer in AWS

---

## 1️⃣ Introduction

Migrating databases to the cloud is a key step in modernizing workloads and achieving scalability, flexibility, and cost savings. AWS offers **Database Migration Service (DMS)** to facilitate seamless, low-downtime migrations, along with other tools for file transfers and application modernization.

---

## 2️⃣ AWS Database Migration Service (DMS)

### 🔹 Overview

AWS DMS is a **fully managed service** that helps you migrate data between databases quickly and securely with minimal downtime. It supports homogeneous (e.g., Oracle to Oracle) and heterogeneous (e.g., Oracle to PostgreSQL) migrations.

### 🔹 Typical Scenario

* **Source Database**: Could be on-premises, in an EC2 instance, or another cloud provider.
* **Target Database**: AWS RDS, Aurora, DynamoDB, or even EC2-hosted databases.

### 🔹 Features

✅ Continuous data replication
✅ Minimal downtime
✅ Supports homogeneous and heterogeneous migrations
✅ Migration monitoring dashboards
✅ CDC (Change Data Capture) support

---

## 3️⃣ AWS Schema Conversion Tool (SCT)

🔸 **AWS SCT** helps convert **database schema and code** from one engine to another (e.g., Oracle to PostgreSQL).

### 🔸 Key Uses:

✅ Converts tables, indexes, views, stored procedures, triggers, etc.
✅ Reports compatibility issues and suggests solutions.
✅ Generates a migration assessment report.

---

## 4️⃣ Source and Target Database Support

### 🔹 Source Databases

* On-premises (Oracle, SQL Server, MySQL, PostgreSQL, MongoDB, etc.)
* EC2-hosted databases
* AWS RDS
* Azure / GCP-hosted databases

### 🔹 Target Databases

* Amazon RDS (all engines)
* Amazon Aurora
* Amazon Redshift (for data warehouse)
* DynamoDB (via AWS DMS)
* S3 (as a data lake or interim storage)
* EC2-hosted databases

🔹 **Tip:** AWS DMS also supports **ongoing replication** for near real-time use cases.

---

## 5️⃣ Data Sync Overview

### 🔹 Data Sync

* AWS DataSync is a **fully managed service** for transferring large amounts of data between:

  * On-premises storage
  * S3
  * EFS
  * FSx
  * Other AWS services or regions

✅ Supports **incremental replication**
✅ Handles **millions of files**
✅ Compression and encryption built-in

### 🔹 Typical Use Cases

* Data lake ingestion
* Backup and archiving
* Hybrid cloud architectures
* Large-scale file migrations

---

## 6️⃣ On-Premises to AWS: Examples

* Migrate **shared file systems** to S3, EFS, or FSx.
* Transfer large datasets (logs, backups) to S3.
* Migrate relational databases to RDS or Aurora using DMS.

---

## 7️⃣ AWS Storage Options (Post-Migration Targets)

| **Service**           | **Use Case**                                                   |
| --------------------- | -------------------------------------------------------------- |
| **S3**                | Data lake, backups, static assets                              |
| **EFS**               | File share for applications                                    |
| **FSx**               | Fully managed Windows file system or Lustre (high performance) |
| **Amazon RDS/Aurora** | Relational database workloads                                  |

---

## 8️⃣ Migration Strategies

🔹 **Lift-and-Shift**: Move apps as-is to AWS (e.g., EC2 migration).
🔹 **Re-Architecting**: Redesign apps for cloud-native services (e.g., Lambda, Aurora).
🔹 **Re-Developing**: Rebuild apps from scratch to leverage serverless or containers.
🔹 **Consolidating**: Merge multiple workloads into one cloud-native service (e.g., Aurora Multi-Master).

---

## 9️⃣ AWS Application Migration Service

* Replaces the older AWS Server Migration Service (SMS).
* Automates the **lift-and-shift migration** of physical, virtual, and cloud-based servers to AWS.
* Supports **re-hosting** of applications without code changes.

---

## 🔟 AWS Transfer Family

A **fully managed service** to transfer files into and out of AWS using standard protocols:

✅ **SFTP** (Secure File Transfer Protocol)
✅ **FTPS** (File Transfer Protocol over SSL)
✅ **FTP** (File Transfer Protocol)

### 🔹 Benefits

* Integrates with S3 and EFS.
* Supports user management via AWS IAM.
* Provides audit logging via CloudWatch.

---

## 1️⃣1️⃣ Important Points to Remember

✅ **DMS** is for database migrations (structured data).
✅ **DataSync** is for file-level data movement (unstructured data).
✅ **Schema Conversion Tool** helps with heterogeneous migrations.
✅ **DMS** supports **ongoing replication** for near real-time migration.
✅ Always plan **cutover** and **downtime** strategies.
✅ Choose between **lift-and-shift** and **re-architecture** based on business needs.
✅ Secure transfers using encryption and VPC configurations.
✅ **AWS Application Migration Service** now replaces **SMS** for server-level migrations.

---

## 📝 Additional Topics (Optional)

* Database Performance Tuning in AWS.
* Data Encryption during Migration (TLS, VPN).
* Network considerations: Direct Connect, VPN.
* Cost considerations: reserved instances, data transfer charges.
* Post-migration validation and testing strategies.
