# AWS Interview Questions & Answers

---

## VPC & Networking

**Q1: List the components required to build Amazon VPC?**  
**Ans:** Subnet, Internet Gateway, NAT Gateway, HW VPN Connection, Virtual Private Gateway, Customer Gateway, Router, Peering Connection, VPC Endpoint for S3, Egress-only Internet Gateway.

**Q2: How do you safeguard your EC2 instances running in a VPC?**  
**Ans:** Use Security Groups to configure inbound and outbound traffic. Security Groups automatically deny unauthorized access.

**Q3: In a VPC how many EC2 instances can you use?**  
**Ans:** Initially 20 instances per region. Maximum VPC size: **65,536 instances**.

**Q4: Can you establish a peering connection to a VPC in a different REGION?**  
**Ans:** ❌ Not possible (only within the same region).

**Q5: Can you connect your VPC with a VPC owned by another AWS account?**  
**Ans:** ✅ Yes, if the owner accepts the connection.

**Q6: What are the different connectivity options available for your VPC?**  
**Ans:** Internet Gateway, Virtual Private Gateway, NAT, EndPoints, Peering Connections.

**Q7: Can an EC2 instance inside your VPC connect with the EC2 instance belonging to other VPCs?**  
**Ans:** ✅ Yes, provided proper routing via Internet Gateway.

**Q8: How can you monitor network traffic in your VPC?**  
**Ans:** Using **Amazon VPC Flow Logs**.

**Q9: Difference between Security Groups and ACLs in a VPC?**  
**Ans:**  
- Security Group → Instance level (stateful).  
- ACL → Subnet level (stateless).  

**Q10: How does an EC2 instance in a VPC connect with the internet?**  
**Ans:** Using **Public IP** or **Elastic IP**.

---

## Core AWS Services

**Q11: Different types of Cloud Computing services?**  
**Ans:**  
- PaaS – Platform as a Service  
- IaaS – Infrastructure as a Service  
- SaaS – Software as a Service  

**Q12: What is Auto Scaling?**  
**Ans:** Scaling EC2 instances automatically.  
- Scale-IN → reduce instances.  
- Scale-OUT → increase instances.

**Q13: What is AMI?**  
**Ans:** Amazon Machine Image – template of OS + software configs.

**Q14: Difference between Stopping and Terminating Instances?**  
**Ans:**  
- Stop → Instance shuts down, EBS persists.  
- Terminate → Instance + EBS deleted.

**Q15: Where should standby RDS instance be located?**  
**Ans:** In a **different AZ** for high availability.

**Q16: Difference between Amazon RDS, DynamoDB, and Redshift?**  
**Ans:**  
- RDS → SQL (structured data).  
- DynamoDB → NoSQL (unstructured data).  
- Redshift → Data warehouse for analytics.

**Q17: What are Lifecycle Hooks?**  
**Ans:** Used in Auto Scaling to pause and run custom actions during launch/terminate.

**Q18: What is S3?**  
**Ans:** Simple Storage Service – scalable object storage.

**Q19: What is AWS Lambda?**  
**Ans:** Event-driven compute service; runs code without managing servers.

**Q20: In S3 how many buckets can be created?**  
**Ans:** By default **100 per account per region**.

---

## CDN & Global Infrastructure

**Q21: What is CloudFront?**  
**Ans:** CDN service delivering content via **Edge Locations**.

**Q22: Brief about S3 service?**  
**Ans:** Object storage, like FTP. Supports snapshots, encryption, file transfer.

**Q23: Explain Regions and Availability Zones (AZs).**  
**Ans:**  
- Region = independent geographic area.  
- AZ = isolated datacenter within region, connected with low latency.  

**Q24: Types of Load Balancer?**  
**Ans:** Classic LB, Application LB.

**Q25: Can an AMI be shared?**  
**Ans:** ✅ Yes, but security risks exist.

**Q26: What is a Hypervisor?**  
**Ans:** Software for virtualization. AWS uses **XEN**.

**Q27: What is Key Pair?**  
**Ans:** Used for secure login. Separate per region.

**Q28: What is ClassicLink?**  
**Ans:** Allows EC2-Classic to communicate with VPC instances.

**Q29: Can you edit a Route Table in VPC?**  
**Ans:** ✅ Yes.

**Q30: How many Elastic IPs can you create?**  
**Ans:** **5 per region per account**.

---

## Monitoring & Security

**Q31: Can you ping the router or default gateway?**  
**Ans:** ❌ No, not supported. Only EC2 instances.

**Q32: How will you monitor network traffic in a VPC?**  
**Ans:** Using **VPC Flow Logs**.

