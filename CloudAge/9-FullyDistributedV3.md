# 🧠 Hadoop Fully Distributed Cluster & AWS Deployment Notes (V3)

---

## 🔷 What is Hadoop?

Apache Hadoop is an open-source framework that allows for the distributed processing of large data sets across clusters of computers using simple programming models.

### 🔹 Key Features:

* Distributed storage using **HDFS (Hadoop Distributed File System)**
* Batch processing using **MapReduce**
* **Scalable**: Easy to add more nodes to the cluster
* **Fault-tolerant**: Automatic data replication
* **Cost-effective**: Runs on commodity hardware
* **High Throughput**: Optimized for large files
* **Data Locality**: Moves compute to the data

---

## 🖥️ Fully Distributed Cluster Setup (V3)

### ✅ Cluster Summary:

* 6 Machine Instances created
* Formed into a fully distributed Hadoop cluster
* All machines have Hadoop installed and are configured via shared `core-site.xml`, `dfs-site.xml`, etc.

### 🔑 EC2 Configuration:

* Key file: `cloudage.pem`
* Security:

  * Inbound Rules:

    * Allow **SSH (22)** from `My IP`
    * Allow **All Traffic** for testing
    * Custom TCP: **50070** (for NameNode Web UI)
  * Outbound Rules:

    * Default allow all

### 🔐 Squid Proxy:

Optional caching proxy setup for internal communication and filtering.

---

## 📂 Directory Navigation & File System

```bash
cd /usr/local/hadoop/dfs/
cd ../conf/
nano core-site.xml
cd ../dfs/local/taskTracker/
cd ../../name/current/
ls  # Shows: version, edits, fsimage, fstime

cd ../../data/
ls  # in_use.lock, storage, tmp
```

---

## 💾 HDFS Operations

```bash
hadoop fs -ls /user/ubuntu/
hadoop fs -get /user/ubuntu/tcpdump ~/
ls -i ~/tcpdump
```

### Sample Commands

```bash
hadoop fs -ls /usr/
cat fsimage
cat
free
ss -l
```

---

## 🔁 Metadata & Namespace

* `fsimage`: Persistent snapshot of the HDFS metadata
* `edits`: Transaction log of recent operations
* `VERSION`: Contains the cluster's namespace ID

---

## 📤 File Transfer & Access

```bash
pscp -i cloudage.pem cloudage.pem ubuntu@13.203.202.173
mv cloudage.pem ~/.ssh/
cat known_hosts
```

## 👤 User Management

```bash
sudo adduser user1
```

## 🔐 SSH Agent Setup

```bash
ssh-agent
# or
eval `ssh-agent` ssh-add
```

---

## 🌐 Key Networking Tools

* `arp` – View ARP cache
* `jps` – List Java processes (used in Hadoop)
* `ls -i` – Show inode number
* `tcpdump` – Network packet analyzer
* `ss -l` – View listening ports

---

## 📊 Cloud & Gen AI Infrastructure Needs

### 📈 Demands for GenAI:

* **Data Storage**: Scalable (S3, HDFS, local DFS)
* **Processing Power**: High-performance CPUs/GPUs
* **Real-time Operation**: Low latency pipelines

### ✅ Operational Requirements:

* Excel-based Monitoring (optional logging via Excel)
* Security: Key pair, SSH, and firewall rules
* Reliability & Durability: Replication, fault-tolerance
* Performance Efficiency: Data locality, efficient pipelines
* Cost Optimization: Spot instances, auto-scaling
* Sustainability: Energy-efficient node deployment

---

## 🧠 Summary

* Hadoop's fully distributed mode mimics real-world production clusters
* EC2 + Hadoop = Scalable Big Data Infrastructure
* Tools like `scp`, `ssh-agent`, `pscp`, and `jps` simplify management
* Focus on **metadata handling**, **port configuration**, **HDFS navigation**, and **resource management**
* Gen AI needs extensive compute + storage power, which Hadoop-style setups can support when integrated with modern cloud and AI frameworks




Here is the **complete set of 40 questions** with **all options**, **correct answers**, and **detailed explanations** in a clear, professional format:

---

# ✅ AWS, Hadoop, and Linux – Quiz Questions, Answers & Explanations

---

### **Question 1:**

**Which AWS service provides a fully managed database solution?**
A) EC2
B) Lambda
✅ **C) RDS**
D) S3
**Explanation:** RDS (Relational Database Service) is a fully managed database service for relational databases like MySQL, PostgreSQL, and Oracle.

---

### **Question 2:**

**What must be done before changing the instance type of a fully distributed cluster?**
A) Restart the daemons
✅ **B) Stop the cluster**
C) Restart all nodes
D) Reconfigure networking
**Explanation:** To change the instance type, the cluster must be stopped to avoid data loss or corruption.

---

### **Question 3:**

**What is Squid in the context of networking?**
✅ **A) A firewall**
B) A database
C) A cloud service
D) A logging tool
**Explanation:** Squid is a caching and forwarding web proxy that can also function as a firewall.

---

### **Question 4:**

