
-----

# 🐳 Docker Setup, Maven Web App Deployment & Interview Guide

-----

## 📌 Why Docker?

Docker is a containerization platform that allows developers to package applications and their dependencies into standardized units called **containers**.

### ✅ Benefits:

  * Eliminates "It works on my machine" problems
  * Consistent environments (dev → prod)
  * Lightweight and faster than VMs
  * Easy rollbacks and deployments
  * Portable and scalable

-----

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

-----

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

-----

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

-----

## 🐳 Docker Build & Run

### 🔟 Build Docker Image

```bash
docker build -t shinchan .
```

### 🔁 Run Container with Port Mapping

```bash
docker run -d -p 8080:8080 --name shinchan-container shinchan
```

-----

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

-----

## 🔄 Port Mapping & Public Access

### 🎯 Port Mapping Explanation:

  * `-p 8080:8080` → Binds container’s 8080 to host’s 8080
  * Access App: `http://<public_ip>:8080/maven-web-app/`

-----

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

-----

## 📂 Docker Concepts

### 📌 WORKDIR

Sets the working directory inside the container (like `cd`).

```dockerfile
WORKDIR /app
```

-----

### 📦 Docker Volumes

For persistent data:

```bash
docker volume create myvol
docker run -v myvol:/data busybox
```

-----

### 🧱 Multi-Stage Build (Reduce Image Size)

```dockerfile
FROM maven:3.9.6 AS builder
WORKDIR /app
COPY . .
RUN mvn clean package

FROM tomcat:latest
COPY --from=builder /app/target/maven-web-app.war /usr/local/tomcat/webapps/
```

-----

### 📘 Docker Compose Example

```yaml
version: '3'
services:
  web:
    image: maven-web-app
    ports:
      - "8080:8080"
```

-----

## 🧠 Interview Questions & Answers

### 🔹 Docker Basics

1.  **What is Docker?**

      * **Answer:** Docker is an open-source platform that enables developers to build, ship, and run applications in a consistent and isolated environment using containerization. It packages an application and all its dependencies into a standard unit called a container.

2.  **How does Docker differ from a virtual machine?**

      * **Answer:**
          * **Virtual Machines (VMs):** Virtualize the *hardware*. Each VM runs its own full operating system (OS) on top of a hypervisor. This makes them heavier, slower to start, and consume more resources (RAM, CPU, disk space).
          * **Docker Containers:** Virtualize the *operating system*. Containers share the host OS kernel and only package the application, its libraries, and dependencies. They are lightweight, start quickly, and are more efficient in resource usage.

3.  **What is containerization?**

      * **Answer:** Containerization is a lightweight form of virtualization that packages an application along with its entire runtime environment (code, runtime, system tools, system libraries, and settings) into a self-contained, executable package called a container. This ensures that the application runs consistently across different computing environments.

### 🔹 Docker CLI & Execution

4.  **Difference between `docker ps` and `docker ps -a`?**

      * **Answer:**
          * `docker ps`: Lists only the *running* Docker containers.
          * `docker ps -a`: Lists *all* Docker containers, including running, stopped, and exited ones.

5.  **How to remove all stopped containers?**

      * **Answer:** `docker container prune` or `docker rm $(docker ps -aq)`

6.  **How to check logs of a container?**

      * **Answer:** `docker logs <container-name-or-id>` (e.g., `docker logs shinchan-container`)

### 🔹 Dockerfile

7.  **Explain `FROM`, `COPY`, `CMD`, `ENTRYPOINT`**

      * **Answer:**
          * `FROM`: Specifies the base image for the new image (e.g., `FROM ubuntu:22.04`). It must be the first instruction in a Dockerfile.
          * `COPY`: Copies files or directories from the host machine (build context) into the Docker image. (e.g., `COPY . /app`)
          * `CMD`: Provides default commands and arguments for an executing container. It can be overridden when running the container. Only the last `CMD` in a Dockerfile will be effective.
          * `ENTRYPOINT`: Configures a container that will run as an executable. Arguments provided with `docker run` are appended to the `ENTRYPOINT`. It's often used with `CMD` to provide default arguments.

8.  **What is the role of `EXPOSE`?**

      * **Answer:** `EXPOSE` informs Docker that the container listens on the specified network ports at runtime. It serves as documentation and doesn't actually publish the port. To map the port to the host, you need to use the `-p` or `--publish` flag with `docker run`.

9.  **What’s the difference between `WORKDIR` and `RUN cd`?**

      * **Answer:**
          * `WORKDIR`: Sets the working directory for any subsequent `RUN`, `CMD`, `ENTRYPOINT`, `COPY`, or `ADD` instructions in the Dockerfile. It persists for all subsequent layers.
          * `RUN cd`: Changes the directory *only for that specific `RUN` command*. It does not affect the working directory of subsequent instructions or the final image's default working directory.

### 🔹 Project Specific

10. **Why Tomcat as base image?**

      * **Answer:** Tomcat is chosen as the base image because the application is a Java web application packaged as a `.war` file. Tomcat is a widely used open-source web server and servlet container that is specifically designed to run Java web applications. Using a Tomcat base image provides the necessary runtime environment to deploy and execute the WAR file without needing to manually install and configure Tomcat within the container.