**Q33: Can a VPC span multiple AZs?**  
**Ans:** ✅ Yes.

**Q34: How to ensure EC2 is launched in a specific AZ?**  
**Ans:** Select subnet linked to that AZ.

**Q35: Any bandwidth constraints for Internet Gateways?**  
**Ans:** ❌ No. Horizontally scalable.

**Q36: What is Default VPC?**  
**Ans:** Auto-created with default subnets + security features.

**Q37: Can you use default EBS Snapshots?**  
**Ans:** ✅ Yes, if in same region.

**Q38: What happens if you delete a Peering Connection?**  
**Ans:** Terminated on both sides.

**Q39: Can you peer across regions?**  
**Ans:** ❌ No (except via **inter-region peering** in advanced services).

**Q40: Can you connect VPCs from different accounts?**  
**Ans:** ✅ Yes, if accepted.

---

## Databases

**Q41: What happens when DB instance is deleted?**  
**Ans:** Manual snapshots remain. Automated backups deleted.

**Q42: What is the significance of an Elastic IP?**  
**Ans:** Static public IP stays with instance.

**Q43: How will you use S3 with EC2?**  
**Ans:** Store static content, snapshots, scalable storage.

**Q44: Can you connect your company datacenter to AWS Cloud?**  
**Ans:** ✅ Yes, via **VPN or Direct Connect**.

**Q45: Can you change Private IP of EC2?**  
**Ans:** ❌ No. It’s static.

**Q46: What is the use of Subnets?**  
**Ans:** To divide network into smaller, manageable parts.

**Q47: What is the use of Route Table?**  
**Ans:** Defines packet routing rules.

**Q48: Can standby DB be used for read/write?**  
**Ans:** ❌ No. Only during failover.

**Q49: What is Connection Draining?**  
**Ans:** ELB feature to reroute traffic from unhealthy instances.

**Q50: Role of AWS CloudTrail?**  
**Ans:** Logs all API calls for auditing.

---

## Miscellaneous

**Q51: What is Amazon Transfer Acceleration?**  
**Ans:** Speeds up S3 uploads via optimized paths & Edge Locations.

**Q52: AWS CEO?**  
**Ans:** Jeff Bezos (Note: as of 2025 → CEO is Adam Selipsky).

**Q53: EC2 launch year?**  
**Ans:** 2006.  

**Q54: S3 launch year?**  
**Ans:** 2006.  

**Q55: Can AWS store unlimited data?**  
**Ans:** ✅ True.  

**Q56: Rapid provisioning allows quick VM creation?**  
**Ans:** ✅ True.  

**Q57: Hybrid = AWS + other cloud provider?**  
**Ans:** ❌ False (Hybrid = AWS + On-premises).  

**Q58: Added security for AWS management?**  
**Ans:** Create **IAM Users**.  

---

## EC2, Elastic Compute & Instance Types

**Q59: Is AMI a template?**  
**Ans:** ✅ True.  

**Q60: EC2 instances are Virtual Servers in AWS?**  
**Ans:** ✅ True.  

**Q61: What does "elastic" in EC2 mean?**  
**Ans:** Increase/decrease capacity + Pay per use.  

**Q62: Can you upload a custom image to AWS Marketplace?**  
**Ans:** ✅ True.  

**Q63: EC2 Machine types define?**  
**Ans:** Core count.  

**Q64: Default instance type?**  
**Ans:** On-demand.  

**Q65: What is Elastic Computing?**  
**Ans:** Spin up/down VMs as needed.  

**Q70: Can you launch multiple instances with same AMI?**  
**Ans:** ✅ True.  

**Q71: PEM file = one-time physical password?**  
**Ans:** ✅ True.  

**Q72: Windows user requires PPK file to connect Linux instance?**  
**Ans:** ✅ True.  

**Q73: Can you buy EC2 time from other users?**  
**Ans:** ✅ True (via Spot market).  

**Q74: Instance not visible?**  
**Ans:** Wrong region selected.  

**Q75: Why terminate unused instance?**  
**Ans:** Extra cost.  

---

## Storage

**Q76: AWS service for caching data/images?**  
**Ans:** AWS Edge Locations.  

**Q77: Regions, AZs, Edge Locations = same?**  
**Ans:** ❌ False.  

**Q78: Every service available in every region?**  
**Ans:** ❌ False.  

**Q79: Premium support available?**  
**Ans:** ✅ True.  

**Q80: Can you add new Debit/Credit card in AWS account?**  
**Ans:** ✅ True.  

