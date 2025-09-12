# AWS Interview Questions and Answers

## Q1) What is AWS?
**Answer:** AWS stands for Amazon Web Services. AWS is a platform that provides on-demand resources for hosting web services, storage, networking, databases, and other resources over the internet with a pay-as-you-go pricing model.

---

## Q2) What are the components of AWS?
**Answer:** Components of AWS include:
- EC2 (Elastic Compute Cloud)
- S3 (Simple Storage Service)
- Route 53
- EBS (Elastic Block Store)
- CloudWatch
- Key-Pairs

---

## Q3) What are key-pairs?
**Answer:** Key-pairs are secure login credentials for your instances/virtual machines. They contain a public key and a private key used to connect to instances.

---

## Q4) What is S3?
**Answer:** S3 stands for Simple Storage Service. It is a storage service that provides an interface to store any amount of data, at any time, from anywhere in the world. You pay only for what you use.

---

## Q5) What are the pricing models for EC2 instances?
**Answer:** The pricing models for EC2 instances are:
- On-demand
- Reserved
- Spot
- Scheduled
- Dedicated

---

## Q6) What are the types of volumes for EC2 instances?
**Answer:** There are two types of volumes:
- Instance store volumes
- EBS (Elastic Block Store) volumes

---

## Q7) What are EBS volumes?
**Answer:** EBS stands for Elastic Block Store. These are persistent volumes that can be attached to instances. Data on EBS volumes is preserved even when instances are stopped.

---

## Q8) What are the types of volumes in EBS?
**Answer:** EBS volume types include:
- General purpose
- Provisioned IOPS
- Magnetic
- Cold HDD
- Throughput optimized

---

## Q9) What are the different types of instances?
**Answer:** Instance types include:
- General purpose
- Compute optimized
- Storage optimized
- Memory optimized
- Accelerated computing

---

## Q10) What is auto-scaling and what are its components?
**Answer:** Auto-scaling automatically scales the number of instances based on CPU or memory utilization. Its components are:
- Auto-scaling groups
- Launch configuration

---

## Q11) What are reserved instances?
**Answer:** Reserved instances allow you to reserve fixed capacity EC2 instances with a contract of 1 or 3 years.

---

## Q12) What is an AMI?
**Answer:** AMI stands for Amazon Machine Image. It is a template containing software configurations, launch permissions, and block device mapping for launching instances.

---

## Q13) What is an EIP?
**Answer:** EIP stands for Elastic IP address. It is a static IP address designed for dynamic cloud computing, allowing instances to retain the same IP after stop/start.

---

## Q14) What is CloudWatch?
**Answer:** CloudWatch is a monitoring tool used to monitor various AWS resources, including health checks, network, and application performance.

---

## Q15) What are the types of monitoring in CloudWatch?
**Answer:** CloudWatch offers:
- Basic monitoring (free)
- Detailed monitoring (chargeable)

---

## Q16) What are the CloudWatch metrics available for EC2 instances?
**Answer:** Metrics include:
- DiskReads
- DiskWrites
- CPU utilization
- NetworkPacketsIn
- NetworkPacketsOut
- NetworkIn
- NetworkOut
- CPUCreditUsage
- CPUCreditBalance

---

## Q17) What is the minimum and maximum size of individual objects in S3?
**Answer:** Minimum size is 0 bytes, and maximum size is 5TB.

---

## Q18) What are the different storage classes in S3?
**Answer:** S3 storage classes:
- Standard frequently accessed
- Standard infrequently accessed
- One-zone infrequently accessed
- Glacier
- RRS (reduced redundancy storage)

---

## Q19) What is the default storage class in S3?
**Answer:** The default storage class is Standard frequently accessed.

---

## Q20) What is Glacier?
**Answer:** Glacier is a backup or archival service used to store data from S3 for long-term retention.

---

## Q21) How can you secure access to your S3 bucket?
**Answer:** Access can be controlled via:
- ACL (Access Control List)
- Bucket policies

---

## Q22) How can you encrypt data in S3?
**Answer:** Encryption methods:
- Server-side encryption – S3 (AES-256 encryption)
- Server-side encryption – KMS (Key Management Service)
- Server-side encryption – C (Client-side)

---

## Q23) What are the parameters for S3 pricing?
**Answer:** S3 pricing is based on:
- Storage used
- Number of requests
- Storage management
- Data transfer
- Transfer acceleration