11. **How does the WAR deploy?**

      * **Answer:** In the provided Dockerfile, the `maven-web-app.war` file is copied directly into `usr/local/tomcat/webapps/`. Tomcat, by default, automatically detects and deploys WAR files placed in its `webapps` directory upon startup. When the container starts, Tomcat initializes and makes the web application available.

12. **What does port mapping achieve?**

      * **Answer:** Port mapping (`-p 8080:8080`) allows traffic from a specific port on the Docker host machine (the first `8080`) to be forwarded to a specific port inside the Docker container (the second `8080`). Without port mapping, the application running inside the container on port 8080 would not be accessible from outside the host machine. It essentially creates a bridge for network communication.

13. **How would you reduce Docker image size?**

      * **Answer:**
          * **Multi-stage builds:** This is the most effective way. Use one stage to build the application (e.g., with Maven) and a separate, smaller stage to package only the necessary runtime artifacts (e.g., the WAR file onto a Tomcat base image), discarding build tools and intermediate files.
          * **Use smaller base images:** Opt for minimal images like Alpine versions of official images (e.g., `tomcat:jre8-alpine` instead of `tomcat:latest`).
          * **Combine `RUN` commands:** Chain multiple `RUN` commands with `&&` to reduce the number of layers.
          * **Clean up after `RUN` commands:** Remove caches, temporary files, and unnecessary dependencies immediately after installing them in the same `RUN` command.
          * **Use `.dockerignore`:** Exclude unnecessary files and directories (like `.git`, `target/`, `.idea/`) from the build context.

### 🔹 CI/CD

14. **How would you integrate Docker with Jenkins?**

      * **Answer:**
          * **Install Docker on Jenkins Agent:** The Jenkins agent (or master, though not recommended for production) needs Docker installed.
          * **Grant Jenkins User Docker Permissions:** Add the `jenkins` user to the `docker` group (`sudo usermod -aG docker jenkins`) and restart Jenkins.
          * **Use `sh` step in `Jenkinsfile`:** As shown in the sample, `sh` steps can directly execute Docker commands (e.g., `docker build`, `docker run`).
          * **Docker Pipeline Plugin:** For more advanced scenarios, the Docker Pipeline plugin provides Groovy DSL steps (`docker.build()`, `docker.run()`, etc.) for better integration and image management.
          * **Containerizing Jenkins itself:** Jenkins can also run as a Docker container, often using a Docker-in-Docker setup for building other Docker images.

15. **Explain the `Jenkinsfile` stages.**

      * **Answer:**
          * **`Clone`:** This stage is responsible for fetching the source code of the application from the specified Git repository (`https://github.com/badshahgit/maven-web-app`). This ensures the build uses the latest code.
          * **`Build WAR`:** In this stage, Maven is used to compile the Java web application and package it into a `.war` file (`mvn clean package`). This produces the deployable artifact.
          * **`Docker Build & Deploy`:** This final stage performs the Docker operations:
              * `docker build -t maven-web-app .`: Builds a new Docker image from the Dockerfile in the current directory, tagging it as `maven-web-app`.
              * `docker stop maven-web-app || true`: Attempts to stop any existing container named `maven-web-app`. The `|| true` ensures the pipeline doesn't fail if the container doesn't exist.
              * `docker rm maven-web-app || true`: Attempts to remove any stopped container named `maven-web-app`. Again, `|| true` prevents failure if it doesn't exist.
              * `docker run -d -p 8080:8080 --name maven-web-app maven-web-app`: Runs a new Docker container in detached mode (`-d`), mapping port 8080 from the host to 8080 in the container, names the container `maven-web-app`, and uses the newly built `maven-web-app` image. This deploys the application.

16. **What are common security practices for Docker containers?**

      * **Answer:**
          * **Use minimal base images:** As discussed, smaller images reduce the attack surface.
          * **Don't run as root:** Use the `USER` instruction in Dockerfile to run processes as a non-root user.
          * **Scan images for vulnerabilities:** Use tools like Clair, Trivy, or Docker Scout to scan images for known CVEs.
          * **Regularly update base images:** Keep your base images up-to-date to get security patches.
          * **Avoid sensitive information in images:** Don't bake secrets (API keys, passwords) directly into the image; use Docker secrets or environment variables (with caution).
          * **Minimize exposed ports:** Only expose necessary ports.
          * **Implement proper logging and monitoring:** Collect container logs and monitor for suspicious activity.
          * **Limit resource usage:** Use `--memory`, `--cpus`, etc., with `docker run` to prevent resource exhaustion attacks.
          * **Use trusted registries:** Pull images from trusted public or private registries.
          * **Sign and verify images:** Use Docker Content Trust to ensure the integrity and authenticity of images.

-----

## 🧾 Full Terminal Command History (Recap)

```bash
sudo dnf remove docker docker-client docker-client-latest docker-common docker-latest docker-latest-logrotate docker-logrotate docker-engine podman runc
yum update
sudo yum install docker # Corrected typo: "insatll" to "install"
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

-----