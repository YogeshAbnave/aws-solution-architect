# 📘 Virtual Private Cloud (VPC) — Detailed Overview

---

## 1️⃣ What is a VPC?

A **Virtual Private Cloud (VPC)** is a logically isolated section of the AWS Cloud where you can launch AWS resources (like EC2 instances, databases, etc.) in a **virtual network** that you define. You have full control over:

* IP address ranges
* Subnets (public/private)
* Route tables
* Internet gateways
* NAT devices
* Security settings (Security Groups, Network ACLs)

---

## 2️⃣ How People are Identified (Analogy)

To understand VPC and network segmentation, consider ways to identify a person:

| Identification Type       | Example           |
| ------------------------- | ----------------- |
| Nickname                  | "Yogesh"          |
| Full Name                 | "Yogesh Abnave"   |
| Social Security Number    | "123-45-6789"     |
| Nickname (Friends/Family) | "Yogi"            |
| Public Identifier         | Cell phone number |

Similarly, **IP addresses** and **CIDR blocks** help identify resources in a network.

---

## 3️⃣ CIDR (Classless Inter-Domain Routing)

CIDR defines **IP address ranges** using notation like `/16`, `/24`, etc.

**Example:**

```
CIDR Notation: 192.168.0.1/16
```

* First 16 bits: Network ID (192.168)
* Remaining 16 bits: Host IDs

| Notation | IPs            | Address Range                 |
| -------- | -------------- | ----------------------------- |
| /32      | 1 IP           | 192.168.0.0                   |
| /24      | 256 IPs        | 192.168.0.0 - 192.168.0.255   |
| /16      | 65,536 IPs     | 192.168.0.0 - 192.168.255.255 |
| /8       | 16,777,216 IPs | 192.0.0.0 - 255.255.255.255   |
| /0       | All IPs        | 0.0.0.0 - 255.255.255.255     |

🔢 **Binary Example**:

```
192.168.0.1
= 11000000.10101000.00000000.00000001
= 128+32+8 = 168 (in the second octet)
```

---

## 4️⃣ VPC — Create Your Own (Step by Step)

### 1. **Create a VPC**

* Navigate to AWS VPC Console → VPC → Create VPC.
* Name it (e.g., MyVPC).
* Specify the CIDR block (e.g., 10.0.0.0/16).
* AWS reserves:

  * First 4 addresses + last address in every subnet (ex: 10.0.0.0, 10.0.0.1, 10.0.0.2, 10.0.0.3, 10.0.0.255).

### 2. **Create Subnets**

* Public Subnet (for EC2 with internet access).
* Private Subnet (for DBs, internal apps).

### 3. **Elastic Network Interfaces (ENIs)**

* Virtual NICs attached to EC2.
* Demo: Create ENI → Attach to EC2.

---

## 5️⃣ Security Groups

* **Stateful Firewall**
* Controls **inbound/outbound** traffic at the instance level.
* By default, inbound is **denied**; outbound is **allowed**.

**Inbound Rules:**

* Allow SSH (port 22)
* Allow HTTP (port 80)

**Demo:**

1. Go to EC2 → Security Groups → Create.
2. Add inbound rule: Allow SSH (22) from your IP.
3. Add outbound rule: Allow all traffic (default).

---

## 6️⃣ Network ACLs (NACLs)

* Stateless firewall at the **subnet level**.
* Rules control **inbound/outbound**.
* Unlike Security Groups, they are stateless—**you must configure both directions**.

**Demo:**

1. Go to VPC → NACLs → Create.
2. Add inbound rule: Block port 80.
3. Add outbound rule: Allow all.

🔍 **Blocking Port 80**

* Add a deny rule for port 80 on both inbound and outbound.

---

## 7️⃣ Comparison: Security Groups vs NACLs

| Feature             | Security Group                 | NACL                  |
| ------------------- | ------------------------------ | --------------------- |
| Stateful            | Yes                            | No                    |
| Operates At         | Instance level                 | Subnet level          |
| Default Behavior    | Inbound: Deny, Outbound: Allow | Allow all             |
| Use Case            | Specific EC2 traffic           | Subnet-wide filtering |
| Supports Deny Rules | No                             | Yes                   |

---

## 8️⃣ NAT Devices

* Provide internet access for private subnets.

**Types:**

* **NAT Gateway (recommended)**: Managed, auto-scalable.
* **NAT Instance**:

  * Manually managed EC2 instance.
  * Must disable source/destination check.

---

## 9️⃣ Bastion Host

* Jump box to connect to private instances.
* Placed in public subnet.

---

## 🔟 VPC Peering

* Connect two VPCs privately.
* VPC A ↔ VPC B.
* Routes must be updated for communication.

**Demo:**

1. VPC → Peering → Create Peering Connection.
2. Accept request in the target VPC.
3. Update route tables.

---

## 🔢 VPC Endpoints

* Access AWS services **privately** without internet gateway.
* Examples: S3, DynamoDB.

---

## 🔗 VPC Reachability Analyzer

* Tool to troubleshoot connectivity issues.

---

## 🔌 AWS Direct Connect

* Private, high-bandwidth connection from on-prem to AWS.

---

## 🚏 Transit Gateway

* Hub-and-spoke architecture.
* Connects multiple VPCs and on-prem networks.
* Centralized routing.

---

## 🛡️ Key Points Summary

✅ VPCs are tied to AWS regions.
✅ IP ranges defined using CIDR blocks.
✅ Subnets segment the VPC.
✅ Security Groups = Stateful; NACLs = Stateless.
✅ NAT devices enable internet for private subnets.
✅ VPC Peering and Transit Gateways connect networks.
✅ Use VPC endpoints to access AWS services privately.

---

## 📍 Other Notes

* Elastic Network Interfaces (ENIs) — attach multiple IPs to an EC2.
* VPC splitting — divides your IP range into multiple subnets.
* AWS reserves IPs in each subnet:

  * .0 (network address)
  * .1 (VPC router)
  * .2 (DNS)
  * .3 (future use)
  * .255 (broadcast address).

---

## 📝 Suggested Demo Checklist

✅ Create VPC with CIDR (10.0.0.0/16).
✅ Create public/private subnets.
✅ Create Internet Gateway.
✅ Attach IGW to VPC.
✅ Create route tables & routes.
✅ Launch EC2 in public subnet.
✅ Create ENI & attach to EC2.
✅ Configure Security Groups & NACLs.
✅ Block port 80 using NACL.
✅ Create NAT Gateway & private EC2.
✅ Set up VPC Peering between two VPCs.
✅ Test connectivity with Reachability Analyzer.
✅ Explore VPC endpoints for private S3 access.

