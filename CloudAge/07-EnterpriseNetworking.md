# Enterprise Networking

```
Enterprise Networking
├── 1. Network Types and Scopes
│   ├── University: LAN, WAN, PAN, CAN
│   ├── Microsoft: Internet
│   ├── Open Source: Public Network
│   ├── Open Source: Private Network
│   └── CISCO: Intra Networking
│
├── 2. Purpose: Share Information
│   ├── Story of Floppy Disk
│   └── Problems & Solutions
│       ├── Ruling Bodies: ANSI, ISO, IEEE, ARP
│       ├── Hardware
│       │   ├── Controller
│       │   ├── ISA
│       │   ├── Adapter
│       │   ├── Cable: Coaxial, UTP
│       │   ├── Wireless
│       │   ├── PCI
│       │   ├── RJ45
│       │   └── CAT-5
│       └── Software
│           ├── TCP
│           ├── TCP/IP
│           ├── UDP
│           └── DHCP
│
├── 3. Data Transmission & Protocols
│   ├── Broadcast
│   ├── Collision
│   ├── Ethernet
│   ├── Topology
│   ├── Unicasting
│   ├── Acknowledgement
│   └── Main Difference: Broadcast vs Unicast
│
├── 4. Network Devices & Structures
│   ├── Hub
│   │   ├── Why Invented?
│   │   ├── Hardware Hub
│   │   ├── Structure
│   │   └── Dumb Device
│   ├── Bridge
│   ├── Switch
│   ├── Router
│   ├── Network Device Additions (A, B, C, D)
│   ├── Peer-to-Peer Connection
│   ├── Standalone Machine
│   ├── MAC ID, IP, Hostname
│   ├── RAM, ROM, Cache Memory
│   ├── Manual Connect
│   ├── Dynamic Host Control File
│   ├── DHCP & Flow
│   ├── 0.0.0.0: IP Release
│   └── Summary of Devices: Hub, Bridge, Switch, Router, DHCP
│
├── 5. Addressing & Protocols
│   ├── MAC, Host, IP, IPv4
│   ├── TCP/IP
│   ├── Public IP, Gateway Device
│   ├── IP Classification
│   ├── UDP (YouTube) vs TCP (Banking)
│   ├── IPv4: 8 Octets, 32 bits
│   ├── IP Classes: A, B, C, D
│   ├── CERN: 0–256
│   ├── Special IPs
│   │   ├── 0.0.0.0: Release
│   │   └── 127.0.0.1: Loopback
│   ├── Private IP Ranges
│   │   ├── 10.0.0.0
│   │   ├── 192.168.0.0
│   │   └── 172.16.0.0/31
│   ├── APIPA: 169.254.0.0
│   ├── Range Examples
│   │   ├── 126.100.10.10
│   │   ├── 100.254.10.9
│   │   ├── 125.125.125.125
│   │   ├── 192.168.X.X
│   │   └── 179.254.3.7
│   └── ISP Reserved: 100.254.0.0
│
├── 6. Troubleshooting & Management
│   ├── Restart Router: Why?
│   ├── Renew
│   ├── Kernel IP Connection
│   ├── Troubleshooting Steps
│   ├── Distinguish Network vs Host Part
│   ├── LAN, Intranet, Private Network
│   ├── Configure Router Range
│   ├── Gateway Address/Router
│   └── Range Limit, IPv4 Infra
│
├── 7. Standards & Organizations
│   ├── CERN
│   ├── ANSI
│   ├── ISO
│   ├── IEEE
│   └── ISP (Internet Service Provider)
│
├── 8. Security & Remote Access
│   ├── SSH Client
│   └── SSL Server
│
└── 9. Miscellaneous
    ├── License
    ├── Manual vs Dynamic Config
    ├── Network Topology
    └── Shielded vs Unshielded Cable
```


# Enterprise Networking

