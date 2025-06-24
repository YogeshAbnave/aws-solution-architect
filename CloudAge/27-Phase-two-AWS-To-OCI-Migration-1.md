
---

# ☁️ Oracle Cloud Infrastructure (OCI) Documentation

## 📌 Overview

Oracle Cloud Infrastructure (OCI) is a next-generation cloud designed for enterprise applications and modern workloads. This guide covers core components, identity and security setup, networking (including VPN and hybrid cloud), and steps for integrating Oracle Cloud with AWS.

---

## 🏠 OCI Services Overview

### 🔧 Core Services

| Category                          | Services                                                                 |
| --------------------------------- | ------------------------------------------------------------------------ |
| **Compute**                       | Launch virtual machines (VMs), autoscaling, custom images                |
| **Storage**                       | Block Storage, Object Storage, File Storage                              |
| **Networking**                    | VCN, Subnets, DRG, VPN, Load Balancer                                    |
| **Databases**                     | ATP (Autonomous Transaction Processing), ADW (Autonomous Data Warehouse) |
| **Analytics & AI**                | Data Flow, AI Services, Oracle Analytics Cloud                           |
| **Developer Services**            | Functions, API Gateway, DevOps CI/CD                                     |
| **Identity & Security**           | IAM, Policies, MFA, Domains, Groups, Federation                          |
| **Observability & Management**    | Logging, Monitoring, Alarms, Metrics                                     |
| **Hybrid Cloud**                  | OCI FastConnect, Multi-cloud with Azure, Roving Edge                     |
| **Migration & Disaster Recovery** | Database Migration, Site-to-Site VPN, Replication                        |
| **Billing & Cost Mgmt**           | Budgets, Usage Reports, Cost Tracking                                    |
| **Governance & Admin**            | Compartments, Quotas, Tags, Policies                                     |
| **Marketplace**                   | Prebuilt Oracle and third-party images                                   |

---

## 🗂️ Identity and Access Management (IAM)

### 📦 Compartment Structure

OCI uses a **parent-child compartment model** for resource isolation and control:

* Parent Compartment → Child Compartment → Resources
* Fine-grained access control via **Policies**

### 🛂 Steps to Configure IAM

1. **Create IAM Domain:**

   * Go to **Identity → Domains**
   * Click **Create Domain**, define region, name, and description.

2. **Create User:**

   * Go to **Identity → Users → Create User**
   * Provide user name, email, and assign to the domain.

3. **Enable MFA:**

   * Go to **Identity → Users → MFA Settings**
   * Enroll via Authenticator App or SMS

4. **Create Group & Policy:**

   * Create group: `Identity → Groups → Create Group`
   * Add user to group.
   * Create policy:

     ```text
     Allow group <group_name> to manage all-resources in compartment <compartment_name>
     ```

---

## 🌐 Networking in OCI

### 🔄 Virtual Cloud Network (VCN)

VCN is a **software-defined network** within OCI used to manage resources securely.

#### Components:

* Subnets (Private/Public)
* Route Tables
* Internet Gateway (IG)
* NAT Gateway
* Service Gateway
* Dynamic Routing Gateway (DRG)

---

### 🧮 CIDR (Classless Inter-Domain Routing)