---

## Q24) What is the prerequisite for cross-region replication in S3?
**Answer:** Versioning must be enabled on both source and destination buckets, and they must be in different regions.

---

## Q25) What are roles?
**Answer:** Roles are used to provide permissions to trusted entities within your AWS account. They are similar to users but do not require username/password.

---

## Q26) What are policies and what are the types?
**Answer:** Policies are permissions attached to users. Types include:
- Managed policies
- Inline policies

---

## Q27) What is CloudFront?
**Answer:** CloudFront is a content delivery network (CDN) service that distributes content with low latency and high data transfer speeds.

---

## Q28) What are edge locations?
**Answer:** Edge locations are caching sites where content is stored to reduce latency for end-users.

---

## Q29) What is the maximum individual archive size in Glacier?
**Answer:** The maximum individual archive size is 40TB.

---

## Q30) What is VPC?
**Answer:** VPC stands for Virtual Private Cloud. It allows you to create a logically isolated network with customizable IP ranges, subnets, gateways, and security groups.

---

## Q31) What is VPC peering connection?
**Answer:** VPC peering allows you to connect two VPCs, enabling instances to communicate as if they are in the same network.

---

## Q32) What are NAT gateways?
**Answer:** NAT (Network Address Translation) gateways allow instances in a private subnet to connect to the internet but prevent unsolicited inbound connections.

---

## Q33) How can you control security in your VPC?
**Answer:** Security can be controlled using:
- Security groups
- NACL (Network Access Control List)

---

## Q34) What are the types of storage gateway?
**Answer:** Storage gateway types:
- File gateway
- Volume gateway
- Tape gateway

---

## Q35) What is a snowball?
**Answer:** Snowball is a data transport solution that uses physical appliances to transfer large amounts of data into and out of AWS securely.

---

## Q36) What are the database types in RDS?
**Answer:** RDS database types:
- Aurora
- Oracle
- MySQL
- PostgreSQL
- MariaDB
- SQL Server

---

## Q37) What is Redshift?
**Answer:** Redshift is a fully managed, petabyte-scale data warehouse service.

---

## Q38) What is SNS?
**Answer:** SNS stands for Simple Notification Service. It is used to send notifications via email or message.

---

## Q39) What are the routing policies in Route 53?
**Answer:** Routing policies:
- Simple routing
- Latency routing
- Failover routing
- Geolocation routing
- Weighted routing
- Multivalue answer

---

## Q40) What is the maximum message size in SQS?
**Answer:** The maximum message size is 256 KB.

---

## Q41) What are the types of queues in SQS?
**Answer:** Queue types:
- Standard queue
- FIFO (First In First Out) queue

---

## Q42) What is multi-AZ RDS?
**Answer:** Multi-AZ RDS maintains a standby replica in another availability zone for disaster recovery.

---

## Q43) What are the types of backups in RDS?
**Answer:** Backup types:
- Automated backups
- Manual snapshots

---

## Q44) What is the difference between security groups and network ACL?
**Answer:**

| Security Groups                          | Network ACL                           |
|------------------------------------------|---------------------------------------|
| Operate at instance level                | Operate at subnet level               |
| Support allow rules only                 | Support allow and deny rules          |
| Stateful filtering                       | Stateless filtering                   |
| Unlimited security groups per instance   | Up to 5 security groups per instance  |

---

## Q45) What are the types of load balancers in EC2?
**Answer:** Load balancer types:
- Application load balancer
- Network load balancer
- Classic load balancer

---

## Q46) What is an ELB?
**Answer:** ELB stands for Elastic Load Balancing. It automatically distributes incoming traffic across multiple targets.

---

## Q47) What are the two types of access when creating users?
**Answer:** Access types:
- Programmatic access
- Console access

---

## Q48) What are the benefits of auto-scaling?
**Answer:** Benefits:
- Better fault tolerance
- Better availability
- Better cost management

---

## Q49) What are security groups?
**Answer:** Security groups act as a firewall for instances, controlling inbound and outbound traffic.

---

## Q50) What are shared AMIs?
**Answer:** Shared AMIs are machine images created by other developers and made available for use.

---

## Q51) What is the difference between classic load balancer and application load balancer?
**Answer:** Application load balancer supports dynamic port mapping and multiple listeners, while classic load balancer uses one port per listener.

