

# 📘 Databases Overview in AWS

---

## 1️⃣ Introduction: Why Databases Matter

Databases store, organize, and manage **structured and unstructured data**. They enable applications to handle data efficiently, ensuring performance, reliability, and scalability.

AWS offers multiple managed database services, reducing the operational burden of provisioning, maintenance, backups, and scaling.

---

## 2️⃣ Database Types and Use Cases

AWS supports a **wide range of database types**—each optimized for specific use cases:

| **Type**        | **Use Case**                                     | **AWS Services**              |
| --------------- | ------------------------------------------------ | ----------------------------- |
| Relational      | Structured data with relationships, transactions | Amazon RDS, Aurora            |
| Non-Relational  | Flexible schema, key-value, documents, graphs    | DynamoDB, DocumentDB, Neptune |
| Data Warehouse  | Analytics, big data, OLAP queries                | Amazon Redshift               |
| Time Series     | IoT, telemetry, time-stamped data                | Amazon Timestream             |
| Ledger          | Immutable, cryptographically verifiable records  | Amazon QLDB                   |
| In-Memory Cache | High-speed caching                               | ElastiCache (Redis/Memcached) |
| Search          | Full-text search, logs                           | Amazon OpenSearch             |

---

## 3️⃣ Managed Database Services

AWS provides **fully managed database services**, handling:

✅ Provisioning
✅ Patching
✅ Backups and snapshots
✅ Monitoring
✅ Scaling
✅ High availability

Example: Amazon RDS offers automated backups, patch management, and Multi-AZ deployments for **high availability**.

---

## 4️⃣ Relational Databases in AWS

Relational databases store structured data in **tables** with rows and columns, supporting **ACID transactions**.

### 🔹 Example

* **Customers Table** → stores customer data.
* **Orders Table** → linked via a **foreign key**.

---

### 🔹 Amazon RDS Overview

AWS RDS (Relational Database Service) supports **six popular relational engines**:

| **Engine**           | **Use Case**                                      |
| -------------------- | ------------------------------------------------- |
| MySQL                | General purpose, open-source                      |
| PostgreSQL           | Advanced features, extensibility                  |
| MariaDB              | Drop-in replacement for MySQL                     |
| Oracle               | Enterprise features, PL/SQL                       |
| Microsoft SQL Server | Windows workloads, .NET apps                      |
| Amazon Aurora        | MySQL- and PostgreSQL-compatible, cloud-optimized |

---

## 5️⃣ Read Replicas in RDS

Read replicas allow **read-only** copies of your database for:

✅ Offloading read traffic
✅ Reporting and analytics
✅ Scaling reads horizontally

* **Write operations** still go to the primary database.
* Replicas are **asynchronous**.

---

## 6️⃣ Read and Write Access

| **Primary DB**    | Handles **read** and **write** operations.   |
| ----------------- | -------------------------------------------- |
| **Read Replicas** | Handle **read-only** operations (no writes). |

Use read replicas to improve **read scalability** without impacting write performance.

---

## 7️⃣ RDS Read Replicas vs Multi-AZ

| **Feature**         | **Read Replicas**      | **Multi-AZ**                   |
| ------------------- | ---------------------- | ------------------------------ |
| Purpose             | Scale reads, analytics | High availability              |
| Sync Mode           | Asynchronous           | Synchronous replication        |
| Use Case            | Scale read traffic     | Failover during outages        |
| Read-Only Access    | Yes                    | No (standby is not accessible) |
| Cross-Region Option | Yes                    | Yes (cross-region replication) |

---

## 8️⃣ RDS Deployment Scenarios

| **Scenario** | **Description**                                            |
| ------------ | ---------------------------------------------------------- |
| Single AZ    | Basic deployment, lower cost, single point of failure.     |
| Multi-AZ     | Synchronous replication across AZs for automatic failover. |
| Cross-Region | Disaster recovery, global applications.                    |

---

## 9️⃣ EBS Volumes and RDS

* RDS uses **EBS (Elastic Block Store)** volumes for storage.
* Supports **automated snapshots**:

  * Daily backups.
  * Point-in-time recovery.
  * User-initiated snapshots for backups or cloning.

---

## 🔟 Auto Scaling

* RDS does not **auto-scale** vertically (instance size) — you must manually resize.
* RDS can **auto-scale storage** (e.g., Aurora’s auto-scaling storage).
* Aurora Serverless offers **automatic compute scaling**.

---

## 1️⃣1️⃣ Demo (Step-by-Step)

### 🔹 Create an RDS Database

✅ Console → RDS → Create Database
✅ Select engine (e.g., MySQL)
✅ Choose Multi-AZ or Single AZ
✅ Configure instance size, storage (EBS)
✅ Configure VPC, security groups
✅ Enable automatic backups
✅ Launch instance

### 🔹 Add a Read Replica

✅ Select DB → Actions → Create read replica
✅ Choose region (same or cross-region)
✅ Configure settings → Launch

---

## 1️⃣2️⃣ Additional Key Concepts

✅ **IAM Authentication** — Use AWS IAM to control DB access.
✅ **Parameter Groups** — Configure DB engine settings.
✅ **Option Groups** — Enable additional features (e.g., Oracle Enterprise options).
✅ **Monitoring** — CloudWatch metrics, Enhanced Monitoring.
✅ **Maintenance** — Apply patches with maintenance windows.

---

## 📝 Summary Checklist

🔲 Know your workload (OLTP, OLAP, etc.).
🔲 Choose the appropriate engine (MySQL, PostgreSQL, etc.).
🔲 Decide on single vs. Multi-AZ deployment.
🔲 Use read replicas for scaling reads.
🔲 Configure EBS backups and snapshots.
🔲 Secure your DB with IAM roles and security groups.
🔲 Plan scaling strategy (Aurora Serverless for compute, RDS storage auto-scaling).

---

## 1️⃣3️⃣ Suggested Additional Topics

✅ **Aurora Global Databases** — low-latency global applications.
✅ **Data Migration** — AWS DMS (Database Migration Service).
✅ **RDS Proxy** — connection pooling for high-concurrency workloads.
✅ **Performance Insights** — detailed performance monitoring.
✅ **Cost Optimization** — reserved instances, right-sizing.
✅ **Serverless Options** — Aurora Serverless for unpredictable workloads.
