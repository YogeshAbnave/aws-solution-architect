# AWS Networking Solutions: Complete Step-by-Step Guide

## 1. Creating a VPC Foundation

**Problem:** Need to establish a network foundation for cloud resources within an AWS Region.

**Solution Steps:**

### Step 1: Create VPC via Console
1. Navigate to **VPC Dashboard** → **Your VPCs** → **Create VPC**
2. Select **VPC only**
3. Configure:
   - **Name tag:** MyVPC
   - **IPv4 CIDR block:** 10.0.0.0/16 (provides 65,536 IP addresses)
   - **IPv6 CIDR block:** No IPv6 CIDR block (or select Amazon-provided if needed)
   - **Tenancy:** Default
4. Click **Create VPC**

### Step 2: Create VPC via CLI
```bash
aws ec2 create-vpc --cidr-block 10.0.0.0/16 --tag-specifications 'ResourceType=vpc,Tags=[{Key=Name,Value=MyVPC}]'

# For IPv6 support:
aws ec2 create-vpc --cidr-block 10.0.0.0/16 --amazon-provided-ipv6-cidr-block --tag-specifications 'ResourceType=vpc,Tags=[{Key=Name,Value=MyVPC}]'
```

### Step 3: Add Additional IPv4 CIDR Blocks (Optional)
```bash
aws ec2 associate-vpc-cidr-block --vpc-id vpc-12345678 --cidr-block 10.1.0.0/16
```

---

## 2. Creating Subnets and Route Tables

**Problem:** Need segmentation and redundancy within a VPC with distinct network layouts.

**Solution Steps:**

### Step 1: Create Route Table
1. Go to **VPC Dashboard** → **Route Tables** → **Create route table**
2. Configure:
   - **Name:** MyRouteTable
   - **VPC:** Select your VPC
3. Click **Create route table**

### Step 2: Create Subnets in Different AZs
1. Go to **VPC Dashboard** → **Subnets** → **Create subnet**
2. **Subnet 1:**
   - **VPC ID:** Select your VPC
   - **Subnet name:** PublicSubnet-AZ1
   - **Availability Zone:** us-east-1a
   - **IPv4 CIDR block:** 10.0.1.0/24 (251 usable IPs)
3. **Subnet 2:**
   - **Subnet name:** PublicSubnet-AZ2
   - **Availability Zone:** us-east-1b
   - **IPv4 CIDR block:** 10.0.2.0/24

### Step 3: Associate Subnets with Route Table
1. Select **Route Table** → **Subnet associations** tab
2. Click **Edit subnet associations**
3. Select both subnets → **Save associations**

### CLI Commands:
```bash
# Create route table
aws ec2 create-route-table --vpc-id vpc-12345678 --tag-specifications 'ResourceType=route-table,Tags=[{Key=Name,Value=MyRouteTable}]'

# Create subnets
aws ec2 create-subnet --vpc-id vpc-12345678 --cidr-block 10.0.1.0/24 --availability-zone us-east-1a
aws ec2 create-subnet --vpc-id vpc-12345678 --cidr-block 10.0.2.0/24 --availability-zone us-east-1b

# Associate subnet with route table
aws ec2 associate-route-table --subnet-id subnet-12345678 --route-table-id rtb-12345678
```

---

## 3. Internet Connectivity Setup

**Problem:** EC2 instance within VPC subnet needs Internet Access.

**Solution Steps:**

### Step 1: Create Internet Gateway
1. Go to **VPC Dashboard** → **Internet Gateways** → **Create internet gateway**
2. **Name:** MyIGW
3. Click **Create internet gateway**
4. Select the IGW → **Actions** → **Attach to VPC**
5. Select your VPC → **Attach internet gateway**

### Step 2: Update Route Table
1. Go to **Route Tables** → Select your public route table
2. **Routes** tab → **Edit routes**
3. **Add route:**
   - **Destination:** 0.0.0.0/0
   - **Target:** Internet Gateway (select MyIGW)