---

## Q52) How many IP addresses does AWS reserve in a subnet by default?
**Answer:** 5 IP addresses.

---

## Q53) What is meant by subnet?
**Answer:** A subnet is a segmented segment of a larger IP network.

---

## Q54) How can you convert a public subnet to a private subnet?
**Answer:** Remove the internet gateway (IGW) and add a NAT gateway. Associate the subnet with a private route table.

---

## Q55) Is it possible to reduce an EBS volume?
**Answer:** No, EBS volumes can be increased but not reduced.

---

## Q56) What is the use of elastic IP? Are they charged by AWS?
**Answer:** Elastic IPs are static IPv4 addresses used for internet-facing instances. They are charged if not attached to a running instance.

---

## Q57) How can I restore a deleted S3 bucket?
**Answer:** If versioning was enabled, the bucket can be restored.

---

## Q58) What should I do if I get a "service limit exceeded" error when launching an EC2 instance?
**Answer:** Contact AWS support to increase the service limit.

---

## Q59) How can I modify EBS volumes in Linux and Windows?
**Answer:** Use the console to modify volumes. For Windows, use disk management; for Linux, mount the volume.

---

## Q60) Is it possible to stop an RDS instance?
**Answer:** Yes, for non-production and non-multi-AZ instances.

---

## Q61) What are parameter groups in RDS?
**Answer:** Parameter groups are collections of settings that define database behavior.

---

## Q62) What is the use of tags?
**Answer:** Tags are used for identifying and grouping AWS resources.

---

## Q63) How can I rectify an IAM error when launching an instance?
**Answer:** Ensure the IAM user has the necessary permissions to launch instances.

---

## Q64) How can I avoid exposing my AWS account ID to users?
**Answer:** Use the IAM console to create a custom sign-in URL.

---

## Q65) How many elastic IP addresses does AWS offer by default?
**Answer:** 5 elastic IPs per region.

---

## Q66) What does sticky session do in ELB?
**Answer:** It binds a user session to a specific instance.

---

## Q67) Which load balancer makes routing decisions at the transport or application layer?
**Answer:** Classic load balancer.

---

## Q68) What is an elastic network interface?
**Answer:** It is a virtual network interface that can be attached to an instance in a VPC.

---

## Q69) Why select SSH in a security group for a Linux instance?
**Answer:** To allow secure shell access from your computer to the instance.

---

## Q70) How are security group changes applied to Windows instances?
**Answer:** Changes are automatically applied.

---

## Q71) Which cloud service do load balancer and DNS service fall under?
**Answer:** IaaS (Infrastructure as a Service).

---

## Q72) How can I create an encrypted volume from an unencrypted volume?
**Answer:** Create a snapshot of the unencrypted volume with encryption enabled, then create a volume from the encrypted snapshot.

---

## Q73) Where do you specify the maximum number of instances in auto-scaling?
**Answer:** In the auto-scaling launch configuration.

---

## Q74) What are the types of AMI provided by AWS?
**Answer:** Types include:
- Instance store backed
- EBS backed

---

## Q75) How can you ensure user requests are always attached to a single instance in ELB?
**Answer:** Use sticky sessions.

---

## Q76) When should you use provisioned IOPS over standard RDS storage?
**Answer:** For batch-oriented workloads requiring high I/O performance.

---

## Q77) Can the standby DB instance in multi-AZ be used for read/write operations?
**Answer:** No, the standby is for failover only.

---

## Q78) Which service is used for near real-time e-commerce data analysis?
**Answer:** Amazon DynamoDB.

---

## Q79) What configuration provides high availability for a two-tier web application with complex queries?
**Answer:** Use Amazon DynamoDB.

---

## Q80) What are suitable use cases for DynamoDB?
**Answer:** Storing metadata for S3 objects and running relational joins.

---

## Q81) How can you optimize cost for an application retrieving data every 5 minutes?
**Answer:** Use Amazon ElastiCache to reduce read throughput.

---

## Q82) How can you resolve read contention on RDS MySQL?
**Answer:** Deploy ElastiCache, increase instance size, and implement provisioned IOPS.

---

## Q83) How would you store data from 100K sensors for 2 years?
**Answer:** Use a 6-node Redshift cluster with 96TB storage.

---

## Q84) Which service is best for rendering images and general computing?
**Answer:** Application Load Balancer.