## Architecture Overview
```
┌─────────────────────────────────────────────────────────────────┐
│                    ENTERPRISE NETWORK ARCHITECTURE              │
├─────────────────────────────────────────────────────────────────┤
│  Application Layer (Layer 7)                                   │
│  ├── Web Services (HTTP/HTTPS)                                 │
│  ├── Email (SMTP/POP3/IMAP)                                    │
│  ├── File Transfer (FTP/SFTP)                                  │
│  └── Remote Access (SSH/Telnet)                                │
├─────────────────────────────────────────────────────────────────┤
│  Presentation Layer (Layer 6)                                  │
│  ├── Data Encryption/Decryption                                │
│  ├── Compression                                               │
│  └── Data Translation                                          │
├─────────────────────────────────────────────────────────────────┤
│  Session Layer (Layer 5)                                       │
│  ├── Session Management                                        │
│  ├── Authentication                                            │
│  └── Authorization                                             │
├─────────────────────────────────────────────────────────────────┤
│  Transport Layer (Layer 4)                                     │
│  ├── TCP (Reliable, Connection-oriented)                       │
│  ├── UDP (Fast, Connectionless)                                │
│  └── Port Management                                           │
├─────────────────────────────────────────────────────────────────┤
│  Network Layer (Layer 3)                                       │
│  ├── IP Addressing (IPv4/IPv6)                                 │
│  ├── Routing (Static/Dynamic)                                  │
│  ├── ICMP (Internet Control Message Protocol)                  │
│  └── NAT (Network Address Translation)                         │
├─────────────────────────────────────────────────────────────────┤
│  Data Link Layer (Layer 2)                                     │
│  ├── MAC Addressing                                            │
│  ├── Ethernet Frames                                           │
│  ├── Switching                                                 │
│  └── Error Detection                                           │
├─────────────────────────────────────────────────────────────────┤
│  Physical Layer (Layer 1)                                      │
│  ├── Cables (Coaxial, UTP, Fiber)                             │
│  ├── Wireless (Wi-Fi, Bluetooth)                              │
│  ├── Hubs and Repeaters                                        │
│  └── Electrical Signals                                        │
└─────────────────────────────────────────────────────────────────┘
```

## Physical Network Architecture
```
                    ┌─────────────────────────────┐
                    │         INTERNET            │
                    └─────────────┬───────────────┘
                                  │
                    ┌─────────────▼───────────────┐
                    │       ISP ROUTER            │
                    └─────────────┬───────────────┘
                                  │
                    ┌─────────────▼───────────────┐
                    │      ENTERPRISE FIREWALL    │
                    └─────────────┬───────────────┘
                                  │
                    ┌─────────────▼───────────────┐
                    │       CORE ROUTER           │
                    └─────────────┬───────────────┘
                                  │
        ┌─────────────────────────┼─────────────────────────┐
        │                         │                         │
┌───────▼────────┐    ┌───────────▼────────┐    ┌───────────▼────────┐
│ DISTRIBUTION   │    │   DISTRIBUTION     │    │   DISTRIBUTION     │
│   SWITCH 1     │    │     SWITCH 2       │    │     SWITCH 3       │
└───────┬────────┘    └───────────┬────────┘    └───────────┬────────┘
        │                         │                         │
┌───────▼────────┐    ┌───────────▼────────┐    ┌───────────▼────────┐
│  ACCESS        │    │    ACCESS          │    │    ACCESS          │
│  SWITCH        │    │    SWITCH          │    │    SWITCH          │
└───────┬────────┘    └───────────┬────────┘    └───────────┬────────┘
        │                         │                         │
   ┌────┴────┐              ┌─────┴─────┐              ┌─────┴─────┐
   │ DEVICES │              │  DEVICES  │              │  DEVICES  │
   └─────────┘              └───────────┘              └───────────┘
```

## Network Topology Architecture
```
Internet Cloud
     │
     ▼
┌─────────────┐
│   Firewall  │ ◄── Security Layer
└─────────────┘
     │
     ▼
┌─────────────┐
│   Router    │ ◄── Network Layer (Layer 3)
└─────────────┘
     │
     ▼
┌─────────────┐
│   Switch    │ ◄── Data Link Layer (Layer 2)
└─────────────┘
     │
   ┌─┴─┐
   ▼   ▼
┌─────┐ ┌─────┐
│ PC1 │ │ PC2 │ ◄── End Devices
└─────┘ └─────┘
```

