## AWS to Oracle Cloud (OCI) Migration Using Rclone: Complete Beginner-Friendly Guide

This end-to-end documentation merges all details for migrating an Ubuntu VM from AWS to Oracle Cloud Infrastructure (OCI) using Rclone. It includes architecture, prerequisites, step-by-step procedures, commands, configuration, and best practices for a smooth migration process.

---

## **1. Objectives**

- Prepare an Ubuntu VM in AWS for migration to OCI.
- Export the prepared VM as an image to Amazon S3.
- Transfer the image to OCI Object Storage using Rclone.
- Create a custom image in OCI and launch a new instance from it.
- (Optional) Set up VPN connectivity for secure, production-grade transfers.

---

## **2. Prerequisites**

- AWS account with S3, EC2 access, and API keys.
- OCI account with access to Object Storage, Compute, IAM, and API keys.
- Security group and VCN subnet setup in both clouds.
- Ubuntu 22.04 AMI on AWS (exportable).
- Oracle Linux VM on OCI (for Rclone operations).
- AWS CLI and OCI CLI access (CloudShell or local setup).
- SSH key pairs for both AWS and OCI.

---

## **3. Architecture Overview**

```
AWS (Mumbai)                OCI (ap-mumbai-1)
+---------------------+     +------------------------+
| EC2 Ubuntu VM       |     | Compute Instance       |
| Boot Volume         |     | (Oracle Linux + Rclone)|
|  |                  |     |                        |
|  v                  |     |                        |
| Snapshot            |     |                        |
|  |                  |     |                        |
|  v                  |     |                        |
| Export Image        |     |                        |
|  |                  |     |                        |
|  v                  |     |                        |
| S3 Bucket           || OCI Object Storage     |
+---------------------+     +------------------------+
```

- **Image transfer** is performed via Rclone over the internet or a VPN.
- For production, use Site-to-Site VPN or FastConnect for security and performance[1].

---

## **4. Step-by-Step Migration**

### **Step 1: Prepare Data Transfer Infrastructure**

#### **1.1. Create Storage Buckets**

- **Amazon S3 Bucket:**
  - Enable Access Control Lists (ACLs).
  - Block all public access.
  - Attach a region-specific custom ACL to allow image export (use AWS documentation for canonical IDs).
- **OCI Object Storage Bucket:**
  - Create a bucket in the standard storage tier for receiving the VM disk image[1].

#### **1.2. Install and Configure Rclone**

- **Install Rclone on OCI VM:**
  ```bash
  sudo -v ; curl https://rclone.org/install.sh | sudo bash
  ```
- **Configure Rclone Remotes:**
  ```bash
  rclone config
  ```
  - **Amazon S3 Remote:**
    - Name: e.g., `aws-s3`
    - Type: S3
    - Provider: AWS
    - Enter Access Key, Secret Key, Region, Location Constraint, ACL (set to `private`).
  - **OCI Remote:**
    - Name: e.g., `oci-remote`
    - Type: Oracle Object Storage
    - Auth: `user_principal_auth` (using OCI user and API signing keys)
    - Enter Namespace, Compartment OCID, Region, Endpoint (`https://.objectstorage..oci.customer-oci.com/n/`)
    - Ensure `~/.oci/config` and API keys are set up.
  - **Verify Configuration:**
    ```bash
    cat ~/.config/rclone/rclone.conf
    ```
  - **Test Connections:**
    ```bash
    rclone lsd aws-s3:
    rclone lsd oci-remote:
    ```


---

### **Step 2: Prepare AWS Source VM**

#### **2.1. Snapshot the Boot Volume**
- Take a snapshot before making changes:
  ```bash
  aws ec2 create-snapshot --volume-id 
  ```


#### **2.2. Enable Serial Console**
- Edit `/etc/default/grub.d/50-cloudimg-settings.cfg` and `/etc/default/grub`:
  - Ensure:
    - `GRUB_TIMEOUT_STYLE` is commented or set to `menu`
    - `GRUB_TIMEOUT` > 0
    - `GRUB_CMDLINE_LINUX` includes `console=tty1 console=ttyS0,115200`
    - `GRUB_TERMINAL="serial console"`
    - `GRUB_SERIAL_COMMAND="serial --unit=0 --speed=115200"`
  - Update GRUB:
    ```bash
    sudo update-grub
    ```


#### **2.3. Check Paravirtualization (VirtIO) Drivers**
- Check kernel:
  ```bash
  sudo grep -i virtio /boot/config-$(uname -r)
  ```