4. **Save changes**

### Step 3: Create and Associate Elastic IP
1. Go to **EC2 Dashboard** → **Elastic IPs** → **Allocate Elastic IP address**
2. **Public IPv4 address pool:** Amazon's pool of IPv4 addresses
3. Click **Allocate**
4. Select the EIP → **Actions** → **Associate Elastic IP address**
5. Select your EC2 instance → **Associate**

### Step 4: Validate Connectivity
1. Use **Systems Manager Session Manager** to connect to instance
2. Run: `ping google.com`
3. Check public IP: `curl http://169.254.169.254/latest/meta-data/public-ipv4`

### CLI Commands:
```bash
# Create IGW
aws ec2 create-internet-gateway --tag-specifications 'ResourceType=internet-gateway,Tags=[{Key=Name,Value=MyIGW}]'

# Attach IGW to VPC
aws ec2 attach-internet-gateway --internet-gateway-id igw-12345678 --vpc-id vpc-12345678

# Add route to route table
aws ec2 create-route --route-table-id rtb-12345678 --destination-cidr-block 0.0.0.0/0 --gateway-id igw-12345678

# Allocate and associate EIP
aws ec2 allocate-address --domain vpc
aws ec2 associate-address --instance-id i-12345678 --allocation-id eipalloc-12345678
```

---

## 4. NAT Gateway for Private Subnet Outbound Access

**Problem:** EC2 instance in private subnet needs outbound Internet access only (not inbound).

**Solution Steps:**

### Step 1: Create NAT Gateway
1. Go to **VPC Dashboard** → **NAT Gateways** → **Create NAT gateway**
2. Configure:
   - **Name:** MyNATGateway
   - **Subnet:** Select public subnet
   - **Connectivity type:** Public
   - **Elastic IP allocation ID:** Create new EIP or select existing
3. Click **Create NAT gateway**

### Step 2: Create Private Route Table
1. **Route Tables** → **Create route table**
2. **Name:** PrivateRouteTable
3. Select your VPC → **Create route table**

### Step 3: Update Private Route Table
1. Select **PrivateRouteTable** → **Routes** tab → **Edit routes**
2. **Add route:**
   - **Destination:** 0.0.0.0/0
   - **Target:** NAT Gateway (select MyNATGateway)
3. **Save changes**

### Step 4: Create Private Subnet and Associate
1. **Subnets** → **Create subnet**
2. Configure:
   - **Subnet name:** PrivateSubnet-AZ1
   - **Availability Zone:** us-east-1a
   - **IPv4 CIDR block:** 10.0.3.0/24
3. Associate with PrivateRouteTable

### CLI Commands:
```bash
# Allocate EIP for NAT Gateway
aws ec2 allocate-address --domain vpc

# Create NAT Gateway
aws ec2 create-nat-gateway --subnet-id subnet-12345678 --allocation-id eipalloc-12345678

# Create private route table
aws ec2 create-route-table --vpc-id vpc-12345678 --tag-specifications 'ResourceType=route-table,Tags=[{Key=Name,Value=PrivateRouteTable}]'

# Add route to NAT Gateway
aws ec2 create-route --route-table-id rtb-87654321 --destination-cidr-block 0.0.0.0/0 --nat-gateway-id nat-12345678
```

---

## 5. Security Groups with Self-Referencing Rules

**Problem:** Group of EC2 instances needs to communicate with each other (SSH on port 22), with new instances automatically gaining access.

**Solution Steps:**

### Step 1: Create Security Group
1. Go to **EC2 Dashboard** → **Security Groups** → **Create security group**
2. Configure:
   - **Security group name:** SSH-SelfReference-SG
   - **Description:** Allow SSH between instances in this group
   - **VPC:** Select your VPC

### Step 2: Add Self-Referencing Inbound Rule
1. **Inbound rules** → **Add rule**
2. Configure:
   - **Type:** SSH
   - **Protocol:** TCP
   - **Port range:** 22
   - **Source:** Custom → Select the same security group (SSH-SelfReference-SG)
