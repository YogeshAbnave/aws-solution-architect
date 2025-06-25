
---

### **Question 1**

**Q:** For public cloud deployments, which cloud providers are supported by Cloudera Data Platform (CDP)?

* A) Amazon Web Services (AWS) and Google Cloud Platform (GCP) ✅
* B) Microsoft Office 365 and IBM Cloud
* C) Oracle Cloud and Alibaba Cloud
* D) None, CDP is only available for on-premises deployments.
  **Answer:** A) AWS and GCP
  **Explanation:** CDP supports both AWS and GCP for public cloud deployments, enabling hybrid and multi-cloud architectures.

---

### **Question 2**

**Q:** In Hadoop, what role does Apache Tez play?

* A) It serves as a distributed file system.
* B) It manages cluster resource allocation.
* C) It processes data in a directed acyclic graph (DAG) fashion. ✅
* D) It provides data storage and retrieval services.
  **Answer:** C)
  **Explanation:** Apache Tez is a DAG-based execution engine that optimizes performance over MapReduce.

---

### **Question 3**

**Q:** What is the role of the data catalogue in CDP?

* A) A programming language
* B) Provides data visualization tools
* C) Manages metadata and data lineage ✅
* D) Manages cloud infrastructure
  **Answer:** C)
  **Explanation:** The CDP Data Catalog helps manage metadata, classify data, and ensure governance and lineage tracking.

---

### **Question 4**

**Q:** What does Cloudera Manager do?

* A) Manages cloud resources
* B) Manages and monitors clusters and services ✅
* C) Provides data analytics
* D) Manages network security
  **Answer:** B)
  **Explanation:** Cloudera Manager provides centralized management and monitoring of clusters and Hadoop services.

---

### **Question 5**

**Q:** External firewalls in cloud computing are called:

* A) Safety gates
* B) Network barriers
* C) Security groups ✅
* D) Data encryption
  **Answer:** C)
  **Explanation:** In AWS and other clouds, "security groups" act as virtual firewalls controlling inbound/outbound traffic.

---

### **Question 6**

**Q:** What does CDP Private Cloud offer?

* A) Public cloud services
* B) Web hosting
* C) On-premises big data solutions ✅
* D) DBMS tools
  **Answer:** C)
  **Explanation:** CDP Private Cloud extends CDP functionality to on-premises data centers for hybrid data management.

---

### **Question 7**

**Q:** What does FQDN stand for?

* A) Fully Qualified Data Node
* B) Fully Qualified Distributed Network
* C) Fully Qualified Domain Node
* D) Fully Qualified Domain Name ✅
  **Answer:** D)
  **Explanation:** FQDN is the complete domain name specifying exact location within the DNS hierarchy.

---

### **Question 8**

**Q:** SELinux "permissive" mode allows:

* A) Enforcing policies
* B) Logging violations without enforcement ✅
* C) Blocking network
* D) Enabling firewalls
  **Answer:** B)
  **Explanation:** In permissive mode, SELinux logs policy violations but doesn’t block actions.

---

### **Question 9**

**Q:** What does "dsh" stand for?

* A) Distributed Shell ✅
* B) Dancing Shell
* C) Data Storage Hadoop
* D) Distributed Software Hosting
  **Answer:** A)
  **Explanation:** `dsh` executes shell commands across multiple remote machines simultaneously.

---

### **Question 10**

**Q:** What does `getenforce` show in Linux?

* A) Firewall rules
* B) SELinux status ✅
* C) Network connections
* D) Memory stats
  **Answer:** B)
  **Explanation:** `getenforce` returns whether SELinux is in Enforcing, Permissive, or Disabled mode.

---

### **Question 11**

**Q:** What does the “swappiness” parameter control in Linux?

* A) Network traffic
* B) Memory allocation
* C) Disk storage
* D) Tendency to swap memory pages to disk ✅
  **Answer:** D)
  **Explanation:** Lower swappiness means less use of swap space; higher values use swap more aggressively.

---

### **Question 12**

**Q:** What is Apache Tez designed for?

* A) Data storage
* B) Real-time processing
* C) Data analysis and querying ✅
* D) Data encryption
  **Answer:** C)
  **Explanation:** Tez accelerates data processing using DAGs and is used by Hive and Pig.

---

### **Question 13**

**Q:** What is Spark mainly used for?

* A) Data storage
* B) Resource management
* C) Parallel computing
* D) Data processing and analytics ✅
  **Answer:** D)
  **Explanation:** Apache Spark provides in-memory computing for high-speed analytics.

---

### **Question 14**

**Q:** Key data structure in Apache Tez DAGs?

* A) Linked List
* B) Tree
* C) Stack
* D) Vertex ✅
  **Answer:** D)
  **Explanation:** Each node (or task) in a DAG is called a vertex in Tez.

---

### **Question 15**

**Q:** Advantage of Apache Tez over MapReduce?