---

## Q85) How do you change the instance type for instances in an auto-scaling group?
**Answer:** Update the auto-scaling launch configuration.

---

## Q86) How can you reduce load on an EC2 instance at 100% CPU utilization?
**Answer:** Create a load balancer and register the instance with it.

---

## Q87) What does connection draining do?
**Answer:** It re-routes traffic from instances being updated or failing health checks.

---

## Q88) Which service terminates and replaces unhealthy instances?
**Answer:** Auto-scaling.

---

## Q89) What are lifecycle hooks used for in auto-scaling?
**Answer:** To add wait time during scale-in or scale-out events.

---

## Q90) What happens if an auto-scaling group fails to launch an instance for 24 hours?
**Answer:** Auto-scaling suspends the scaling process.

---

## Q91) How are security group rule changes applied?
**Answer:** Immediately to all instances in the security group.

---

## Q92) Which AWS resource does not need to be recreated in another region for disaster recovery?
**Answer:** Route 53 record sets.

---

## Q93) How can you capture client connection information from load balancers every 5 minutes?
**Answer:** Enable AWS CloudTrail for the load balancers.

---

## Q94) Which service would you not use to deploy an app?
**Answer:** Lambda (used for running code, not deploying apps).

---

## Q95) How does Elastic Beanstalk apply updates?
**Answer:** By creating a duplicate environment with updates before swapping.

---

## Q96) Why can't I use a key created in one region to encrypt an object in another region?
**Answer:** Keys are region-specific. Use a key in the same region as the resource.

---

## Q97) How can you monitor read/write IOPS for RDS and send alerts?
**Answer:** Use Amazon CloudWatch.

---

## Q98) How can you ensure all AWS accounts are billed to a single account?
**Answer:** Use AWS Organizations to invite all accounts to join.

---

## Q99) What is the best practice for securing DynamoDB access from an EC2 instance?
**Answer:** Attach an IAM role with DynamoDB access to the EC2 instance.

---

## Q100) How can an application securely access S3 using AWS credentials?
**Answer:** Create an IAM role for the EC2 instance with S3 access permissions.

---

## Q101) How can you create a CloudWatch alarm for 500 errors?
**Answer:** Create a CloudWatch Logs group, define metric filters for 500 errors, set an alarm, and use SNS for notifications.

---

## Q102) What is the most cost-effective architecture for a multi-platform web application?
**Answer:** Use multiple ELBs, one for each platform type, with session stickiness and SSL termination.

---

## Q103) How can you migrate a legacy client-server application to AWS with high availability?
**Answer:** Use ELB with TCP listener and proxy protocol enabled.

---

## Q104) How can you prepare for a 20x traffic increase over 4 weeks?
**Answer:** Check service limits in Trusted Advisor and adjust as necessary.

---

## Q105) How can you ensure high availability for a critical application?
**Answer:** Deploy instances across multiple availability zones and use an ELB.

---

## Q106) How can you encrypt protected health information in transit and at rest?
**Answer:** Use SSL termination on load balancers, SSL listeners on instances, EBS encryption, and S3 server-side encryption.

---

## Q107) How can you ensure load-testing requests are evenly distributed?
**Answer:** Reconfigure the load-testing software to re-resolve DNS for each request.

---

## Q108) What is the most cost-effective way to use different instance types with ELB?
**Answer:** Use separate ELBs for each instance type and distribute load using Route 53 weighted round-robin.

---

## Q109) How can you ensure sensitive data access is authenticated by a central system?
**Answer:** Have the web application authenticate users and provision STS tokens for direct S3 access.

---

## Q110) How can you make Microsoft Active Directory highly available on AWS?
**Answer:** Use a VPC with resilient hardware IPSEC tunnels and deploy domain controllers in different subnets/AZs.

---

## Q111) What is cloud computing?
**Answer:** Cloud computing provides on-demand access to computing resources over the internet without direct management.

---

## Q112) Why use cloud computing?
**Answer:** Benefits include lower cost, improved performance, no IT maintenance, business connectivity, easy upgrades, and device independence.

---

## Q113) What are the deployment models in cloud computing?
**Answer:** Models include:
- Private cloud
- Public cloud
- Hybrid cloud
- Community cloud

---

