# 📚 **AWS Security and Compliance Services**

---

## 🛡️ **1. Overview of AWS Security Services**

AWS provides a **shared responsibility model** for security. Security responsibilities are divided between AWS (the cloud provider) and the customer (you).

| **Responsibility**          | **Description**                                                                                      |
| --------------------------- | ---------------------------------------------------------------------------------------------------- |
| **AWS Responsibility**      | Security **of** the cloud: hardware, software, networking, and facilities that run AWS services.     |
| **Customer Responsibility** | Security **in** the cloud: data protection, access management, application security, and compliance. |

---

## 🏗️ **2. Infrastructure Protection**

Protect the network and infrastructure layers from threats:

* **AWS Shield**: Protection against Distributed Denial of Service (DDoS) attacks.

  * **Shield Standard**: Automatically enabled for all AWS customers.
  * **Shield Advanced**: Additional DDoS protection with real-time metrics, 24/7 AWS DDoS Response Team (DRT), and cost protection.
* **AWS Web Application Firewall (WAF)**: Protects web applications from common web exploits.
* **Amazon VPC Security**: Includes Security Groups and Network ACLs to control inbound and outbound traffic.

---

## 🔒 **3. Data Protection**

Data protection focuses on securing data at rest and in transit:

* **Encryption Types**:

  * **At Rest**: Encrypting data stored on disks (S3, EBS, RDS, etc.).
  * **In Transit**: Encrypting data as it moves across the network (HTTPS, TLS).
* **AWS Key Management Service (KMS)**:

  * Primary service for creating and managing cryptographic keys.
  * Supports both **AWS-managed keys** and **customer-managed keys**.
* **AWS CloudHSM**:

  * Dedicated hardware security modules for customers with strict compliance requirements.
  * Allows managing keys in FIPS 140-2 Level 3 validated hardware.
* **Types of Keys**:

  * **AWS Managed Keys**: Managed and rotated by AWS automatically.
  * **Customer Managed Keys**: Customer fully controls the key lifecycle, usage, and rotation.
* **AWS Certificate Manager (ACM)**:

  * Issues and manages SSL/TLS certificates for websites and applications.

---

## 🔐 **4. Data Protection Services**

* **AWS Secrets Manager**:

  * Securely stores and manages secrets (e.g., database credentials, API keys).
  * Supports automatic rotation and auditing.
* **SSM Parameter Store**:

  * Hierarchical storage for configuration data and secrets.
  * Supports both plain text and encrypted values using KMS.
  * Best for general parameters and smaller secrets.

| Feature                 | SSM Parameter Store | Secrets Manager      |
| ----------------------- | ------------------- | -------------------- |
| Secret Rotation         | ❌ Manual only       | ✅ Automatic rotation |
| Cost                    | Free (basic)        | Pay per secret       |
| API Gateway Integration | ❌                   | ✅                    |

---

### 🔧 **Secrets Manager Demo: Storing a New Password**

1. **Go to AWS Secrets Manager Console**.
2. **Click "Store a new secret"**.
3. Select **"Other type of secret"**.
4. Add **key-value pairs** (e.g., `username` and `password`).
5. Select **KMS key** for encryption (optional).
6. Name your secret (e.g., `/myapp/dbpassword`).
7. **Review** and click **Store**.

---

## 🕵️ **5. Threat Detection and Monitoring**

* **Amazon Inspector**:

  * Automated security assessment for EC2 instances and container workloads.
  * Checks for vulnerabilities and best practices.
* **Amazon GuardDuty**:

  * Threat detection service that continuously monitors AWS accounts and workloads for malicious or unauthorized behavior.
* **AWS Security Hub**:

  * Centralized view of security alerts and compliance status across AWS accounts.
  * Aggregates findings from GuardDuty, Inspector, Macie, and third-party tools.
* **Amazon Detective**:

  * Interactive security investigation service.
  * Visualizes relationships between resources to help identify root causes of security issues.

---

## 📝 **6. Compliance and Governance**

* **AWS Artifact**:

  * Self-service portal for on-demand access to AWS compliance reports and agreements (e.g., ISO, SOC, PCI).
  * Helps demonstrate AWS’s compliance posture to regulators and auditors.

---

## 📌 **7. Important Points to Remember**

✅ **AWS Shared Responsibility Model**: Know what AWS handles vs. what you need to manage.
✅ **Shield Standard** is enabled by default for all AWS accounts.
✅ Always encrypt data **at rest** and **in transit**.
✅ **KMS** is the central service for managing keys.
✅ Use **Secrets Manager** for secure, rotating secrets.
✅ Combine **GuardDuty**, **Inspector**, and **Security Hub** for a holistic security posture.
✅ Use **AWS Artifact** for compliance documentation.
✅ Understand the differences between **Secrets Manager** and **SSM Parameter Store**.
✅ Stay up to date with best practices for incident response and monitoring.

---

## 🚀 Summary Table

| **Category**              | **Services**                                  |
| ------------------------- | --------------------------------------------- |
| Infrastructure Protection | AWS Shield, AWS WAF, VPC Security             |
| Data Protection           | KMS, CloudHSM, ACM, S3 encryption             |
| Threat Detection          | GuardDuty, Inspector, Security Hub, Detective |
| Secret Management         | Secrets Manager, SSM Parameter Store          |
| Compliance                | AWS Artifact, Security Hub                    |

---

## 🔗 Additional Topics

* **AWS Macie** (Data Loss Prevention for S3).
* **IAM best practices** (least privilege, MFA).
* **Incident Response** (AWS CloudTrail, AWS Config).
* **Zero Trust Architecture** (fine-grained controls, micro-segmentation).
