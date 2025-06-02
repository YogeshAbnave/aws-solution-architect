# 📚 AWS Cloud Documentation

## Table of Contents
1. [AWS Cloud Baseline](#aws-cloud-baseline)
2. [Authentication and Authorization](#authentication-and-authorization)
3. [Security Token Service (STS)](#security-token-service-sts)
4. [Active Directory Integration](#active-directory-integration)
5. [AWS SSO and Organizations](#aws-sso-and-organizations)
6. [Exam Preparation Guide](#exam-preparation-guide)

---

## AWS Cloud Baseline

### 🌐 Overview
AWS (Amazon Web Services) is a comprehensive cloud computing platform providing computing power, storage, databases, and a broad set of services that help organizations build scalable and secure applications.

### 💡 Key Benefits
- **Scalability:** Scale up or down based on demand
- **Cost-Effective:** Pay-as-you-go model; avoid large upfront investments
- **Flexibility:** Choose the operating system, programming language, web application platform, database, and other services you need

### 🛠️ Foundational Services

| Service Category | AWS Service | Description | Example Use Case |
|-----------------|-------------|-------------|------------------|
| **Compute** | EC2 | Virtual servers in the cloud | Hosting a web server or application backend |
| **Database** | RDS | Managed relational database service | Running a managed MySQL/PostgreSQL database |
| **Storage** | S3 | Object storage service | Hosting website static files (HTML/CSS/JS) |
| **Networking** | VPC | Virtual Private Cloud | Creating a secure private network for applications |
| **Security** | IAM | Identity and Access Management | Managing user permissions and roles |

### 📝 Example: Hosting a Website
1. **Launch an EC2 instance** (Amazon Linux 2)
2. **Install a web server** (e.g., Apache)
3. **Upload website files** to `/var/www/html`
4. **Configure security group** to allow HTTP (port 80) and SSH (port 22)
5. **Use Route 53** to create a DNS record pointing to the EC2 public IP

---

## Authentication and Authorization

### 🔑 IAM (Identity and Access Management)
IAM helps manage **users, groups, and permissions** within a **single AWS account**.

**Example Scenario:**
- **User:** Alice (Developer)
- **Group:** Developers
- **Policy:** Developers can deploy Lambda functions but cannot delete S3 buckets

### 🔑 IAM Identity Center (formerly AWS SSO)
Centralized access across **multiple AWS accounts** and 3rd-party applications.

**Example Scenario:**
- Alice needs access to the Dev account and Salesforce
- AWS SSO lets Alice sign in once and get access to both

### 👤 Root User vs. IAM User

| Feature | Root User | IAM User |
|---------|-----------|----------|
| **Access** | Full account-wide permissions | Controlled by policies |
| **Example Usage** | Close AWS account, billing changes | Create EC2 instances, manage resources |
| **Best Practice** | Use sparingly with MFA enabled | Use least privilege principle |

### 👥 User Groups
Group users with similar roles for easier management.

**Examples:**
- **Tester Group:** Read-only access to S3 buckets
- **Admin Group:** Full access to all services
- **Developers Group:** Deploy EC2 and Lambda functions

### 🛡️ Roles
Roles provide **temporary credentials** for applications, services, or users.

**Example Scenario:**
- **Need:** EC2 instance needs to read from S3
- **Solution:** Attach a role with `AmazonS3ReadOnlyAccess` policy to the EC2 instance

### 📜 Policies
Policies define permissions using JSON format.

**Example Policy:**
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
```

**Can be attached to:** Users, groups, or roles

---

## Security Token Service (STS)

### 🔐 What is STS?
STS issues **short-lived credentials** with limited privileges for enhanced security.

### Example Use Case
Alice (Developer) wants to access a production account for deployment:
1. Alice logs into Dev account
2. She uses **Switch Role** to assume the "DeploymentRole" in Production
3. STS issues her temporary credentials with limited permissions
4. Alice can now perform deployment tasks with restricted access

### 🕹️ How Security Tokens Work
1. **Request:** Alice requests a token from STS
2. **Verification:** STS verifies permissions
3. **Issue:** STS provides:
   - Access Key ID
   - Secret Access Key
   - Session Token
4. **Access:** Alice uses these credentials to access resources

⏳ **Important:** Tokens expire in a few hours, limiting security risk

### 🔄 Switch Role Process
1. Alice clicks **Switch Role** in the console
2. Enters required information:
   - **Account ID:** 123456789012
   - **Role name:** DeploymentRole
3. STS issues temporary credentials for the session

### 🧩 Identity Federation
Use an external Identity Provider (IdP) like Active Directory or Google to authenticate users.

**Example Flow:**
1. Alice logs in to Okta
2. Okta issues a SAML token
3. Alice presents the token to AWS STS
4. STS validates the token
5. STS issues AWS temporary credentials

---

## Active Directory Integration

### 🗂️ What is Active Directory?
A directory service by Microsoft for managing:
- Users and their authentication
- Groups and permissions
- Computers and devices
- Access control policies

### 🏢 AWS Directory Service Types

| Service | Description | Key Features |
|---------|-------------|--------------|
| **AWS Managed Microsoft AD** | Fully managed, Windows-based directory service | Complete AD functionality in AWS |
| **AD Connector** | Proxy for on-premises AD integration | No directory stored in AWS, acts as bridge |

### 🔗 Trust Relationships Comparison

| Feature | AWS Managed Microsoft AD | AD Connector |
|---------|-------------------------|--------------|
| **Directory Managed by AWS?** | Yes | No |
| **Trust Relationship** | Supports one-way or two-way trust | Relies on on-premises AD |
| **Data Storage** | Directory stored in AWS | No directory stored in AWS |
| **Use Case** | New AWS-native directory needs | Existing on-premises AD integration |

### 📝 Example Implementation Scenario
**Use Case:** AWS workloads need to authenticate against corporate Active Directory

**Solution Steps:**
1. Deploy AWS Managed Microsoft AD
2. Set up a trust relationship with on-premises AD
3. Configure EC2 Windows instances to use the directory
4. Users can now log into EC2 instances using corporate credentials

---

## AWS SSO and Organizations

### 🔑 AWS SSO Overview
Single Sign-On provides centralized access to:
- AWS Management Console across multiple accounts
- Third-party applications (Salesforce, Jira, etc.)

**Example User Experience:**
Alice logs into AWS SSO portal and gains access to:
- AWS Development Account
- AWS Production Account
- Salesforce CRM
- Jira Project Management

### 🏢 AWS Organizations
Centralized management and governance of multiple AWS accounts.

**Example Organizational Structure:**
```
Root Organization
├── Production OU
│   ├── Prod-Web-App Account
│   └── Prod-Database Account
├── Development OU
│   ├── Dev-Testing Account
│   └── Dev-Staging Account
└── Sandbox OU
    └── Experimental Account
```

### 📜 Service Control Policies (SCPs)
Restrict services and actions across accounts and organizational units.

**Example SCP Implementations:**
- **Sandbox OU:** Deny expensive EC2 instance types
- **Development OU:** Restrict access to production databases
- **Finance OU:** Allow only S3 read-only access for cost reporting

### 📝 Key Benefits
- **Consolidated Billing:** Single bill for all accounts
- **Improved Governance:** Centralized policy enforcement
- **Enhanced Security:** Account-level isolation
- **Simplified Management:** Bulk operations across accounts

### 🔗 Integration Strategy
Combine these services for maximum effectiveness:
1. **AWS SSO** for centralized authentication
2. **AWS Organizations** to structure and manage accounts
3. **Service Control Policies** to enforce compliance and security
4. **IAM roles** for cross-account access with least privilege

---

## Exam Preparation Guide

### 📚 Core Concepts to Master

#### Identity and Access Management
- **IAM Users, Groups, and Roles**
- **Policy types and inheritance**
- **Cross-account access patterns**
- **Temporary credentials and STS**

#### Compute Services
- **EC2 instance types and use cases**
- **Auto Scaling and Load Balancing**
- **Lambda serverless functions**
- **Container services (ECS, EKS)**

#### Storage and Databases
- **S3 storage classes and lifecycle policies**
- **RDS vs. DynamoDB use cases**
- **Backup and disaster recovery strategies**

#### Networking
- **VPC design and subnet planning**
- **Security groups vs. NACLs**
- **NAT gateways and internet gateways**
- **Route tables and routing**

### 🔒 Security Best Practices
- **Principle of least privilege** for all access
- **Enable MFA** for all privileged accounts
- **Use IAM roles** instead of access keys when possible
- **Implement resource tagging** for management and billing
- **Monitor with CloudWatch and CloudTrail**
- **Encrypt data** at rest and in transit

### 📖 Recommended Study Resources
- **AWS Official Documentation** - Primary source of truth
- **AWS Whitepapers** - Best practices and architectural guidance
- **AWS Well-Architected Framework** - Design principles
- **AWS Free Tier** - Hands-on practice labs
- **AWS Training and Certification** - Official courses

### 📝 Practice Questions

#### Question 1: Secure EC2 to S3 Access
**Question:** How do you securely allow an EC2 instance to read from an S3 bucket?

**Answer:** Attach an IAM Role with `AmazonS3ReadOnlyAccess` policy to the EC2 instance. This provides temporary credentials without storing access keys on the instance.

#### Question 2: Cross-Account Access
**Question:** A developer in Account A needs temporary access to resources in Account B. What's the best approach?

**Answer:** 
1. Create an IAM role in Account B with required permissions
2. Add a trust policy allowing Account A to assume the role
3. Developer uses STS AssumeRole to get temporary credentials
4. Access is logged and time-limited for security

### 📝 Hands-On Practice Exercises

#### Exercise 1: Static Website Hosting
Deploy a static website on S3 with public access:
1. **Create S3 bucket** with unique name
2. **Upload website files** (index.html, CSS, images)
3. **Enable static website hosting** in bucket properties
4. **Configure bucket policy** for public read access
5. **Test website** using S3 endpoint URL

#### Exercise 2: Multi-Account Setup
Practice with AWS Organizations:
1. **Create organization** in master account
2. **Invite member accounts** or create new ones
3. **Organize accounts** into Organizational Units
4. **Apply Service Control Policies** to restrict actions
5. **Test cross-account** IAM role assumption

### 📈 Study Schedule Recommendation

#### Week 1-2: Foundation
- AWS Cloud basics and core services
- IAM fundamentals and hands-on practice

#### Week 3-4: Compute and Storage
- EC2 instance management
- S3 configurations and policies

#### Week 5-6: Networking and Security
- VPC design and implementation
- Security best practices and monitoring

#### Week 7-8: Advanced Topics
- Multi-account strategies
- Identity federation and SSO

#### Week 9-10: Practice and Review
- Mock exams and weak area focus
- Hands-on labs for complex scenarios

### 🎯 Success Tips
- **Practice regularly** with AWS Free Tier
- **Focus on use cases** rather than just memorizing features
- **Understand the "why"** behind AWS recommendations
- **Join study groups** or online communities
- **Take practice exams** to identify knowledge gaps
- **Document your learning** for quick review