3. Click **Create security group**

### Step 3: Attach to EC2 Instances
1. Go to **EC2 Dashboard** → **Instances**
2. Select instance → **Actions** → **Security** → **Change security groups**
3. Add **SSH-SelfReference-SG** → **Save**

### Step 4: Validate
1. Use SSM Session Manager to connect to one instance
2. SSH to another instance: `ssh ec2-user@<private-ip-of-other-instance>`

### CLI Commands:
```bash
# Create security group
aws ec2 create-security-group --group-name SSH-SelfReference-SG --description "Allow SSH between instances" --vpc-id vpc-12345678

# Add self-referencing rule
aws ec2 authorize-security-group-ingress --group-id sg-12345678 --protocol tcp --port 22 --source-group sg-12345678

# Attach to instance
aws ec2 modify-instance-attribute --instance-id i-12345678 --groups sg-12345678
```

---

## 6. VPC Reachability Analyzer Troubleshooting

**Problem:** Two EC2 instances in different isolated subnets cannot connect via SSH.

**Solution Steps:**

### Step 1: Run Initial Analysis
1. Go to **VPC Dashboard** → **Reachability Analyzer** → **Create and analyze path**
2. Configure:
   - **Source type:** Instance
   - **Source:** Select Instance-1
   - **Destination type:** Instance
   - **Destination:** Select Instance-2
   - **Protocol:** TCP
   - **Destination port:** 22
3. Click **Create and analyze path**

### Step 2: Review Results
- If **NetworkPathFound: false** with **ExplanationCode: ENI_SG_RULES_MISMATCH**
- This indicates security group rules are blocking the connection

### Step 3: Fix Security Group Rules
1. Go to Instance-2's Security Group
2. **Inbound rules** → **Add rule**
3. Configure:
   - **Type:** SSH
   - **Protocol:** TCP
   - **Port:** 22
   - **Source:** Custom → Select Instance-1's Security Group
4. **Save rules**

### Step 4: Rerun Analysis
1. Return to **Reachability Analyzer**
2. Select your analysis → **Actions** → **Rerun analysis**
3. Result should now show **NetworkPathFound: true**

### CLI Commands:
```bash
# Create reachability analysis
aws ec2 create-network-insights-path --source i-source123 --destination i-dest456 --protocol tcp --destination-port 22

# Start analysis
aws ec2 start-network-insights-analysis --network-insights-path-id nip-12345678

# Check analysis results
aws ec2 describe-network-insights-analyses --network-insights-analysis-ids nia-12345678
```

---

## 7. Application Load Balancer with HTTPS Redirection

**Problem:** Containerized web application in private subnet needs to be publicly available and secure (HTTPS).

**Solution Steps:**

### Step 1: Create Application Load Balancer
1. Go to **EC2 Dashboard** → **Load Balancers** → **Create Load Balancer**
2. Select **Application Load Balancer**
3. Configure:
   - **Name:** MyALB
   - **Scheme:** Internet-facing
   - **VPC:** Select your VPC
   - **Mappings:** Select public subnets from at least 2 AZs

### Step 2: Create Target Group
1. **Target Groups** → **Create target group**
2. Configure:
   - **Target type:** IP addresses (for Fargate)
   - **Target group name:** MyTargetGroup
   - **Protocol:** HTTP
   - **Port:** 80
   - **VPC:** Select your VPC
   - **Health check path:** /

### Step 3: Configure ALB Listeners
1. In ALB creation, **Listeners and routing:**
   - **Listener 1:**
     - **Protocol:** HTTP
     - **Port:** 80
     - **Default actions:** Redirect to HTTPS (443)
   - **Listener 2:**
     - **Protocol:** HTTPS
     - **Port:** 443
     - **Default actions:** Forward to MyTargetGroup
     - **Security certificates:** Select/create ACM certificate