- Check initramfs:
  ```bash
  sudo lsinitramfs /boot/initrd.img-$(uname -r) | grep virtio
  ```
- If missing, add drivers:
  ```bash
  sudo dracut -v -f --add-drivers "virtio virtio_pci virtio_scsi" /boot/initramfs-$(uname -r).img $(uname -r)
  ```


#### **2.4. Configure Networking**
- Edit Netplan config:
  ```bash
  sudo vi /etc/netplan/50-cloud-init.yaml
  ```
  - Ensure DHCP is used, and MAC address references are removed.
  - Apply changes:
    ```bash
    sudo netplan apply
    ```


---

### **Step 3: Export AWS VM Image to S3**

- Stop the EC2 instance.
- Export as VMDK/OVA to S3:
  ```bash
  aws ec2 create-instance-export-task \
    --instance-id  \
    --target-environment vmware \
    --export-to-s3-task DiskImageFormat=vmdk,ContainerFormat=ova,S3Bucket=
  ```
- Monitor export:
  ```bash
  aws ec2 describe-export-tasks --export-task-ids 
  ```
  - Disk Image Format: VMDK (required by OCI)
  - Container Format: OVA
  - Target Environment: vmware[1]

---

### **Step 4: Transfer Image from S3 to OCI Object Storage**

- SSH into the OCI VM with Rclone configured.
- Transfer the image:
  ```bash
  rclone copy aws-s3:/ oci-remote: -vv
  ```


---

### **Step 5: Import Image in OCI and Launch Instance**

- In OCI Console, go to Compute → Custom Images → Import Image.
  - Compartment: Select as needed.
  - Name: Enter a name for the custom image.
  - OS: Ubuntu
  - Source: Import from Object Storage bucket (select bucket and image file).
  - Launch Mode: Paravirtualized
- Click **Import image**.
- Once imported, create a new VM instance from this image.
  - Use the same SSH key as AWS (convert `.pem` to `.pem.pub` if needed).
  - Username: `ubuntu`
  - SSH into the VM:
    ```bash
    ssh -i pathToKey/keyfile ubuntu@
    ```


---

## **6. Best Practices and Notes**

- Always block public access to S3 buckets.
- Use VPN or FastConnect for secure, large transfers.
- Use Rclone’s verbose mode (`-vv`) for troubleshooting.
- For production, automate steps with scripts or orchestration tools.
- Use Load Balancer and ACM for HTTPS in production environments.
- Always test the process with a non-production VM first[1].

---

## **7. Reference Commands Summary**

| Task                     | Command Example                                            |
|--------------------------|-----------------------------------------------------------|
| Install Rclone           | `curl https://rclone.org/install.sh \| sudo bash`         |
| Configure Rclone         | `rclone config`                                           |
| List S3 buckets          | `rclone lsd aws-s3:`                                      |
| Copy image S3 → OCI      | `rclone copy aws-s3:bucket/file oci-remote:bucket -vv`    |
| Update Ubuntu            | `sudo apt update`                                         |
| Install Apache           | `sudo apt install apache2 -y`                             |
| Edit GRUB config         | `sudo vi /etc/default/grub`                               |
| Update GRUB              | `sudo update-grub`                                        |
| Edit Netplan             | `sudo vi /etc/netplan/50-cloud-init.yaml`                 |
| Apply Netplan            | `sudo netplan apply`                                      |
| Check VirtIO             | `sudo grep -i virtio /boot/config-$(uname -r)`            |

---


## AWS to Oracle Cloud (OCI) Migration Using Rclone: Step-by-Step Guide with All Necessary Commands

This comprehensive guide includes every required command for migrating an Ubuntu VM from AWS to Oracle Cloud Infrastructure (OCI) using Rclone. Each step is detailed for beginners, covering preparation, export, transfer, and import.

---

## **1. Prerequisites**

- AWS and OCI accounts with appropriate permissions.
- AWS CLI and OCI CLI installed (or use AWS CloudShell).
- SSH key pairs for both clouds.
- Ubuntu 22.04 AMI on AWS (exportable).
- Oracle Linux VM in OCI for Rclone operations.

---

## **2. Prepare AWS Source VM**

**2.1. Launch and Prepare EC2 Instance**
```bash
# Launch Ubuntu 22.04 EC2 instance via AWS Console or CLI
# Update and install Apache (optional)
sudo apt update
sudo apt install apache2 -y
```