**Q81: Can you resize instance (micro → large)?**  
**Ans:** ✅ True.  

**Q82: On-demand instances use bid mechanism?**  
**Ans:** ❌ False.  

**Q83: Can RIs be sold in Marketplace?**  
**Ans:** ✅ True.  

**Q86: Most expensive instance option?**  
**Ans:** On-demand.  

**Q87: Amazon S3 accessible via HTTP/HTTPS?**  
**Ans:** ✅ True.  

**Q88: Amazon S3 is NOT object storage?**  
**Ans:** ❌ False.  

**Q93: Single object size limit in S3?**  
**Ans:** 5 TB.  

**Q94: Unlimited buckets in S3?**  
**Ans:** ❌ False (100 by default).  

**Q95: Instance/EBS-backed root volumes delete data by default?**  
**Ans:** ✅ True (unless configured).  

**Q99: Difference between Instance Store vs EBS?**  
- Instance Store → temporary, non-persistent.  
- EBS → persistent, encrypted, snapshot support.  

**Q100: Can EBS attach to running instance in same AZ?**  
**Ans:** ✅ True.  


## Q101: EBS is internet accessible  
**Answer:** False

## Q102: EBS has persistent file system for EC2  
**Answer:** True

## Q103: EBS supports incremental snapshots  
**Answer:** True

## Q104: Amazon Glacier enables customers to offload the administrative burdens of operating and scaling storage to AWS.  
**Answer:** True

## Q105: Amazon Glacier is a great storage choice when low storage cost is paramount.  
**Answer:** True

## Q106: Data is rarely retrieved, and retrieval latency of several hours is acceptable in Glacier  
**Answer:** True

## Q107: Glacier is basically for data archival  
**Answer:** True

## Q108: It is very cheap storage  
**Answer:** True

## Q109: Glacier has very, very slow retrieval times  
**Answer:** True

## Q110: By Default, Instance-Backed and EBS-Backed root volumes delete all data. However, when using EBS-Backed storage, you can configure it to save the data on the root volume.  
**Answer:** True

## Q111: You can switch from an Instance-Backed to an EBS-Backed root volume at any time.  
**Answer:** False

## Q112: When using an EBS-Backed machine, you can override the terminate option and save the root volume.  
**Answer:** True

## Q113: VPC is Private, Isolated, Virtual Network  
**Answer:** True

## Q114: VPC would be logically isolated network in AWS cloud  
**Answer:** True

## Q115: VPC is also give control of network architecture  
**Answer:** True

## Q116: VPC is also going to enhanced security  
**Answer:** True

## Q117: VPC has ability to interwork with other organizations  
**Answer:** True

## Q118: VPC does not enable hybrid cloud(site-to-site VPN)  
**Answer:** False

## Q119: Route Table is a set of Rules tells the direction of network  
**Answer:** True

## Q120: Security Group is a subnet level of security  
**Answer:** False

## Q121: NACLs(Network Access Lists) is a resource level of security  
**Answer:** False

## Q122: Any default stack is available in Cloud Formation?  
**Answer:** You cannot create a default stack but you can choose the type of stack to create (e.g., sample stack, Linux-based Chef stack, Windows-based Chef stack).

## Q123: What is the difference between Stack and Template in Cloud Formation?  
**Answer:**  
- **Stack:** Collection of AWS resources managed together.  
- **Template:** JSON/YAML file that defines resources.  

## Q124: We can create multiple server for same stack?  
**Answer:** Yes, you can configure Webserver Capacity to launch multiple instances automatically.

## Q125: Can you explain the term SQS is pull based, not pushed base.  
**Answer:** Messages are pushed into the queue by producers but must be pulled by consumers using ReceiveMessage API.

## Q126: How many Elastic IP address can be associated with a single account?  
**Answer:** 5

## Q127: What is the name of the additional network interfaces that can be created and attached to any Amazon EC2 instance in your VPC?  
**Answer:** Elastic Network Interface

## Q128: You have configured ELB with three instances... What service ensures traffic reroutes to healthy instances?  
**Answer:** Fault Tolerance

## Q129: After configuring ELB, you need to ensure user requests always attach to a single instance. What setting?  
**Answer:** Sticky Session

## Q130: Which of the following metrics cannot have a CloudWatch alarm?  
**Answer:** RRS lost object

## Q131: Which service is provided by CloudWatch?  
**Answer:** Monitor estimated AWS usage

## Q132: Which statement is not true regarding instance addressing?  
**Answer:** The user can communicate using the private IP across regions

## Q133: Which service provides the edge – storage or content delivery system?  
**Answer:** Amazon CloudFront

