

-----

# ☁️ Oracle Cloud Infrastructure (OCI) Documentation

## 📌 Overview

Oracle Cloud Infrastructure (OCI) is a next-generation cloud designed for enterprise applications and modern workloads. This guide covers core components, identity and security setup, networking (including VPN and hybrid cloud), and steps for integrating Oracle Cloud with AWS. It also includes practical examples and troubleshooting tips for real-world cloud scenarios.

-----

## 🏠 OCI Services

OCI offers a comprehensive suite of cloud services. Here's a breakdown of the core categories:

| Category | Description & Examples |
| :----------------------------- | :----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| **Compute** | Virtual Machines (VMs), Bare Metal, Autoscaling, Custom Images, Container Engine for Kubernetes (OKE) |
| **Storage** | Block Storage, Object Storage, File Storage, Archive Storage |
| **Networking** | Virtual Cloud Network (VCN), Subnets, Internet Gateway (IG), NAT Gateway, Service Gateway, Dynamic Routing Gateway (DRG), VPN, Load Balancer, FastConnect |
| **Databases** | Autonomous Transaction Processing (ATP), Autonomous Data Warehouse (ADW), Exadata Database Service, MySQL Database Service, NoSQL Database |
| **Analytics & AI** | Oracle Analytics Cloud, Data Flow, AI Services, GoldenGate |
| **Developer Services** | Functions, API Gateway, DevOps (CI/CD), Container Engine for Kubernetes |
| **Identity & Security** | Identity and Access Management (IAM), Policies, Multi-Factor Authentication (MFA), Domains, Groups, Security Zones, Cloud Guard, Vault |
| **Observability & Management** | Logging, Monitoring, Alarms, Metrics, Resource Manager, Application Performance Monitoring (APM) |
| **Hybrid Cloud** | OCI FastConnect, Multi-cloud with Azure, Roving Edge Infrastructure |
| **Migration & Disaster Recovery** | Database Migration Service, Site-to-Site VPN, Data Replication, Backup and Restore |
| **Billing & Cost Management** | Budgets, Usage Reports, Cost Analysis, Cost Tracking |
| **Governance & Administration** | Compartments, Quotas, Tags, Policies |
| **Marketplace** | Prebuilt Oracle and third-party images and solutions |

-----

## 🗂️ Identity and Access Management (IAM)

IAM in OCI manages access to cloud resources securely.

### Compartment Structure

OCI uses a **parent-child compartment model** for logical organization and isolation of resources. This hierarchical structure allows for fine-grained access control through policies.

  * Root Compartment (Tenancy)
      * Parent Compartment (e.g., "Development")
          * Child Compartment (e.g., "Dev-App1")
              * Resources (VMs, Databases, etc.)

### 🛂 IAM Configuration Steps

1.  **Create IAM Domain:**

      * **Console:** Navigate to **Identity & Security** → **Domains**. Click **Create Domain**, then define the region, name, and description.
      * **CLI:**
        ```bash
        oci iam domain create --compartment-id <compartment_OCID> --display-name <domain_name>
        ```

2.  **Create User:**

      * **Console:** Go to **Identity & Security** → **Users**. Click **Create User**, provide a username, email, and assign them to the created domain.
      * **CLI:**
        ```bash
        oci iam user create --compartment-id <compartment_OCID> --name <user_name> --description "New user"
        ```

3.  **Enable MFA (Multi-Factor Authentication):**

      * **Console:** For a specific user, go to **Identity & Security** → **Users** → *[Select User]* → **MFA Settings**. Enroll via an Authenticator App or SMS. MFA adds an essential layer of security.

4.  **Create Group & Add User:**

      * **Console:** Go to **Identity & Security** → **Groups**. Click **Create Group**, enter a name and description. Then, select the group and **Add User** to it.
      * **CLI (Create Group):**
        ```bash
        oci iam group create --compartment-id <compartment_OCID> --name <group_name> --description "Description for group"
        ```
      * **CLI (Add User to Group):**
        ```bash
        oci iam group add-user --user-id <user_OCID> --group-id <group_OCID>
        ```

5.  **Create and Attach Policies:**

      * Policies define what actions groups can perform on resources within specific compartments.
      * **Console:** Go to **Identity & Security** → **Policies**. Click **Create Policy**, enter a name, description, select the compartment, and input the policy statements.
      * **Example Policy Statement:**
        ```text
        Allow group <group_name> to manage all-resources in compartment <compartment_name>
        ```
      * **CLI:**
        ```bash
        oci iam policy create --compartment-id <compartment_OCID> --name <policy_name> --statements '["Allow group <group_name> to manage all-resources in compartment <compartment_name>"]'
        ```

-----

## 🌐 Networking in OCI

