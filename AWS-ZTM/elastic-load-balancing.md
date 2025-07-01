
# 📑 Elastic Load Balancing and Auto Scaling in AWS

---

## 1️⃣ What is Elastic Load Balancing?

**Elastic Load Balancing (ELB)** automatically distributes incoming application traffic across multiple targets—like Amazon EC2 instances, containers, and IP addresses—in one or more Availability Zones (AZs).

### 🔍 Key Benefits of ELB:

✅ **Managed Service:** AWS handles the heavy lifting—provisioning, scaling, and managing the load balancer.
✅ **AWS Guarantees Uptime:** Built-in high availability and fault tolerance.
✅ **Single Endpoint Exposure:** Simplifies DNS management, as clients connect via one endpoint.
✅ **Distributes Load:** Balances traffic across multiple instances and AZs.
✅ **Handles Instance Failures:** Health checks ensure traffic is only routed to healthy targets.

---

## 2️⃣ Load Balancer Types in AWS

### 1. **Application Load Balancer (ALB)**

* Best for HTTP/HTTPS traffic.
* Supports path-based and host-based routing, WebSockets, and HTTP/2.
* Example use: Building a web app that routes `/api/*` to backend servers.

### 2. **Network Load Balancer (NLB)**

* Handles TCP/UDP traffic at Layer 4.
* Best for high performance and low latency.
* Example use: Gaming servers or VoIP applications.

### 3. **Gateway Load Balancer (GLB)**

* For deploying third-party virtual appliances (e.g., firewalls, intrusion prevention systems).
* Example use: Inserting security appliances transparently into your network.

### 4. **Classic Load Balancer (CLB)**

* Legacy option for simple load balancing across multiple EC2 instances.

---

## 3️⃣ Example: Setting Up an Application Load Balancer (ALB)

### 🛠️ Steps:

1. **Launch EC2 Instances (Web Servers)**

   * At least two instances in different AZs.

2. **Create a Security Group**

   * Allow HTTP/HTTPS inbound traffic.

3. **Create an ALB**

   * Listener on port 80/443.
   * Configure **Target Group** with EC2 instances.

4. **Health Checks**

   * Default HTTP health check on `/`.

5. **Test Access**

   * Single DNS endpoint provided by ALB (e.g., `my-alb-1234567890.us-east-1.elb.amazonaws.com`).

---

## 4️⃣ Connection Draining vs Deregistration Delay

| **Concept**              | **Description**                                                                             |
| ------------------------ | ------------------------------------------------------------------------------------------- |
| **Connection Draining**  | Gracefully completes in-flight requests before removing an instance from the load balancer. |
| **Deregistration Delay** | AWS term for Connection Draining in ALB/NLB. Default is 300 seconds (5 min). Adjustable.    |

---

## 5️⃣ Load Balancing with TLS/SSL Certificates

* Use AWS Certificate Manager (ACM) to provision and manage SSL/TLS certificates.
* Configure HTTPS listener on ALB.
* Enable **Server Name Indication (SNI)** to host multiple SSL certificates on the same ALB (great for multi-tenant apps).

---

## 6️⃣ Integrating with ECS

### ECS Setup:

* Create an ECS cluster with container instances (using AWS Fargate or EC2).
* Create a **service** with **3 tasks** behind an **ALB**.
* ALB routes traffic to ECS tasks based on target group registration.

### Security Groups:

* One for ALB (allow internet traffic).
* One for ECS instances (allow traffic from ALB).

---

## 7️⃣ Auto Scaling

### 1. **Auto Scaling Groups (ASG) for EC2 Instances**

* Automatically adds/removes EC2 instances based on demand.
* Benefits:

  * **Replace unhealthy instances automatically.**
  * **Run at optimal capacity (cost saving).**

### 2. **Auto Scaling ECS Services**

* ECS **Service Auto Scaling**: Adjusts the number of tasks based on CPU/Memory utilization or custom metrics.
* ECS **Cluster Auto Scaling**: Adjusts the number of container instances in the ECS cluster.

---

## 8️⃣ Scaling Policies

| **Policy Type**        | **Description**                                                              |
| ---------------------- | ---------------------------------------------------------------------------- |
| **Dynamic Scaling**    | Automatically adjusts capacity based on real-time metrics (e.g., CPU > 70%). |
| **Predictive Scaling** | Uses ML to anticipate traffic patterns and scale in advance.                 |
| **Scheduled Scaling**  | Predefined schedules (e.g., scale up at 9 AM, down at 5 PM).                 |

---

## 9️⃣ Target Tracking Policies

* Maintain a **target utilization** (e.g., CPU at 50%).
* Automatically scales up or down to maintain the target.

---

## 🔟 Warm-up and Cooldown Periods

* **Warm-up Period:** Time taken for new instances to become ready and start serving traffic.
* **Cooldown Period:** Time between scale-in/out events to prevent rapid oscillation.

---

## 1️⃣1️⃣ ECS Scaling Example

### Scenario:

* You want to scale ECS tasks based on **average CPU utilization**:

  * Scale-out if CPU > 70%.
  * Scale-in if CPU < 30%.

**Steps:**

1. Create **CloudWatch Alarms** for CPU thresholds.
2. Link alarms to ECS Service Auto Scaling.
3. Configure warm-up time (\~60 seconds) to ensure tasks are fully started before traffic is routed.

---

## 1️⃣2️⃣ Database Auto Scaling

* **Relational Database (RDS):**

  * Supports **Read Replicas** for read scaling.
  * Aurora Serverless supports autoscaling compute capacity.

* **DynamoDB:**

  * On-demand or provisioned capacity with auto-scaling.

---

## 1️⃣3️⃣ Important Points to Remember

### ✅ Load Balancing:

* Always distribute traffic across multiple AZs.
* Health checks are crucial for high availability.
* Use **single endpoint** to simplify client connections.

### ✅ Auto Scaling:

* Combine **target tracking** with **dynamic scaling** for best results.
* Always set warm-up and cooldown periods to avoid rapid oscillations.
* ECS can scale **service tasks** and **cluster container instances**.
* Scale databases carefully; some services like RDS may require manual intervention.

---

## 📌 Summary

AWS Elastic Load Balancing and Auto Scaling are foundational services for building highly available, fault-tolerant, and cost-effective architectures. By combining them, you ensure that your application can handle unpredictable traffic patterns without manual intervention.

---

## 🌐 Example YAML Snippet for ECS with ALB (Fargate):

```yaml
Resources:
  MyCluster:
    Type: AWS::ECS::Cluster

  MyTaskDefinition:
    Type: AWS::ECS::TaskDefinition
    Properties:
      Family: my-app
      NetworkMode: awsvpc
      ContainerDefinitions:
        - Name: my-container
          Image: nginx
          PortMappings:
            - ContainerPort: 80

  MyService:
    Type: AWS::ECS::Service
    Properties:
      Cluster: !Ref MyCluster
      DesiredCount: 3
      LaunchType: FARGATE
      TaskDefinition: !Ref MyTaskDefinition
      LoadBalancers:
        - ContainerName: my-container
          ContainerPort: 80
          TargetGroupArn: !Ref MyTargetGroup
      NetworkConfiguration:
        AwsvpcConfiguration:
          Subnets: [subnet-xxxxxxx, subnet-yyyyyyy]
          SecurityGroups: [sg-xxxxxxx]

  MyTargetGroup:
    Type: AWS::ElasticLoadBalancingV2::TargetGroup
    Properties:
      Protocol: HTTP
      Port: 80
      VpcId: vpc-xxxxxxx
```
