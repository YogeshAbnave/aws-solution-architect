

---

# 🐧 Beginner's Guide to Linux Commands and Kernel Info

## 📌 What is Linux?

* **Linux** is the **kernel** of various operating systems (distros) such as Ubuntu, RHEL, Debian, Fedora, etc.
* It's open-source and maintained by **kernel.org**, with tools and packages from **gnu.org** and server tools from **apache.org**.

## 🌐 Versioning and Platform Support

### 🔍 Kernel Version Example (2.6.x)

```bash
uname -a
```

* **OS**: Linux
* **FQDN**: Fully Qualified Domain Name
* **Kernel Version**: e.g., 2.6.18

  * `2.6` = Major version
  * `.18` = Minor version
  * Patch info added by distro vendors
* **Date & Time**: Kernel compile time

### 💻 Platform & Virtualization Support

| Distro              | Physical CPUs | Virtual Guests |
| ------------------- | ------------- | -------------- |
| RHEL/Debian (Basic) | 2 (Sockets)   | 4              |
| RHEL (Advanced)     | Unlimited     | Unlimited      |

> 📝 Third-party virtualization software (like VMware) not included in limits.

### ✅ Supported Architectures

* Intel 32/64-bit
* AMD 32/64-bit
* IBM POWER, z-series, S/390

### 🖥️ Common Use-Cases

* File & Print Server
* Web Server
* Infrastructure (DNS, DHCP)
* Application Server (Tomcat, WebLogic, etc.)
* Database Server (MySQL, PostgreSQL, Oracle)
* Clustering

---

## 🛠️ Basic Linux Commands with Descriptions

| Command       | Description                                              |
| ------------- | -------------------------------------------------------- |
| `tty`         | Shows current terminal device name                       |
| `whoami`      | Displays current logged-in user                          |
| `which <cmd>` | Shows path of the executable                             |
| `echo`        | Prints strings or variable values to STDOUT              |
| `echo $PATH`  | Shows system PATH variable                               |
| `set`         | Displays and sets shell variables                        |
| `clear`       | Clears the terminal screen                               |
| `reset`       | Resets terminal settings                                 |
| `history`     | Shows command history                                    |
| `!<number>`   | Executes the Nth command from history                    |
| `pwd`         | Prints working directory                                 |
| `cd`          | Change directories (e.g., `cd ..` to go up)              |
| `ls`          | Lists files in current or specified directory            |
| `cat`         | Displays file content                                    |
| `mkdir`       | Creates directory (e.g., `mkdir -p a/b/c`)               |
| `cp`          | Copies files/directories                                 |
| `mv`          | Moves or renames files                                   |
| `rm`          | Removes files or directories (`-rf` for recursive force) |
| `touch`       | Creates empty file or updates timestamp                  |
| `stat`        | Shows detailed file info                                 |
| `find`        | Searches for files                                       |
| `alias`       | Creates command aliases                                  |

---

## 🔁 Redirection & Piping

### 🔽 Input Redirection `<`

```bash
cat < input.txt
```

* Reads from file instead of keyboard input.

### 🔼 Output Redirection `>`

```bash
cat file.txt > output.txt
```

* Overwrites output.txt with file.txt content.

### ➕ Append Output `>>`

```bash
cat file.txt >> output.txt
```

* Appends content if file exists.

### 🔗 Pipe `|`

```bash
cat file.txt | grep "pattern"
```

* Sends output of one command as input to another.

---

## 🔗 Command Chaining

| Operator | Description                        |    |                                 |
| -------- | ---------------------------------- | -- | ------------------------------- |
| `;`      | Run commands sequentially          |    |                                 |
| `&&`     | Run next only if previous succeeds |    |                                 |
| \`       |                                    | \` | Run next only if previous fails |

```bash
cat file.txt ; ls -l
cat file.txt && echo "Success"
cat file.txt || echo "Failed"
```

---

## 📄 File Viewing Utilities

| Command | Description                  |
| ------- | ---------------------------- |
| `more`  | View file one page at a time |
| `less`  | View large files efficiently |
| `head`  | Show beginning lines         |
| `tail`  | Show ending lines            |
| `wc -l` | Count lines in file          |
| `file`  | Determines file type         |

---

## 🧪 Other Useful Commands

| Command | Example                  | Description                                |
| ------- | ------------------------ | ------------------------------------------ |
| `seq`   | `seq 1000 > numbers.txt` | Generate sequence of numbers               |
| `su`    | `su -`                   | Switch user (to root if no user specified) |

---

> 🔎 **Tip:** Hidden files in Linux start with a dot (`.`), e.g., `.bashrc`, `.bash_history`.

> 💡 **Tab Completion** in Bash helps auto-complete commands or file names.

> 💬 **Copy-Paste in GNOME Terminal**:

* Ctrl+Shift+C to copy
* Ctrl+Shift+V to paste

---
