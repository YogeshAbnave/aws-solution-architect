
---

### ✅ **Step-by-Step: Connect PuTTY to Ubuntu EC2 Instance**

---

### 🔹 **1. Download PuTTY and PuTTYgen**

* Go to: [https://www.chiark.greenend.org.uk/\~sgtatham/putty/latest.html](https://www.chiark.greenend.org.uk/~sgtatham/putty/latest.html)
* Download:

  * **PuTTY (.exe)** — for SSH connection
  * **PuTTYgen (.exe)** — to convert `.pem` to `.ppk`

---

### 🔹 **2. Convert `.pem` to `.ppk` using PuTTYgen**

1. Open **PuTTYgen**.
2. Click **Load**.
3. At the file type dropdown (bottom-right), change from `*.ppk` to **All Files**.
4. Select your EC2 **Key Pair** file (`.pem`) and click **Open**.
5. A message will appear: “Successfully imported foreign key.” → Click **OK**.
6. Click **Save private key**.

   * When prompted “Are you sure you want to save this key without a passphrase?” → Click **Yes**.
   * Name the file (e.g., `my-key.ppk`) and **save it** to a secure location.

---

### 🔹 **3. Configure PuTTY**

1. Open **PuTTY**.
2. In **Session** (left side panel), set:

   * **Host Name**: `ubuntu@<your-ec2-public-ip>`

     * Example: `ubuntu@18.189.3.59`
   * **Port**: `22`
   * **Connection type**: SSH
3. (Optional but recommended): In **Saved Sessions**, type a name like `UbuntuEC2`, then click **Save**.

---

### 🔹 **4. Load the `.ppk` Private Key**

1. In left-side panel, go to:

   * **Connection** → **SSH** → **Auth**
2. Click **Browse** and select the `.ppk` file you saved earlier.
3. (Optional): Go to **Session** again and click **Save** to keep this config.

---

### 🔹 **5. Connect to EC2**

1. Click **Open**.
2. A security alert may pop up on first connection → Click **Yes**.
3. You’ll now connect to your EC2 instance via SSH terminal.

---

### 🟢 **You're now connected to your Ubuntu EC2 instance using PuTTY!**

---