### Step 4: Configure HTTP to HTTPS Redirect
1. After ALB creation, go to **Listeners**
2. Select HTTP:80 listener → **Edit**
3. **Default actions:**
   - **Action type:** Redirect
   - **Protocol:** HTTPS
   - **Port:** 443
   - **Status code:** 301 - Permanently moved

### CLI Commands:
```bash
# Create ALB
aws elbv2 create-load-balancer --name MyALB --subnets subnet-12345678 subnet-87654321 --security-groups sg-12345678

# Create target group
aws elbv2 create-target-group --name MyTargetGroup --protocol HTTP --port 80 --vpc-id vpc-12345678 --target-type ip

# Create HTTPS listener
aws elbv2 create-listener --load-balancer-arn arn:aws:elasticloadbalancing:region:account:loadbalancer/app/MyALB/1234567890abcdef --protocol HTTPS --port 443 --certificates CertificateArn=arn:aws:acm:region:account:certificate/12345678-1234-1234-1234-123456789012 --default-actions Type=forward,TargetGroupArn=arn:aws:elasticloadbalancing:region:account:targetgroup/MyTargetGroup/1234567890abcdef

# Create HTTP redirect listener
aws elbv2 create-listener --load-balancer-arn arn:aws:elasticloadbalancing:region:account:loadbalancer/app/MyALB/1234567890abcdef --protocol HTTP --port 80 --default-actions Type=redirect,RedirectConfig='{Protocol=HTTPS,Port=443,StatusCode=HTTP_301}'
```

---

## 8. Managed Prefix Lists for CIDR Management

**Problem:** Managing multiple CIDR ranges (Workspaces Gateway, Home PC IP) across different security groups.

**Solution Steps:**

### Step 1: Create Managed Prefix List
1. Go to **VPC Dashboard** → **Managed Prefix Lists** → **Create prefix list**
2. Configure:
   - **Name:** WorkspaceAccess-PrefixList
   - **Address family:** IPv4
   - **Maximum entries:** 10
   - **Prefix list entries:**
     - Entry 1: `203.0.113.0/24` (Workspace Gateway CIDR)
     - Entry 2: `198.51.100.5/32` (Home PC IP)

### Step 2: Reference in Security Groups
1. Go to **Security Groups** → Select target security group
2. **Inbound rules** → **Add rule**
3. Configure:
   - **Type:** HTTP/HTTPS/Custom
   - **Source:** Custom → Select your prefix list
4. Repeat for other security groups as needed

### Step 3: Update Prefix List (for temporary access)
1. Go back to **Managed Prefix Lists**
2. Select your prefix list → **Associations** tab
3. **Entries** tab → **Modify entries**
4. Add: `192.0.2.100/32` (temporary Home PC IP)
5. **Save**

### Step 4: Version Management
- View **Versions** tab to see all modifications
- Can restore to previous versions if needed

### CLI Commands:
```bash
# Create prefix list
aws ec2 create-managed-prefix-list --prefix-list-name WorkspaceAccess-PrefixList --address-family IPv4 --max-entries 10 --entries Cidr=203.0.113.0/24,Description="Workspace Gateway" Cidr=198.51.100.5/32,Description="Home PC"

# Use in security group rule
aws ec2 authorize-security-group-ingress --group-id sg-12345678 --ip-permissions IpProtocol=tcp,FromPort=80,ToPort=80,PrefixListIds=[{PrefixListId=pl-12345678}]

# Modify prefix list
aws ec2 modify-managed-prefix-list --prefix-list-id pl-12345678 --add-entries Cidr=192.0.2.100/32,Description="Temporary Home PC"
```

---

## 9. VPC Endpoints for S3 Access

**Problem:** Security concerns about data exfiltration and need to limit VPC resources to access only a specific S3 bucket.

**Solution Steps:**

### Step 1: Create S3 Bucket
1. Go to **S3 Console** → **Create bucket**
2. **Bucket name:** my-secure-bucket-12345
3. Configure security settings → **Create bucket**