## Q114) Explain cloud service models.
**Answer:**
- SaaS (Software as a Service): Software hosted and managed by a vendor (e.g., Google Drive).
- PaaS (Platform as a Service): Platform for developers to build applications (e.g., AWS Elastic Beanstalk).
- IaaS (Infrastructure as a Service): Virtualized computing resources (e.g., AWS EC2).

---

## Q115) What are the advantages of cloud computing?
**Answer:** Advantages include pay-per-use, scalability, elasticity, high availability, speed, agility, and global reach.

---

## Q116) What is AWS?
**Answer:** AWS is a secure cloud services platform offering compute power, database storage, content delivery, and other functionalities.

---

## Q117) What is a region, availability zone, and edge location?
**Answer:**
- Region: A geographic area with multiple availability zones.
- Availability zone: A data center within a region.
- Edge location: A CDN endpoint for low-latency content delivery.

---

## Q118) How can you access AWS?
**Answer:** Via AWS Console, CLI, or SDK.

---

## Q119) What is EC2 and its benefits?
**Answer:** EC2 provides resizable compute capacity. Benefits include ease of use, elasticity, high availability, and cost-effectiveness.

---

## Q120) What are the EC2 pricing models?
**Answer:** On-demand, reserved, spot, and dedicated host.

---

## Q121) What are the EC2 instance types?
**Answer:** General purpose, compute optimized, memory optimized, storage optimized, and accelerated computing.

---

## Q122) What is an AMI and its types?
**Answer:** AMI is a template for launching instances. Types include AWS-published, marketplace, custom, and uploaded.

---

## Q123) How is addressing done for EC2 instances?
**Answer:** Via public DNS, public IP, or elastic IP.

---

## Q124) What is a security group?
**Answer:** A virtual firewall controlling inbound and outbound traffic for instances.

---

## Q125) When does an instance show a retired state?
**Answer:** When a reserved instance reservation period ends.

---

## Q126) Why does my EC2 instance IP change on stop/start?
**Answer:** Public IPs are dynamic. Use an elastic IP for a static address.

---

## Q127) What is Elastic Beanstalk?
**Answer:** A service for deploying and managing applications without managing infrastructure.

---

## Q128) What is Amazon Lightsail?
**Answer:** A service for launching and managing virtual private servers with simplified pricing.

---

## Q129) What is EBS?
**Answer:** Elastic Block Store provides persistent block-level storage for EC2 instances.

---

## Q130) How do EBS volumes compare?
**Answer:**
- Magnetic: Lowest performance, 1 GB–1 TB, 100 IOPS.
- General-purpose SSD: 1 GB–16 TB, up to 10,000 IOPS.
- Provisioned IOPS SSD: 4 GB–16 TB, up to 20,000 IOPS.

---

## Q131) What are cold HDD and throughput-optimized HDD?
**Answer:**
- Cold HDD: For less frequent access, 500 GB–16 TB, 250 MB throughput.
- Throughput-optimized HDD: For frequent access, 500 GB–16 TB, 500 MB throughput.

---

## Q132) What is an EBS-optimized instance?
**Answer:** An instance configured for better EBS performance with dedicated capacity.

---

## Q133) What is an EBS snapshot?
**Answer:** A point-in-time backup of an EBS volume.

---

## Q134) Can an EBS volume be attached to multiple instances?
**Answer:** No, but multiple volumes can be attached to a single instance.

---

## Q135) What virtualization types are available in AWS?
**Answer:** Hardware-assisted virtualization (HVM) and para-virtualization (PV).

---

## Q136) Differentiate block storage and file storage.
**Answer:**
- Block storage: Manages data as fixed-size blocks.
- File storage: Manages data as files and folders.

---

## Q137) What are the advantages and disadvantages of EFS?
**Answer:**
- Advantages: Fully managed, scalable, multi-AZ.
- Disadvantages: Not available in all regions, no cross-region replication.

---

## Q138) What should you remember when creating an S3 bucket?
**Answer:** Bucket names must be globally unique, can contain up to 63 characters, and you can have up to 100 buckets per account.

---

## Q139) What are the S3 storage classes?
**Answer:** Standard, standard-IA, one-zone-IA, glacier, RRS.

---

## Q140) Explain S3 lifecycle rules.
**Answer:** Rules automate transitioning data between storage classes or deleting it after a period.

---

## Q141) How are S3 and KMS related?
**Answer:** KMS is used for server-side encryption of S3 data.