**What does the IP range 0.0.0.0/0 represent?**
A) Internal network only
B) Private network
✅ **C) Anywhere (all IPs)**
D) Loopback only
**Explanation:** 0.0.0.0/0 refers to all IPv4 addresses and is used to allow traffic from any IP.

---

### **Question 5:**

**What is the purpose of the `uname` command?**
A) To list users
✅ **B) To display kernel name**
C) To update packages
D) To check disk usage
**Explanation:** The `uname` command shows system information, such as kernel name, version, etc.

---

### **Question 6:**

**Which command starts all the daemons in a Hadoop cluster?**
A) daemon-start.sh
B) cluster-run.sh
✅ **C) start-all.sh**
D) start-dfs.sh
**Explanation:** `start-all.sh` starts both the HDFS and YARN daemons in Hadoop.

---

### **Question 7:**

**What does the `arp` command manage?**
A) Memory allocation
B) Network routing tables
✅ **C) Address Resolution Protocol (ARP) cache**
D) File system
**Explanation:** `arp` displays or modifies the kernel ARP table used to map IP addresses to MAC addresses.

---

### **Question 8:**

**Which command is used to find the inode address of a file?**
A) inode -l
B) find -i
✅ **C) ls -i**
D) stat
**Explanation:** `ls -i` shows the inode number of files, which is useful for tracking file system details.

---

### **Question 9:**

**In Hadoop, which folder contains both logical and physical data structures?**
A) /usr/bin
✅ **B) /usr/local/hadoop/dfs**
C) /etc/hadoop
D) /var/hdfs
**Explanation:** Hadoop’s dfs folder contains both metadata and data structures.

---

### **Question 10:**

**What is the default replication factor in Hadoop?**
A) 1
B) 2
✅ **C) 3**
D) 5
**Explanation:** Hadoop replicates each block of data 3 times by default for fault tolerance.

---

### **Question 11:**

**Which file in Hadoop stores a snapshot of the namespace?**
A) edits
✅ **B) fsimage**
C) namenode.log
D) cluster.conf
**Explanation:** `fsimage` is a persistent snapshot of the HDFS metadata.

---

### **Question 12:**

**Which command brings a file from HDFS to the local machine?**
A) hadoop fs -put
B) hadoop get
✅ **C) hadoop fs -get**
D) hdfs -fetch
**Explanation:** `hadoop fs -get` copies a file from HDFS to the local file system.

---

### **Question 13:**

**What does the `jps` command show in a Hadoop environment?**
A) Running kernel processes
✅ **B) Java processes**
C) System logs
D) Node IPs
**Explanation:** `jps` lists all Java Virtual Machine (JVM) processes on a machine.

---

### **Question 14:**

**Which of the following is NOT part of AWS's Well-Architected Framework pillars?**
A) Security
B) Option 2
C) Durability
✅ **D) Virtualization**
**Explanation:** The five pillars are: Operational Excellence, Security, Reliability, Performance Efficiency, and Cost Optimization.

---

### **Question 15:**

**What is the purpose of the `scp` command?**
A) Run Hadoop jobs
✅ **B) Securely copy files between systems**
C) Start cluster
D) Connect to database
**Explanation:** `scp` stands for Secure Copy and is used to transfer files securely over SSH.

---

### **Question 16:**

**What does `ls -a` display?**
✅ **A) All files including hidden files**
B) File sizes
C) Only directories
D) Only regular files
**Explanation:** The `-a` flag shows all files, including those beginning with a dot (`.`).

---

### **Question 17:**

**Which folder contains files like `authorized_keys` and `known_hosts`?**
A) .cache
✅ **B) .ssh**
C) .bashrc
D) .profile
**Explanation:** `.ssh` stores SSH-related configurations and keys.

---

### **Question 18:**

**What does the `known_hosts` file store?**
A) Public IPs
B) Usernames
✅ **C) Fingerprints of previously connected hosts**
D) SSH passwords
**Explanation:** This file stores the SSH fingerprint of servers to detect tampering.

---

### **Question 19:**

**Which file comes from `/etc/skel` and runs before `.bashrc`?**
A) .cache
✅ **B) .profile**
C) .config
D) .init
**Explanation:** `.profile` is initialized at login and often calls `.bashrc`.

---

### **Question 20:**

**What is the correct command to add a new user?**
A) add user1
B) newuser add
✅ **C) sudo adduser user1**
D) create user1
**Explanation:** `sudo adduser` is the standard way to add a user in Debian-based systems.

---

Continuing from **Question 21 to Question 40** with all options, correct answers, and explanations:

---

### **Question 21:**

**What does the `.profile` file do in a Linux environment?**
A) Runs after .bashrc
B) Stores SSH keys
✅ **C) Initializes the user environment and calls .bashrc**
D) Manages daemons
**Explanation:** `.profile` is executed at login and typically sources `.bashrc` to load user settings.

---

### **Question 22:**

**What protocol is used by SSH for secure communication?**
A) HTTP
B) IPsec
✅ **C) Tunneling**
D) FTP
**Explanation:** SSH uses encrypted tunneling for secure data transfer between hosts.

