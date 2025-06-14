# 💻 Server Management & Networking - Complete Notes

---

## 📚 Table of Contents

1. Server Management
2. 7-Layer OSI Model
3. SSH and Server Access
4. Network Interface Configuration
5. IP Addressing & Routes
6. Communication & Connectivity Testing
7. DNS & Name Resolution
8. Apache & Hadoop Setup
9. Key Networking Commands
10. Troubleshooting & Monitoring

---

## 1. 🔧 Server Management

Server management involves monitoring and maintaining servers to ensure optimal performance, uptime, and security.

* **Serverless Applications**: Execution model where cloud provider runs the server, auto-scaling and managing.
* **Apache Web Server**: `sudo systemctl status apache2`
* **Java Setup**:

  ```bash
  sudo apt update
  sudo apt install openjdk-11-jdk -y
  ```

## 2. 🧪 OSI 7-Layer Model

| Layer | Name         | Description                                  |
| ----- | ------------ | -------------------------------------------- |
| 7     | Application  | User interfaces and app communication (HTTP) |
| 6     | Presentation | Data formatting/encryption (SSL/TLS)         |
| 5     | Session      | Connection management                        |
| 4     | Transport    | Reliable delivery (TCP/UDP)                  |
| 3     | Network      | Logical addressing and routing (IP)          |
| 2     | Data Link    | MAC addressing, switches (Ethernet)          |
| 1     | Physical     | Hardware transmission (Cables, NICs)         |

### Detailed Explanation with Examples

**Layer 7 - Application Layer**

* **Function**: Interacts with software applications (e.g., web browsers, email clients).
* **Example**: When you open a website using Chrome, the browser uses HTTP (or HTTPS).
* **Protocols**: HTTP, FTP, SMTP, DNS, Telnet, SSH

**Layer 6 - Presentation Layer**

* **Function**: Translates data formats, handles encryption/decryption.
* **Example**: SSL/TLS encryption secures HTTPS traffic.
* **Concepts**: Data compression, format conversion (JPEG, PNG, MP4, etc.)

**Layer 5 - Session Layer**

* **Function**: Manages sessions between systems.
* **Example**: Login session in a website (session cookies, token handling)
* **Protocols**: NetBIOS, PPTP, RPC

**Layer 4 - Transport Layer**

* **Function**: Ensures data transfer reliability and error checking.
* **Example**: TCP retransmits lost packets; UDP streams video with low latency.
* **Protocols**: TCP, UDP

**Layer 3 - Network Layer**

* **Function**: Handles logical addressing, routing of packets.
* **Example**: Routers use IP addresses to send packets across the internet.
* **Protocols**: IP (IPv4/IPv6), ICMP, IGMP

**Layer 2 - Data Link Layer**

* **Function**: Physical addressing (MAC), error detection, switching.
* **Example**: Switches use MAC addresses to forward frames.
* **Sub-layers**: MAC and LLC
* **Protocols**: Ethernet, PPP

**Layer 1 - Physical Layer**

* **Function**: Transmits raw bits over a physical medium.
* **Example**: Fiber optic cable, Ethernet cable, wireless radio waves
* **Devices**: Hubs, repeaters, cables, NICs (Network Interface Cards)

---

## 3. 🔐 SSH Access to Remote Server

```bash
ssh -i "C:/Users/admin/Downloads/cloudage.pem" ubuntu@ec2-65-2-153-70.ap-south-1.compute.amazonaws.com
```

* Use of `.pem` key ensures secure authentication.
* IP used can be checked using:

  ```bash
  curl ifconfig.me
  ```

## 4. 🌐 Network Interface Configuration

### Why Attach an Instance to a Network Interface?

* For **load balancing**, **failover**, **multi-homing**, and **static IP association**.
* You can assign **multiple public IPs** using ENIs (Elastic Network Interfaces).

### Steps:

1. Create a Network Interface
2. Attach Subnet & Domain of the Instance
3. Associate to an EC2 instance
4. Assign public/private IPs
5. Use **Actions > Associate Address** in AWS

### Commands:

```bash
ifconfig
ethtool eth0
ip addr show
ip link
ip neighbor
ip route
ip route | grep default
arp -n
```

---

## 5. 🧽 IP Addressing & Routing

* View routes:

  ```bash
  ip route | grep default
  ```
* Example:

  ```bash
  default via 172.31.0.1 dev eth0 proto dhcp src 172.31.13.220 metric 100
  ```