### Step 2: Create Gateway VPC Endpoint
1. Go to **VPC Dashboard** → **Endpoints** → **Create endpoint**
2. Configure:
   - **Name:** S3-Gateway-Endpoint
   - **Service category:** AWS services
   - **Service:** com.amazonaws.region.s3 (Gateway)
   - **VPC:** Select your VPC
   - **Route tables:** Select route tables for subnets needing S3 access

### Step 3: Create Custom Policy
1. In endpoint creation, **Policy:** Custom
2. Add policy:
```json
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Principal": "*",
            "Action": [
                "s3:GetObject",
                "s3:PutObject",
                "s3:ListBucket"
            ],
            "Resource": [
                "arn:aws:s3:::my-secure-bucket-12345",
                "arn:aws:s3:::my-secure-bucket-12345/*"
            ]
        }
    ]
}
```

### Step 4: Add S3 Bucket Policy (Optional - Challenge)
1. Go to **S3 Console** → Select bucket → **Permissions** → **Bucket policy**
2. Add policy:
```json
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Deny",
            "Principal": "*",
            "Action": "s3:*",
            "Resource": [
                "arn:aws:s3:::my-secure-bucket-12345",
                "arn:aws:s3:::my-secure-bucket-12345/*"
            ],
            "Condition": {
                "StringNotEquals": {
                    "aws:sourceVpce": "vpce-12345678"
                }
            }
        }
    ]
}
```

### Step 5: Test Access
1. SSH to EC2 instance in private subnet
2. Test: `aws s3 ls s3://my-secure-bucket-12345`
3. Verify no internet gateway is needed

### CLI Commands:
```bash
# Create VPC endpoint
aws ec2 create-vpc-endpoint --vpc-id vpc-12345678 --service-name com.amazonaws.us-east-1.s3 --vpc-endpoint-type Gateway --route-table-ids rtb-12345678 --policy-document file://s3-endpoint-policy.json

# Test S3 access
aws s3 ls s3://my-secure-bucket-12345
```

---

## 10. Transit Gateway for Cross-VPC Connectivity

**Problem:** Connect traffic between all VPCs and share a single NAT Gateway across multiple VPCs for cost savings.

**Solution Steps:**

### Step 1: Create Transit Gateway
1. Go to **VPC Dashboard** → **Transit Gateways** → **Create Transit Gateway**
2. Configure:
   - **Name:** MyTransitGateway
   - **Description:** Hub for multi-VPC connectivity
   - **Amazon side ASN:** 64512 (default)
   - **Auto accept shared attachments:** Enable
   - **Default route table association:** Enable
   - **Default route table propagation:** Enable

### Step 2: Create VPC Attachments
For each VPC:
1. **Transit Gateway Attachments** → **Create Transit Gateway Attachment**
2. Configure:
   - **Name:** VPC1-Attachment
   - **Transit Gateway ID:** Select MyTransitGateway
   - **Attachment type:** VPC
   - **VPC ID:** Select VPC1
   - **Subnets:** Select dedicated attachment subnets (or existing subnets)

### Step 3: Update VPC Route Tables
For each VPC's route table:
1. **Route Tables** → Select VPC route table → **Routes** → **Edit routes**
2. Add routes for other VPCs:
   - **Destination:** 10.1.0.0/16 (other VPC CIDR)
   - **Target:** Transit Gateway

### Step 4: Configure Shared NAT Gateway Route
For VPCs without NAT Gateway:
1. Update their route tables
2. **Add route:**
   - **Destination:** 0.0.0.0/0
   - **Target:** Transit Gateway
3. In Shared Services VPC route table, ensure internet traffic can flow to TGW

### Step 5: Configure TGW Route Table (if using custom routing)
1. **Transit Gateway Route Tables** → Select route table
2. **Routes** → **Create route**
3. Add specific routes for traffic flow control

