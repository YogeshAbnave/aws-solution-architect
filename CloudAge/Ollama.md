Perfect ✅ Yogesh.
You’ve provided the **complete Ollama installation guide (manual + automated)** and now you want it transformed into a **clean, structured document** with **ASCII architecture diagram** — showing the full deployment flow of **Ollama + Open-WebUI + Docker** on a Linux instance.

Below is your **formatted, interview-ready documentation**, preserving **every single command** and adding a **clear ASCII architecture** showing the system design.

---

# 🦙 **Complete Ollama + Open-WebUI Installation & Architecture Guide**

---

## 🧩 **Overview**

This guide explains how to install and configure **Ollama** (for running local LLMs like DeepSeek, Llama, Qwen) and **Open-WebUI** (for browser-based chat interface) on an **Ubuntu instance**.
It provides **two methods** — a **manual setup** and a **fully automated script**.

Both methods deploy **Ollama (Snap)** and **Open-WebUI (Docker)** on the same system, making it easy to host, run, and interact with local LLMs through a web interface.

---

## ⚙️ **Architecture Overview (ASCII)**

```
                     ┌────────────────────────────┐
                     │        User Browser        │
                     │  Access via:               │
                     │  http://<IPv4>:8080/       │
                     └─────────────┬──────────────┘
                                   │
                    HTTP (Port 8080) ↕ WebSocket
                                   │
                     ┌─────────────▼──────────────┐
                     │      Open-WebUI (Docker)   │
                     │----------------------------│
                     │ - Frontend Chat Interface  │
                     │ - Backend for LLM API Calls│
                     │ - Mounted Volume:          │
                     │   /app/backend/data        │
                     │ - Env: OLLAMA_BASE_URL     │
                     └─────────────┬──────────────┘
                                   │
                     REST API (Port 11434)
                                   │
                     ┌─────────────▼──────────────┐
                     │       Ollama Service       │
                     │----------------------------│
                     │ - Installed via Snap       │
                     │ - Runs Local LLM Models    │
                     │ - Example: deepseek-r1:8b  │
                     │ - Exposes API on 11434     │
                     └─────────────┬──────────────┘
                                   │
                                   │
                          Local Linux Instance
                        (Ubuntu EC2 / Bare Metal)
                                   │
                                   │
                      ┌────────────▼──────────────┐
                      │   System Components       │
                      │---------------------------│
                      │ - Snap (for Ollama)       │
                      │ - Docker Engine           │
                      │ - curl, ss, bash, snapd   │
                      │ - make_script.sh script   │
                      └───────────────────────────┘
```

---

## 📘 **Manual Installation Commands (`ollama.txt`)**

### 🔹 Script Transfer Method

```bash
# Send Scripts To The Instance:
scp -i chabi.cer make_script.sh cleanup_script.sh ubuntu@<YOUR_IP>:/home/ubuntu
chmod +x make_script.sh cleanup_script.sh
./make_script.sh
# Viola!
```

---

### 🔹 Manual Installation Steps

```bash
# Update system packages
sudo apt update

# Install Ollama
sudo snap install ollama
ollama --version
ollama run deepseek-r1:8b

# Install Docker
sudo snap install docker

# Run Open-WebUI Docker container
sudo docker run -d \
  --network host \
  --name open-webui \
  -p 3000:8080 \
  -e OLLAMA_BASE_URL=http://localhost:11434 \
  -v open-webui:/app/backend/data \
  --add-host=host.docker.internal:host-gateway \
  --restart always \
  ghcr.io/open-webui/open-webui:main

# Access the application
# Go To http://<YOUR_MACHINE_IPv4>:8080/
# Viola!
```

---

### 🔹 Troubleshooting Commands

```bash
# Docker Container Management
sudo docker stop open-webui    # Stops Docker Container
sudo docker start open-webui   # Starts Docker Container
sudo docker rm -f open-webui   # Remove Docker Container

# Ollama Service Verification
sudo ss -tnlp | grep ollama     # Check Ollama Is Running On Port 11434
curl http://localhost:11434/api/tags  # Check If Correct Output Is Visible

# Model Management
ollama rm deepseek-r1:8b        # If while installing new model storage runs out

# Ollama Service Control
sudo snap stop ollama           # To Stop Ollama
sudo snap start ollama          # To Start Ollama
```

---

## 🤖 **Automated Installation Script (`make_script.sh`)**