* Check local IP path:

  ```bash
  ip route get <destination>
  ```
* View up/down interfaces:

  ```bash
  ip link
  ```

---

## 6. 📡 Connectivity & Testing Tools

### Netcat (nc) and Telnet

* Testing communication:

  ```bash
  nc -l localhost 12345
  telnet localhost 12345
  ```
* Type message and check output between terminals.

### Netstat

```bash
netstat -tln
netstat -uln
netstat -an | grep 53
```

* Shows listening ports, established connections.

### Ping & Tracepath

```bash
ping 127.0.0.53
tracepath cloudage.co.in
```

---

## 7. 🌍 DNS & Hostname Resolution

### Commands:

```bash
whatis openssl
dig rohit.com
nslookup rohit.com
```

### Host Mapping:

Edit `/etc/hosts`

```bash
127.0.0.1 localhost
127.127.127.127 hostlocal
172.31.13.220 ec2-65-2-153-70.ap-south-1.compute.amazonaws.com rohit.com
```

### SSL Check:

```bash
openssl s_client -connect cloudage.global:443
```

---

## 8. ☁️ Hadoop & Web Server Setup

### Hadoop Installation:

```bash
cd /opt
wget https://downloads.apache.org/hadoop/common/hadoop-3.3.6/hadoop-3.3.6.tar.gz
tar -xvzf hadoop-3.3.6.tar.gz
mv hadoop-3.3.6 hadoop
```

### Start Hadoop:

```bash
start-all.sh
jps
```

### HDFS Commands:

```bash
hadoop fs -mkdir -p /user/ubuntu/file
hadoop fs -ls /
```

### Important Ports:

* 50010 – DataNode
* 50070 – NameNode Web UI
* 9000 – HDFS Listen

---

## 9. 🔍 Important Network Tools Summary

| Command           | Purpose                                   |
| ----------------- | ----------------------------------------- |
| `ifconfig`        | Show IP and NIC configuration             |
| `ip addr show`    | List all IP addresses and interfaces      |
| `ip route`        | View routing table                        |
| `netstat`         | Show open ports, connections              |
| `ethtool eth0`    | Interface capabilities                    |
| `arp -n`          | ARP cache                                 |
| `ip neighbor`     | Show neighbor discovery table (IPv6/IPv4) |
| `ping`            | Test connectivity                         |
| `dig`, `nslookup` | DNS resolution tools                      |
| `telnet/nc`       | Socket-level testing                      |

---

## 10. ⚠️ Troubleshooting & Monitoring

* Verify ports:

  ```bash
  netstat -tulnp | grep <port>
  ```
* Check Apache service:

  ```bash
  sudo systemctl status apache2
  ```
* Shutdown safely:

  ```bash
  sudo shutdown
  ```

---

## ✅ Summary

* SSH access enables secure remote management.
* Understanding OSI layers helps diagnose network issues.
* `ip`, `netstat`, `curl`, `dig` are essential tools.
* Attaching multiple network interfaces aids in redundancy and load balancing.
* Hadoop setup involves JDK, download, configure, and run.
* Editing `/etc/hosts` allows local DNS mapping.





---

### ✅ Question 1

**Does Hadoop v1 support IPv6?**

* A) Yes
* B) No ✅

> Hadoop v1 does **not** support IPv6 natively. IPv6 support was introduced in later versions of Hadoop to address modern networking needs.

---

### ✅ Question 2

**How does HDFS work for Read and Write data?**

* A) HDFS works in write once and read many fashion. ✅
* B) HDFS works in write once and write many fashion.
* C) HDFS works in read once and write many fashion.
* D) HDFS works in write again and again and read many fashion.

> HDFS is optimized for **high-throughput access** to large datasets, making it ideal for batch processing. Once data is written, it cannot be modified.

---

### ✅ Question 3

**In the command `ssh -i`, what does `-i` stand for?**

* A) IP address
* B) IP version
* C) Immediately
* D) Identifier ✅

> The `-i` flag in SSH specifies the **identity file**, or private key, used for authentication when connecting to a remote system.

---

### ✅ Question 4

**In the command `tar -xzvf`, what does `v` stand for?**

* A) Zip
* B) Unzip
* C) Forcefully
* D) Verbose ✅

> The `v` option stands for **verbose**, which lists files processed by the tar command during compression or extraction.

---

### ✅ Question 5