### CLI Commands:
```bash
# Create Transit Gateway
aws ec2 create-transit-gateway --description "Multi-VPC Hub" --options=AmazonSideAsn=64512,AutoAcceptSharedAttachments=enable,DefaultRouteTableAssociation=enable,DefaultRouteTablePropagation=enable

# Create VPC attachment
aws ec2 create-transit-gateway-vpc-attachment --transit-gateway-id tgw-12345678 --vpc-id vpc-12345678 --subnet-ids subnet-12345678

# Add route to VPC route table
aws ec2 create-route --route-table-id rtb-12345678 --destination-cidr-block 10.1.0.0/16 --transit-gateway-id tgw-12345678

# Add internet route via TGW
aws ec2 create-route --route-table-id rtb-87654321 --destination-cidr-block 0.0.0.0/0 --transit-gateway-id tgw-12345678
```

---

## 11. VPC Peering Connection

**Problem:** Enable network communication between EC2 instances in two separate VPCs in a simple and cost-effective manner.

**Solution Steps:**

### Step 1: Create VPC Peering Connection
1. Go to **VPC Dashboard** → **Peering Connections** → **Create Peering Connection**
2. Configure:
   - **Name:** VPC1-to-VPC2-Peering
   - **VPC (Requester):** Select VPC1
   - **Account:** My account
   - **Region:** This region
   - **VPC (Accepter):** Select VPC2
3. Click **Create Peering Connection**

### Step 2: Accept Peering Connection
1. Select the peering connection
2. **Actions** → **Accept Request**
3. Confirm acceptance