---

## Q142) What is cross-region replication in S3?
**Answer:** It asynchronously replicates objects to a bucket in another region.

---

## Q143) How do you create an encrypted EBS volume?
**Answer:** Select the encryption option during volume creation.

---

## Q144) Explain stateful and stateless firewalls.
**Answer:**
- Stateful: Tracks connection state (e.g., security groups).
- Stateless: Does not track state (e.g., NACL).

---

## Q145) What is a NAT instance and NAT gateway?
**Answer:**
- NAT instance: An EC2 instance for NAT.
- NAT gateway: A managed NAT service.

---

## Q146) What is VPC peering?
**Answer:** A connection between two VPCs enabling private communication.

---

## Q147) What is MFA in AWS?
**Answer:** Multi-factor authentication adds an extra layer of security.

---

## Q148) What are the authentication methods in AWS?
**Answer:** Username/password, access key, and access key/session token.

---

## Q149) What is a data warehouse in AWS?
**Answer:** A central repository for data from multiple sources, used for reporting and complex queries.

---

## Q150) What is multi-AZ in RDS?
**Answer:** A deployment with a standby replica in another AZ for failover.

---

## Q151) What is DynamoDB?
**Answer:** A fully managed NoSQL database service.

---

## Q152) What is CloudFormation?
**Answer:** A service for creating and managing AWS infrastructure using code.

---

## Q153) How do you plan auto-scaling?
**Answer:** Via manual, scheduled, or dynamic scaling.

---

## Q154) What is an auto-scaling group?
**Answer:** A collection of EC2 instances managed by auto-scaling.

---

## Q155) Differentiate basic and detailed monitoring in CloudWatch.
**Answer:**
- Basic: Data every 5 minutes.
- Detailed: Data every minute for a fee.

---

## Q156) What is the relationship between Route 53 and CloudFront?
**Answer:** Route 53 can route traffic to CloudFront distributions.

---

## Q157) What are the Route 53 routing policies?
**Answer:** Simple, weighted, latency-based, failover, geolocation.

---

## Q158) What is ElastiCache?
**Answer:** A service for managing in-memory caching environments.

---

## Q159) What are SES, SQS, and SNS?
**Answer:**
- SES: Simple Email Service for sending emails.
- SQS: Simple Queue Service for message queuing.
- SNS: Simple Notification Service for notifications.

---

## Q160) How to use Amazon SQS?
**Answer:** Use SQS to decouple and scale microservices, distributed systems, and serverless applications.

---

## Q161) What is the importance of buffer in AWS?
**Answer:** Buffers help manage load and synchronize components, improving fault tolerance.

---

## Q162) How can you secure data in the cloud?
**Answer:** Avoid storing sensitive data, use encryption, strong passwords, and encrypted cloud services.

---

## Q163) Name the layers of cloud computing.
**Answer:** SaaS, PaaS, IaaS.

---

## Q164) What is Lambda Edge?
**Answer:** A service for running Lambda functions at CloudFront edge locations.

---

## Q165) Distinguish between scalability and flexibility.
**Answer:**
- Scalability: Ability to handle increased load.
- Flexibility: Ability to adapt to changing requirements.

---

## Q166) What is IaaS?
**Answer:** Infrastructure as a Service provides virtualized computing resources.

---

## Q167) What is PaaS?
**Answer:** Platform as a Service provides a platform for developing and managing applications.

---

## Q168) What is SaaS?
**Answer:** Software as a Service provides software applications over the internet.

---

## Q169) Which automation tools can help with spin-up services?
**Answer:** AWS CLI, SDK, CloudFormation, and third-party tools like Terraform.

---

## Q170) What is an AMI? How do I build one?
**Answer:** An AMI is a template for launching instances. Create one by configuring an instance and creating an image via the AWS console.

---

## Q171) What are the features of CloudFront?
**Answer:** Low-latency content delivery via a global network of edge locations.

---

## Q172) What are the features of EC2?
**Answer:** Resizable compute capacity, secure, and scalable.

---

## Q173) Explain storage for EC2 instances.
**Answer:** Instance store (ephemeral) and EBS (persistent) storage.

---

## Q174) Which components provide connectivity with external networks in a VPC?
**Answer:** Internet gateway (IGW) and virtual private gateway (VGW).

---

