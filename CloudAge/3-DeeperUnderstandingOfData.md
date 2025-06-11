## IT & Cloud Infrastructure Mind Map

### IT & Cloud Infrastructure  

```
IT & Cloud Infrastructure
├── Cloud Computing
│   ├── Public Cloud Providers
│   │   ├── AWS
│   │   ├── Azure
│   │   ├── GCP
│   │   ├── IBM Cloud
│   │   └── Oracle Cloud
│   │   └── Alibaba Cloud
│   │   └── Notes: Global reach, pay-as-you-go, managed services, compliance
│   │   └── [Image: Logos of major cloud providers]
│   ├── Private Cloud
│   │   └── Notes: In-house, on-premises, custom solutions, more control
│   │   └── [Image: Server racks in a private data center]
│   ├── Hybrid Cloud
│   │   └── Notes: Combines public and private, flexibility, data locality
│   │   └── [Image: Diagram blending cloud and on-premises icons]
│   ├── Cloud Billing
│   │   ├── Bill
│   │   ├── Pay-as-you-go
│   │   └── [Image: Cloud with currency symbols]
│   ├── Cloud Deployment
│   │   ├── Data Centers
│   │   ├── Global Compliance
│   │   └── [Image: Map with data center locations]
│   ├── Cloud Architecture
│   │   ├── AWS Well-Architected Framework
│   │   │   ├── Pillars: Security, Reliability, Performance, Cost Optimization, Operational Excellence
│   │   │   ├── How: Best practices, automation, monitoring, scaling
│   │   │   └── [Image: Five-pillar diagram]
│   │   ├── Best Practices
│   │   │   ├── Architectural patterns, automation, resilience
│   │   │   └── [Image: Flowchart of best practices]
│   │   ├── Open Account in AWS
│   │   │   └── Steps: Register, verify, set up IAM, create VPC, launch EC2
│   │   │   └── [Image: AWS account dashboard screenshot]
│   │   ├── Services
│   │   │   ├── VPC (Virtual Private Cloud)
│   │   │   ├── EC2 (Elastic Compute Cloud)
│   │   │   ├── S3 (Simple Storage Service)
│   │   │   ├── IAM (Identity & Access Management)
│   │   │   ├── Bedrock, Personalize (AI services)
│   │   │   └── [Image: AWS service icons]
│   │   ├── Cloud Scaling
│   │   │   ├── Scaling up/down (manual, automated)
│   │   │   ├── Example: Billion day traffic spike
│   │   │   └── [Image: Graph showing scaling events]
│   │   ├── Security
│   │   │   ├── Shared responsibility model
│   │   │   ├── SLA (3 months, 24 hrs, 2 months)
│   │   │   └── [Image: Shield icon, SLA timeline]
│   │   └── Compliance
│   │       └── Notes: Data protection, regulatory standards
│   │       └── [Image: Compliance certificate icon]
│   └── Bare Metal
│       ├── In-house (On-premises)
│       ├── Vendors: Dell, HP, IBM
│       ├── Custom Machines
│       └── [Image: Physical server hardware]
├── Infrastructure Types
│   ├── Blade Server vs. Rack Server
│   │   ├── Blade: High density, modular, efficient cooling
│   │   ├── Rack: Flexible, scalable, standard in data centers
│   │   └── [Image: Side-by-side diagram of blade vs rack server]
│   ├── Bare Metal
│   │   ├── Direct hardware access, no virtualization
│   │   ├── Used for high performance, custom workloads
│   │   └── [Image: Bare metal server photo]
│   └── Virtualization
│       ├── Xen (used by public cloud)
│       └── [Image: Virtualization stack diagram]
├── Data Management
│   ├── Data Types
│   │   ├── OLTP (Online Transaction Processing)
│   │   │   ├── Little data, RDBMS, SQL, hot data, DBA
│   │   │   └── [Image: OLTP database icon]
│   │   ├── OLAP (Online Analytical Processing)
│   │   │   ├── Big data, 3V's (Volume, Velocity, Variety), in-memory, warm storage
│   │   │   └── [Image: OLAP cube or big data icon]
│   │   ├── Cloud Storage
│   │   │   ├── AWS Glacier (archival)
│   │   │   ├── SLA 24 hrs (current), 2 months (archive)
│   │   │   └── [Image: Glacier logo, storage timeline]
│   │   ├── Data Lifecycle
│   │   │   ├── Little data → Big data → All data → Archival data → Distilled data (20%)
│   │   │   └── [Image: Funnel diagram showing data reduction]
│   │   └── Data Analysis
│   │       ├── Teamwork on all data types
│   │       └── [Image: Team analyzing data dashboard]
│   └── Data Management Models
│       ├── Custom (tailored to business)
│       ├── Ready-bundled (vendor/OEM)
│       └── [Image: Custom vs. vendor solution icons]
├── Application & Service Lifecycle
│   ├── Domain Discussion
│   │   ├── Life of business, strategic planning
│   │   └── [Image: Business flowchart]
│   ├── Infra → Architect → Development Team → Services → Application
│   │   └── [Image: Pipeline diagram]
│   └── Accuracy & AI
│       ├── AI in AWS (Bedrock, Personalize)
│       ├── Typical accuracy ~50%
│       └── [Image: AI neural net graphic]
└── Key Concepts & Best Practices
    ├── Global compliance, fully managed, shared security, ease of use
    ├── SLA (Service Level Agreement) durations
    ├── Cloud scaling automation vs. manual
    ├── Pay-as-you-go, billing models
    └── [Image: Checklist or best practices icons]
```