## Q134: Free usage tier instance with snapshot size of 50GB?  
**Answer:** Not possible under free usage tier

## Q135: Possible connection issues when connecting to EC2 instance?  
**Answer:** All of the above

## Q136: Sticky session with ELB does what?  
**Answer:** Binds the user session with a specific instance

## Q137: Which main email platform service?  
**Answer:** SES

## Q138: Which type of load balancer makes routing decisions at transport/application layer?  
**Answer:** Classic Load Balancer

## Q139: CloudFront requests per second limit?  
**Answer:** No limit

## Q140: While configuring security group, what must be selected?  
**Answer:** All of the above

## Q141: Which is a virtual network interface for EC2 in VPC?  
**Answer:** Elastic Network Interface

## Q142: Why select SSH when configuring security group?  
**Answer:** To allow traffic from your computer to port 22

## Q143: Quickest way to set up an email service?  
**Answer:** Amazon SES console

## Q144: Security group rule changes on Windows instance?  
**Answer:** Automatically applied

## Q145: Load Balancer and DNS come under which type of cloud service?  
**Answer:** IAAS-Network (correction: it's **Network**, not Storage)

## Q146: How to create encrypted volume from unencrypted one?  
**Answer:** Snapshot → Copy snapshot with encryption → Create volume

## Q147: Where specify max number of instances in Auto Scaling?  
**Answer:** Auto Scaling Group

## Q148: Prevent scaling during temporary network I/O spike?  
**Answer:** Suspend scaling

## Q149: Types of AMI?  
**Answer:** EBS-backed and Instance Store-backed

## Q150: What is the significance of forming subnets?  
**Answer:** Smartly utilize network that have large number of hosts

## Q151: Which service to transfer objects from datacenter with CloudFront?  
**Answer:** AWS Direct Connect

## Q152: Fully managed Data Warehouse service?  
**Answer:** Amazon Redshift

## Q153: Which statements are applicable to AWS EFS?  
**Answer:** All of the above

## Q154: Role of Connection Draining?  
**Answer:** Waits for requests to complete before terminating instances

## Q155: Use of Lambda?  
**Answer:** Running serverless applications

## Q156: Application Load Balancing?  
**Answer:** Feature of ELB + Distributes traffic to target groups

## Q157: Uses of Elastic Beanstalk?  
**Answer:** Deploy/manage applications + Supports multiple languages

## Q158: Connect datacenter to Amazon Cloud network?  
**Answer:** VPN between datacenter and VPC

## Q159: Private + Public workloads architecture?  
**Answer:** Hybrid Cloud

## Q160: DynamoDB stores what?  
**Answer:** Metadata

## Q161: Significance of CloudTrail?  
**Answer:** Governance, auditing, risk auditing, and activity history

## Q162: Global CDN with low latency?  
**Answer:** Amazon CloudFront

## Q163: Reserved Instances for multi-subnet deployments?  
**Answer:** Yes, available for all instances

## Q164: Correct statement?  
**Answer:** You can attach multiple Zones/Subnets to a Route Table

## Q165: Serverless NoSQL DB with millisecond latency?  
**Answer:** Amazon DynamoDB

## Q166: Keep standby DB in same AZ?  
**Answer:** Not recommended

## Q167: Can S3 objects be delivered by CloudFront?  
**Answer:** Yes

## Q168: Launch EC2 with pre-allocated private IP?  
**Answer:** Launch in VPC

## Q169: Edit SG rules for multiple instances?  
**Answer:** Yes, applies to all

## Q170: Route 53 statements true?  
**Answer:** A, B, C

## Q171: What is a VPC?  
**Answer:** Virtual network dedicated to your AWS account; can connect to datacenter

## Q172: What is an Elastic IP?  
**Answer:** Static IPv4 address; region-specific

## Q173: Fully managed in-memory data store?  
**Answer:** Amazon ElastiCache

## Q174: Which service to create domain names?  
**Answer:** Route 53

## Q175: Valid statement about EBS volumes?  
**Answer:** Multiple volumes can attach to single EC2 instance

## Q176: Valid statement about EBS Snapshots?  
**Answer:** Accessible via EC2

## Q178: Valid VPC scenario?  
**Answer:** Peering between VPCs in same region

## Q179: Connect VPC to datacenter?  
**Answer:** VPN

## Q180: Valid VPC scenarios?  
**Answer:** A, B, D

## Q181: How do EC2 instances access internet inside VPC?  
**Answer:** Internet Gateway

## Q182: Highly secured design?  
**Answer:** EC2 in public subnet, DB in private subnet

## Q183: EC2 public + DB private deployment model?  
**Answer:** Hybrid Cloud

## Q184: Which service distributes contents from Edge Locations?  
**Answer:** CloudFront

## Q185: AWS service for hosting apps?  
**Answer:** EC2

## Q186: Add what to Auto Scaling group for custom actions?  
**Answer:** Lifecycle Hooks

## Q187: What is Auto Scaling?  
**Answer:** Creating/terminating instances (scale in/out)

## Q188: Want complex queries but not data warehouse?  
**Answer:** Amazon RDS

## Q189: What is an AZ?  
**Answer:** Location inside region protected from failures

## Q190: Shared cloud for organizations (gov, banks)?  
**Answer:** Community Cloud

## Q191: How many buckets can be created in S3?  
**Answer:** 100

## Q192: Maximum object size in S3?  
**Answer:** 5TB

## Q193: Service to host static website?  
**Answer:** Amazon S3

## Q194: Which is not part of SG?  
**Answer:** Users

## Q195: Data transport with physical devices?  
**Answer:** Snowball

## Q196: Which IP for CGW?  
**Answer:** Public IP

## Q197: Max subnets per VPC?  
**Answer:** 200

## Q198: REST API with HMAC-SHA1 auth, storage service?  
**Answer:** S3

## Q199: Structured data store supporting indexing/queries?  
**Answer:** SimpleDB

## Q200: How many Elastic IP addresses per account?  
**Answer:** 5
"""


Perfect 👍 You’ve now listed **Q201 – Q250** with options, explanations, and some direct notes.
Let’s structure this into the **same format as your earlier assignment (Q101–Q200)**, with **answers + detailed explanation** so it’s ready for your notes or study material.

---

# 📘 AWS Practice Questions (Q201 – Q250) with Answers & Explanations

---

### **Q201. After configuring ELB, you need to ensure that the user requests are always attached to a single instance. What setting can you use?**

* A) Session cookie
* B) Cross zone load balancing
* C) Connection drainage
* D) Sticky session ✅

**Answer:** D) Sticky session
**Explanation:** ELB sticky sessions (session affinity) bind a user session to a specific EC2 instance by using a cookie, ensuring requests from the same client always go to the same backend instance.

---

### **Q202. Which of the following metrics cannot have a CloudWatch alarm?**

* A) EC2 instance status check failed
* B) EC2 CPU utilization
* C) RRS lost object ✅
* D) Auto scaling group CPU utilization

**Answer:** C) RRS lost object
**Explanation:** RRS (Reduced Redundancy Storage) lost object is a **metric** but cannot be used to trigger alarms. Other metrics like CPU, status check, and ASG are supported.

---

### **Q203. Which of the below mentioned service is provided by CloudWatch?**

* A) Monitor estimated AWS usage
* B) Monitor EC2 log files
* C) Monitor S3 storage ✅
* D) Monitor AWS calls using CloudTrail

**Answer:** C) Monitor S3 storage
**Explanation:** CloudWatch monitors metrics like S3 bucket size, number of objects, request count. AWS usage is via **Cost Explorer**, logs are via **CloudWatch Logs**, and API calls via **CloudTrail**.

---

### **Q204. Which service provides the edge storage or content delivery system that caches data at different locations?**

* A) Amazon RDS
* B) SimpleDB
* C) Amazon CloudFront ✅
* D) Amazon Associates Web Services

**Answer:** C) Amazon CloudFront
**Explanation:** Amazon CloudFront is AWS’s CDN (Content Delivery Network) that caches data in **edge locations** for low latency access.

---

### **Q205. What are the possible connection issues you can face while connecting to your instance?**

* A) Connection timed out
* B) Server refused our key
* C) No supported authentication methods available
* D) All of the above ✅

**Answer:** D) All of the above
**Explanation:** EC2 connectivity can fail due to timeout, incorrect key, or authentication issues.

---

### **Q206. You enabled sticky session with ELB. What does it do with your instance?**

* A) Routes all the requests to a single DNS
* B) Binds the user session with a specific instance ✅
* C) Binds the user IP with a specific session
* D) Provides a single ELB DNS for each IP address

**Answer:** B) Binds the user session with a specific instance
**Explanation:** Sticky sessions use cookies to bind a session to one instance behind the ELB.

---

### **Q207. Which is an email platform that provides an easy, cost-effective way to send and receive email using your own domains?**

* A) SES ✅
* B) SNS
* C) SQS
* D) SAS

**Answer:** A) SES (Simple Email Service)
**Explanation:** SES is AWS’s managed email platform. SNS = notifications, SQS = queueing.

---

### **Q208. How many requests per second can Amazon CloudFront handle?**

* A) 1000
* B) 100
* C) 10000
* D) No such limit ✅

**Answer:** D) No such limit
**Explanation:** Amazon CloudFront scales automatically to handle virtually unlimited requests.

---

### **Q209. Which is a virtual network interface that you can attach to an instance in a VPC?**

* A) Elastic IP
* B) AWS Elastic Interface
* C) Elastic Network Interface ✅
* D) AWS Network ACL

**Answer:** C) Elastic Network Interface (ENI)
**Explanation:** ENI is a virtual NIC that you can attach to EC2 in a VPC.

---

### **Q210. You launched an EC2 instance in EC2-Classic and want to change the security group rule. How will these changes be effective?**

* A) Security group rules cannot be changed
* B) Changes are automatically applied to all instances ✅
* C) Changes need reboot
* D) Changes will be effective after 24 hours

**Answer:** B) Automatically applied
**Explanation:** Security group rule changes apply instantly to all attached instances.

---

### **Q211. Load Balancer and DNS service comes under which type of cloud service?**

* A) IaaS – Network ✅
* B) IaaS – Computational
* C) IaaS – Storage
* D) None

**Answer:** A) IaaS – Network
**Explanation:** Load balancers and DNS (Route 53) are **networking services**, part of IaaS.

---

### **Q212. You have an unencrypted EBS volume and want to create another encrypted volume from it. How?**

* A) Copy unencrypted volume directly
* B) Create snapshot and encrypt it ✅
* C) Apply encryption parameters on volume directly
* D) Not possible

**Answer:** B) Create snapshot and encrypt it
**Explanation:** Take a snapshot of the unencrypted volume → copy snapshot with encryption → create encrypted volume.

---

### **Q213. Where does the user specify the maximum number of instances with Auto Scaling?**

* A) Launch Config
* B) Auto Scaling Group ✅
* C) Auto Scaling Policy
* D) Auto Scaling Size

**Answer:** B) Auto Scaling Group
**Explanation:** ASG defines **min, max, and desired capacity** of instances.

---

### **Q214. How can a user ensure that a huge data download event does not trigger Auto Scaling?**

* A) Network I/O not affected
* B) Policy cannot be set on network I/O
* C) No way to stop scaling
* D) Suspend scaling ✅

**Answer:** D) Suspend scaling
**Explanation:** To prevent unwanted scaling during temporary spikes, suspend scaling policies.

---

### **Q215. Types of AMI provided by AWS?**

* A) EBS backed ✅
* B) Instance Store backed ✅
* C) None
* D) Both A and B

**Answer:** D) Both A and B
**Explanation:** AMIs can be **EBS-backed** or **Instance Store-backed**.

---

📌 … and so on until **Q250** (you already have them written nicely in descriptive form).
I can polish all Q216 – Q250 into the same **Q → Options → Answer → Explanation** format like above.

---

👉 Do you want me to **continue formatting Q216 – Q250 into Q\&A with answers + explanations** (like I did for Q201–Q215) and then add them into your `AWS_Practice_Q201-Q300.md` assignment file?



Got it ✅ Let’s continue formatting **Q216 – Q250** into proper **Q\&A style with answers and explanations**.

---

# 📘 AWS Practice Q\&A (Q216 – Q250)

---

### **Q216. Name some cloud service providers for public & private cloud.**

**Answer:**

* **Public Cloud:** AWS, Microsoft Azure, Google Cloud, Oracle Cloud, Alibaba Cloud
* **Private Cloud:** RedHat OpenStack, Rackspace, VMware, IBM Private Cloud

**Explanation:**
Public cloud providers offer scalable, pay-as-you-go services over the internet. Private cloud solutions are designed for enterprises that need security, control, and compliance in their own datacenter or dedicated environment.

---

### **Q217. What are the different instance categories based on pricing?**

**Answer:**

1. **On-Demand Instances:** Pay hourly with no commitment.
2. **Reserved Instances (RI):** 1 or 3-year commitment with significant discounts.
3. **Spot Instances:** Bid on unused capacity at discounted prices.

**Explanation:**
On-demand is flexible, Reserved saves cost for predictable workloads, and Spot is best for fault-tolerant or batch workloads.

---

### **Q218. You have private servers on-premises and workloads in public cloud. What is this architecture called?**

**Answer:** Hybrid Cloud

**Explanation:**
Hybrid cloud combines on-premises infrastructure with public cloud services to balance cost, scalability, and compliance.

---

### **Q219. Difference between S3 and Glacier storage.**

**Answer:**

* **S3:** Used for frequently accessed data (hot storage).
* **Glacier:** Low-cost archival storage for infrequently accessed (cold) data.

**Explanation:**
S3 provides high availability and low latency. Glacier provides cheap long-term storage with retrieval delays (minutes to hours).

---

### **Q220. Name some database engines available natively in RDS.**

**Answer:** MySQL, PostgreSQL, MariaDB, Oracle, Microsoft SQL Server, Amazon Aurora

**Explanation:**
Amazon RDS supports multiple engines so users can migrate and scale their databases without managing infrastructure.

---

### **Q221. How can you automate resource provisioning in AWS?**

**Answer:**

* AWS CloudFormation
* Third-party tools: Ansible, Chef, Puppet

**Explanation:**
CloudFormation enables Infrastructure as Code (IaC), allowing templates to provision AWS resources in a repeatable and automated way.

---

### **Q222. What is Auto Scaling and its benefits?**

**Answer:**
**Definition:** Auto Scaling automatically adjusts EC2 capacity based on demand.
**Benefits:** Handles web traffic spikes, ensures availability, reduces cost by scaling in during low demand.

**Explanation:**
This is critical for dynamic workloads like e-commerce or ticket booking sites.

---

### **Q223. Difference between S3 availability & durability.**

**Answer:**

* **Availability:** System uptime, e.g., 99.99% of time S3 can serve requests.
* **Durability:** Data persistence, e.g., 99.999999999% (11 9’s) that data won’t be lost.

**Explanation:**
S3 achieves durability by storing data redundantly across multiple facilities.

---

### **Q224. Important features of S3 buckets.**

**Answer:**

* Static website hosting
* Versioning
* Encryption (SSE/Client-side)
* Lifecycle policies
* Unlimited storage

**Explanation:**
S3 provides object-based storage with flexible management and security features.

---

### **Q225. Measures to protect data in S3.**

**Answer:**

* Encrypt data (SSE-S3, SSE-KMS, SSE-C)
* Use pre-signed URLs
* Enable MFA delete
* Access Control Lists & IAM policies

**Explanation:**
Following security best practices ensures both accidental and malicious data loss is minimized.

---

### **Q226. What is an Elastic IP address?**

**Answer:**
Elastic IP (EIP) is a static IPv4 address allocated by AWS and associated with EC2 instances.

**Explanation:**
Useful for remapping to different instances in case of failure. Charges apply if EIP is allocated but not in use.

---

### **Q227. EC2 instance is at 100% CPU utilization. What should you do?**

**Answer:**
Create an **Elastic Load Balancer (ELB) with Auto Scaling** to distribute load across multiple instances.

**Explanation:**
This ensures high availability and distributes requests across healthy instances.

---

### **Q228. What is CloudWatch and what can you do with it?**

**Answer:**
CloudWatch monitors AWS resources and applications by collecting logs, metrics, and events.

**Uses:**

* Create alarms
* Collect logs
* Troubleshoot issues
* Optimize infrastructure

**Explanation:**
It provides real-time visibility and automation to maintain healthy operations.

---

### **Q229. How is cloud classified based on services?**

**Answer:**

1. **IaaS (Infrastructure as a Service):** EC2, EBS
2. **PaaS (Platform as a Service):** Elastic Beanstalk
3. **SaaS (Software as a Service):** WorkDocs, WorkMail

**Explanation:**
These categories define abstraction levels from infrastructure to complete software solutions.

---

### **Q230. Messaging service in AWS with use case.**

**Answer:**
**Service:** Amazon SNS (Simple Notification Service)
**Use Case:** Banking system sends SMS/email when a transaction occurs.

**Explanation:**
SNS enables push notifications to multiple endpoints such as email, SMS, or Lambda functions.

---

### **Q231. Company has 20 TB data for analytics, then archival. Which services to use?**

**Answer:**

* **S3** for initial storage
* **Redshift** for analytics
* **Glacier** for archival via S3 lifecycle policies

**Explanation:**
This combination ensures performance (Redshift), scalability (S3), and low-cost archival (Glacier).

---

### **Q232. RDS crashes during high traffic, replica not promoted. What to do?**

**Answer:**

* Use a larger RDS instance type
* Enable automated/manual snapshots

**Explanation:**
Scaling vertically improves performance. Snapshots ensure recovery from failures.

---

### **Q233. DB in EC2 Linux with ext4 EBS running out of space. What do you do?**

**Answer:**

1. Increase EBS volume size in AWS console
2. Run `resize2fs` on OS to expand filesystem

**Explanation:**
EBS resizing must be followed by OS-level resize to use additional capacity.

---

### **Q234. How to estimate AWS migration costs?**

**Answer:**

* Map on-premise servers to AWS EC2 instance types
* Use AWS Pricing Calculator to estimate

**Explanation:**
Helps predict future operational costs accurately before migration.

---

### **Q235. VPN with single IPSEC tunnel becomes unreachable during peak. What’s the fix?**

**Answer:**
Add multiple **IPSEC tunnels** to improve redundancy.

**Explanation:**
Multiple tunnels ensure failover and better availability at minimal cost.

---

### **Q236. What is Cloud Computing?**

**Answer:**
Cloud Computing is using remote servers hosted on the internet to store, manage, and process data instead of local servers.

**Explanation:**
Cloud providers (AWS, Azure, GCP) offer scalable services billed on usage.

---

### **Q237. Merits of Cloud Computing.**

**Answer:**

* No infrastructure maintenance
* Lower cost
* Improved performance
* Unlimited storage
* Increased reliability
* Device independence

**Explanation:**
Cloud reduces operational overhead while increasing flexibility and performance.

---

### **Q238. Characteristics of Cloud Computing.**

**Answer:**

* Scalability
* Low capital expense
* Pay-as-you-use
* Location independence
* 24×7 availability

**Explanation:**
These features make cloud computing cost-effective and globally accessible.

---

### **Q239. Top 10 advantages of Cloud Computing.**

**Answer:**

* Pay as you go
* Increased mobility
* High availability
* Easy management
* Dynamic scaling
* Shared resources
* Eco-friendly
* High productivity
* Faster deployment
* Low CAPEX

**Explanation:**
Cloud benefits span cost, flexibility, and operational efficiency.

---

### **Q240. Layers of Cloud Computing (Service Models).**

**Answer:**

1. **IaaS** – Infrastructure (EC2, EBS)
2. **PaaS** – Platforms for developers (Elastic Beanstalk)
3. **SaaS** – Complete software (WorkMail, Salesforce)

**Explanation:**
Each layer provides different levels of abstraction and control.

---

### **Q241. How do you disable password-based root logins in EC2?**

**Answer:**
Edit `/etc/ssh/sshd_config` → set:

```
PermitRootLogin without-password
```

**Explanation:**
This forces use of key-pairs instead of insecure root passwords.

---

### **Q242. How to take a snapshot of a RAID array?**

**Answer:**
Quiesce applications and flush caches before snapshotting all RAID volumes together.

**Explanation:**
Snapshots may otherwise miss in-memory/cached data, leading to inconsistent RAID recovery.

---

### **Q243. Difference between Volume and Snapshot.**

**Answer:**

* **Volume:** Block storage device attached to EC2.
* **Snapshot:** Point-in-time backup of a volume.

**Explanation:**
Snapshots can be used to create new volumes across AZs.

---

### **Q244. What happens if an Elastic Beanstalk app stops responding?**

**Answer:**
Beanstalk automatically replaces failed resources to restore application health.

**Explanation:**
Elastic Beanstalk manages infrastructure for high availability.

---

### **Q245–Q246. How to update AMI tools at boot time?**

**Answer (Linux):**

```bash
echo “Updating EC2 AMI tools”
yum update -y aws-amitools-ec2
echo “Updated EC2 AMI tools”
```

**Explanation:**
Ensures AMIs always use the latest AWS tools for compatibility.

---

### **Q247. How does AWS Lambda handle failures?**

**Answer:**

* **Synchronous:** Exception returned to caller
* **Asynchronous:** Retries automatically (3 times)
* **DynamoDB/Kinesis triggers:** Retries until success or 24-hour data expiry

**Explanation:**
Lambda has built-in retry policies depending on invocation type.

---

### **Q248. Storage classes in AWS.**

**Answer:**

* S3 (object storage)
* EBS (block storage)
* EFS (managed NFS)
* Glacier (archive)
* Storage Gateway (hybrid)
* Snowball / Snowmobile (data transport)

**Explanation:**
Each service targets different storage and access patterns.

---

### **Q249. How is S3 encryption done?**

**Answer:**

* **In Transit:** SSL/TLS
* **At Rest:**

  * SSE-S3
  * SSE-KMS
  * SSE-C
  * Client-side encryption

**Explanation:**
AWS provides both server-side and client-side encryption methods.

---

### **Q250. How to upload a file >100 MB to S3?**

**Answer:**
Use **Multipart Upload**.

**Explanation:**
Multipart upload splits a large file into chunks, uploads them in parallel, and combines them into a single object in S3.

---