## 1. Network Fundamentals
### Network Types and Scopes
- **LAN (Local Area Network)** - University/Campus networks
- **WAN (Wide Area Network)** - Geographic distribution
- **PAN (Personal Area Network)** - Individual device connectivity
- **CAN (Campus Area Network)** - Multi-building networks
- **Internet** - Global network infrastructure
- **Intranet** - Private internal networks
- **Extranet** - Extended private networks

### Network Classifications
- **Public Networks** - Open access networks
- **Private Networks** - Restricted access networks

## 2. Network Purpose and Evolution
### Primary Objective
- **Information Sharing** - Core purpose of networking

### Historical Context
- **Floppy Disk Era** - Pre-networking data transfer challenges

### Standardization Bodies
- **ANSI** (American National Standards Institute)
- **ISO** (International Organization for Standardization)
- **IEEE** (Institute of Electrical and Electronics Engineers)
- **CERN** (European Organization for Nuclear Research)

## 3. Network Infrastructure Components

### Hardware Components
- **Network Controllers** - Interface management
- **ISA (Industry Standard Architecture)** - Bus standard
- **Network Adapters** - Device connectivity interfaces
- **PCI (Peripheral Component Interconnect)** - Expansion bus

### Cabling and Physical Media
- **Coaxial Cable** - Legacy transmission medium
- **UTP (Unshielded Twisted Pair)** - Standard copper cabling
- **CAT-5/CAT-5e** - Category 5 Ethernet cables
- **RJ45 Connectors** - Standard Ethernet connectors
- **Wireless Technologies** - Radio frequency transmission

### Software Protocols
- **TCP (Transmission Control Protocol)** - Reliable data transmission
- **TCP/IP Suite** - Internet protocol stack
- **UDP (User Datagram Protocol)** - Fast, connectionless protocol

## 4. Network Architecture Models

### OSI Reference Model (7 Layers)
```
Layer 7 │ Application  │ HTTP, HTTPS, FTP, SMTP, DNS
Layer 6 │ Presentation │ SSL/TLS, JPEG, ASCII, Encryption
Layer 5 │ Session      │ NetBIOS, RPC, SQL Sessions
Layer 4 │ Transport    │ TCP, UDP, Port Numbers
Layer 3 │ Network      │ IP, ICMP, OSPF, BGP, Routers
Layer 2 │ Data Link    │ Ethernet, Wi-Fi, MAC, Switches
Layer 1 │ Physical     │ Cables, Hubs, Repeaters, Signals
```

### TCP/IP Model (4 Layers)
```
Application Layer    │ HTTP, FTP, SMTP, DNS
Transport Layer      │ TCP, UDP
Internet Layer       │ IP, ICMP, ARP
Network Access Layer │ Ethernet, Wi-Fi, Physical
```

### Enterprise Network Hierarchy
```
Core Layer
├── High-speed backbone
├── Redundancy and fault tolerance
└── Minimal processing overhead

Distribution Layer
├── Policy enforcement
├── Security filtering
├── Inter-VLAN routing
└── WAN access

Access Layer
├── End-user connectivity
├── Port security
├── VLANs
└── PoE (Power over Ethernet)
```
- **DHCP (Dynamic Host Configuration Protocol)** - Automatic IP assignment

## 5. Data Transmission Methods

### Communication Types
- **Broadcast** - One-to-all communication
- **Unicast** - One-to-one

## 🌐 Enterprise Networking: Node/Tree Hierarchy (Detailed Notes)

---

### 1. **Network Types**

These define the physical or logical scale and purpose of the network.

* **LAN (Local Area Network)**:
  Covers a small geographic area like an office or building. High speed and low latency.

* **WAN (Wide Area Network)**:
  Spans large areas like cities, countries, or continents. Often managed by ISPs.

* **PAN (Personal Area Network)**:
  Very short range, connects personal devices like mobile phones and laptops using Bluetooth or USB.