### Step 3: Update Route Tables in VPC1
1. **Route Tables** → Select VPC1's route table
2. **Routes** → **Edit routes** → **Add route**
3. Configure:
   - **Destination:** 10.1.0.0/16 (VPC2's CIDR)
   - **Target:** Peering Connection (select your peering connection)
4. **Save changes**

### Step 4: Update Route Tables in VPC2
1. **Route Tables** → Select VPC2's route table
2. **Routes** → **Edit routes** → **Add route**
3. Configure:
   - **Destination:** 10.0.0.0/16 (VPC1's CIDR)
   - **Target:** Peering Connection (select your peering connection)
4. **Save changes**

### Step 5: Update Security Groups
For both VPCs:
1. **Security Groups** → Select instance security group
2. **Inbound rules** → **Add rule**
3. Configure:
   - **Type:** All ICMP - IPv4 (for ping test)
   - **Source:** Custom → Enter the other VPC's CIDR (e.g., 10.1.0.0/16)
4. **Save rules**

### Step 6: Test Connectivity
1. SSH to instance in VPC1
2. Ping instance in VPC2: `ping <private-ip-of-vpc2-instance>`

### CLI Commands:
```bash
# Create peering connection
aws ec2 create-vpc-peering-connection --vpc-id vpc-12345678 --peer-vpc-id vpc-87654321

# Accept peering connection
aws ec2 accept-vpc-peering-connection --vpc-peering-connection-id pcx-12345678

# Add routes
aws ec2 create-route --route-table-id rtb-12345678 --destination-cidr-block 10.1.0.0/16 --vpc-peering-connection-id pcx-12345678
aws ec2 create-route --route-table-id rtb-87654321 --destination-cidr-block 10.0.0.0/16 --vpc-peering-connection-id pcx-12345678

# Update security group for ICMP
aws ec2 authorize-security-group-ingress --group-id sg-12345678 --protocol icmp --port -1 --cidr 10.1.0.0/16
```

---

## 12. CloudFront Distribution for Global Content Delivery

**Problem:** S3 bucket is being used for static web content, but need fast and secure data loading for global users.

**Solution Steps:**

### Step 1: Prepare S3 Bucket
1. Go to **S3 Console** → **Create bucket**
2. **Bucket name:** my-static-website-content-12345
3. Upload your static web content (HTML, CSS, JS, images)
4. **Properties** → **Static website hosting** → **Enable**
5. **Index document:** index.html

### Step 2: Create Origin Access Identity (OAI)
1. Go to **CloudFront Console** → **Origin Access Identities** → **Create Origin Access Identity**
2. **Comment:** OAI for my-static-website-content
3. **Create**

### Step 3: Create CloudFront Distribution
1. **CloudFront Console** → **Distributions** → **Create Distribution**
2. **Origin Settings:**
   - **Origin Domain:** Select your S3 bucket
   - **Origin Path:** (leave blank)
   - **Origin Access:** Yes use OAI
   - **Origin Access Identity:** Select the OAI created above
   - **Bucket Policy:** Yes, update the bucket policy

### Step 4: Configure Distribution Settings
3. **Default Cache Behavior:**
   - **Path Pattern:** Default (*)
   - **Viewer Protocol Policy:** Redirect HTTP to HTTPS
   - **Allowed HTTP Methods:** GET, HEAD, OPTIONS, PUT, POST, PATCH, DELETE
   - **Cache Policy:** Managed-CachingOptimized

4. **Distribution Settings:**
   - **Price Class:** Use all edge locations (for best performance)
   - **AWS WAF:** None (or configure if needed)
   - **Custom Domain:** (optional - add your domain)
   - **SSL Certificate:** Default CloudFront Certificate or Custom SSL

### Step 5: Update S3 Bucket Policy
CloudFront will automatically update the bucket policy, or manually add:
```json
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Principal": {
                "AWS": "arn:aws:iam::cloudfront:user/CloudFront Origin Access Identity ABCDEFG1234567"
            },
            "Action": "s3:GetObject",
            "Resource": "arn:aws:s3:::my-static-website-content-12345/*"
        }
    ]
}
```

### Step 6: Test and Configure
1. Wait for deployment (Status: Deployed)
2. Test CloudFront URL: `https://d1234567890abc.cloudfront.net`
3. Configure **Custom Error Pages** if needed
4. Set up **Lambda@Edge** for advanced functionality (optional)

### Step 7: Configure Custom Domain (Optional)
1. **Route 53** → **Hosted Zones** → Select your domain
2. **Create Record:**
   - **Record name:** www
   - **Record type:** A
   - **Alias:** Yes
   - **Route traffic to:** Alias to CloudFront distribution
   - **Choose distribution:** Select your CloudFront distribution

### CLI Commands:
```bash
# Create OAI
aws cloudfront create-cloud-front-origin-access-identity --cloud-front-origin-access-identity-config CallerReference=my-oai-$(date +%s),Comment="OAI for static website"

# Create distribution
aws cloudfront create-distribution --distribution-config file://cloudfront-config.json

# Example cloudfront-config.json structure would be quite large - use console for easier setup

# Invalidate cache when content updates
aws cloudfront create-invalidation --distribution-id E1234567890ABC --paths "/*"
```

### Additional Configuration Options:

**Cache Behaviors:**
- Set different cache policies for different content types
- `/api/*` → Origin Request Policy for dynamic content
- `*.jpg` → Long cache duration for images

**Security Headers:**
- Use Response Headers Policy to add security headers
- Configure HSTS, X-Frame-Options, etc.

**Monitoring:**
- CloudWatch metrics for monitoring performance
- CloudTrail for API logging
- AWS WAF for additional security

---

## Best Practices Summary

1. **VPC Design:**
   - Plan CIDR blocks carefully (cannot be changed)
   - Use multiple AZs for redundancy
   - Separate public and private subnets

2. **Security:**
   - Use Security Groups with least privilege
   - Implement Defense in Depth
   - Regular security group audits

3. **Cost Optimization:**
   - Use single NAT Gateway for development
   - Multiple NAT Gateways for production
   - Gateway endpoints are free vs Interface endpoints

4. **Monitoring:**
   - VPC Flow Logs for traffic analysis
   - CloudWatch for metrics
   - VPC Reachability Analyzer for troubleshooting

5. **Scalability:**
   - Use Transit Gateway for complex topologies
   - Managed Prefix Lists for CIDR management
   - CloudFront for global content delivery