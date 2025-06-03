

## 1️⃣ EC2 (Elastic Compute Cloud)

### 💡 Key Points

✅ **Purpose:** Scalable, resizable compute capacity (virtual machines).
✅ **Launch Options:**

* **On-Demand:** Pay-as-you-go, flexible.
* **Reserved:** 1-3 year commitment for steady workloads.
* **Spot:** Bid for unused capacity (cheap but interruptible).
* **Dedicated Hosts:** Physical server reserved for compliance/licensing.
* **Dedicated Instances:** Single-tenant hardware but still share host with others.

✅ **Instance Lifecycle:**

1. Choose an **AMI** (OS + software).
2. Choose **instance type** (CPU, memory, network).
3. Configure networking, IAM role, and shutdown behavior.
4. **Add EBS volumes** for root and data storage.
5. Set **tags** for organization.
6. **Configure Security Groups** (allow SSH/HTTP/HTTPS).
7. Launch with a **key pair** (.pem).

✅ **SSH Access:**

* `chmod 400 key.pem`
* `ssh -i key.pem ec2-user@<public-ip>`

✅ **Storage Options:**

* **Instance Store:** Ephemeral, fast, data lost when instance stops/terminates.
* **EBS:** Persistent block storage, supports snapshots, encryption.

✅ **Placement Groups:**

* **Cluster:** Low latency, high throughput (HPC workloads).
* **Spread:** Distributes instances to avoid single point of failure.
* **Partition:** Logical groups with fault isolation.

✅ **Performance:**

* **IOPS:** Input/output per second; best for transactional workloads.
* **Throughput:** MB/s; best for big data, streaming.

✅ **Security:**

* Use **Security Groups** (stateful firewall).
* Use **VPC/Subnets** for network isolation.
* **Key pairs** for secure SSH.

---

## 2️⃣ Lambda (Serverless Compute)

### 💡 Key Points

✅ **Purpose:** Run code **without managing servers**.
✅ **Event-driven:** Triggered by S3, API Gateway, DynamoDB, etc.
✅ **Benefits:**

* Fully managed execution environment.
* Automatic scaling.
* Pay-per-execution.

✅ **Use Cases:**

* Data processing.
* Real-time file processing (e.g., S3 uploads).
* API backends.

✅ **Quotas & Limits:**

| Category              | Value                         |
| --------------------- | ----------------------------- |
| Memory                | 128 MB to 10 GB               |
| CPU                   | 6 vCPUs max                   |
| Execution Timeout     | Up to 15 minutes              |
| Deployment Package    | 50 MB zipped, 250 MB unzipped |
| /tmp Storage          | 512 MB ephemeral              |
| Concurrent Executions | 1000 (soft limit)             |

✅ **Steps to Use Lambda with S3:**

1. Create an S3 bucket.
2. Create Lambda function with an execution role granting S3 access.
3. Add an S3 trigger (e.g., ObjectCreated).
4. Write code to process file (log output, transform data, etc.).
5. Test the function.

✅ **Security:**

* Use IAM roles for least privilege.
* Encrypt data at rest and in transit.

---

## 3️⃣ Containers

### 💡 Key Points

✅ **Docker:**

* Container runtime that uses host OS for lightweight virtualization.
* Faster startup and efficient resource usage compared to VMs.

✅ **Key Components:**

* **Docker Image:** Blueprint with app code + dependencies.
* **Container:** Running instance of an image.
* **Dockerfile:** Instructions to build an image.

✅ **AWS Services:**

* **ECS:** AWS-managed container orchestration (supports EC2 and Fargate).

  * **Cluster:** Group of container instances.
  * **Task Definition:** JSON describing container specs.
  * **Service:** Manages running tasks and scaling.
* **EKS:** Fully managed Kubernetes control plane.
* **ECR:** Private Docker image registry.

✅ **Demo Steps for ECS:**

1. Push Docker image to ECR.
2. Create ECS cluster (EC2 or Fargate).
3. Register a task definition.
4. Create a service to run tasks.
5. Monitor tasks via ECS console and CloudWatch.

✅ **Security:**

* Use IAM roles for ECS tasks.
* Use VPC security groups and private subnets for container isolation.
* Use ECR lifecycle policies to manage image cleanup.

---

## 📝 Important Notes

🔑 **SSH:** Always secure private keys and use `chmod 400` for permissions.
🔒 **Security Groups:** Review inbound/outbound rules regularly.
💾 **EBS Snapshots:** Automate backups to avoid data loss.
📦 **Lambda Limits:** Stay within quotas and consider concurrency limits.
⚡ **Container Networking:** Choose VPC and subnet design carefully for performance and security.
📊 **Monitor:** Use CloudWatch for logs, metrics, and alarms for all services.

---

## 🛠️ Tips

✅ Always tag resources for cost allocation and management.
✅ Use IAM roles instead of long-lived access keys.
✅ Use auto-scaling groups for EC2 and ECS services to handle traffic spikes.
✅ Leverage Placement Groups to meet performance needs.
✅ Automate everything using CloudFormation/Terraform for reproducibility.

---

## 📚 Summary

✅ **EC2:** VMs with flexible storage and network options.
✅ **Lambda:** Serverless compute with event-driven triggers.
✅ **Containers:** Lightweight, portable app environments using Docker/ECS/EKS.