* A) Simplicity
* B) Real-time support
* C) Performance via optimized DAG processing ✅
* D) Enhanced storage
  **Answer:** C)
  **Explanation:** Tez significantly improves performance by avoiding intermediate writes between steps.

---

### **Question 16**

**Q:** CDP DataHub (CDP-DH) focuses on:

* A) Storage
* B) Real-time stream
* C) Data integration and movement ✅
* D) Governance
  **Answer:** C)
  **Explanation:** CDP DataHub supports scalable, integrated data movement and pipelines.

---

### **Question 17**

**Q:** Primary function of YARN?

* A) Data storage
* B) Resource management ✅
* C) Querying
* D) Networking
  **Answer:** B)
  **Explanation:** YARN manages compute resources across applications in a Hadoop cluster.

---

### **Question 18**

**Q:** What does `iptables` do in Linux?

* A) Memory management
* B) Encryption
* C) Packet filtering and NAT ✅
* D) Data analytics
  **Answer:** C)
  **Explanation:** `iptables` manages network traffic rules, including firewall settings.

---

### **Question 19**

**Q:** Primary purpose of `pdsh`?

* A) Send to single remote
* B) Local commands
* C) Send to multiple remotes in parallel ✅
* D) Hadoop job management
  **Answer:** C)
  **Explanation:** `pdsh` is used for parallel command execution across many servers.

---

### **Question 20**

**Q:** CDP-DE is used for:

* A) Reporting
* B) Storage
* C) Real-time processing
* D) Data prep and transformation ✅
  **Answer:** D)
  **Explanation:** CDP-DE focuses on preparing and transforming data before analytics.

---

### **Question 21**

**Q:** Purpose of "Tuned" service in Linux?

* A) Encryption
* B) Performance optimization ✅
* C) Memory defrag
* D) Storage
  **Answer:** B)
  **Explanation:** `tuned` dynamically adjusts system settings for performance profiles.

---

### **Question 22**

**Q:** CDP-DW is used for:

* A) Real-time streams
* B) Machine learning
* C) Large-scale data storage
* D) High-performance data warehousing ✅
  **Answer:** D)
  **Explanation:** CDP-DW enables scalable, secure, and optimized data warehouse queries.

---

### **Question 23**

**Q:** What is Transparent Huge Pages (THP)?

* A) Security feature
* B) Network protocol
* C) Memory management ✅
* D) Encryption
  **Answer:** C)
  **Explanation:** THP optimizes memory usage for large pages but can impact performance in Hadoop.

---

### **Question 24**

**Q:** Command for distributed shell execution?

* A) pdsh ✅
* B) dshell
* C) pshell
* D) parashell
  **Answer:** A)
  **Explanation:** `pdsh` allows simultaneous command execution across nodes.

---

### **Question 25**

**Q:** Hybrid platform for on-prem, cloud, edge data?

* A) CDP ✅
* B) Hadoop
* C) Hive
* D) Spark
  **Answer:** A)
  **Explanation:** Cloudera Data Platform supports unified analytics across all environments.

---

### **Question 26**

**Q:** Feature included in Cloudera Runtime?

* A) Python
* B) Impala ✅
* C) MySQL
* D) PostgreSQL
  **Answer:** B)
  **Explanation:** Impala is Cloudera’s MPP SQL query engine for Hadoop.

---

### **Question 27**

**Q:** Key CDP component?

* A) Hadoop ✅
* B) Kubernetes
* C) Apache HTTP
* D) Microsoft Office
  **Answer:** A)
  **Explanation:** CDP builds on Hadoop ecosystem with integrated tools.

---

### **Question 28**

**Q:** Language commonly used in CDP data processing?

* A) Java
* B) Python ✅
* C) C++
* D) Ruby
  **Answer:** B)
  **Explanation:** Python is widely used for Spark, Hive, and pipeline scripting.

---

### **Question 29**

**Q:** Apache Tez apps are written in:

* A) Java and Python ✅
* B) JS and Ruby
* C) C++ and PHP
* D) Swift and Kotlin
  **Answer:** A)
  **Explanation:** Tez APIs are Java-based, with some Python wrappers available.

---

### **Question 30**

**Q:** CDP Data Catalog is for:

* A) Real-time streaming
* B) ML deployment
* C) Metadata management and governance ✅
* D) BI and dashboards
  **Answer:** C)

---

### **Question 31**

**Q:** CDP Data Flow is used for:

* A) Machine learning
* B) Real-time analytics ✅
* C) On-premises only
* D) Data governance
  **Answer:** B)

---

### **Question 32**

**Q:** Correct CDP statement:

* A) Only on-prem
* B) Cloud-only
* C) Unified platform for on-prem and cloud ✅
* D) ML-only
  **Answer:** C)

---

### **Question 33**

**Q:** Technology for containerization?

* A) Virtualization
* B) Hadoop
* C) Docker ✅
* D) Spark
  **Answer:** C)

---

