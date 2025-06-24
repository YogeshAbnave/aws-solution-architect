
---

# 🐳 Docker Setup, Maven Web App Deployment & Interview Guide

---

## 📌 Why Docker?

Docker is a containerization platform that allows developers to package applications and their dependencies into standardized units called **containers**.

### ✅ Benefits:

* Eliminates "It works on my machine" problems
* Consistent environments (dev → prod)
* Lightweight and faster than VMs
* Easy rollbacks and deployments
* Portable and scalable

---

## 🔧 Step-by-Step Docker Setup (CentOS / RHEL)

### 1️⃣ Remove Old Docker, Podman, and Dependencies

```bash
sudo su -
sudo dnf remove docker \
    docker-client \
    docker-client-latest \
    docker-common \
    docker-latest \
    docker-latest-logrotate \
    docker-logrotate \
    docker-engine \
    podman \
    runc
```

### 2️⃣ Update System

```bash
yum update -y
```

### 3️⃣ Install Docker

```bash
sudo yum install docker -y
```

### 4️⃣ Start Docker

```bash
sudo systemctl start docker
sudo systemctl enable docker
sudo systemctl status docker
```

---

## ☕ Java & Maven Setup

### 5️⃣ Install Java (JDK 8 & 11 for compatibility)

```bash
sudo yum install java-11-openjdk-devel -y
sudo yum install java-1.8.0-openjdk-devel -y
java -version
```

### 6️⃣ Install Apache Maven

```bash
cd /opt
sudo curl -O https://archive.apache.org/dist/maven/maven-3/3.9.6/binaries/apache-maven-3.9.6-bin.tar.gz
sudo tar -xvzf apache-maven-3.9.6-bin.tar.gz
sudo mv apache-maven-3.9.6 /opt/maven
sudo nano /etc/profile.d/maven.sh
```

#### Add to `maven.sh`:

```bash
export M2_HOME=/opt/maven
export PATH=${M2_HOME}/bin:${PATH}
```

```bash
source /etc/profile.d/maven.sh
mvn -version
```

---

## 🌐 Project Setup: Maven Web App Deployment

### 7️⃣ Clone & Prepare the Project

```bash
git clone https://github.com/badshahgit/maven-web-app.git
cd maven-web-app
```

### 8️⃣ Build WAR File

```bash
mvn clean package
```

(If necessary, create target directory manually)

```bash
mkdir target
```

### 9️⃣ Verify WAR File

```bash
ls -l target/maven-web-app.war
```

---

## 🐳 Docker Build & Run

### 🔟 Build Docker Image

```bash
docker build -t shinchan .
```

### 🔁 Run Container with Port Mapping

```bash
docker run -d -p 8080:8080 --name shinchan-container shinchan
```

---

## 🧪 Verify Container

### 🔍 Check Images, Containers

```bash
docker images
docker ps
docker ps -a
docker logs shinchan-container
```

### 🔐 Access Inside Container

```bash
docker exec -it shinchan-container /bin/bash
```

---

## 🔄 Port Mapping & Public Access

### 🎯 Port Mapping Explanation:

* `-p 8080:8080` → Binds container’s 8080 to host’s 8080
* Access App: `http://<public_ip>:8080/maven-web-app/`

---

## 🤖 Docker + Jenkins CI/CD Pipeline

### 🧱 Sample `Jenkinsfile`

```groovy
pipeline {
    agent any

    stages {
        stage('Clone') {
            steps {
                git 'https://github.com/badshahgit/maven-web-app'
            }
        }

        stage('Build WAR') {
            steps {
                sh 'mvn clean package'
            }
        }

        stage('Docker Build & Deploy') {
            steps {
                sh '''
                docker build -t maven-web-app .
                docker stop maven-web-app || true
                docker rm maven-web-app || true
                docker run -d -p 8080:8080 --name maven-web-app maven-web-app
                '''
            }
        }
    }
}
```

---

## 📂 Docker Concepts

### 📌 WORKDIR

Sets the working directory inside the container (like `cd`).

```dockerfile
WORKDIR /app
```

---

### 📦 Docker Volumes

For persistent data:

```bash
docker volume create myvol
docker run -v myvol:/data busybox
```

---

### 🧱 Multi-Stage Build (Reduce Image Size)

```dockerfile
FROM maven:3.9.6 AS builder
WORKDIR /app
COPY . .
RUN mvn clean package

FROM tomcat:latest
COPY --from=builder /app/target/maven-web-app.war /usr/local/tomcat/webapps/
```

---

### 📘 Docker Compose Example

```yaml
version: '3'
services:
  web:
    image: maven-web-app
    ports:
      - "8080:8080"
```

---

## 🧠 Interview Questions

### 🔹 Docker Basics

1. What is Docker?
2. How does Docker differ from a virtual machine?
3. What is containerization?

### 🔹 Docker CLI & Execution

4. Difference between `docker ps` and `docker ps -a`?
5. How to remove all stopped containers?
6. How to check logs of a container?

### 🔹 Dockerfile

7. Explain `FROM`, `COPY`, `CMD`, `ENTRYPOINT`
8. What is the role of `EXPOSE`?
9. What’s the difference between `WORKDIR` and `RUN cd`?

### 🔹 Project Specific

10. Why Tomcat as base image?
11. How does the WAR deploy?
12. What does port mapping achieve?
13. How would you reduce Docker image size?

### 🔹 CI/CD

14. How would you integrate Docker with Jenkins?
15. Explain the `Jenkinsfile` stages.
16. What are common security practices for Docker containers?

---

## 🧾 Full Terminal Command History (Recap)

```bash
sudo dnf remove docker docker-client docker-client-latest docker-common docker-latest docker-latest-logrotate docker-logrotate docker-engine podman runc
yum update
yum insatll docker
sudo yum install docker
docker images
service docker status
service docker start
docker ps -a
docker ps
ll
docker version
git clone https://github.com/badshahgit/maven-web-app.git
cd maven-web-app/
cat Dockerfile
mvn clean package
sudo yum install java-11-openjdk-devel -y
sudo yum install java-1.8.0-openjdk-devel -y
java -version
cd /opt
sudo curl -O https://archive.apache.org/dist/maven/maven-3/3.9.6/binaries/apache-maven-3.9.6-bin.tar.gz
sudo tar -xvzf apache-maven-3.9.6-bin.tar.gz
sudo mv apache-maven-3.9.6 /opt/maven
sudo nano /etc/profile.d/maven.sh
source /etc/profile.d/maven.sh
mvn -version
mkdir target
ls -l target/maven-web-app.war
docker build -t shinchan .
docker run -d -p 8080:8080 --name shinchan-container shinchan
docker ps
docker exec -it shinchan-container /bin/bash
```

---