* **CAN (Campus Area Network)**:
  Connects networks within a university, campus, or enterprise complex.

* **Internet (Microsoft’s context)**:
  A global network of interconnected LANs and WANs using TCP/IP.

* **Public Network (Open Source)**:
  Open to public access. Typically, the internet falls under this.

* **Private Network (Open Source)**:
  Internal network restricted to organizational use.

* **Intra Networking (CISCO)**:
  Network within an organization that shares data internally.

---

### 2. **Purpose: Why Networking?**

Networks exist to **share information** and **resources** across devices and locations.

* **Floppy Disk Story**:
  In early days, data was transferred physically. Networking eliminated this limitation.

* **Problems**:
  Lack of speed, data duplication, high maintenance.

* **Solutions**:

  * **Standard Bodies**:

    * **ANSI**: American National Standards Institute
    * **ISO**: International Organization for Standardization
    * **IEEE**: Institute of Electrical and Electronics Engineers
    * **ARP**: Address Resolution Protocol (used in resolving IPs to MAC addresses)
  * **Hardware**:

    * Controllers, ISA cards, NICs, Coaxial cables, UTP, PCI slots, RJ45 connectors, CAT-5 cables.
  * **Software**:

    * Protocols like TCP, TCP/IP, UDP, DHCP that manage communication.

---

### 3. **Transmission Concepts**

Covers how data is transmitted within a network.

* **Broadcast**:
  Sends data to all devices on a network.

* **Collision**:
  Occurs when two devices send data at the same time on a shared medium.

* **Ethernet**:
  Standard for wired LAN communication.

* **Topology**:
  The physical or logical layout of a network (star, ring, mesh, bus).

* **Unicasting**:
  Sending data from one sender to one receiver.

* **Acknowledgement**:
  Used in reliable transmission (e.g., TCP), ensures data is received.

* **Broadcast vs Unicast**:
  Broadcast sends to all; Unicast sends to a specific device.

---

### 4. **Network Devices & Structures**

Devices used to facilitate data flow within or between networks.

* **Hub**:
  Dumb device, sends incoming data to all ports without logic.

* **Bridge**:
  Connects and filters traffic between two network segments.

* **Switch**:
  Smarter than a hub; sends data only to the intended recipient based on MAC.

* **Router**:
  Routes data between different networks using IP addresses.

* **Additions**:
  Device labels A, B, C, D often denote different logical roles or configurations.

* **Peer-to-Peer Connection**:
  No central server; all devices share resources equally.

* **Standalone Machine**:
  Not connected to any network.

* **MAC ID, IP, Hostname**:
  Unique identifiers for devices (hardware-level and network-level).

* **Memory**:

  * RAM: Temporary, fast memory.
  * ROM: Permanent memory (firmware).
  * Cache: Faster than RAM, used for storing frequently accessed data.

* **DHCP**:

  * Automatically assigns IP addresses.
  * **DHCP Flow**:

    1. Discover
    2. Offer
    3. Request
    4. Acknowledge
  * **0.0.0.0**: IP address indicating device is requesting DHCP assignment.

---

### 5. **Addressing & Protocols**

* **MAC Address**:
  Hardware-level, permanent unique ID.

* **IP Address**:
  Logical address (IPv4 – 32 bits).

* **TCP/IP Stack**:
  Protocol suite for internet communication.

* **Public IP**:
  Globally unique, accessible over internet.

* **Private IP**:
  Internal use (e.g., 192.168.x.x, 10.x.x.x).

* **Gateway**:
  Device that connects local network to outside networks.

* **UDP vs TCP**:

  * **UDP**: Faster, unreliable (used in streaming like YouTube).
  * **TCP**: Slower but reliable (used in banking, emails).

* **IPv4**:

  * 32-bit address.
  * 4 octets (e.g., 192.168.1.1).
  * Address Classes:

    * **A**: 1.0.0.0 to 126.255.255.255
    * **B**: 128.0.0.0 to 191.255.255.255
    * **C**: 192.0.0.0 to 223.255.255.255
    * **D**: Multicast (224.x.x.x)

