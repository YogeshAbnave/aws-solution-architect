
# 📚 AWS Cloud Notes

---

## `01_AWS_Cloud_Baseline.md`

```markdown
# AWS Cloud Baseline

A high-level overview of essential AWS services and concepts to build a solid cloud foundation.

---

## 🌐 Overview

AWS (Amazon Web Services) is a comprehensive cloud computing platform providing computing power, storage, databases, and a broad set of services that help organizations build scalable and secure applications.

---

## 💡 Key Benefits

- **Scalability:** Scale up or down based on demand.
- **Cost-Effective:** Pay-as-you-go model; avoid large upfront investments.
- **Flexibility:** Choose the operating system, programming language, web application platform, database, and other services you need.

---

## 🛠️ Foundational Services

| Service    | AWS Service | Example Use Case |
| ---------- | ----------- | ---------------- |
| Compute    | EC2         | Hosting a web server or application backend. |
| Database   | RDS         | Running a managed MySQL/PostgreSQL database. |
| Storage    | S3          | Hosting website static files (HTML/CSS/JS). |
| Networking | VPC         | Creating a secure private network for applications. |
| Security   | IAM         | Managing user permissions and roles. |

---

## 📝 Example: Hosting a Website

- **Step 1:** Launch an EC2 instance (Amazon Linux 2).
- **Step 2:** Install a web server (e.g., Apache).
- **Step 3:** Upload website files to `/var/www/html`.
- **Step 4:** Configure a security group to allow HTTP (port 80) and SSH (port 22).
- **Step 5:** Use Route 53 to create a DNS record pointing to the EC2 public IP.
```

---

## `02_Authentication_and_Authorization.md`

````markdown
# Authentication and Authorization in AWS

Understand IAM, roles, users, groups, and best practices with real-world examples.

---

## 🔑 IAM (Identity and Access Management)

IAM helps manage **users, groups, and permissions** within a **single AWS account**.

### Example:
- **User:** Alice (Developer)
- **Group:** Developers
- **Policy:** Developers can deploy Lambda functions but cannot delete S3 buckets.

---

## 🔑 IAM Identity Center (formerly AWS SSO)

Centralized access across **multiple AWS accounts** and 3rd-party apps.

### Example:
- **Scenario:** Alice needs access to the Dev account and Salesforce.
- **Solution:** AWS SSO lets Alice sign in once and get access to both.

---

## 👤 Root User vs. IAM User

| Feature       | Root User                       | IAM User                      |
| ------------- | ------------------------------- | ----------------------------- |
| Access        | Full account-wide permissions.  | Controlled by policies.       |
| Example       | Close AWS account.              | Create EC2 instances.         |
| Best Practice | Use sparingly with MFA enabled. | Use least privilege.          |

---

## 👥 User Groups

Group users with similar roles.

### Example:
- **Tester Group:** Read-only access to S3 buckets.
- **Admin Group:** Full access to all services.
- **Developers Group:** Deploy EC2 and Lambda.

---

## 🛡️ Roles

Roles provide **temporary credentials** for apps/services/users.

### Example:
- **Scenario:** EC2 instance needs to read from S3.
- **Solution:** Attach a role with `AmazonS3ReadOnlyAccess` policy to the EC2 instance.

---

## 📜 Policies

Policies define permissions in JSON.

### Example:
```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": "s3:GetObject",
      "Resource": "arn:aws:s3:::example-bucket/*"
    }
  ]
}
````

* **Attach to:** Users, groups, or roles.

````

---

## `03_Security_Token_Service.md`

```markdown
# AWS Security Token Service (STS)

Use STS to obtain **temporary credentials** for secure, cross-account access.

---

## 🔐 What is STS?

STS issues **short-lived credentials** with limited privileges.

### Example Use Case:
- Alice (Dev) wants to **access a production account** for deployment:
  - Alice logs into Dev account.
  - She uses **Switch Role** to assume the "DeploymentRole" in Prod.
  - STS issues her temporary credentials with limited permissions.

---

## 🕹️ How Security Tokens Work

1. Alice requests a token from STS.
2. STS verifies permissions.
3. STS issues:
   - Access Key ID
   - Secret Access Key
   - Session Token
4. Alice uses these credentials to access resources.

⏳ Tokens expire in a few hours, limiting risk.

---

## 🔄 Switch Role Process