## Q175) What are the characteristics of VPC subnets?
**Answer:** Each subnet is in one AZ, and by default, subnets can route between each other.

---

## Q176) How can you send requests to S3?
**Answer:** Via authenticated or anonymous requests using REST API or SDK.

---

## Q177) What is the best approach to secure data in the cloud?
**Answer:** Use encryption, avoid sensitive data, strong passwords, and regular backups.

---

## Q178) What is AWS Certificate Manager?
**Answer:** A service for provisioning and managing SSL/TLS certificates.

---

## Q179) What is AWS KMS?
**Answer:** Key Management Service for creating and managing encryption keys.

---

## Q180) What is Amazon EMR?
**Answer:** Elastic MapReduce for processing big data using Hadoop.

---

## Q181) What is Amazon Kinesis Firehose?
**Answer:** A service for loading streaming data into data stores.

---

## Q182) What is Amazon CloudSearch?
**Answer:** A service for adding search functionality to applications.

---

## Q183) Can an EC2 classic instance become part of a VPC?
**Answer:** Yes, by migrating to a VPC.

---

## Q184) What is the work of a VPC router?
**Answer:** It routes traffic between subnets and to gateways.

---

## Q185) How can you connect a VPC to a corporate data center?
**Answer:** Use AWS Direct Connect for a dedicated network connection.

---

## Q186) Can you access S3 from EC2 instances?
**Answer:** Yes, via the internet or VPC endpoints.

---

## Q187) What is the difference between S3 and EBS?
**Answer:** S3 is object storage for files, EBS is block storage for instances.

---

## Q188) What do you understand by AWS?
**Answer:** AWS is a cloud platform offering computing, storage, database, and other services.

---

## Q189) Explain the main elements of AWS.
**Answer:** Key services include EC2, S3, Route 53, IAM, and CloudWatch.

---

## Q190) What is an AMI? What does it include?
**Answer:** An AMI includes a template for launching instances with software, permissions, and storage mapping.

---

## Q191) Is vertical scaling possible on Amazon instances?
**Answer:** Yes, by changing the instance type.

---

## Q192) What is the relationship between AMI and instance?
**Answer:** An AMI is used to launch instances.

---

## Q193) What is the difference between S3 and EC2?
**Answer:** S3 is for storage, EC2 is for compute.

---

## Q194) How many storage options are there for EC2 instances?
**Answer:** Four: EBS, instance store, S3, and added storage.

---

## Q195) What are security best practices for EC2 instances?
**Answer:** Use least privilege, configuration management, and controlled access.

---

## Q196) Explain the features of EC2 services.
**Answer:** Virtual environments, persistent storage, firewall, templates, and static IPs.

---

## Q197) How to send a request to S3?
**Answer:** Via REST API or SDK wrapper libraries.

---

## Q198) What is the default number of buckets in AWS?
**Answer:** 100 buckets per account.

---

## Q199) What is the purpose of T2 instances?
**Answer:** For moderate performance with burstable CPU.

---

## Q200) What is the use of buffer in AWS?
**Answer:** To manage load and synchronize components.

---

## Q201) What happens when an EC2 instance is stopped or terminated?
**Answer:** Stopped: EBS volumes remain. Terminated: EBS volumes are deleted unless configured otherwise.

---

## Q202) What are popular DevOps tools?
**Answer:** Jenkins, Git, Nagios, Selenium, Docker, Puppet, Chef, Ansible.

---

## Q203) What is the difference between IAM roles and policies?
**Answer:** Roles are for services, policies are for users and groups.

---

## Q204) What are the default services in a custom VPC?
**Answer:** Route table, network ACL, security group.

---

## Q205) What is the difference between public and private subnet?
**Answer:** Public subnet has an internet gateway, private subnet does not.

---

## Q206) How can you access an EC2 instance in a private subnet?
**Answer:** Via VPN or a bastion host.

---

## Q207) How can you update a MySQL database in a private subnet?
**Answer:** Use a NAT gateway or instance.

---

## Q208) What is the difference between security groups and NACL?
**Answer:** Security groups are stateful and instance-level, NACL are stateless and subnet-level.

---

## Q209) What is the difference between Route 53 and ELB?
**Answer:** Route 53 is DNS, ELB is load balancing.

---

## Q210) What database engines can be used in RDS?
**Answer:** MySQL, PostgreSQL, MariaDB, Oracle, SQL Server, Aurora.