* **Special IPs**:

  * **0.0.0.0**: No specific IP; used for DHCP discovery.
  * **127.0.0.1**: Loopback/localhost.
  * **169.254.x.x**: APIPA; used when DHCP fails.
  * **100.64.0.0/10**: Carrier-grade NAT (ISP use).

---

### 6. **Troubleshooting & Management**

* **Router Restart**:
  Refreshes configuration and resets corrupted states.

* **Renew IP**:
  Renews IP lease with DHCP server.

* **Kernel IP Connection Table**:
  System-level data on active TCP/UDP sessions.

* **Config Router Range**:
  Define IP allocation pool.

* **Distinguish Network & Host Part**:
  Done using subnet mask (e.g., /24 = 255.255.255.0).

* **LAN, Intranet**:
  Internal networks. Intranet is typically private web-based applications within LAN.

* **Gateway Address**:
  First hop in routing to other networks.

---

### 7. **Standards & Organizations**

* **CERN**:
  Pioneered World Wide Web and research networks.

* **ANSI**:
  US standards body.

* **ISO**:
  Global standardization, OSI model designer.

* **IEEE**:
  Created Ethernet standards (802.3).

* **ISP (Internet Service Provider)**:
  Provides access to internet.

---

### 8. **Security & Remote Access**

* **SSH (Secure Shell)**:
  Secure protocol for remote command-line access.

* **SSL (Secure Socket Layer)**:
  Encrypts data for secure web access (HTTPS).

---

### 9. **Miscellaneous**

* **Licensing**:
  Networking software or OS may require commercial licenses.

* **Manual vs Dynamic Configuration**:

  * Manual: Admin sets IPs manually.
  * Dynamic: DHCP assigns IPs automatically.

* **Network Topologies**:

  * **Star**: All devices connect to a central switch.
  * **Bus**: Single backbone cable.
  * **Ring**: Each device connects to two others forming a loop.
  * **Mesh**: Devices interconnected redundantly.

* **Cabling**:

  * **UTP**: Unshielded twisted pair.
  * **STP**: Shielded twisted pair.
  * **CAT-5/CAT-6**: Ethernet standards.
  * **Coaxial**: Legacy cables, still used in some cases.
  * **RJ45**: Standard connector for Ethernet.

---

```
Networking
├── Connection Types
│   ├── Dial-up
│   ├── DSL
│   │   └── DSLAM
│   ├── VSNL Gateway Connect
│   └── Country Connection
├── Network Structure
│   ├── Root (root / root-local-hdd)
│   ├── File System Root (\)
│   ├── URL // network
│   ├── URI ||| file
│   └── Separator (.)
├── Domain Name System (DNS)
│   ├── TLD (Top Level Domain)
│   │   ├── gov
│   │   ├── net
│   │   ├── org
│   │   └── com
│   ├── Hosting Services
│   ├── Index Domestic DNS
│   ├── Global DNS
│   │   ├── 8.8.8.8 (Google DNS)
│   │   └── 8.8.4.4 (Google DNS)
│   ├── Private Network
│   └── Public Network
├── Protocols & Ports
│   ├── HTTP (port 80)
│   ├── HTTPS
│   ├── SSH (port 22)
│   ├── FTP
│   ├── SMTP
│   └── Mail
├── Networking Components
│   ├── Client
│   ├── Server
│   ├── LAN
│   ├── ISP
│   ├── DHCP
│   ├── Router
│   ├── Network
│   ├── Host
│   └── Subdomain
├── Web Address Structure
│   ├── Protocol (http://)
│   ├── Port (e.g., 6500, 22, 80)
│   ├── Network
│   ├── Subdomain (www)
│   ├── Domain (abc.com)
│   ├── Separator (.)
│   └── Top Level Domain
├── Services & Activities
│   ├── Browsing
│   ├── Remote Access
│   ├── Wealth, Women, Wine (example hosting/services)
│   └── Crash in Past (www)
├── Useful Commands
│   ├── Connect to SSH
│   ├── tracepath -4 ec2-52-66-188-230.ap-south-1.compute.amazonaws.com
│   ├── traceroute ec2-52-66-188-230.ap-south-1.compute.amazonaws.com
│   ├── tracepath 52.66.188.230
│   ├── sudo apt install whois -y
│   └── whois cloudage.ae
```