**In the command `tar -xzvf`, what does `x` stand for?**

* A) Extract ✅
* B) Unzip
* C) Forcefully
* D) Verbose

> The `x` option is used to **extract** files from an archive.

---

### ✅ Question 6

**In the command `tar -xzvf`, what does `z` stand for?**

* A) Zip
* B) Unzip ✅
* C) Forcefully
* D) Verbose

> The `z` option tells `tar` to filter the archive through **gzip** for decompression (unzip).

---

### ✅ Question 7

**In which directory do we find the `id_rsa` and `id_rsa.pub` key in Linux?**

* A) /usr/bin
* B) /usr/sbin
* C) \~/.ssh/ ✅
* D) None of the above

> SSH key pairs are typically stored in the **\~/.ssh/** directory under a user's home folder.

---

### ✅ Question 8

**In which environment is JDK used?**

* A) Production
* B) Staging
* C) Development ✅
* D) POC

> The **Java Development Kit (JDK)** is used during the **development** phase to compile and build Java applications.

---

### ✅ Question 9

**In which of the modes can you start your Hadoop cluster?**

* A) Local Mode and Map-reduce Mode
* B) Local (standalone) mode, Pseudo-distributed mode and Fully-distributed mode. ✅
* C) Client Mode and Cluster Mode
* D) Interactive mode and script mode.

> Hadoop can be run in 3 primary modes:
>
> * Local (for debugging),
> * Pseudo-distributed (single machine with daemons), and
> * Fully-distributed (multi-node production).

---

### ✅ Question 10

**Is Data important or Metadata important?**

* A) Data
* B) Metadata
* C) Both ✅

> **Both** are crucial. Data is the actual content, while **metadata** describes the structure and organization of that data.

---

### ✅ Question 11

**Is Hadoop 1 used in Production?**

* A) Yes, it is currently used in Production.
* B) NO, it’s Obsolete. ✅

> Hadoop 1 is outdated and no longer recommended for production use. It has been replaced by Hadoop 2 and 3 with better scalability and features.

---

### ✅ Question 12

**Is Hadoop a data operating system?**

* A) YES ✅
* B) NO
* C) Maybe not sure

> Hadoop can be considered a **data operating system** as it manages data storage (HDFS) and processing (MapReduce/YARN).

---

### ✅ Question 13

**Is Linux a system operating system?**

* A) YES ✅
* B) NO
* C) Maybe not sure

> **Linux** is a widely used open-source system **operating system**, providing a stable foundation for applications and services.

---

### ✅ Question 14

**What are the components of Name Node?**

* A) Editlog & fsimage is the file system. ✅
* B) Hadoop is the main File system.
* C) Linux and Hadoop file system.
* D) None of the Above

> The **NameNode** uses **fsimage** to store the file system state and **editlog** to record changes, ensuring HDFS metadata is maintained.

---

### ✅ Question 15

**What are the two types of folders in HDFS?**

* A) HDFS and Mapred
* B) Mapreduce and Data
* C) DFS & Mapred ✅
* D) DFS & Mapreduce

> HDFS has configuration directories typically labeled under **DFS** (for storage configs) and **Mapred** (for MapReduce configs).

---

### ✅ Question 16

**What are the V’s of big data?**

* A) Volume, Value, Variety, Velocity, and Veracity. ✅
* B) Valuable, Versatile, Vigorous, and Variety.
* C) Volatile, Valuable, Variable.
* D) None of the above.

> The **5 V's of Big Data** are Volume, Velocity, Variety, Veracity, and Value—describing the properties and challenges of big data.

---

### ✅ Question 17

**What does `core-site.xml` impact?**

* A) Data node
* B) Name node ✅
* C) Task manager
* D) Cluster

> `core-site.xml` sets **core Hadoop configurations** like the NameNode address (fs.defaultFS), directly impacting the NameNode.

---

### ✅ Question 18

**What does JDK stand for?**

* A) Java Downloadable kit
* B) Java Development Kit ✅
* C) Java Development Key
* D) Java downloadable key

> **JDK** stands for **Java Development Kit**, a set of tools for developing and running Java programs.

---

### ✅ Question 19

**What does the `/` indicate in Linux?**

* A) The symbol `/` indicates the domain name.
* B) The symbol `/` indicates the filename.
* C) The symbol `/` indicates the home of the filesystem.
* D) The symbol `/` indicates the root of the filesystem. ✅

> In Linux, `/` represents the **root directory**, the top level of the file system hierarchy.

---

### ✅ Question 20

**What is `/etc/hosts` used for?**

* A) This file is used to associate host name or IP address with the network interface. ✅
* B) This is a system file in Linux that stores encrypted user passwords and is accessible only to the root user.
* C) This is an ASCII file that contains records for system groups.
* D) This is a text file that contains a message or system identification to be printed before the login prompt.

> `/etc/hosts` is used to **manually map hostnames to IP addresses**, providing basic DNS functionality locally.

---
### Question 21

**What is a filesystem?**

* A) ✅ A file system stores and organizes data and can be thought of as a type of index for all the data contained in a storage device.
* B) File system is known where all the data is kept.
* C) File system is known where structured data is kept.
* D) File system is known where non-structured data is kept.

> A filesystem manages how data is stored and retrieved.

### Question 22

**What is a heartbeat signal?**

* A) A Heartbeat is a signal from Namenode to Datanode to indicate that it is alive.
* B) A Heartbeat is a signal from Slave to Workernode to indicate that it is alive.
* C) ✅ A Heartbeat is a signal from Datanode to Namenode to indicate that it is alive.
* D) A Heartbeat is a signal from Master node to Zookeeper to indicate that it is alive.

> Heartbeats ensure that datanodes are functioning properly.

### Question 23

**What is a node?**

* A) A device which is incapable of connecting to a network
* B) ✅ A system or device which is connected to the internet is called a node.
* C) A system or device which manages the DNS server.
* D) A system or a device which configures the DHCP servers to lease IP addresses

> Any connected device on a network is considered a node.

### Question 24

**What is inode number in Linux?**

* A) The inode number refers to a directory.
* B) The inode number refers to the Linux version.
* C) ✅ The inode number refers to the physical file, the data stored in a particular location.
* D) The inode number refers to the number of files stored in Linux.

> Each file has a unique inode number representing metadata.

### Question 25

**What is known as the USER Directory?**

* A) ✅ USER is known as the Human Directory.
* B) USER is known as the Portfolio Directory.
* C) USER is known as the Directory Directory.
* D) Both A & C

> The USER directory represents user-specific data.

### Question 26

**What is known as the USR Directory?**

* A) ✅ USR is known as the application Directory.
* B) USR is known as the Apps/dir./directory folder.
* C) USR is known as the Parent Directory.
* D) USER as a Directory.

> `/usr` holds read-only user data; applications and libraries.

### Question 27

**What is Pseudo-Distributed Mode?**

* A) The Pseudo-distributed mode does not offer you a true distributed environment.
* B) ✅ Just like the Standalone mode, in Pseudo-Distributed Mode, Hadoop is run on a single-node in a pseudo(false) distributed mode.
* C) The usage of this mode is very limited, and it can be only used for experimentation.
* D) It offers true distributed computing capability and offers built-in reliability, scalability, and fault tolerance.

> All daemons run on a single machine for development testing.

### Question 28

**What is RSA?**

* A) It is a private-key cryptographer and Federal Information Processing Standard for digital signatures.
* B) ✅ RSA algorithm (Rivest-Shamir-Adleman) is the basis of a cryptosystem -- a suite of cryptographic algorithms that are used for specific security services.
* C) A private key is a large numerical value that is used to encrypt data.
* D) None of the above.

> RSA is used in secure data transmission.

### Question 29

**What is the block size of the Linux file system?**

* A) 8KB
* B) ✅ 4MB
* C) 8MB
* D) Both A & C

> Ext4 default block size is 4KB, but question might imply HDFS default.

### Question 30

**What is the default authentication mechanism?**

* A) DSA
* B) ✅ RSA
* C) NSA
* D) PSA

> RSA is the most commonly used key authentication.

### Question 31

**What is the default heartbeat interval?**

* A) The default heartbeat interval is 2 seconds.
* B) The default heartbeat interval is 5 seconds.
* C) The default heartbeat interval is 1 second.
* D) ✅ The default heartbeat interval is 3 seconds.

> Ensures Namenode knows Datanodes are alive.

### Question 32

**What is the default port number for Name Node webui (HTTP) (IPv4)?**

* A) 50074
* B) ✅ 50070
* C) 7180
* D) 7185

> Used to access HDFS NameNode web UI.

### Question 33

**What is the default port used for accessing the cluster through SSH?**

* A) ✅ 22
* B) 80
* C) 50070
* D) None of the Above

> Port 22 is default for SSH.

### Question 34

**What is the Name of Hadoop file system?**

* A) ✅ Hadoop (HDFS)
* B) Big data
* C) Linux for Hadoop
* D) Both A & B

> HDFS is Hadoop Distributed File System.

### Question 35

**What is the use of `mapred-site.xml`?**

* A) It is responsible for writing the address of Task Tracker.
* B) It is responsible for writing the address of Mapred Tracker.
* C) ✅ It is responsible for writing the address of Job tracker.
* D) It is responsible for writing the address of Live Tracker.

> Configures MapReduce job settings.

### Question 36

**When does the size of a file increase from 0KB in Linux?**

* A) Whenever you create a blank file, the size will increase.
* B) Whenever you read and write a blank file, the size will increase.
* C) Whenever you move a file with a single alphabet, the file size will increase.
* D) ✅ Whenever you create a file with a single alphabet, the file size will increase.

> Data must be written for the file to gain size.

### Question 37

**Where do we find the tmp folder of Hadoop?**

* A) ✅ /usr/local/hadoop/tmp
* B) /usr/root/hadoop/tmp
* C) /usr/user/hadoop/tmp
* D) /usr/hadoop/tmp

> Default temp folder path for HDFS configs.

### Question 38

**Which are the client configuration files in Hadoop?**

* A) Core-site.xml
* B) Hdfs-site.xml
* C) Mapred-site.xml
* D) ✅ All of the above

> All these files define Hadoop's behavior.

### Question 39

**Which directory do we install third party software in Linux?**

* A) /user
* B) /bin
* C) ✅ /usr
* D) /sbin

> `/usr` is standard for 3rd-party applications.

### Question 40

**Which file do we configure the environment of Hadoop?**

* A) Core.site.xml
* B) ✅ Hadoop.env.sh
* C) bashrc
* D) None of the above

> `hadoop-env.sh` sets JAVA\_HOME and other env variables.

### Question 41

**Which file do we update to configure the environment in Linux?**

* A) ✅ .bashrc
* B) Core-site.xml
* C) Hdfs-site.xml
* D) None of the above

> `.bashrc` contains user-specific shell configs.

### Question 42

**Which port number do we use for HTTP?**

* A) 22
* B) ✅ 80
* C) 443
* D) 88

> HTTP uses port 80.

### Question 43

**Which port number do we use for HTTPS?**

* A) 22
* B) 80
* C) ✅ 443
* D) 88

> HTTPS uses port 443.

### Question 44

**Which range of IP address is for the Loopback address?**

* A) 129.1.0.1 - 129.255.255.255
* B) ✅ 127.0.0.0 - 127.255.255.255
* C) 129.192.168.1 - 129.255.255.255
* D) 129.0.0.1

> Loopback addresses are reserved in 127.0.0.0/8.

### Question 45

**Why do we configure `hdfs-site.xml`?**

* A) For Data storage
* B) For Mapping
* C) ✅ For Replication Factor
* D) For Reducing the data

> Set properties like replication, block size.

### Question 46

**Why do we move sudo Hadoop to usr/local/Hadoop?**

* A) It’s a First Party Software.
* B) ✅ It’s a Third-Party software.
* C) It’s a Second Part Software.
* D) Both B & C

> `/usr/local` is for locally compiled or 3rd-party software.

### Question 47

**Why do we need to install the JVM?**

* A) To make it platform dependent
* B) To make it platform distributed
* C) ✅ To make it platform independent
* D) To make it platform incompatible

> JVM allows Java code to run on any OS.

### Question 48

**Why do we use the `jps` command?**

* A) To check all the Processes ID
* B) ✅ To check if all the processes are running
* C) To check the IP address
* D) To Check the JDK Connection

> `jps` lists running Java processes.

### Question 49

**Why do we use the command `start-dfs.sh`?**

* A) To start the Logical daemons
* B) To start the non-Logical daemons
* C) ✅ To start the Physical daemons
* D) To start the Random daemons

> Starts NameNode, DataNode, SecondaryNameNode.

### Question 50

**Why do we use the command `start-mapred.sh`?**

* A) To start the Physical demons
* B) To start the non-Logical demons
* C) To start the Random demons
* D) ✅ To start the Logical demons

> Starts JobTracker and TaskTracker in Hadoop 1.x