---

### **Question 23:**

**Which command sets up secure communication between servers using a key?**
A) scp-add-key
✅ **B) eval ssh-agent && ssh-add .ssh/security.pem**
C) ssh-auth add
D) ssh-init.pem
**Explanation:** This command adds your SSH private key to the authentication agent for passwordless communication.

---

### **Question 24:**

**What does `source .profile` do?**
A) Reloads SSH configuration
B) Restarts the server
✅ **C) Runs the profile file line by line**
D) Deletes the file
**Explanation:** `source` executes a file in the current shell without launching a new process.

---

### **Question 25:**

**Which file includes Fully Qualified Domain Name (FQDN) entries?**
A) /etc/dns.conf
✅ **B) /etc/hosts**
C) /etc/fqdn
D) /usr/local/fqdn.conf
**Explanation:** The `/etc/hosts` file maps hostnames to IP addresses, including FQDNs.

---

### **Question 26:**

**Which SSH configuration file allows multiple custom settings?**
✅ **A) /etc/ssh/ssh\_config**
B) /home/ssh/config
C) /var/log/ssh\_conf
D) /ssh.conf
**Explanation:** `/etc/ssh/ssh_config` is the client-side configuration file where you can define host-specific settings.

---

### **Question 27:**

**Which command copies a file to another host’s `.ssh` folder?**
A) cp security.pem
B) ssh-copy security.pem
✅ **C) scp .ssh/security.pem hostname:/home/ubuntu/.ssh**
D) rsync -ssh security.pem
**Explanation:** `scp` is used to securely copy files to remote servers, including SSH key files.

---

### **Question 28:**

**Why do we configure `/etc/hosts` in a cluster setup?**
A) For disk mounting
B) For load balancing
✅ **C) For passwordless two-way communication**
D) For monitoring services
**Explanation:** Proper name resolution via `/etc/hosts` is essential for SSH and Hadoop communication in clusters.

---

### **Question 29:**

**What is `dsh`?**
✅ **A) Distributed shell**
B) Digital secure hub
C) Distributed server handler
D) Data sync handler
**Explanation:** `dsh` (Distributed Shell) allows you to run the same command across multiple machines simultaneously.

---

### **Question 30:**

**Where are most open-source projects listed?**
A) open.org
B) linux-foundation.org
✅ **C) github.com**
D) apache.org
**Explanation:** GitHub is the largest platform for hosting open-source code repositories.

---

### **Question 31:**

**Which file contains the hostnames for `dsh` configuration?**
A) host.config
B) nodes.yaml
✅ **C) machines.list**
D) cluster.conf
**Explanation:** `machines.list` holds the list of target machines for `dsh`.

---

### **Question 32:**

**Which `dsh` configuration file contains group info?**
A) dsh.group
✅ **B) dsh.conf**
C) hosts.group
D) user.config
**Explanation:** `dsh.conf` can include group-related configurations and paths.

---

### **Question 33:**

**Which encryption types are commonly used in SSH?**
A) SHA and SSL
B) AES and DES
✅ **C) RSA and DSA**
D) FTP and SFTP
**Explanation:** SSH typically uses public-key cryptography, like RSA and DSA, for authentication.

---

### **Question 34:**

**What does Hadoop DFS primarily focus on?**
A) Reading data
B) Running MapReduce jobs
✅ **C) Writing data**
D) Compression
**Explanation:** HDFS is optimized for high-throughput writes and large file storage.

---

### **Question 35:**

**What type of operation is MapReduce more focused on?**
A) Writing
✅ **B) Reading**
C) Compression
D) Decryption
**Explanation:** MapReduce reads data from HDFS and processes it in parallel before writing results.

---

### **Question 36:**

**Which directory typically contains application binaries?**
A) /etc
B) /opt
✅ **C) /usr**
D) /bin
**Explanation:** `/usr` often holds system-wide binaries, libraries, and documentation.

---

### **Question 37:**

**Which command shows the Hadoop namespace ID?**
A) hadoop version
✅ **B) cat version**
C) hdfs version
D) get-namespace
**Explanation:** `cat` on the version file in Hadoop directories reveals the namespace ID.

---

### **Question 38:**

**How does a Hadoop cluster use the namespace ID?**
A) To identify daemons
✅ **B) To identify services**
C) To validate logs
D) To read HDFS blocks
**Explanation:** The namespace ID helps the NameNode identify and manage the cluster’s file system namespace.

---

### **Question 39:**

**What type of file is `fsimage` in Hadoop?**
A) Temporary log
B) RAM cache
✅ **C) Persistent metadata snapshot**
D) User configuration
**Explanation:** `fsimage` is a static snapshot of the HDFS metadata at a given time.

---

### **Question 40:**

**Where are files initially stored before being written to the `fsimage` in Hadoop?**
A) SSD
B) NameNode cache
✅ **C) RAM**
D) Datanodes
**Explanation:** Metadata updates are first kept in memory (RAM) and written to `edits` logs before being merged into `fsimage`.

---