---

## Essential Networking Commands

- **SSH Connection:**  
  `ssh user@host`

- **Trace Network Path (IPv4):**  
  `tracepath -4 `

- **Traceroute:**  
  `traceroute `

- **Install Whois Utility:**  
  `sudo apt install whois -y`

- **Whois Lookup:**  
  `whois `

---

## Example: Web Address Structure

| Component      | Example Value                    |
|----------------|----------------------------------|
| Protocol       | http://                          |
| Port           | 80, 22, 6500                     |
| Subdomain      | www                              |
| Domain         | abc.com                          |
| Separator      | .                                |
| TLD            | com, net, org, gov               |

---

## DNS Example

- **Domestic DNS:** Provided by local ISP.
- **Global DNS:** 8.8.8.8 (Google), 8.8.4.4 (Google).
- **Whois Lookup:** Shows domain registration info.

---

# 📡 Networking Concepts & Commands Cheat Sheet

## 🌐 1. Internet Connection Types

| Term                               | Meaning                                                                                          |
| ---------------------------------- | ------------------------------------------------------------------------------------------------ |
| **Dial-Up**                        | Internet over phone lines, very slow, legacy tech.                                               |
| **DSL (Digital Subscriber Line)**  | High-speed internet using telephone lines, faster than dial-up.                                  |
| **DSLAM (DSL Access Multiplexer)** | Device in telecom exchanges that connects DSL lines to the ISP's backbone.                       |
| **VSNL Gateway**                   | Legacy gateway by Videsh Sanchar Nigam Limited (now Tata Comm) to connect Indian users globally. |
| **Country Connection**             | Typically refers to how ISPs or backbones connect globally (via undersea cables, etc.).          |

---

## 🗂️ 2. File System & Address Concepts

| Term                                | Description                                                  |
| ----------------------------------- | ------------------------------------------------------------ |
| `/`                                 | Root directory in Linux.                                     |
| `root-local-hdd`                    | Local hard drive's root partition.                           |
| `\`                                 | Root in Windows file system.                                 |
| `URL (Uniform Resource Locator)`    | Example: `https://www.example.com/page`                      |
| `URI (Uniform Resource Identifier)` | Broader than URL; can identify a file, service, or web page. |
| `.`                                 | Separator used in domain names and file extensions.          |

---

## 🌍 3. DNS & Domains

| Concept                    | Description                                                         |
| -------------------------- | ------------------------------------------------------------------- |
| **TLD (Top Level Domain)** | The last part of a domain name: `.com`, `.org`, `.net`, `.gov`      |
| **Subdomain**              | `www` in `www.abc.com`                                              |
| **Domain Name**            | `abc.com`                                                           |
| **Global DNS**             | Google DNS: `8.8.8.8`, `8.8.4.4`                                    |
| **Private Network**        | Internal network, not accessible from outside (e.g., `192.168.x.x`) |
| **Public Network**         | Internet-accessible network                                         |
| **Index Domestic DNS**     | Refers to local DNS records or ISP-maintained DNS.                  |
| **Separator**              | `.` used in domain names like `www.example.com`                     |

---

## 🧱 4. Networking Components

| Component                    | Role                                                |
| ---------------------------- | --------------------------------------------------- |
| **Client**                   | Device requesting resources (e.g., browser, mobile) |
| **Server**                   | Provides resources (e.g., websites, files, APIs)    |
| **Router**                   | Forwards packets between networks                   |
| **DHCP**                     | Assigns IP addresses to devices dynamically         |
| **ISP**                      | Internet Service Provider                           |
| **LAN (Local Area Network)** | Private network in a small area (home, office)      |
| **Host**                     | Any device on a network with an IP address          |

---

## 🌐 5. Web Address Anatomy