---

### **How to Visualize This Mind Map**

- **Central Node:** "IT & Cloud Infrastructure" (use a cloud or data center image)
- **First-Level Branches:** Cloud Computing, Infrastructure Types, Data Management, Application & Service Lifecycle, Key Concepts & Best Practices
- **Second-Level Branches:** As shown above, with each major topic broken into subtopics
- **Images:** For each branch, use relevant icons or diagrams (e.g., cloud provider logos, server diagrams, database icons, compliance certificates)

---

````markdown



# EC2 Management & Linux Commands

## 1. Why Use IAM Users Instead of the Root User?

The **root user** in AWS has **unrestricted access** to all resources and should only be used for initial account setup (e.g., billing, creating IAM users).  
**IAM users** are recommended because they:
- Follow **least privilege**: only necessary permissions are assigned.
- Enhance security: root credentials are not exposed.
- Enable easy user management: roles, groups, and policies.
- Provide detailed auditing with AWS CloudTrail.

**Recommendation:**  
- Lock away root credentials.
- Use IAM users for daily operations.

---

## 2. Launching an EC2 Instance (Step by Step)

### 2.1 Common Steps for Both Windows and Ubuntu

1. **Login to AWS Console** as an IAM user.
2. Navigate to **EC2 Dashboard** and click **Launch Instance**.
3. **Name the instance** (e.g., `ProductionServer1`).
4. **Choose an AMI**:
   - **Windows**: Microsoft Windows Server 2019 Base.
   - **Ubuntu**: Ubuntu Server 22.04 LTS.
5. **Select Instance Type** (e.g., `t2.micro` for testing).
6. **Key Pair**:
   - Create a new key pair or select an existing one.
   - Download the `.pem` file.
7. **Network Settings**:
   - Assign a **public IP** (if needed).
   - Configure **Security Group**:
     - Windows: Allow **TCP port 3389** (RDP).
     - Ubuntu: Allow **TCP port 22** (SSH).
8. **Storage**: Adjust size as required.
9. Click **Launch Instance**.

---

## 3. List of All Production Servers

### Using AWS Console:
- Filter by **Tags** (e.g., `Environment: Production`).
- Review **Instance IDs**, **Names**, and **Public IPs**.

### Using AWS CLI:
```bash
aws ec2 describe-instances \
    --filters "Name=tag:Environment,Values=Production" \
    --query 'Reservations[*].Instances[*].[InstanceId,PublicIpAddress,State.Name,Tags]' \
    --output table
````

---

## 4. Connect to Instance (SSH Client)

### On Linux/macOS:

```bash
ssh -i /path/to/your-key.pem ubuntu@<Public-IP>
```

(Use `ec2-user` for Amazon Linux.)

---

## 5. Connect to Instance (Windows PowerShell)

```powershell
ssh -i "C:\path\to\your-key.pem" ubuntu@<Public-IP>
```

---

## 6. Connect to Instance Using PuTTY

### Step 1: Convert `.pem` to `.ppk`

* Open **PuTTYgen**.
* Click **Load**, select the `.pem` file.
* Click **Save Private Key** to save as `.ppk`.

### Step 2: Configure PuTTY

1. **Host Name**: `ubuntu@<Public-IP>`
2. Navigate to **Connection → SSH → Auth → Credentials**:

   * Browse to your `.ppk` file.
3. Click **Open**.
4. Accept the host key and connect.

---

## 7. Edit Inbound Rules

1. Go to **EC2 Dashboard → Security Groups**.
2. Select the Security Group assigned to your instance.
3. Click **Edit Inbound Rules**.
4. Add or adjust:

   * SSH: **Port 22** (Ubuntu).
   * RDP: **Port 3389** (Windows).
   * Restrict to trusted IPs.
5. Save changes.

---

## 8. Useful Linux Commands

| Command            | Description                                   |
| ------------------ | --------------------------------------------- |
| `uname`            | Display OS name and version.                  |
| `w`                | Show who is logged in and what they’re doing. |
| `ls`               | List files and directories.                   |
| `whois`            | Domain ownership information.                 |
| `sudo shutdown -c` | Cancel a scheduled shutdown.                  |

---

## 9. Optional Tips

* **Always use IAM users** or roles instead of root for everyday tasks.
* **Monitor with CloudTrail** for suspicious activity.
* **Use security groups** to restrict access to your instances.

---

## Summary

✅ Use IAM users for daily AWS management.
✅ Launch EC2 instances step by step.
✅ List production servers via console or CLI.
✅ Connect to instances using SSH or PuTTY.
✅ Edit inbound rules for secure access.
✅ Use essential Linux commands (`uname`, `w`, `ls`, `whois`, `sudo shutdown -c`).

---

**Need help with screenshots or automation? Let me know! 🚀**

```

---

Would you like me to generate a downloadable `.md` file? Let me know! 📄
```