1. Alice clicks **Switch Role** in the console.
2. Enters:
   - **Account ID:** 123456789012
   - **Role name:** DeploymentRole
3. STS issues temporary credentials.

---

## 🧩 Identity Federation

Use an external IdP (e.g., Active Directory, Google) to authenticate users.

### Example:
- Alice logs in to Okta → Okta issues a SAML token.
- Alice presents the token to AWS STS → STS validates.
- STS issues AWS temporary credentials.
````

---

## `04_Active_Directory.md`

```markdown
# Active Directory Integration with AWS

Understand AWS Directory Service and its connection to on-premises Active Directory.

---

## 🗂️ What is Active Directory?

A directory service by Microsoft for managing:
- Users
- Groups
- Computers
- Access Control

---

## 🏢 AWS Directory Service Types

| Service                      | Description                                                               |
| ---------------------------- | ------------------------------------------------------------------------- |
| **AWS Managed Microsoft AD** | Fully managed, Windows-based directory service.                           |
| **AD Connector**             | Proxy for on-prem AD integration. No directory stored in AWS.             |

---

## 🔗 Trust Relationships

| Feature                   | AWS Managed Microsoft AD                                   | AD Connector                  |
| ------------------------- | ---------------------------------------------------------- | ----------------------------- |
| Directory Managed by AWS? | Yes                                                        | No                            |
| Trust Relationship        | Supports one-way or two-way trust.                         | Relies on on-premises AD.     |
| Data Storage              | Directory stored in AWS.                                   | No directory stored in AWS.   |

---

## 📝 Example Scenario

- **Use Case:** AWS workloads need to authenticate against corporate AD.
- **Solution:** Deploy AWS Managed Microsoft AD → set up a trust relationship with on-premises AD → users can log into EC2 Windows instances using corporate credentials.
```

---

## `05_AWS_SSO_and_Organizations.md`

```markdown
# AWS SSO and AWS Organizations

Learn centralized access management across multiple AWS accounts.

---

## 🔑 AWS SSO Overview

Single Sign-On for:
- AWS Management Console
- Third-party apps (e.g., Salesforce)

### Example:
- Alice logs into AWS SSO → Access to:
  - AWS Dev Account
  - Salesforce
  - Jira

---

## 🏢 AWS Organizations

Centralized management of AWS accounts.

### Example Structure:
- **Root OU**
  - Production
  - Development
  - Sandbox

---

## 📜 Service Control Policies (SCPs)

Restrict services/actions across accounts.

### Example:
- Deny EC2 usage in **Sandbox OU**.
- Allow S3 read-only in **Finance OU**.

---

## 📝 Benefits

- Consolidated billing.
- Improved governance/security.
- Centralized policy management.

---

## 🔗 Putting It All Together

Combine:
- AWS SSO for login.
- AWS Organizations to manage accounts/OUs.
- SCPs to control what services are accessible.
```

---

## `06_Preparing_for_Exam.md`

```markdown
# AWS Exam Preparation

Tips to prepare for AWS certifications.

---

## 📚 Review Foundational Concepts

- IAM
- EC2
- S3
- RDS
- VPC
- Load Balancing

---

## 🔒 Understand Best Practices

- Least privilege principle.
- Enable MFA.
- Use tagging for resource management.
- Monitor with CloudWatch and CloudTrail.

---

## 📖 Study Resources

- AWS Documentation
- AWS Whitepapers
- AWS Well-Architected Framework
- Hands-on labs with AWS Free Tier

---

## 📝 Example Practice Question

- **Question:** How do you allow an EC2 instance to read from an S3 bucket securely?
  - **Answer:** Attach an IAM Role with `AmazonS3ReadOnlyAccess` policy to the EC2 instance.

---

## 📝 Example Practice Exercise

- Deploy a static website on S3 with public read access.
  - Create an S3 bucket.
  - Upload index.html.
  - Enable static website hosting.
  - Add a bucket policy to allow public read.

---

## 📈 Progress Tracking

- Weekly goals: Review 2 services per week.
- Practice with sample labs or small projects.
```

---

## ✨ How to Organize

You can split these into separate `.md` files:

```
01_AWS_Cloud_Baseline.md
02_Authentication_and_Authorization.md
03_Security_Token_Service.md
04_Active_Directory.md
05_AWS_SSO_and_Organizations.md
06_Preparing_for_Exam.md
```