| Element   | Example                                                              |
| --------- | -------------------------------------------------------------------- |
| Protocol  | `http://`, `https://`                                                |
| Port      | `22` (SSH), `80` (HTTP), `443` (HTTPS), `6500` (custom/app-specific) |
| Subdomain | `www`                                                                |
| Domain    | `abc.com`                                                            |
| TLD       | `.com`, `.net`, etc.                                                 |
| Separator | `.`                                                                  |
| Full URL  | `http://www.abc.com`                                                 |

---

## 🛠️ 6. Internet Services

| Service                 | Function                                               |
| ----------------------- | ------------------------------------------------------ |
| **Browsing**            | Accessing web pages                                    |
| **Remote Access**       | Using SSH/RDP to connect to a server                   |
| **Email (Mail)**        | Uses protocols like SMTP/POP3/IMAP                     |
| **Hosting Services**    | Host websites, apps (example: AWS, GoDaddy)            |
| **Wealth, Women, Wine** | Possibly metaphorical; ignore unless context-specific. |

---

## 🔐 7. Protocols & Ports

| Protocol  | Port   | Description               |
| --------- | ------ | ------------------------- |
| **HTTP**  | 80     | Web traffic (unencrypted) |
| **HTTPS** | 443    | Secure web traffic        |
| **SSH**   | 22     | Secure shell access       |
| **FTP**   | 21     | File transfer             |
| **SMTP**  | 25/587 | Email sending             |

---

## 🧪 8. Useful Networking Commands (Linux)

| Command                     | Description                    |
| --------------------------- | ------------------------------ |
| `ssh user@ip`               | Connect to server via SSH      |
| `tracepath -4 ec2-...`      | Trace network route using IPv4 |
| `traceroute domain`         | Detailed path a packet takes   |
| `tracepath IP`              | Simple path trace              |
| `sudo apt install whois -y` | Install `whois` tool           |
| `whois domain.com`          | Get domain registration info   |
| `ping domain.com`           | Check if a host is reachable   |
| `curl http://example.com`   | Fetch web page via terminal    |
| `nslookup example.com`      | DNS record lookup              |
| `dig example.com`           | Advanced DNS queries           |

---

## 💡 Examples

### 🔑 Connect to SSH

```bash
ssh -i "your-key.pem" ubuntu@your-ec2-ip
```

### 🌐 Whois Command

```bash
whois cloudage.ae
```

### 🔍 Trace Route

```bash
tracepath -4 ec2-52-66-188-230.ap-south-1.compute.amazonaws.com
traceroute ec2-52-66-188-230.ap-south-1.compute.amazonaws.com
tracepath 52.66.188.230
```

---

## 1. SSH and User Management

### SSH Connection with Verbose Output
```bash
ssh -vvv -i "C:/Users/admin/Downloads/cloudage.pem" ubuntu@172.31.13.220
```
- **-vvv**: Enables maximum verbosity for debugging SSH issues.
- **-i**: Specifies the private key file for authentication.
- **ubuntu@172.31.13.220**: Connects as user `ubuntu` to the given IP.

### Basic User Commands
```bash
sudo su         # Become root user
cd              # Go to home directory
passwd          # Change password for current user
id              # Show current user and group IDs
```

### Editing Sudoers File (Be Careful!)
```bash
sudo nano /etc/sudoers
```
- **Purpose:** To grant or modify sudo privileges.
- **Warning:** Syntax errors can lock you out of sudo! Prefer `sudo visudo` for safety.

---

## 2. User and Root Information

### What is the user ID of root?
- **Root user ID (UID):** `0`
- **Check with:** `id root` or `cat /etc/passwd | grep root`

### What is `sshd`?
- **sshd**: The SSH daemon (server) that listens for and handles SSH connections.

---

## 3. Linux File Structure and User Creation

### What is `/etc`?
- **/etc**: Directory for system configuration files (e.g., `hosts`, `sudoers`, `passwd`).

### Create a New User
```bash
sudo adduser newusername
```

---

## 4. System Updates

### Update and Upgrade
```bash
sudo apt update
sudo apt list --upgradable
sudo apt upgrade
```
- **`apt update`**: Refreshes the package list (does NOT install anything).
- **`apt list --upgradable`**: Shows packages that have newer versions available.
- **`apt upgrade`**: Installs available updates for packages.