---

## Q211) What are status checks in EC2?
**Answer:** System status checks (AWS-side) and instance status checks (customer-side).

---

## Q212) What is required for VPC peering?
**Answer:** Non-overlapping CIDR blocks.

---

## Q213) How to troubleshoot EC2 instances?
**Answer:** Check instance states and logs.

---

## Q214) How can EC2 instances be resized?
**Answer:** By changing the instance type.

---

## Q215) What is EBS?
**Answer:** Block-level storage for EC2 instances.

---

## Q216) What is the difference between EBS, EFS, and S3?
**Answer:** EBS is for one instance, EFS is for multiple instances, S3 is for object storage.

---

## Q217) What is the maximum number of buckets in AWS?
**Answer:** 100 by default, more on request.

---

## Q218) What is the maximum number of EC2 instances in a VPC?
**Answer:** 20 by default, more on request.

---

## Q219) How can EBS be accessed?
**Answer:** By attaching to an EC2 instance.

---

## Q220) What is the process to mount EBS to an EC2 instance?
**Answer:** Use `mkfs`, `fdisk`, `mkdir`, and `mount` commands.

---

## Q221) How to add volume permanently to an instance?
**Answer:** Edit `/etc/fstab` file.

---

## Q222) What is the difference between service role and SAML federated role?
**Answer:** Service roles are for AWS services, federated roles are for user access.

---

## Q223) How many policies can be attached to a role?
**Answer:** 10 (soft limit), up to 20.

---

## Q224) What are the ways to access AWS?
**Answer:** Console, CLI, SDK.

---

## Q225) How is root user different from IAM user?
**Answer:** Root user has full access, IAM user has limited permissions.

---

## Q226) What is the principle of least privilege in IAM?
**Answer:** Grant only necessary permissions.

---

## Q227) What is non-explicit deny for an IAM user?
**Answer:** Default deny when no policies are attached.

---

## Q228) What is the precedence between explicit allow and explicit deny?
**Answer:** Explicit deny overrides explicit allow.

---

## Q229) What is the benefit of IAM groups?
**Answer:** Simplify user management by grouping users with similar permissions.

---

## Q230) What is the difference between administrative access and power user access?
**Answer:** Administrative access has full access, power user access excludes IAM management.

---

## Q231) What is the purpose of an identity provider?
**Answer:** To establish trust between AWS and corporate AD.

---

## Q232) What are the benefits of STS?
**Answer:** Temporary credentials, no need to embed keys.

---

## Q233) What is the benefit of AWS Organizations?
**Answer:** Consolidated billing and policy management.

---

## Q234) What is the maximum file length in S3?
**Answer:** 1024 bytes in UTF-8.

---

## Q235) Which activity cannot be done using auto-scaling?
**Answer:** Maintain a fixed number of running instances.

---

## Q236) How will you secure data at rest in EBS?
**Answer:** Use encryption.

---

## Q237) What is the maximum size of an S3 object?
**Answer:** 5TB.

---

## Q238) Can S3 objects be delivered through CloudFront?
**Answer:** Yes.

---

## Q239) Which service distributes content using edge locations?
**Answer:** CloudFront.

---

## Q240) What is ephemeral storage?
**Answer:** Temporary storage.

---

## Q241) What are shards in Kinesis?
**Answer:** Units of capacity for data streams.

---

## Q242) Where can you find ephemeral storage?
**Answer:** In instance store.

---

## Q243) What is it called when you have servers on-premises and some workload on the cloud?
**Answer:** Hybrid cloud.

---

## Q244) Can Route 53 route to infrastructure outside AWS?
**Answer:** True.

---

## Q245) Is Simple Workflow Service a valid SNS subscriber?
**Answer:** No.

---

## Q246) Which cloud model do developers leverage extensively?
**Answer:** IaaS.

---

## Q247) Can CloudFront serve content from a non-AWS origin server?
**Answer:** Yes.

---

## Q248) Is EFS a centralized storage service?
**Answer:** Yes.

---

## Q249) Which service is used for near real-time e-commerce data analysis?
**Answer:** DynamoDB or Redshift.

---

## Q250) Which EBS volume type is recommended for 15,000 IOPS?
**Answer:** Provisioned IOPS.

--- 

This list covers a wide range of AWS topics and is designed to help you prepare for interviews. Good luck!