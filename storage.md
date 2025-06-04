# 📘 AWS Storage Overview

---

## 1️⃣ Introduction

AWS offers a variety of storage solutions tailored to different workloads:

✅ **Amazon S3** — Object storage
✅ **Amazon EFS** — File storage
✅ **Amazon FSx** — Managed third-party file systems
✅ **Storage Gateway** — Hybrid cloud storage (on-premises + cloud)
✅ **Snow Family** — Edge computing and offline data migration

Each service addresses specific use cases, from **web apps and backups** to **enterprise data storage**.

---

## 2️⃣ Amazon S3 — Simple Storage Service

### 🔹 What is S3?

* Inexpensive, **object-based storage** (like files, images, videos, backups).
* **Scales automatically**, reliable and durable.
* Organized into **buckets** (top-level containers).

---

### 🔹 S3 Naming and Architecture

* Buckets are globally unique within AWS.
* Bucket names:

  * Lowercase letters, numbers, hyphens (no uppercase or underscores).
  * Example: `my-company-backups`.
* Buckets exist within a single AWS **region** but accessible globally.

---

### 🔹 Step-by-Step: Create an S3 Bucket

✅ AWS Console → S3 → **Create bucket**
✅ Enter **bucket name** (e.g., `my-company-backups`).
✅ Choose region (e.g., `us-east-1`).
✅ Configure settings (versioning, encryption, permissions).
✅ Click **Create bucket**.

---

### 🔹 S3 Size Limits

* **Single object** limit: 5 TB.
* **Upload limit** (single PUT): 5 GB recommended limit.
* **Multipart Upload**:

  * Required for large files.
  * Splits file into parts (upload in parallel, resumable).

---

### 🔹 Durability and Availability

* **Durability**: 99.999999999% (11 nines).
* **Availability**: 99.99% (SLA).

---

## 3️⃣ S3 Encryption

### 🔹 At Rest

1. **Server-Side Encryption (SSE)**:

   * SSE-S3: S3 manages keys.
   * SSE-KMS: AWS KMS manages keys (additional features like audit trails).
   * SSE-C: Customer-provided keys.

2. **Client-Side Encryption**:

   * Encrypt data before uploading.

---

### 🔹 In Transit

* Use **SSL/TLS** (HTTPS) when accessing S3 endpoints.
* Always enable encrypted endpoints.

---

### 🔹 Encryption Buckets and Objects

* Enable **default encryption** at the bucket level.
* Apply encryption settings per object as needed.

---

## 4️⃣ S3 Versioning

* Keeps **multiple versions** of an object.
* Helps recover from accidental deletes or overwrites.
* Bucket-level setting.

### 🔹 MFA Delete

* Extra layer of protection to prevent accidental deletion.
* Requires multi-factor authentication to delete versions.
* **Demo**:

  * Enable versioning on bucket.
  * Enable MFA delete in console.

---

### 🔹 Object Lock

* Prevents object deletion or overwriting for a specified retention period.
* **Legal Hold**:

  * Applies to object versions.
  * Protects data until explicitly removed.

---

## 5️⃣ S3 Lifecycle Management

* Optimize storage costs automatically.
* Define **lifecycle rules**:

  * Transition to cheaper storage (e.g., S3 Standard → S3-IA).
  * Expire/delete objects after a retention period.

---

### 🔹 S3 Storage Classes

| Class                   | Use Case                                  |
| ----------------------- | ----------------------------------------- |
| S3 Standard             | Frequent access, high durability.         |
| S3 Standard-IA          | Infrequent access, lower cost.            |
| S3 One Zone-IA          | Single AZ, low-cost, less durable.        |
| S3 Glacier              | Archival, retrieval within minutes/hours. |
| S3 Glacier Deep Archive | Lowest cost, retrieval within hours.      |

---

## 6️⃣ Accessing Objects in S3

### 🔹 Access Policies

1. **IAM Policies**:

   * User or role-level permissions.

2. **Resource Policies**:

   * Bucket policies (resource-based).
   * Examples: allow cross-account access, restrict IP ranges.

---

### 🔹 Block Public Access

* Block all public access at account or bucket level.
* Highly recommended for security.

---

### 🔹 Bucket Policies

* JSON-based policy applied at bucket level.
* AWS Policy Generator can help create policies.

---

### 🔹 Pre-Signed URLs

* Temporary, secure URL for accessing an object.
* Example: share a file without making it public.

---

## 7️⃣ Static Website Hosting in S3

* Host a static site using an S3 bucket.
* Configure:

  * Index document (e.g., index.html).
  * Error document (e.g., error.html).
* Use Route 53 or domain provider to point DNS to bucket endpoint.

---

## 8️⃣ CORS and S3

* Cross-Origin Resource Sharing.
* Allows web apps to access resources in different domains.
* Configure CORS rules in bucket settings.

---

## 9️⃣ Elastic File System (EFS)

* **Fully managed, elastic file system** for EC2, Lambda, containers.
* Supports:

  * **Mount Targets** (to connect across AZs).
  * **POSIX-compliant** (NFS).

---

## 🔟 Amazon FSx

* Fully managed **third-party file systems** (Windows File Server, Lustre).
* Supports Windows-based apps, HPC workloads.

---

## 1️⃣1️⃣ AWS Storage Gateway

* Hybrid storage for on-premises and AWS.

* Three types:

  1. **File Gateway** — NFS/SMB to S3.
  2. **Volume Gateway** — iSCSI block storage.
  3. **Tape Gateway** — Virtual tape backups to S3 Glacier.

* Useful for:

  * On-prem backup/restore.
  * Data migration to AWS.
  * Archiving.

---

## 1️⃣2️⃣ Edge Computing and Storage

* **Snow Family**:

  * Snowcone, Snowball Edge, Snowmobile.
  * For edge computing and offline data transfer.

---

## 1️⃣3️⃣ Additional Key Points

✅ S3 is **inexpensive, virtually unlimited, reliable object storage**.
✅ **Eventually consistent** — new writes might take time to propagate.
✅ **Storage classes** optimize cost by matching usage patterns.
✅ Use **Versioning + MFA Delete** to protect data.
✅ **Access Control** is critical — IAM, bucket policies, and ACLs.
✅ **Pre-signed URLs** enable temporary sharing.
✅ **EFS** for file storage on EC2, containers, Lambda.
✅ **Amazon FSx** for third-party file systems.
✅ **Storage Gateway** bridges on-prem and cloud.
✅ **Snow Family** supports offline data transfer and edge computing.

---

## 1️⃣4️⃣ New Topics You May Want to Explore

✅ **S3 Intelligent-Tiering** — automatic cost optimization by moving objects between frequent and infrequent tiers.
✅ **Replication** — Cross-Region Replication (CRR) and Same-Region Replication (SRR) for disaster recovery.
✅ **Event Notifications** — triggers on object creation/deletion (SNS, SQS, Lambda).
✅ **Object Lambda** — modify data before serving via GET requests.

---

## 📝 Summary Checklist

🔲 Create S3 bucket & upload object.
🔲 Enable encryption (SSE-S3/SSE-KMS/SSE-C).
🔲 Enable versioning & MFA delete.
🔲 Create lifecycle rules for cost optimization.
🔲 Block public access & test pre-signed URLs.
🔲 Host a static website.
🔲 Mount EFS to EC2 instance.
🔲 Explore FSx for Windows or Lustre.
🔲 Deploy a Storage Gateway.
🔲 Understand Snow Family and edge use cases.