**2.2. Enable Serial Console (for OCI compatibility)**
```bash
sudo vi /etc/default/grub.d/50-cloudimg-settings.cfg
sudo vi /etc/default/grub
# Add or update:
# GRUB_TIMEOUT=5
# GRUB_CMDLINE_LINUX="console=tty1 console=ttyS0,115200"
# GRUB_TERMINAL="serial console"
# GRUB_SERIAL_COMMAND="serial --unit=0 --speed=115200"
sudo update-grub
```

**2.3. Check VirtIO Drivers**
```bash
sudo grep -i virtio /boot/config-$(uname -r)
sudo lsinitramfs /boot/initrd.img-$(uname -r) | grep virtio
# If missing:
sudo dracut -v -f --add-drivers "virtio virtio_pci virtio_scsi" /boot/initramfs-$(uname -r).img $(uname -r)
```

**2.4. Update Netplan Configuration**
```bash
sudo vi /etc/netplan/50-cloud-init.yaml
# Remove MAC address mapping if present, ensure DHCP is set
sudo netplan apply
```

---

## **3. Create and Export AMI to S3**

**3.1. Create an AMI from the EC2 Instance**
```bash
# In AWS Console: Actions > Image and templates > Create image
# Or via CLI:
aws ec2 create-image --instance-id  --name "MyExportableAMI"
```

**3.2. Create S3 Bucket (if not already created)**
```bash
aws s3api create-bucket --bucket  --region 
```

**3.3. Assign Required IAM Role to EC2 (if not already assigned)**
- Attach the `vmimport` role or a custom role with the necessary permissions for VM Import/Export and S3 access.

**3.4. Export the AMI to S3**
```bash
aws ec2 export-image \
  --image-id  \
  --disk-image-format VMDK \
  --s3-export-location S3Bucket=,S3Prefix=exports/ \
  --role-name 
```
- Example:
```bash
aws ec2 export-image \
  --image-id ami-1234567890abcdef0 \
  --disk-image-format VMDK \
  --s3-export-location S3Bucket=my-export-bucket,S3Prefix=exports/ \
  --role-name vmimport
```


**3.5. Monitor Export Progress**
```bash
aws ec2 describe-export-image-tasks --export-image-task-ids 
```


---

## **4. Prepare OCI for Image Import**

**4.1. Create OCI Object Storage Bucket**
- In OCI Console: Object Storage > Create Bucket (Standard Tier)

**4.2. Launch Oracle Linux VM in OCI (for Rclone)**
- Ensure internet access (public subnet or NAT gateway)
- Add your SSH public key

**4.3. Install Rclone**
```bash
sudo -v ; curl https://rclone.org/install.sh | sudo bash
```

---

## **5. Configure Rclone for S3 and OCI**

**5.1. Start Rclone Configuration**
```bash
rclone config
```
- **For AWS S3:**
  - Name: `aws-s3`
  - Type: S3
  - Provider: AWS
  - Enter Access Key, Secret Key, Region, etc.
- **For OCI:**
  - Name: `oci-remote`
  - Type: Oracle Object Storage
  - Auth: `user_principal_auth`
  - Enter Namespace, Compartment OCID, Region, Endpoint, etc.

**5.2. Verify and Test Remotes**
```bash
cat ~/.config/rclone/rclone.conf
rclone lsd aws-s3:
rclone lsd oci-remote:
```

---

## **6. Transfer Image from S3 to OCI Object Storage**

**6.1. Copy Image Using Rclone**
```bash
rclone copy aws-s3:/exports/export-ami-.vmdk oci-remote: -vv
```
- Example:
```bash
rclone copy aws-s3:my-export-bucket/exports/export-ami-1234567890abcdef0.vmdk oci-remote:my-oci-bucket -vv
```

---

## **7. Import Image in OCI and Launch Instance**

**7.1. Import Image in OCI**
- In OCI Console: Compute > Custom Images > Import Image
  - Source: Object Storage
  - Select bucket and image file
  - OS: Ubuntu
  - Launch Mode: Paravirtualized

**7.2. Launch New Instance from Custom Image**
- In OCI Console: Compute > Instances > Create Instance
  - Select your custom image
  - Use the same SSH key as AWS
  - Username: `ubuntu`
  - Subnet: public or private as required

**7.3. Connect to the New Instance**
```bash
ssh -i  ubuntu@
```

---

## **8. Optional: Site-to-Site VPN Setup (Production)**

