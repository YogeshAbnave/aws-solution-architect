````markdown
# 🌐 EC2 & Linux: Complete Reference Guide

## 🔹 1. Launching an EC2 Ubuntu Instance (Step-by-Step)

1. **Login** to AWS Management Console.
2. Navigate to **EC2 Dashboard** → Click **Launch Instance**.
3. **Choose Ubuntu OS** (e.g., Ubuntu Server 22.04 LTS).
4. **Create Key Pair**:
   - Click **Create New Key Pair**.
   - Select `.pem` format and download (e.g., `cloudage.pem`).
5. **Select Instance Type**: `t2.micro` (Free Tier).
6. **Configure Security Group**:
   - Allow SSH (TCP port 22).
7. **Launch Instance** using the selected key.

---

## 🔹 2. Connect to EC2 via SSH

From **Git Bash** or Terminal on Windows:
```bash
ssh -i "C:/Users/admin/Downloads/cloudage.pem" ubuntu@<public-ip>
````

Example:

```bash
ssh -i "C:/Users/admin/Downloads/cloudage.pem" ubuntu@ec2-52-66-188-230.ap-south-1.compute.amazonaws.com
```

---

## 🔹 3. Basic Linux Commands

### 🔸 `uname` – View System Information

```bash
uname -a
```

Options:

* `-s` – Kernel name
* `-r` – Kernel release
* `-v` – Kernel version
* `-m` – Machine hardware name
* `-o` – Operating system
* `--all` – Print all above info

### 🔸 `lscpu` – View CPU Architecture

```bash
lscpu
```

### 🔸 `sudo shutdown` – Shut down instance

```bash
sudo shutdown now           # Shut down immediately
sudo shutdown -c            # Cancel scheduled shutdown
```

---

## 🔹 4. OS Lifecycle Stages

| Stage    | Description                                 |
| -------- | ------------------------------------------- |
| Alpha    | Initial development, unstable.              |
| Beta     | Testing phase, bugs expected.               |
| Final    | Ready for release, mostly stable.           |
| Stable   | Stable version used in production.          |
| LTS      | Long-Term Support (e.g., Ubuntu 20.04 LTS). |
| Obsolete | No longer supported or maintained.          |
| Legend   | Legacy systems still referenced or used.    |

---

## 🔹 5. UNIX & Linux Origins

### 🌟 UNIX – The Mother of All OS

* Developed in **1969** at **Bell Labs**.
* Originally designed for **government, military, and research** use.
* Evolved into multiple variants: BSD, Solaris, HP-UX, etc.

### 🧠 Evolution Tree

```
UNIX
 ├── BSD
 ├── HP-UX
 ├── Sun Solaris
 ├── MINIX
 │    └── Influenced Linus Torvalds (Linux)
 └── GNU (Free Software)
      └── GNOME (GUI for GNU/Linux)
```

---

## 🔹 6. Linux vs UNIX vs GNU

| Feature          | UNIX                        | Linux                              |
| ---------------- | --------------------------- | ---------------------------------- |
| Origin           | Bell Labs                   | Linus Torvalds (inspired by MINIX) |
| License          | Proprietary                 | Open Source (GPL)                  |
| Hardware Binding | Tightly coupled with vendor | Hardware agnostic                  |
| GUI              | Optional (like CDE)         | GNOME, KDE                         |
| Cost             | Paid                        | Free                               |
| Customization    | Limited                     | Highly customizable                |

---

## 🔹 7. Richard Stallman & GNU

* Founded **Free Software Foundation**.
* Started the **GNU Project**: *"GNU's Not Unix"*.
* Advocated for **GPL (GNU Public License)**.
* Created key tools: `gcc`, `gdb`, `glibc`.

### GNU Ecosystem:

* Website: [https://www.gnu.org](https://www.gnu.org)
* GNOME: GNU's desktop environment (👣 footprint logo)
* Emphasizes **software freedom and user control**.

---

## 🔹 8. Linux Distributions (Distros)

### 🧪 Development

* **Fedora**
* **Debian Testing**
* **Arch Linux**

### 🚀 Production

* **CentOS**
* **Ubuntu LTS**
* **RHEL (Red Hat Enterprise Linux)**
* **SUSE Linux Enterprise**

### 📦 Other Distros

* **BSD** – UNIX-like, secure
* **MINIX** – Educational, microkernel-based
* **Solaris** – Oracle's UNIX OS
* **Noven** – Legacy

---

## 🔹 9. Repositories & Configuration

* **CentOS** and **RHEL** share many repositories.
* Repositories provide access to pre-compiled packages.

### Configure a Repo:

```bash
sudo vi /etc/yum.repos.d/myrepo.repo
```

---

## 🔹 10. Scientific and Enterprise Use Cases

* **Scientific Linux** – CERN’s customized OS.
* **Linux on Mainframes** – IBM Z series.
* **UNIX** – Still used in high-security & telecom.
* **VSNL, BSNL** – Early users of UNIX systems in India.

---

## ✅ Summary

| Task        | Command / Tool                                   |
| ----------- | ------------------------------------------------ |
| Launch EC2  | AWS Console → EC2 → Ubuntu → Key Pair → Launch   |
| Connect EC2 | `ssh -i path.pem ubuntu@<IP>`                    |
| CPU Info    | `lscpu`                                          |
| System Info | `uname -a`                                       |
| Shut Down   | `sudo shutdown -c` (cancel), `sudo shutdown now` |
| View Users  | `w`, `who`                                       |
| Domain Info | `whois domain.com`                               |

---

```