* **CIDR Notation:** e.g., `10.0.0.0/16`
* `2^n` rule: `/24` = 256 IPs, `/16` = 65,536 IPs
* **Tool:** [cidr.xyz](https://cidr.xyz) to calculate IP ranges

---

## ⚙️ VCN Wizard Setup

### ✅ Start with VCN Wizard:

1. Go to **Networking → Virtual Cloud Networks → Start VCN Wizard**
2. Choose:

   * **VCN with Internet Connectivity**
   * or **VCN with Private Subnet + NAT Gateway**

### 🔐 Private Subnet Internet Access

Private subnets **do not** have direct internet access. Use:

* **NAT Gateway** + Route Table
* Assign **Elastic (Public) IP** for outbound internet

---

## 🔐 Site-to-Site VPN Setup (OCI ↔ AWS)

### 📦 Key Terms:

| Term                            | Description                               |
| ------------------------------- | ----------------------------------------- |
| **VPC**                         | Virtual Private Cloud (in AWS or OCI)     |
| **VPN Tunnel**                  | Encrypted tunnel over public internet     |
| **DRG**                         | Dynamic Routing Gateway in OCI            |
| **VGW**                         | Virtual Private Gateway in AWS            |
| **Customer Gateway**            | AWS resource representing OCI's DRG       |
| **IKE (Internet Key Exchange)** | Protocol used to set up IPsec connections |

---

### 🧱 OCI Side Configuration

1. **Create DRG:**

   * Go to **Networking → DRG → Create**

2. **Attach DRG to VCN:**

   * Create DRG Attachment to your VCN

3. **Create CPE (Customer Premises Equipment):**

   * Add the AWS VGW public IP

4. **Create VPN Connection:**

   * Define routing type (Static or Dynamic)
   * Two tunnels are created for redundancy

5. **Download Configuration File:**
   Download `.conf` file for VPN setup

---

### 🧱 AWS Side Configuration

1. **Create Virtual Private Gateway (VGW)**
2. **Attach VGW to AWS VPC**
3. **Create Customer Gateway (CGW):**

   * Use OCI DRG public IP
4. **Create VPN Connection**

   * Choose the downloaded OCI config for IKE and tunnel setup
5. **Create Static Routes**

   * Match the CIDR of the OCI VCN

---

### 📡 IPSec Tunnels

* **Two tunnels** are always created for **high availability**
* Tunnels may show “down” due to:

  * Mismatched configuration (IP, IKE, routing)
  * Security group or firewall rules blocking UDP 500/4500
  * Incomplete BGP or static route configuration

---

## 🧭 Best Practices & Precautions

### 🧠 Before You Begin:

* Ensure CIDR ranges don’t overlap between OCI and AWS
* Enable **ICMP** and **UDP 500, 4500** on firewalls
* Use strong IKE pre-shared key (PSK)
* Validate routing tables in both OCI and AWS
* Keep **CloudShell** or **local CLI** handy for diagnostics

---

## 💸 Billing & Cost Management

* Set **budgets and alerts**
* Use **Cost Analysis** to track service usage
* Enable **Compartment-based billing visibility**

---

## 🧰 Tools & Learning Path

* [CIDR Calculator](https://cidr.xyz)
* [OCI Foundations Associate 2025 Learning Path](https://mylearn.oracle.com/ou/learning-path/become-an-oci-foundations-associate-2025/148056)

---

## 🧠 Interview/Review Questions

1. What is a VCN and how does it differ from a VPC?
2. What is CIDR? Explain with an example.
3. How does NAT Gateway provide internet to private subnets?
4. What is the role of DRG in hybrid networking?
5. What is the difference between CPE and CGW?
6. Why are two IPSec tunnels created?
7. How do you troubleshoot a downed VPN tunnel?
8. How does MFA enhance security in OCI?
9. What is a compartment and how is it used in governance?
10. How do you configure IAM policies in OCI?

---

# Oracle Cloud Infrastructure (OCI) – Complete Beginner Guide with Commands

This comprehensive guide introduces Oracle Cloud Infrastructure (OCI) for beginners, covering all core services, concepts, step-by-step procedures, essential commands, and best practices. It includes practical examples and troubleshooting tips for real-world cloud scenarios.

---

## 🏠 Home: Core OCI Services Overview

| Category                     | Description & Examples                                                                 |
|------------------------------|---------------------------------------------------------------------------------------|
| **Compute**                  | Virtual Machines (VMs), Bare Metal, Autoscaling, Custom Images                        |
| **Storage**                  | Block, Object, File Storage                                                           |
| **Networking**               | Virtual Cloud Network (VCN), Subnets, Gateways (Internet, NAT, Service, DRG), VPN     |
| **Oracle Database**          | Autonomous Database (ATP, ADW), Exadata, NoSQL                                        |
| **Analytics & AI**           | Oracle Analytics Cloud, Data Flow, AI Services                                        |
| **Developer Services**       | Functions, API Gateway, DevOps, CI/CD, Container Engine for Kubernetes                |
| **Identity & Security**      | IAM, Policies, MFA, Groups, Domains, Security Zones                                   |
| **Observability & Management**| Logging, Monitoring, Alarms, Metrics, Resource Manager                               |
| **Hybrid**                   | FastConnect, Multi-cloud, Edge Services                                               |
| **Migration & Disaster Recovery** | Database Migration, VPN, Replication, Backup                                      |
| **Billing & Cost Management** | Budgets, Usage Reports, Cost Tracking                                                |
| **Governance & Administration** | Compartments, Quotas, Tags, Policies                                               |
| **Marketplace**              | Prebuilt Oracle and third-party images and solutions                                  |

---

## 🗂️ Compartment Structure: Parent and Child

- **Compartments** are logical containers for organizing and isolating cloud resources.
- **Parent-child relationship** allows for granular access control and governance.
- **Policies** can be set at any compartment level to control access for users and groups.

**Example:**
- Root Compartment (Tenancy)
  - Parent Compartment (e.g., "Dev")
    - Child Compartment (e.g., "Dev-App1")
      - Resources (VMs, DBs, etc.)

---

## 🛂 Identity and Security

### **Create a Domain**

**Console:**
1. Go to **Identity & Security → Domains**
2. Click **Create Domain**
3. Enter domain name, description, and select region

**CLI:**
```bash
oci iam domain create --compartment-id  --display-name 
```

---

### **Create a New User**

**Console:**
1. Go to **Identity & Security → Users**
2. Click **Create User**
3. Enter user name and email, assign to domain

**CLI:**
```bash
oci iam user create --compartment-id  --name  --description ""
```

---

### **Create a Group**

**Console:**
1. Go to **Identity & Security → Groups**
2. Click **Create Group**
3. Enter group name and description

**CLI:**
```bash
oci iam group create --compartment-id  --name  --description ""
```

---

### **Add User to Group**

**Console:**
1. Go to **Groups →  → Add User**
2. Select user and add

**CLI:**
```bash
oci iam group add-user --user-id  --group-id 
```

---

### **Set Up MFA (Multi-Factor Authentication)**

**Console:**
1. Go to **Identity & Security → Users**
2. Click on the user → **MFA Settings**
3. Enroll via Authenticator App or SMS

---

### **Create and Attach Policies**

**Console:**
1. Go to **Identity & Security → Policies**
2. Click **Create Policy**
3. Enter name, description, compartment, and policy statements

**Example Policy Statement:**
```
Allow group  to manage all-resources in compartment 
```

**CLI:**
```bash
oci iam policy create --compartment-id  --name  --statements '["Allow group  to manage all-resources in compartment "]'
```

---

## 🌐 Networking in OCI

### **What is a VCN (Virtual Cloud Network)?**

- A VCN is a customizable, private network in OCI for launching cloud resources.
- Contains subnets (public/private), route tables, gateways, and security lists.

**Create VCN with Wizard (Console):**
1. Go to **Networking → Virtual Cloud Networks**
2. Click **Start VCN Wizard**
3. Choose configuration (with/without internet, NAT, etc.)

**CLI:**
```bash
oci network vcn create --compartment-id  --display-name  --cidr-block 
```

---

### **What is CIDR?**

- **CIDR (Classless Inter-Domain Routing):** Notation for IP address ranges, e.g., `10.0.0.0/16`
- `/24` = 256 IPs, `/16` = 65,536 IPs
- Use [cidr.xyz](https://cidr.xyz) to calculate and check CIDR ranges

---

### **2 Octet Fix**

- Refers to using a `/16` subnet, giving you two octets for host addressing (e.g., `10.10.0.0/16`).

---

### **Internet Access for Private Subnets**

- Private subnets do **not** have direct internet access.
- Use a **NAT Gateway** and update the route table.

**Assign Elastic (Public) IP:**
1. Create a NAT Gateway
2. Assign a public IP (Elastic IP)
3. Update the route table for private subnet:
   - Destination: `0.0.0.0/0`
   - Target: NAT Gateway

**CLI Example:**
```bash
oci network nat-gateway create --compartment-id  --vcn-id  --display-name 
oci network public-ip create --compartment-id  --lifetime RESERVED
```

---

### **VPN Tunnel**

- A **VPN tunnel** is an encrypted connection over the internet between two networks (e.g., OCI ↔ AWS).
- Used for secure, private communication.

---

### **Hybrid Cloud: Connecting OCI and AWS**

#### **Key Terms**

| Term           | Description                             |
|----------------|-----------------------------------------|
| VCN            | Virtual Cloud Network (OCI)             |
| VPC            | Virtual Private Cloud (AWS)             |
| DRG            | Dynamic Routing Gateway (OCI)           |
| VGW            | Virtual Private Gateway (AWS)           |
| CPE/CGW        | Customer Premises/Gateway (AWS/OCI)     |
| IKE            | Internet Key Exchange (VPN protocol)    |

---

#### **Step-by-Step: OCI ↔ AWS VPN**

**On OCI Side:**

1. **Create DRG**
   - Console: *Networking → DRG → Create*
   - CLI:
     ```bash
     oci network drg create --compartment-id  --display-name 
     ```

2. **Attach DRG to VCN**
   - Console: *Networking → DRG Attachments*
   - CLI:
     ```bash
     oci network drg-attachment create --drg-id  --vcn-id  --display-name 
     ```

3. **Create CPE (Customer Premises Equipment)**
   - Enter AWS VGW public IP
   - CLI:
     ```bash
     oci network cpe create --compartment-id  --ip-address  --display-name 
     ```

4. **Create VPN Connection**
   - Choose static/dynamic routing
   - CLI:
     ```bash
     oci network ipsec-connection create --compartment-id  --drg-id  --cpe-id  --display-name 
     ```

5. **Download Configuration File**
   - Console: *VPN Connection → Download Config*
   - CLI:
     ```bash
     oci network ipsec-connection get --ipsc-id 
     ```

---

**On AWS Side:**

1. **Create Virtual Private Gateway (VGW)**
2. **Attach VGW to AWS VPC**
3. **Create Customer Gateway (CGW)**
   - Use OCI DRG public IP
4. **Create VPN Connection**
   - Use the downloaded OCI config for IKE and tunnel setup
5. **Create Static Routes**
   - Match the CIDR of the OCI VCN

---

### **Create IPSec Connection**

- **Two tunnels** are created for high availability (redundancy).
- If one tunnel fails, the other maintains connectivity.

---

### **Why Tunnels May Be Down**

- Incorrect configuration (IP, IKE version, routing)
- Firewall/security group not allowing UDP 500/4500
- BGP/static route misconfiguration

---

### **IKE (Internet Key Exchange)**

- Protocol used to set up secure, authenticated communications for IPSec VPNs.

---

## ⚙️ Best Practices & Precautions

- **Plan CIDR ranges** to avoid overlap between OCI and AWS.
- **Open required ports** (UDP 500/4500 for IPSec) in firewalls/security lists.
- **Use strong IKE pre-shared keys**.
- **Validate routing tables** on both OCI and AWS.
- **Enable MFA** for all user accounts.
- **Monitor usage** and set up alerts for cost control.
- **Use compartments** for resource isolation and cost tracking.

---

## 💸 Billing & Cost Management

- Set budgets and alerts in the OCI Console.
- Use Cost Analysis for tracking and reporting.
- Enable compartment-based billing for project/team-level visibility.

**CLI Example:**
```bash
oci budgets budget create --compartment-id  --target-compartment-id  --amount  --reset-period MONTHLY --display-name 
```

---

## 🧰 Tools & Learning Path

- **CIDR Calculator:** [cidr.xyz](https://cidr.xyz)
- **OCI CLI Docs:** [OCI CLI](https://docs.oracle.com/en-us/iaas/tools/oci-cli/latest/oci_cli_docs/)
- **OCI Foundations Associate Learning Path:** [Oracle Learning](https://mylearn.oracle.com/ou/learning-path/become-an-oci-foundations-associate-2025/148056)

---

## 🧠 Review & Interview Questions

1. What is a VCN and how does it differ from a VPC?
2. What is CIDR? Explain with an example.
3. How does a NAT Gateway provide internet to private subnets?
4. What is the role of DRG in hybrid networking?
5. What is the difference between CPE and CGW?
6. Why are two IPSec tunnels created?
7. How do you troubleshoot a downed VPN tunnel?
8. How does MFA enhance security in OCI?
9. What is a compartment and how is it used in governance?
10. How do you configure IAM policies in OCI?

---

## ✅ Summary Checklist

- [x] Understand OCI core services and compartment structure
- [x] Set up IAM: domains, users, groups, MFA, and policies
- [x] Create and configure VCN, subnets, gateways, and NAT
- [x] Plan and implement hybrid connectivity (OCI ↔ AWS)
- [x] Use CLI and Console for all major operations
- [x] Monitor billing and set up cost controls
- [x] Follow best practices for security and governance

---


## Oracle Cloud Infrastructure (OCI) – Beginner Concepts & Key Steps

---

### **Home: Core OCI Services**

| Category                     | Description & Examples                                                                 |
|------------------------------|---------------------------------------------------------------------------------------|
| **Compute**                  | Virtual machines (VMs), bare metal servers, Kubernetes, container services            |
| **Storage**                  | Block, object, and file storage for data and backups                                  |
| **Networking**               | Virtual Cloud Network (VCN), subnets, gateways, VPN, load balancer                    |
| **Oracle Database**          | Autonomous Database (ATP for transactions, ADW for analytics), Exadata, NoSQL         |
| **Analytics & AI**           | Oracle Analytics Cloud, Data Flow, AI services                                        |
| **Developer Services**       | Functions, API Gateway, DevOps, CI/CD, Container Engine for Kubernetes                |
| **Identity & Security**      | IAM, policies, MFA, groups, domains, security zones                                   |
| **Observability & Management**| Logging, monitoring, alarms, metrics, resource manager                               |
| **Hybrid**                   | FastConnect, multi-cloud, edge services                                               |
| **Migration & Disaster Recovery** | Database migration, VPN, replication, backup                                      |
| **Billing & Cost Management** | Budgets, usage reports, cost tracking                                                |
| **Governance & Administration** | Compartments, quotas, tags, policies                                               |
| **Marketplace**              | Prebuilt Oracle and third-party images and solutions                                  |

---

### **Compartment Structure: Parent and Child**

- **Compartments** are logical containers for organizing and isolating cloud resources.
- You can nest compartments (parent-child relationship) for granular access control and governance[7].
- Policies can be set at any compartment level to control access for users and groups.

---

### **Identity and Security**

#### **Creating a Domain**
- Go to *Identity → Domains* and create a new domain for user and resource management[7].

#### **Creating a New User**
- Go to *Identity → Users → Create User*, provide details, and assign to a domain[7].

#### **Oracle Policies**
- Policies define what actions groups of users can perform on which resources.
- Example:  
  ```
  Allow group  to manage all-resources in compartment 
  ```

#### **MFA (Multi-Factor Authentication)**
- Enable MFA for users to enhance login security by requiring an additional verification step.

#### **Creating a Group**
- Go to *Identity → Groups → Create Group* and add users as needed.

---

### **Networking Concepts**

#### **What is a VPN Tunnel?**
- A VPN tunnel is an encrypted connection over the internet between two networks (e.g., between OCI and AWS), ensuring secure data transfer[4][5].

#### **What is VCN (Virtual Cloud Network) in Oracle?**
- VCN is a software-defined, private network in OCI, similar to a traditional data center network, allowing you to launch resources in isolated, secure environments[4][5].
- VCN contains subnets, route tables, gateways, and security lists.

#### **What is CIDR?**
- CIDR (Classless Inter-Domain Routing) is a method for allocating IP addresses and routing, written as `IP_address/Prefix` (e.g., `10.0.0.0/16`). `/24` gives 256 IPs, `/16` gives 65,536 IPs[4].
- Use tools like [cidr.xyz](https://cidr.xyz) to check and calculate IP ranges.

#### **2 Octet Fix**
- Likely refers to using a two-octet subnet (e.g., `/16`), giving a large address range for VCN planning.

#### **VCN Wizard**
- Use the VCN Wizard in the OCI Console to quickly create a VCN with required subnets and gateways[4].

#### **Internet for Private Subnet**
- Private subnets do not have direct internet access.  
- Assign a public (elastic) IP to a NAT Gateway, and configure route tables to allow outbound internet access for private resources.

---

### **Hybrid Networking: Oracle and AWS**

#### **Configuration and Precautions**
- Ensure CIDR ranges do not overlap between OCI and AWS.
- Open necessary ports (UDP 500/4500 for IPSec) in security lists/firewalls.
- Use strong IKE pre-shared keys.
- Validate routing tables on both sides.

#### **Steps to Connect OCI and AWS**
1. **Create DRG (Dynamic Routing Gateway) in OCI** and attach to VCN.
2. **Create Virtual Private Gateway (VGW) in AWS** and attach to AWS VPC.
3. **Create Customer Gateway in AWS** using OCI DRG's public IP.
4. **Create VPN Connection** (define static/dynamic routing).
5. **Download Configuration** from OCI for VPN setup.
6. **Create IPSec Connection** (two tunnels for high availability).
7. **Why Two Tunnels?**  
   - For redundancy and failover; if one tunnel goes down, the other maintains connectivity.
8. **Why Tunnels May Be Down:**  
   - Mismatched configs, blocked ports, incorrect routing, or BGP issues.
9. **What is IKE?**  
   - Internet Key Exchange (IKE) is a protocol used to set up secure, authenticated communications for IPSec VPNs.

---

### **Learning Path**

- For structured learning, follow the [OCI Foundations Associate Learning Path](https://mylearn.oracle.com/ou/learning-path/become-an-oci-foundations-associate-2025/148056).

---