---

## 5. System Info and File Operations

```bash
lsb_release -a   # Shows Linux distribution info
ls -a            # Lists all files, including hidden ones
ls -l            # Lists files with permissions and details
```

---

## 6. SSH Keys and Permissions

### Generate SSH Key Pair
```bash
ssh-keygen
```
- Creates `id_rsa` (private) and `id_rsa.pub` (public) in `~/.ssh/`

### Add Public Key to Authorized Keys
```bash
cat id_rsa.pub >> ~/.ssh/authorized_keys
```

### File Permissions (chmod)
| Command                 | Meaning                                    |
|-------------------------|--------------------------------------------|
| chmod 777 id_rsa.pub    | Read/write/execute for everyone (unsafe!)  |
| chmod 400 id_rsa.pub    | Read only for owner (secure for private key)|
| chmod 600 id_rsa.pub    | Read/write for owner (common for private key)|
| chmod 644 id_rsa.pub    | Owner read/write, others read              |
| chmod u+x id_rsa.pub    | Owner execute permission                   |
| chmod 888 id_rsa.pub    | Invalid (8 is not a valid permission digit)|
| chmod 111 id_rsa.pub    | Execute only for all                       |
| chmod 200 id_rsa.pub    | Write only for owner                       |
| chmod 100 id_rsa.pub    | Execute only for owner                     |
| chmod 222 id_rsa.pub    | Write only for all                         |

**Note:**  
- **Private keys should be 400 or 600.**  
- **Public keys can be 644.**

#### How to set chmod 400:
```bash
chmod 400 id_rsa
```

---

## 7. Editing Hosts File

```bash
sudo nano /etc/hosts
```
- Used for local hostname-to-IP mapping.

---

## 8. Java and Hadoop

### Install Java
```bash
sudo apt install openjdk-8-jre -y
sudo apt install openjdk-8-jdk-headless -y
java -version
which java
```

### Process Management
```bash
ps -a           # List running processes
ps -aux         # Detailed process list
ps -aux | grep jvm   # Filter for JVM processes
jps             # Java Virtual Machine Process Status Tool (if JDK installed)
```

### Hadoop Commands
```bash
sudo mv hadoop-1.2.1 /usr/local/hadoop   # Move Hadoop to standard location
nano .bashrc                            # Edit environment variables
echo $PATH                              # Show current PATH
sh start-dfs.sh                         # Start Hadoop DFS
stop-all.sh                             # Stop all Hadoop services
```

---

## 9. Tar Commands

```bash
tar -cvf archive.tar folder/    # Create tar
tar -xvf archive.tar            # Extract tar
```

---

## 10. Miscellaneous

- **ssh hostlocal**: Connect to host named "hostlocal" (must be defined in `/etc/hosts` or DNS).
- **ssh -i id_rsa.pub hostlocal**: Incorrect! Use private key (`id_rsa`), not public (`id_rsa.pub`).
- **bm xen linux**: Xen is a virtualization technology; "bm" likely means "bare metal".

---

## Summary Table: File Permissions (chmod)

| Permission | Numeric | Symbolic | Description                |
|------------|---------|----------|----------------------------|
| rwx------  | 700     | u=rwx    | Owner: all, Group/Other: - |
| rw-------  | 600     | u=rw     | Owner: rw, Group/Other: -  |
| r--------  | 400     | u=r      | Owner: r, Group/Other: -   |
| rw-r--r--  | 644     | u=rw,g=r,o=r | Common for public files |
| r--r--r--  | 444     | u=r,g=r,o=r  | Read-only for all       |
| ---x------ | 100     | u=x      | Owner: execute only        |
| --w--w--w- | 222     | u=w,g=w,o=w  | Write-only for all      |

---

## Best Practices

- **Never share your private key (`id_rsa`)!**
- **Always use correct permissions for SSH keys.**
- **Edit system files (`/etc/sudoers`, `/etc/hosts`) with care!**
- **Keep your system and packages updated.**

---