```bash
#!/bin/bash

# Ollama and Open-WebUI Installation Script
# This script installs Ollama, Docker, and sets up Open-WebUI

set -e  # Exit on any error

echo "🚀 Starting Ollama and Open-WebUI setup..."

# Update system packages
echo "📦 Updating system packages..."
sudo apt update

# Install Ollama
echo "🦙 Installing Ollama..."
sudo snap install ollama

# Check Ollama version
echo "✅ Checking Ollama installation..."
ollama --version

# Install Docker
echo "🐳 Installing Docker..."

# Ask user for model selection
echo ""
echo "🤖 Choose an Ollama model to install:"
echo "1) deepseek-r1:8b (Recommended - 8B parameters)"
echo "2) deepseek-r1:14b (Larger model - 14B parameters)"
echo "3) deepseek-r1:32b (Large model - 32B parameters)"
echo "4) llama3.2:3b (Lightweight - 3B parameters)"
echo "5) llama3.2:8b (Balanced - 8B parameters)"
echo "6) qwen2.5:7b (Alternative - 7B parameters)"
echo "7) Custom model (enter manually)"
echo "8) Skip model installation"
echo ""

while true; do
    read -p "Enter your choice (1-8): " model_choice
    
    case $model_choice in
        1) MODEL_NAME="deepseek-r1:8b"; break ;;
        2) MODEL_NAME="deepseek-r1:14b"; break ;;
        3) MODEL_NAME="deepseek-r1:32b"; break ;;
        4) MODEL_NAME="llama3.2:3b"; break ;;
        5) MODEL_NAME="llama3.2:8b"; break ;;
        6) MODEL_NAME="qwen2.5:7b"; break ;;
        7)
            read -p "Enter custom model name (e.g., llama3:7b): " MODEL_NAME
            if [[ -n "$MODEL_NAME" ]]; then break
            else echo "❌ Model name cannot be empty. Please try again."; fi ;;
        8) MODEL_NAME=""; break ;;
        *) echo "❌ Invalid choice. Please enter 1-8." ;;
    esac
done

# Download and run selected model
if [[ -n "$MODEL_NAME" ]]; then
    echo "🔥 Downloading and running model: $MODEL_NAME"
    echo "⚠️  This may take several minutes depending on model size..."
    ollama run "$MODEL_NAME"
    echo "✅ Model $MODEL_NAME installed successfully!"
else
    echo "⏩ Skipping model installation"
fi

# Run Open-WebUI Docker container
echo "🌐 Setting up Open-WebUI..."
sudo docker run -d \
    --network host \
    --name open-webui \
    -p 3000:8080 \
    -e OLLAMA_BASE_URL=http://localhost:11434 \
    -v open-webui:/app/backend/data \
    --add-host=host.docker.internal:host-gateway \
    --restart always \
    ghcr.io/open-webui/open-webui:main

# Wait for container to start
echo "⏳ Waiting for Open-WebUI to start..."
sleep 10

# Get machine IP address
MACHINE_IP=$(curl ifconfig.me | awk '{print $1}')

# Verify Ollama is running
echo "🔍 Verifying Ollama service..."
if sudo ss -tnlp | grep -q ollama; then
    echo "✅ Ollama is running on port 11434"
else
    echo "⚠️  Warning: Ollama might not be running properly"
fi

# Test Ollama API
echo "🧪 Testing Ollama API..."
if curl -s http://localhost:11434/api/tags > /dev/null; then
    echo "✅ Ollama API is responding"
else
    echo "⚠️  Warning: Ollama API is not responding"
fi

echo ""
echo "🎉 Installation complete!"
echo "🔗 Access Open-WebUI at: http://$MACHINE_IP:8080/"
echo "🔗 Or use: http://localhost:8080/"
echo ""
echo "💡 If you encounter issues, check the troubleshooting section in cleanup.sh"
```

---

## 🌐 **Access URLs**

| Type                | URL                                |
| ------------------- | ---------------------------------- |
| **External Access** | `http://<YOUR_MACHINE_IPv4>:8080/` |
| **Local Access**    | `http://localhost:8080/`           |

---

## 🧠 **Available Models**

| Model             | Description                       |
| ----------------- | --------------------------------- |
| `deepseek-r1:8b`  | Recommended – 8B parameters       |
| `deepseek-r1:14b` | Larger model – 14B parameters     |
| `deepseek-r1:32b` | Very large model – 32B parameters |
| `llama3.2:3b`     | Lightweight version               |
| `llama3.2:8b`     | Balanced medium-size model        |
| `qwen2.5:7b`      | Alternative model option          |

---

## 🔌 **Key Ports**

| Service                     | Port        | Description               |
| --------------------------- | ----------- | ------------------------- |
| **Ollama API**              | 11434       | Model inference endpoint  |
| **Open-WebUI**              | 8080        | Web interface port        |
| **Docker internal mapping** | 3000 → 8080 | Container to host mapping |

---

Would you like me to **export this as a `.md` file** (for GitHub or documentation) or a **.docx file** (for interviews and PDF conversion)?