- Create DRG in OCI.
- Create Virtual Private Gateway in AWS.
- Create Customer Gateways in both clouds.
- Configure VPN connection with two tunnels.
- Download and apply VPN configuration.
- Ensure routing (static or BGP).
- Test private communication.

---

## **9. Summary of Key Commands**

| Purpose                        | Command Example                                                                                   |
|---------------------------------|--------------------------------------------------------------------------------------------------|
| Update Ubuntu                   | `sudo apt update`                                                                                |
| Install Apache                  | `sudo apt install apache2 -y`                                                                    |
| Edit GRUB config                | `sudo vi /etc/default/grub`                                                                      |
| Update GRUB                     | `sudo update-grub`                                                                               |
| Edit Netplan                    | `sudo vi /etc/netplan/50-cloud-init.yaml`                                                        |
| Apply Netplan                   | `sudo netplan apply`                                                                             |
| Check VirtIO                    | `sudo grep -i virtio /boot/config-$(uname -r)`                                                   |
| Check VirtIO in initramfs       | `sudo lsinitramfs /boot/initrd.img-$(uname -r) | grep virtio`                                     |
| Add VirtIO drivers              | `sudo dracut -v -f --add-drivers "virtio virtio_pci virtio_scsi" /boot/initramfs-$(uname -r).img $(uname -r)` |
| Create AMI                      | `aws ec2 create-image --instance-id  --name "MyExportableAMI"`                      |
| Create S3 bucket                | `aws s3api create-bucket --bucket  --region `                       |
| Export AMI to S3                | `aws ec2 export-image --image-id  --disk-image-format VMDK --s3-export-location S3Bucket=,S3Prefix=exports/ --role-name ` |
| Monitor export task             | `aws ec2 describe-export-image-tasks --export-image-task-ids `                |
| Install Rclone                  | `sudo -v ; curl https://rclone.org/install.sh | sudo bash`                                       |
| Configure Rclone                | `rclone config`                                                                                  |
| List S3 buckets                 | `rclone lsd aws-s3:`                                                                             |
| List OCI buckets                | `rclone lsd oci-remote:`                                                                         |
| Copy image S3 → OCI             | `rclone copy aws-s3:/exports/ oci-remote: -vv`                        |
| Connect to OCI instance         | `ssh -i  ubuntu@`                                                       |

---

## AWS to OCI Application Migration with Rclone: Complete Step-by-Step Guide

This guide covers deploying an application on AWS, migrating a VM from AWS to Oracle Cloud Infrastructure (OCI) using Rclone, and includes all necessary commands, configuration, and architectural details.

---

## **1. What is Rclone?**

**Rclone** is an open-source command-line tool for managing files on cloud storage. It supports syncing, copying, and moving data between cloud providers like AWS S3 and Oracle OCI Object Storage, making it ideal for cloud-to-cloud migrations[1][2].

---

## **2. Full Architecture**

```
AWS (ap-mumbai-1)                Site-to-Site VPN/FastConnect              OCI (ap-mumbai-1)
+-------------------+             ------------------------------           +----------------------+
| VPC               |             |                            |           | VCN                  |
|   +-------------+ |             |                            |           |   +----------------+ |
|   | Ubuntu VM   | |---S3 Bucket-|--------------------------->|---Object Storage Bucket     |
|   +-------------+ |             |                            |           |   +----------------+ |
+-------------------+             |                            |           |   | Oracle Linux VM | |
                                  |                            |           |   +----------------+ |
                                  |                            |           |   | Custom Image    | |
                                  |                            |           |   +----------------+ |
                                  ------------------------------           +----------------------+
```
- **Load Balancer, ACM, and Route Tables** can be added for production, with S3 endpoints routed via ACM.

---

## **3. Step-by-Step Migration**

### **A. Deploy Application on AWS**

**1. Launch EC2 Instance (Ubuntu 22.04, ap-mumbai-1 region):**
- Choose Ubuntu 22.04 AMI.
- Select/create a VPC and subnet.
- Create and download a `.pem` SSH key.
- Set security group to allow SSH (22), HTTP (80), etc.

**2. Connect to EC2 Instance:**
- Convert `.pem` to `.ppk` using PuTTYgen (for Windows/Putty users).
- Connect:
  ```bash
  ssh -i your-key.pem ubuntu@
  ```

**3. Prepare the VM:**
```bash
sudo apt update
sudo apt install apache2 -y
# (Deploy your application as needed)
```

---

### **B. Prepare AWS for Migration**