Networking in OCI is built around the Virtual Cloud Network (VCN).

### Virtual Cloud Network (VCN)

A **VCN** is a customizable, private network within OCI, similar to a traditional data center network, where you can securely launch and manage cloud resources.

#### Components:

  * **Subnets:** Logical subdivisions of a VCN, designated as Private or Public.
  * **Route Tables:** Set of rules that control how traffic leaves subnets.
  * **Internet Gateway (IG):** Enables public subnets to access the internet.
  * **NAT Gateway:** Allows resources in private subnets to initiate outbound connections to the internet.
  * **Service Gateway:** Provides private access from a VCN to OCI services (e.g., Object Storage) without traversing the internet.
  * **Dynamic Routing Gateway (DRG):** Connects your VCN to external networks like on-premises data centers or other cloud providers.

### 🧮 CIDR (Classless Inter-Domain Routing)

**CIDR** is a notation for IP address ranges, e.g., `10.0.0.0/16`. The `/` (slash) and number indicate the subnet mask length.

  * A `/24` block contains 256 IP addresses (e.g., `10.0.0.0` to `10.0.0.255`).
  * A `/16` block contains 65,536 IP addresses (e.g., `10.0.0.0` to `10.0.255.255`).
  * **Tool:** Use [cidr.xyz](https://cidr.xyz) to calculate and check IP ranges.
  * **2 Octet Fix:** This often refers to using a `/16` subnet, which allocates two octets for host addressing, providing a large address space for VCN planning.

### ⚙️ VCN Setup

#### Using the VCN Wizard:

1.  **Console:** Go to **Networking** → **Virtual Cloud Networks**.
2.  Click **Start VCN Wizard**.
3.  Choose a configuration:
      * **VCN with Internet Connectivity** (creates public and private subnets, IG, NAT Gateway).
      * **VCN with Private Subnet + NAT Gateway** (for private-only VCN with outbound internet access).

#### Internet Access for Private Subnets:

Private subnets **do not** have direct internet access. To enable outbound internet access:

1.  **Create a NAT Gateway:** This gateway translates private IPs to public IPs for outbound traffic.
2.  **Assign a Public IP (Elastic IP) to the NAT Gateway.**
3.  **Update the private subnet's route table:** Add a rule with `Destination CIDR Block: 0.0.0.0/0` and `Target Type: NAT Gateway`.

-----

## 🔐 Site-to-Site VPN Setup (OCI ↔ AWS)

A **VPN tunnel** creates an encrypted connection over the public internet between two networks, such as OCI and AWS, ensuring secure, private communication. Two tunnels are always created for **high availability** and redundancy.

### 📦 Key Terms for Hybrid Connectivity:

| Term | Description |
| :------------------------------ | :----------------------------------------------------------------- |
| **VCN** | Virtual Cloud Network (Oracle Cloud Infrastructure) |
| **VPC** | Virtual Private Cloud (Amazon Web Services) |
| **VPN Tunnel** | Encrypted connection over the public internet |
| **DRG** | Dynamic Routing Gateway in OCI; connects VCNs to external networks |
| **VGW** | Virtual Private Gateway in AWS; connects AWS VPCs to external VPNs |
| **CPE (OCI) / CGW (AWS)** | Customer Premises Equipment (OCI) / Customer Gateway (AWS); represents the remote VPN endpoint (e.g., AWS VGW's public IP in OCI, or OCI DRG's public IP in AWS) |
| **IKE** | Internet Key Exchange; protocol used to set up IPsec VPN connections |

### 🧱 OCI Side Configuration

1.  **Create DRG:**

      * **Console:** **Networking** → **Dynamic Routing Gateways (DRG)** → **Create DRG**.
      * **CLI:**
        ```bash
        oci network drg create --compartment-id <compartment_OCID> --display-name <drg_name>
        ```

2.  **Attach DRG to VCN:**

      * **Console:** From the DRG details, select **DRG Attachments** and **Create DRG Attachment** to your VCN.
      * **CLI:**
        ```bash
        oci network drg-attachment create --drg-id <drg_OCID> --vcn-id <vcn_OCID> --display-name <attachment_name>
        ```

3.  **Create CPE (Customer Premises Equipment):**

      * **Console:** **Networking** → **Customer-Premises Equipment** → **Create CPE**. Enter the AWS VGW public IP address.
      * **CLI:**
        ```bash
        oci network cpe create --compartment-id <compartment_OCID> --ip-address <aws_vgw_public_IP> --display-name <cpe_name>
        ```

4.  **Create VPN Connection (IPSec Connection):**

      * **Console:** **Networking** → **IPSec Connections** → **Create IPSec Connection**. Select the DRG, CPE, and define the routing type (Static or BGP Dynamic). Two tunnels will be created automatically for redundancy.
      * **CLI:**
        ```bash
        oci network ipsec-connection create --compartment-id <compartment_OCID> --drg-id <drg_OCID> --cpe-id <cpe_OCID> --display-name <ipsec_name>
        ```

5.  **Download Configuration File:**

      * **Console:** From the IPSec Connection details page, click **Download Configuration**. This `.conf` file contains details needed for the AWS side.
      * **CLI:**
        ```bash
        oci network ipsec-connection get --ipsc-id <ipsec_connection_OCID> --query data."tunnels"
        ```

### 🧱 AWS Side Configuration

1.  **Create Virtual Private Gateway (VGW):** In your AWS VPC console.
2.  **Attach VGW to AWS VPC:** Associate the newly created VGW with your target AWS VPC.
3.  **Create Customer Gateway (CGW):** Use the public IP address of the OCI DRG.
4.  **Create VPN Connection:** Use the downloaded OCI configuration file for IKE and tunnel settings.
5.  **Create Static Routes:** Configure static routes in your AWS VPC route tables to direct traffic for the OCI VCN's CIDR block towards the VGW. If using BGP, ensure BGP is configured correctly.

### 📡 IPSec Tunnel Troubleshooting

If IPSec tunnels show "down":

  * **Mismatched Configuration:** Verify that IP addresses, IKE versions, pre-shared keys (PSK), and routing settings (static/BGP) match exactly on both OCI and AWS sides.
  * **Firewall/Security Group Rules:** Ensure that UDP ports **500** (for IKE) and **4500** (for NAT-T) are open and not blocked by any security lists, network security groups, or firewalls on either side.
  * **Incomplete BGP or Static Route Configuration:** Confirm that routes for the remote network are correctly propagated or statically defined in both OCI and AWS.
  * **Logs:** Review the logs on both the OCI side and your AWS VPN connection for error messages.

-----

## 🧭 Best Practices & Precautions

### 🧠 Before You Begin:

  * **CIDR Planning:** Ensure CIDR ranges **do not overlap** between OCI and AWS (or any other connected networks).
  * **Firewall Rules:** Enable **ICMP** (for ping testing) and **UDP 500, 4500** on all relevant security lists, network security groups, and on-premises firewalls.
  * **Pre-shared Key (PSK):** Use a strong and unique IKE pre-shared key for your VPN connection.
  * **Routing Validation:** Thoroughly validate routing tables in both OCI and AWS to ensure traffic flows correctly.
  * **Tools:** Keep **CloudShell** or a **local OCI CLI** handy for diagnostics and quick configuration checks.
  * **MFA:** Always enable MFA for all user accounts to enhance security.
  * **Monitoring:** Set up monitoring and alarms for resource usage and network connectivity.

-----

## 💸 Billing & Cost Management

  * Set **budgets and alerts** in the OCI Console to monitor spending and receive notifications when thresholds are met.
  * Use **Cost Analysis** reports to track service usage and identify cost drivers.
  * Enable **Compartment-based billing visibility** to allocate costs to specific projects or teams.

**CLI Example (Create Budget):**

```bash
oci budgets budget create --compartment-id <your_compartment_OCID> --target-compartment-id <target_compartment_OCID_for_budget> --amount <budget_amount> --reset-period MONTHLY --display-name "Monthly Budget"
```

-----

## 🧰 Tools & Learning Path

  * **CIDR Calculator:** [cidr.xyz](https://cidr.xyz)
  * **OCI CLI Documentation:** [Oracle Cloud Infrastructure CLI](https://docs.oracle.com/en-us/iaas/tools/oci-cli/latest/oci_cli_docs/)
  * **OCI Foundations Associate Learning Path:** [Become an OCI Foundations Associate 2025](https://mylearn.oracle.com/ou/learning-path/become-an-oci-foundations-associate-2025/148056)

-----

## 🧠 Interview/Review Questions

1.  **What is a VCN and how does it differ from a VPC?**

      * **Answer:** A **VCN (Virtual Cloud Network)** in OCI is a customizable, private network segment within Oracle Cloud, similar to a traditional data center network, where you can launch and manage cloud resources securely. A **VPC (Virtual Private Cloud)** is the equivalent concept in AWS. While both offer similar core networking features (subnets, route tables, gateways, security lists), their terminology, specific implementations, and integrations may differ between OCI and AWS. The fundamental purpose, however, remains the same: providing an isolated, software-defined network for your cloud resources.

2.  **What is CIDR? Explain with an example.**

      * **Answer:** **CIDR (Classless Inter-Domain Routing)** is a method for allocating IP addresses and routing IP packets. CIDR notation specifies an IP address range using a base IP and a subnet mask length, e.g., `10.0.0.0/16`. The number after the slash (`/`) indicates the number of bits in the network portion of the IP address. For example, `10.0.0.0/24` represents all IP addresses from `10.0.0.0` to `10.0.0.255`, which is a total of 256 addresses ($2^{(32-24)} = 2^8 = 256$).

3.  **How does NAT Gateway provide internet to private subnets?**

      * **Answer:** A **NAT Gateway** allows resources in a private subnet (which have no direct internet access) to initiate outbound connections to the internet, while preventing inbound connections from the internet. Resources in the private subnet send their traffic to the NAT Gateway. The NAT Gateway then translates the private IP addresses to a public IP address for outbound traffic. Response traffic from the internet is routed back to the NAT Gateway, which then forwards it to the correct private resource. This setup requires configuring the private subnet's route table to direct `0.0.0.0/0` traffic towards the NAT Gateway.

4.  **What is the role of DRG in hybrid networking?**

      * **Answer:** A **DRG (Dynamic Routing Gateway)** in OCI acts as a virtual router that serves as a single point of entry and exit for network traffic between your VCN and external networks. This includes on-premises data centers (via VPN or FastConnect) or other cloud providers (like AWS). It is crucial for enabling hybrid cloud architectures by managing dynamic routing using protocols like BGP or handling static routes, allowing seamless communication across disparate networks.

5.  **What is the difference between CPE and CGW?**

      * **Answer:** **CPE (Customer Premises Equipment)** is an OCI resource that logically represents the on-premises (or remote cloud) VPN device in your network that connects to OCI. In AWS, the equivalent is a **CGW (Customer Gateway)**, which is an AWS resource representing your external VPN device (e.g., OCI’s DRG). Both terms refer to the remote VPN endpoint from the perspective of the cloud provider where they are configured.

6.  **Why are two IPSec tunnels created?**

      * **Answer:** Two IPSec tunnels are created for **high availability** and redundancy. This design ensures continuous connectivity and minimizes downtime in hybrid or multi-cloud setups. If one tunnel experiences an issue (e.g., network outage, maintenance, or configuration problem), the other tunnel can maintain the connection, allowing traffic to continue flowing without interruption.

7.  **How do you troubleshoot a downed VPN tunnel?**

      * **Answer:** To troubleshoot a downed VPN tunnel:
          * **Check Configuration:** Verify that all IP addresses, IKE versions, pre-shared keys, and routing settings (static or BGP) are identical and correctly configured on both the OCI and the remote (e.g., AWS) side.
          * **Network & Firewall:** Ensure that UDP ports 500 (for IKE) and 4500 (for NAT-T) are open and not blocked by any security lists, network security groups, or firewalls along the path.
          * **Logs:** Review the logs on both the OCI IPSec connection and the remote VPN device for any error messages or connection failures.
          * **Routing:** Confirm that correct static routes are defined or BGP is established and advertising routes on both ends for the respective network CIDR blocks.
          * **Connectivity:** Test basic network connectivity using tools like `ping` (if ICMP is allowed) from instances in each cloud.

8.  **How does MFA enhance security in OCI?**

      * **Answer:** **MFA (Multi-Factor Authentication)** significantly enhances security by requiring users to provide more than one form of verification before gaining access. Beyond just a password (something you know), MFA typically requires a second factor like a code from an authenticator app, a fingerprint, or a token (something you have). This makes it much harder for unauthorized users to access an account, even if they manage to compromise the user's password.

9.  **What is a compartment and how is it used in governance?**

      * **Answer:** A **compartment** is a fundamental logical container in OCI used to organize and isolate cloud resources (such as VMs, databases, networks) within your tenancy. For governance, compartments enable:
          * **Resource Organization:** Grouping resources by project, department, or environment.
          * **Access Control:** Applying fine-grained IAM policies at the compartment level to control who can perform specific actions on resources within that compartment.
          * **Cost Tracking:** Allocating costs to specific compartments, allowing for detailed billing analysis for different teams or projects.
          * **Quotas:** Setting resource limits within compartments to manage consumption.

10. **How do you configure IAM policies in OCI?**

      * **Answer:** IAM policies in OCI are configured to grant specific permissions to groups of users on particular resources within compartments.
          * **Console:** You navigate to **Identity & Security** → **Policies**, then click **Create Policy**. Here you provide a name, description, select the compartment where the policy will apply, and write one or more policy statements.
          * **CLI:** You can use the `oci iam policy create` command, providing the compartment OCID, name, and policy statements in JSON format.
          * **Example:** `Allow group <group_name> to manage all-resources in compartment <compartment_name>` allows all members of `<group_name>` to perform any action on any resource within `<compartment_name>`. Policies define what actions (inspect, read, use, manage) a group can perform on specific resource types or all resources in a given compartment.

-----