**4. Snapshot Boot Volume (for safety):**
```bash
aws ec2 create-snapshot --volume-id 
```

**5. Enable Serial Console (for OCI compatibility):**
```bash
sudo vi /etc/default/grub.d/50-cloudimg-settings.cfg
sudo vi /etc/default/grub
# Add or update these lines:
# GRUB_TIMEOUT=5
# GRUB_CMDLINE_LINUX="console=tty1 console=ttyS0,115200"
# GRUB_TERMINAL="serial console"
# GRUB_SERIAL_COMMAND="serial --unit=0 --speed=115200"
sudo update-grub
```

**6. Check VirtIO Drivers:**
```bash
sudo grep -i virtio /boot/config-$(uname -r)
sudo lsinitramfs /boot/initrd.img-$(uname -r) | grep virtio
# If missing:
sudo dracut -v -f --add-drivers "virtio virtio_pci virtio_scsi" /boot/initramfs-$(uname -r).img $(uname -r)
```

**7. Configure Networking (Netplan):**
```bash
sudo vi /etc/netplan/50-cloud-init.yaml
# Remove MAC address mapping, ensure DHCP is set
sudo netplan apply
```

---

### **C. Export AWS VM Image to S3**

**8. Create S3 Bucket (with ACLs, block public access):**
```bash
aws s3api create-bucket --bucket  --region ap-mumbai-1
```

**9. Export Image to S3:**
```bash
aws ec2 create-instance-export-task \
  --instance-id  \
  --target-environment vmware \
  --export-to-s3-task DiskImageFormat=vmdk,ContainerFormat=ova,S3Bucket=
```
- Monitor:
```bash
aws ec2 describe-export-tasks --export-task-ids 
```

---

### **D. Prepare OCI for Migration**

**10. Create Object Storage Bucket in OCI (Standard Tier):**
- In OCI Console: Object Storage > Create Bucket

**11. Launch Oracle Linux VM in OCI (for Rclone):**
- Public subnet or NAT gateway for internet access.
- Add your SSH public key.

**12. Install Rclone:**
```bash
sudo -v ; curl https://rclone.org/install.sh | sudo bash
```

---

### **E. Configure Rclone**

**13. Start Rclone Configuration:**
```bash
rclone config
```

- **For AWS S3:**
  - Name: `aws-s3`
  - Type: S3
  - Provider: AWS
  - Access Key: ``
  - Secret Key: ``
  - Region: `ap-mumbai-1`
  - Location Constraint: `ap-mumbai-1`
  - ACL: `private`
  - Endpoint: (optional, leave blank for AWS S3)
- **For OCI:**
  - Name: `oci-remote`
  - Type: Oracle Object Storage
  - Auth: `user_principal_auth`
  - Namespace: ``
  - Compartment OCID: ``
  - Region: `ap-mumbai-1`
  - Endpoint: `https://.objectstorage.ap-mumbai-1.oci.customer-oci.com/n/`
  - (Ensure `~/.oci/config` and API keys are present)

**14. Verify and List Buckets:**
```bash
rclone lsd aws-s3:
rclone lsd oci-remote:
cat ~/.config/rclone/rclone.conf
```

---

### **F. Transfer Image from S3 to OCI**

**15. Copy Image:**
```bash
rclone copy aws-s3:/ oci-remote: -vv
```

---

### **G. Import Image in OCI and Launch Instance**

**16. Import Image in OCI Console:**
- Compute > Custom Images > Import Image
  - Source: Object Storage
  - Select bucket and image file
  - OS: Ubuntu
  - Launch Mode: Paravirtualized

**17. Launch Instance from Custom Image:**
- Use same SSH key as AWS (upload `.pem.pub` if needed)
- Username: `ubuntu`
- Connect:
```bash
ssh -i your-key.pem ubuntu@
```

---

## **4. Optional: Site-to-Site VPN**

- Create DRG in OCI.
- Create Virtual Private Gateway in AWS.
- Configure VPN connection with two tunnels.
- Update route tables and test private connectivity.

---

## **5. Additional Notes**

- For production, use Site-to-Site VPN or FastConnect for secure, high-speed transfers.
- Use Load Balancer and ACM for HTTPS and routing S3 endpoints.
- Always block public access to S3 and OCI buckets.
- Test in non-production before migrating business-critical workloads.

---

## **6. Reference**

- [Oracle Docs: Migrate Ubuntu AWS to OCI](https://docs.oracle.com/en/learn/migrate-ubuntu-aws-to-oci/index.html)[1]

---
