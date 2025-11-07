# RHEL AWS to OCI Migration - Complete Project Description & Interview Guide

## PROJECT DESCRIPTION

### Overview
This project focuses on migrating Red Hat Enterprise Linux (RHEL) Virtual Machines from Amazon Web Services (AWS) to Oracle Cloud Infrastructure (OCI). The migration enables organizations to leverage OCI's next-generation cloud capabilities for faster application performance, enhanced security, and cost optimization.

### Business Objectives
- **Performance Enhancement**: Achieve 6x faster disk I/O performance through Paravirtualized mode
- **Cost Optimization**: Reduce infrastructure costs by migrating to OCI
- **Infrastructure Modernization**: Move from AWS EC2 to OCI Compute instances
- **Scalability**: Enable better scalability and management in OCI environment

### Technical Architecture

#### Migration Components:
1. **Source Environment**: AWS EC2 instances running RHEL
2. **Data Transfer Layer**: Amazon S3 ↔ OCI Object Storage (via rclone)
3. **Target Environment**: OCI Compute instances with custom images
4. **Network Connectivity**: Internet-based transfer (production: VPN/FastConnect)

#### Migration Flow:
```
AWS RHEL VM → Preparation → Export to S3 → 
Transfer via rclone → OCI Object Storage → 
Custom Image Creation → Instance Launch
```

### Key Technical Components

#### 1. **Storage Infrastructure**
- Amazon S3 bucket (ACL-enabled, private access)
- OCI Object Storage bucket (standard tier)
- Rclone for automated data transfer

#### 2. **VM Preparation**
- Serial console configuration (GRUB settings)
- Paravirtualization driver verification (virtio_pci, virtio_scsi)
- Network configuration (DHCP, MAC address removal)
- Boot volume snapshot

#### 3. **Image Management**
- VMDK format export from AWS
- OVA container format
- Custom image creation in OCI
- Paravirtualized launch mode

#### 4. **Security & Access**
- AWS IAM keys for S3 access
- OCI IAM policies for Object Storage and Compute
- API signing keys for authentication
- SSH key management (retain or regenerate)

### Prerequisites
- AWS account with EC2 and S3 access
- OCI tenancy with appropriate IAM policies
- Oracle Linux VM in OCI for rclone installation
- Network connectivity between AWS and OCI

### Migration Phases

**Phase 1: Infrastructure Setup** (Tasks 1.1-1.2)
- Create storage buckets (S3 and Object Storage)
- Install and configure rclone
- Set up authentication mechanisms

**Phase 2: VM Preparation** (Tasks 2.1-2.4)
- Create boot volume snapshot
- Configure serial console (GRUB)
- Verify paravirtualization drivers
- Configure networking (DHCP, remove MAC addresses)

**Phase 3: Export & Transfer** (Tasks 3-4)
- Export VM to Amazon S3 as VMDK/OVA
- Transfer image using rclone
- Validate image in OCI Object Storage

**Phase 4: Deployment** (Task 5)
- Create custom image in OCI
- Launch instance in Paravirtualized mode
- Validate connectivity and functionality

---

## COMPREHENSIVE INTERVIEW QUESTIONS & ANSWERS

### SECTION 1: PROJECT OVERVIEW & ARCHITECTURE

#### Q1: Can you explain the overall architecture of the RHEL migration project from AWS to OCI?

**Answer:**
The migration architecture consists of five main layers:

1. **Source Layer (AWS)**:
   - EC2 instances running RHEL 9.3
   - Single boot volume configuration
   - Snapshot capability for backup

2. **Export Layer**:
   - VM export to Amazon S3 using AWS CLI
   - VMDK disk format with OVA container
   - ACL-enabled S3 bucket with region-specific permissions

3. **Transfer Layer**:
   - Rclone tool running on OCI Oracle Linux VM
   - Dual remote configuration (AWS S3 and OCI Object Storage)
   - User principal authentication with API keys

4. **Import Layer**:
   - OCI Object Storage (standard tier)
   - Custom image creation with RHEL OS type
   - Paravirtualized mode configuration

5. **Target Layer (OCI)**:
   - OCI Compute instances
   - VCN and subnet configuration
   - SSH access with retained or new keys

The data flows from AWS EC2 → S3 → Internet/VPN → OCI Object Storage → Custom Image → OCI Compute Instance.

---

#### Q2: Why is Paravirtualized mode important in this migration, and what performance benefits does it provide?

**Answer:**
Paravirtualized mode is critical for several reasons:

**Performance Benefits**:
- **6x faster disk I/O performance** compared to emulated mode
- Direct hardware access without full hardware emulation
- Reduced CPU overhead for I/O operations
- Better memory management and network throughput

**Technical Advantages**:
- Uses VirtIO drivers (virtio_pci, virtio_scsi) for optimized virtual hardware access
- Guest OS is aware it's running in a virtualized environment
- Eliminates translation layer between VM and hypervisor
- Direct communication with the hypervisor for I/O operations

**Business Impact**:
- Reduced latency for database operations
- Better application response times
- Cost efficiency through resource optimization
- Improved user experience for production workloads

This is why the entire preparation phase focuses on ensuring VirtIO drivers are present and properly configured.

---

#### Q3: What are the key differences between AWS EC2 and OCI Compute that impact the migration?

**Answer:**
Several architectural differences must be addressed:

**1. Hypervisor & Virtualization**:
- AWS uses Xen/Nitro hypervisor
- OCI uses KVM-based hypervisor
- Requires driver compatibility verification (VirtIO)

**2. Networking**:
- AWS: Elastic Network Interface (ENI) with MAC persistence
- OCI: VNIC with different MAC addressing
- **Migration Impact**: Must remove hardcoded MAC addresses

**3. Serial Console**:
- AWS: EC2 Serial Console (separate service)
- OCI: Integrated instance console connections
- **Migration Impact**: GRUB configuration needed for troubleshooting

**4. Boot Management**:
- AWS: Uses cloud-init with ec2-user default
- OCI: Uses cloud-init with opc default
- **Migration Impact**: User account persistence requires SSH key management

**5. Image Formats**:
- AWS: AMI (proprietary format)
- OCI: Supports VMDK, QCOW2 via custom images
- **Migration Impact**: Export to VMDK format required

**6. Storage**:
- AWS: EBS volumes
- OCI: Block Volumes
- **Migration Impact**: Volume attachment and boot configuration

---

### SECTION 2: PREPARATION TASKS (DEEP DIVE)

#### Q4: Walk me through the complete process of creating and configuring the storage infrastructure. What are the critical configuration details?

**Answer:**

**Amazon S3 Bucket Configuration**:

1. **ACL Configuration**:
   - Enable ACLs (not just bucket policies)
   - Required for VM export permissions
   - Attach region-specific canonical account ID grant
   - Example: For us-east-1: `c4d8eabf8db69dbe46bfe0e517100c554f01200b104d59cd408e777ba442a322`

2. **Access Control**:
   - Block all public access (security best practice)
   - Private bucket with explicit ACL for AWS VM Import/Export service
   - Bucket policy for AWS user access keys

3. **Region Selection**:
   - Must match EC2 instance region
   - Location constraint setting critical for cross-region scenarios

**OCI Object Storage Bucket**:

1. **Storage Tier**:
   - Standard tier (not Archive or Infrequent Access)
   - Required for custom image import
   - Performance considerations for large images

2. **Compartment Selection**:
   - IAM policy scope consideration
   - Resource organization
   - Cost tracking and billing

3. **Namespace Configuration**:
   - Tenancy-specific namespace
   - Required for rclone endpoint configuration
   - Format: `https://<namespace>.objectstorage.<region>.oci.customer-oci.com`

**Critical Details Often Missed**:
- Region-specific ACL grant varies by AWS region
- Bucket versioning can increase storage costs
- Lifecycle policies for automatic cleanup
- Pre-authenticated request (PAR) alternative for temporary access

---

#### Q5: Explain the rclone configuration process in detail. What authentication methods are available and which is recommended?

**Answer:**

**Rclone Installation & Configuration**:

**1. Installation on OCI VM**:
```bash
sudo -v
curl https://rclone.org/install.sh | sudo bash
```

**2. AWS S3 Remote Configuration**:
```
Remote Name: aws-s3-remote
Type: S3 Compatible Storage (option 5)
Provider: AWS (option 1)
access_key_id: <AWS_ACCESS_KEY>
secret_access_key: <AWS_SECRET_KEY>
Region: us-east-1 (or your region)
location_constraint: us-east-1 (matches region)
acl: private
```

**Key Parameters**:
- **access_key_id**: From AWS IAM user (programmatic access)
- **secret_access_key**: Corresponding secret
- **Region**: Must match S3 bucket region
- **ACL**: Use 'private' for most restrictive access

**3. OCI Object Storage Remote Configuration**:

**Authentication Methods**:

a) **User Principal (Recommended for this tutorial)**:
```
Remote Name: oci-storage
Type: Oracle Object Storage (option 47)
Provider: user_principal_auth
Namespace: <tenancy_namespace>
Compartment: <compartment_OCID>
Region: us-ashburn-1
Endpoint: (leave blank or specify)
```

**Prerequisites**:
- OCI API signing keys (RSA key pair)
- OCI configuration file at `~/.oci/config`
```ini
[DEFAULT]
user=ocid1.user.oc1..aaa...
fingerprint=aa:bb:cc:dd...
tenancy=ocid1.tenancy.oc1..aaa...
region=us-ashburn-1
key_file=/home/opc/.oci/oci_api_key.pem
```

b) **Instance Principal (Production Recommended)**:
```
Provider: instance_principal_auth
```

**Advantages**:
- No API keys to manage
- Automatic credential rotation
- Based on dynamic group membership
- More secure for production

**Requirements**:
- Dynamic group with matching rule: `ALL {instance.compartment.id = 'ocid1.compartment...'}`
- IAM policy: `Allow dynamic-group <group-name> to manage object-family in compartment <compartment>`

**4. Configuration Verification**:
```bash
# View configuration
cat ~/.config/rclone/rclone.conf

# Test AWS remote
rclone lsd aws-s3-remote:

# Test OCI remote
rclone lsd oci-storage:

# List buckets
rclone lsf aws-s3-remote:<bucket-name>
```

**Best Practices**:
- Use instance principal in production
- Store API keys securely (OCI Vault)
- Rotate credentials regularly
- Use separate IAM users/principals for different environments
- Enable logging for audit trails

---

#### Q6: What is the purpose of taking a snapshot before VM preparation, and what is the rollback strategy?

**Answer:**

**Purpose of Mandatory Snapshot**:

1. **Disaster Recovery**:
   - Restore point before any configuration changes
   - Protection against configuration errors
   - Recovery from failed migrations

2. **Testing & Validation**:
   - Create test instance from snapshot
   - Validate changes in isolated environment
   - Compare before/after states

3. **Compliance & Audit**:
   - Document original state
   - Meet organizational change management requirements
   - Audit trail for migration activities

4. **Risk Mitigation**:
   - Zero data loss assurance
   - Quick recovery time objective (RTO)
   - Minimal downtime impact

**Rollback Strategy**:

**Scenario 1: Pre-Export Failure**
```
1. Stop failed instance
2. Create new volume from snapshot
3. Detach original boot volume
4. Attach volume from snapshot
5. Start instance
6. Verify functionality
Time: 10-15 minutes
```

**Scenario 2: Post-Export, Pre-Migration Failure**
```
1. Keep source VM unchanged
2. Retry migration with corrected parameters
3. No rollback needed as source unaffected
```

**Scenario 3: Post-Migration Failure in OCI**
```
1. Delete failed OCI instance and custom image
2. Return to AWS source VM
3. Restore from snapshot if source was modified
4. Re-attempt migration after root cause analysis
```

**Snapshot Best Practices**:
- Tag snapshots with migration metadata
- Set retention policy (e.g., 30 days post-migration)
- Document snapshot ID in migration documentation
- Test restore procedure before migration
- Create application-consistent snapshots (stop services if needed)

**AWS Snapshot Commands**:
```bash
# Create snapshot
aws ec2 create-snapshot \
  --volume-id vol-1234567890abcdef \
  --description "Pre-migration snapshot - $(date)" \
  --tag-specifications 'ResourceType=snapshot,Tags=[{Key=Purpose,Value=Migration-Backup},{Key=Date,Value='$(date +%Y-%m-%d)'}]'

# Verify snapshot
aws ec2 describe-snapshots --snapshot-ids snap-xxxxx

# Restore from snapshot
aws ec2 create-volume \
  --snapshot-id snap-xxxxx \
  --availability-zone us-east-1a
```

---

#### Q7: Explain the GRUB configuration changes in detail. Why is each parameter important for serial console access?

**Answer:**

**GRUB (Grand Unified Bootloader) Configuration**:

**File Location**: `/etc/default/grub`

**Critical Parameters**:

**1. GRUB_TIMEOUT_STYLE**:
```bash
# Before (problematic):
GRUB_TIMEOUT_STYLE=hidden

# After (correct):
#GRUB_TIMEOUT_STYLE=hidden
# OR
GRUB_TIMEOUT_STYLE=menu
```
**Purpose**: 
- "hidden" skips boot menu entirely
- "menu" displays boot options
- Allows boot mode selection for troubleshooting
- Required for rescue mode access

**2. GRUB_TIMEOUT**:
```bash
# Before:
GRUB_TIMEOUT=0

# After:
GRUB_TIMEOUT=5
```
**Purpose**:
- Value in seconds for menu display
- 0 = immediate boot (no troubleshooting opportunity)
- 5 = reasonable time to select boot options
- Critical for kernel parameter modification

**3. GRUB_CMDLINE_LINUX**:
```bash
# Before:
GRUB_CMDLINE_LINUX="crashkernel=auto resume=/dev/mapper/rhel-swap rd.lvm.lv=rhel/root rd.lvm.lv=rhel/swap"

# After (append):
GRUB_CMDLINE_LINUX="crashkernel=auto resume=/dev/mapper/rhel-swap rd.lvm.lv=rhel/root rd.lvm.lv=rhel/swap console=tty1 console=ttyS0,115200"
```
**Purpose**:
- `console=tty1`: Physical console output (VGA)
- `console=ttyS0,115200`: Serial console output
- `115200`: Baud rate for serial communication
- Both consoles ensure multiple access paths

**4. GRUB_TERMINAL**:
```bash
# Add this line:
GRUB_TERMINAL="serial console"
```
**Purpose**:
- Enables both serial and console terminal
- Dual output for accessibility
- Required for OCI serial console feature

**5. GRUB_SERIAL_COMMAND**:
```bash
# Add this line:
GRUB_SERIAL_COMMAND="serial --unit=0 --speed=115200"
```
**Purpose**:
- Configures serial port parameters
- `--unit=0`: First serial port (ttyS0)
- `--speed=115200`: Baud rate matching kernel console
- Hardware-level serial communication setup

**Complete Configuration Example**:
```bash
GRUB_TIMEOUT=5
GRUB_DISTRIBUTOR="$(sed 's, release .*$,,g' /etc/system-release)"
GRUB_DEFAULT=saved
GRUB_DISABLE_SUBMENU=true
GRUB_TERMINAL="serial console"
GRUB_SERIAL_COMMAND="serial --unit=0 --speed=115200"
GRUB_CMDLINE_LINUX="crashkernel=auto resume=/dev/mapper/rhel-swap rd.lvm.lv=rhel/root rd.lvm.lv=rhel/swap console=tty1 console=ttyS0,115200"
GRUB_DISABLE_RECOVERY="true"
GRUB_ENABLE_BLSCFG=true
```

**Applying Changes**:
```bash
# Regenerate GRUB configuration
sudo grub2-mkconfig -o /boot/grub2/grub.cfg

# For UEFI systems:
sudo grub2-mkconfig -o /boot/efi/EFI/redhat/grub.cfg

# Verify changes
grep console /boot/grub2/grub.cfg
```

**OCI Serial Console Usage**:
```bash
# Once in OCI, access serial console via:
# 1. OCI Console → Compute → Instance Details → Console Connection
# 2. Create console connection
# 3. Connect via SSH or web console

# Troubleshooting capabilities:
- Password resets
- Network configuration fixes
- Boot issues diagnosis
- Filesystem checks
- Service troubleshooting
```

**Why This Matters**:
- Without serial console, locked-out VM requires termination/recreation
- Critical for password recovery scenarios
- Essential for network configuration issues
- Debugging boot failures
- OCI best practice for all Linux instances

---

#### Q8: How do you verify and ensure Paravirtualization drivers are present? What if they're missing?

**Answer:**

**Paravirtualization Driver Requirements**:

Linux kernel 3.4+ typically includes VirtIO drivers, but verification is mandatory.

**Required Drivers**:
1. **virtio_pci**: PCI bus driver for VirtIO devices
2. **virtio_scsi**: SCSI driver for block devices
3. **virtio_net**: Network driver (beneficial but not critical for boot)
4. **virtio_blk**: Block device driver (alternative to SCSI)

**Verification Process**:

**Step 1: Check Kernel Modules**
```bash
# Check compiled kernel configuration
sudo grep -i virtio /boot/config-$(uname -r)

# Expected output:
CONFIG_VIRTIO_PCI=m        # Module (M) or built-in (Y)
CONFIG_VIRTIO_SCSI=m
CONFIG_VIRTIO_NET=m
CONFIG_VIRTIO_BLK=m
CONFIG_VIRTIO=m
CONFIG_VIRTIO_RING=m
```

**Interpretation**:
- `=m`: Compiled as loadable module
- `=y`: Built into kernel (better)
- `is not set`: Missing (problem)

**Step 2: Check Loaded Modules**
```bash
# Check currently loaded modules
lsmod | grep virtio

# Expected output:
virtio_scsi            18432  2
virtio_pci             24576  0
virtio_ring            24576  2 virtio_scsi,virtio_pci
virtio                 16384  2 virtio_scsi,virtio_pci
```

**Step 3: Check initramfs**
```bash
# Check initial ramdisk filesystem
sudo lsinitrd /boot/initramfs-$(uname -r).img | grep virtio

# Expected output:
drwxr-xr-x   2 root     root            0 Mar 15 10:23 usr/lib/modules/5.14.0-362.el9.x86_64/kernel/drivers/scsi/virtio_scsi.ko.xz
drwxr-xr-x   2 root     root            0 Mar 15 10:23 usr/lib/modules/5.14.0-362.el9.x86_64/kernel/drivers/virtio/virtio_pci.ko.xz
```

**Why Check Both Kernel and initramfs?**
- **Kernel**: Drivers for runtime
- **initramfs**: Drivers for boot process (pre-root filesystem mount)
- Boot volume requires drivers in initramfs
- Secondary volumes can use kernel modules

**Scenario: Drivers Missing from initramfs**

**Solution: Rebuild initramfs with dracut**

```bash
# Backup current initramfs
sudo cp /boot/initramfs-$(uname -r).img /boot/initramfs-$(uname -r).img.backup

# Rebuild with VirtIO drivers
sudo dracut -v -f --add-drivers "virtio virtio_pci virtio_scsi virtio_blk virtio_net" /boot/initramfs-$(uname -r).img $(uname -r)

# Verify rebuild
sudo lsinitrd /boot/initramfs-$(uname -r).img | grep virtio
```

**Dracut Command Breakdown**:
- `-v`: Verbose output
- `-f`: Force overwrite
- `--add-drivers`: Add specified drivers
- `"virtio virtio_pci virtio_scsi virtio_blk virtio_net"`: Driver list
- `/boot/initramfs-$(uname -r).img`: Output file
- `$(uname -r)`: Current kernel version

**Scenario: Drivers Missing from Kernel**

This is rare for RHEL 7+ but can occur with custom kernels.

**Solutions**:
1. **Update kernel**: `sudo yum update kernel`
2. **Rebuild kernel** (advanced):
```bash
sudo yum install kernel-devel kernel-headers
# Modify kernel config to enable VirtIO
# Recompile kernel
```

**Alternative: Use Different Kernel**
```bash
# List available kernels
rpm -qa kernel

# Boot from different kernel version with drivers
# Modify GRUB default boot entry
```

**Verification After Rebuild**:
```bash
# Reboot (in test environment)
sudo reboot

# After reboot, verify
dmesg | grep -i virtio
# Expected: virtio devices detected during boot

lsmod | grep virtio
# Expected: modules loaded

lsblk -o NAME,TYPE,SIZE,MODEL
# Expected: should work in OCI after migration
```

**Impact of Missing Drivers**:
- **Boot failure** in OCI (most critical)
- VM stuck at boot loader
- Cannot access root filesystem
- Instance appears running but inaccessible
- Requires re-migration after correction

**Best Practice**:
- Always verify before export
- Test in non-production instance first
- Document driver versions
- Keep kernel updated
- Use vendor-supported kernels (avoid custom)

---

### SECTION 3: NETWORKING CONFIGURATION

#### Q9: Why must MAC addresses be removed from the network configuration? Walk through the complete network configuration process.

**Answer:**

**Why Remove MAC Addresses**:

**1. Cloud Networking Principles**:
- Cloud VMs receive dynamic MAC addresses from hypervisor
- MAC address tied to specific virtual NIC in source environment
- OCI VNIC generates new MAC address upon instance creation
- Hardcoded MAC causes network interface failure

**2. Migration Impact**:
```
AWS ENI MAC: 06:b2:4f:89:12:34 (AWS-specific)
↓ (migration)
OCI VNIC MAC: 02:00:17:01:56:78 (OCI-specific)
```

If configuration contains AWS MAC:
- Network interface won't initialize
- DHCP fails (interface not found)
- VM boots but no network connectivity
- SSH access impossible
- Application failures

**3. Technical Reason**:
- udev rules map MAC to interface name
- NetworkManager/systemd-networkd use MAC for interface binding
- Configuration mismatch prevents interface activation

**Complete Network Configuration Process**:

**Step 1: Assess Current Configuration**
```bash
# Check network management tool
systemctl status NetworkManager
# OR
systemctl status systemd-networkd

# For this tutorial: NetworkManager (RHEL 9 default)
```

**Step 2: List Network Connections**
```bash
# Show all connections
nmcli connection show

# Example output:
NAME                UUID                                  TYPE      DEVICE
System eth0         5fb06bd0-0bb0-7ffb-45f1-d6edd65f3e03  ethernet  eth0
Wired connection 1  3b5f8d5e-4c7b-3fe6-9a5e-5e7f8d9c6b4a  ethernet  --
```

**Step 3: Examine Specific Connection**
```bash
# Detailed view of eth0 connection
nmcli connection show "System eth0"

# Key parameters to verify:
# connection.id: System eth0
# connection.uuid: 5fb06bd0-0bb0-7ffb-45f1-d6edd65f3e03
# connection.interface-name: eth0
# 802-3-ethernet.mac-address: 06:B2:4F:89:12:34  ← REMOVE THIS
# ipv4.method: auto  ← Should be "auto" (DHCP)
# ipv4.addresses: -- ← Should be empty for DHCP
```

**Step 4: Remove MAC Address**
```bash
# Using connection UUID (more reliable)
sudo nmcli connection modify 5fb06bd0-0bb0-7ffb-45f1-d6edd65f3e03 802-3-ethernet.mac-address ''

# OR using connection name
sudo nmcli connection modify "System eth0" 802-3-ethernet.mac-address ''

# Verify change
nmcli connection show "System eth0" | grep mac-address
# Output should show: 802-3-ethernet.mac-address: --
```

**Step 5: Ensure DHCP Configuration**
```bash
# Verify IPv4 method
nmcli connection show "System eth0" | grep ipv4.method
# Should output: ipv4.method: auto

# If not set to auto:
sudo nmcli connection modify "System eth0" ipv4.method auto

# Remove static IP if present
sudo nmcli connection modify "System eth0" ipv4.addresses ''
sudo nmcli connection modify "System eth0" ipv4.gateway ''
sudo nmcli connection modify "System eth0" ipv4.dns ''
```

**Step 6: Apply Changes**
```bash
# Bring connection down and up
sudo nmcli connection down "System eth0"
sudo nmcli connection up "System eth0"

# OR use UUID
sudo nmcli con up 5fb06bd0-0bb0-7ffb-45f1-d6edd65f3e03

# Verify interface is up with DHCP
ip addr show eth0
# Should show IP from DHCP
```

**Step 7: Check Legacy Configuration Files**
```bash
# RHEL/CentOS traditional location
cat /etc/sysconfig/network-scripts/ifcfg-eth0

# Should NOT contain:
# HWADDR=06:B2:4F:89:12:34
# MACADDR=06:B2:4F:89:12:34

# Correct configuration:
TYPE=Ethernet
BOOTPROTO=dhcp
DEFROUTE=yes
NAME="System eth0"
UUID=5fb06bd0-0bb0-7ffb-45f1-d6edd65f3e03
DEVICE=eth0
ONBOOT=yes
```

**Step 8: Remove udev Persistent Net Rules**
```bash
# Check for udev rules with MAC addresses
ls -la /etc/udev/rules.d/ | grep net

# Common problematic file:
cat /etc/udev/rules.d/70-persistent-net.rules

# Example problematic content:
# SUBSYSTEM=="net", ACTION=="add", DRIVERS=="?*", ATTR{address}=="06:b2:4f:89:12:34", NAME="eth0"

# Remove the file
sudo rm /etc/udev/rules.d/70-persistent-net.rules

# Remove any other net rules with MAC addresses
sudo rm /etc/udev/rules.d/*-net-*.rules
```

**Step 9: Additional Checks**

**Cloud-init Configuration**:
```bash
# Check cloud-init network configuration
cat /etc/cloud/cloud.cfg.d/99-custom-networking.cfg

# Should use DHCP, not MAC-based
# Correct:
network:
  version: 2
  ethernets:
    eth0:
      dhcp4: true
```

**Disable Network MAC Persistence**:
```bash
# Disable consistent network device naming (if needed)
# Add to kernel parameters (in GRUB):
net.ifnames=0 biosdevname=0

# This maintains eth0 naming without MAC dependency
```

**Step 10: Final Verification**
```bash
# Test network connectivity
ping -c 4 google.com

# Check routing
ip route show

# Verify DNS
cat /etc/resolv.conf

# Check for any MAC references
sudo grep -r "06:b2:4f:89:12:34" /etc/

# Should return no results
```

**Post-Migration in OCI**:
```bash
# After instance launch in OCI
# SSH to new instance

# Verify new MAC address received
ip link show eth0
# Should show NEW OCI-assigned MAC

# Verify DHCP lease
cat /var/lib/NetworkManager/dhclient-*.lease
# OR
cat /var/lib/dhcp/dhclient.leases

# Confirm connectivity
ip addr show
ping -c 4 google.com
```

**Troubleshooting Network Issues**:

**Scenario 1: Interface Not Coming Up**
```bash
# Check interface status
nmcli device status

# Manually bring up
sudo ip link set eth0 up
sudo dhclient eth0

# Check logs
journalctl -u NetworkManager -n 50
```

**Scenario 2: DHCP Not Working**
```bash
# Release and renew
sudo dhclient -r eth0
sudo dhclient eth0

# Check DHCP process
ps aux | grep dhclient

# Verify DHCP server reachable (in OCI)
# OCI provides DHCP at 169.254.169.254
```

**Scenario 3: DNS Not Resolving**
```bash
# Check resolv.conf
cat /etc/resolv.conf

# Should contain OCI DNS:
nameserver 169.254.169.254

# If wrong, check NetworkManager DNS
nmcli dev show eth0 | grep DNS
```

---

#### Q10: What are the specific networking differences between AWS and OCI that impact the migration?

**Answer:**

**Comprehensive Networking Comparison**:

**1. Default User Accounts**:

| Aspect | AWS | OCI | Migration Impact |
|--------|-----|-----|------------------|
| Default user | ec2-user | opc | SSH access changes |
| Sudo access | Passwordless | Passwordless | No impact |
| Cloud-init | ec2-user created | opc created | User persistence requires SSH key matching |

**Solution in Migration**:
- Option A: Upload same public key → keeps ec2-user
- Option B: Use new keys → use opc user
- Project tutorial: Uploads same .pem key → retains ec2-user

**2. Metadata Service**:

| Service | AWS | OCI |
|---------|-----|-----|
| Endpoint | 169.254.169.254 | 169.254.169.254 |
| Version | IMDSv2 (session-based) | Similar implementation |
| Access | Token required (v2) | Direct HTTP GET |

**Migration Consideration**:
```bash
# AWS IMDSv2 (token-based):
TOKEN=$(curl -X PUT "http://169.254.169.254/latest/api/token" -H "X-aws-ec2-metadata-token-ttl-seconds: 21600")
curl -H "X-aws-ec2-metadata-token: $TOKEN" http://169.254.169.254/latest/meta-data/

# OCI (simpler):
curl http://169.254.169.254/opc/v1/instance/
```

**3. DHCP Configuration**:

| Feature | AWS | OCI |
|---------|-----|-----|
| DHCP Server | VPC DHCP options | VCN DHCP options |
| DNS Server | VPC+2 address | 169.254.169.254 |
| Domain | ec2.internal (us-east-1) | Region-specific |
| NTP Server | Amazon Time Sync | 169.254.169.254 |

**Migration Impact**:
```bash
# AWS resolv.conf:
nameserver 172.31.0.2
search ec2.internal

# OCI resolv.conf:
nameserver 169.254.169.254
search subnet.vcn.oraclevcn.com
```

**4. Network Interface Naming**:

| Aspect | AWS | OCI |
|--------|-----|-----|
| Primary interface | eth0 | eth0 |
| Naming scheme | Elastic Network Interface | VNIC |
| Persistent naming | Optional (biosdevname) | Supported |
| Multiple interfaces | Multiple ENIs | Multiple VNICs |

**5. MAC Address Assignment**:

| Feature | AWS | OCI |
|---------|-----|-----|
| MAC persistence | Within AZ | Within AD |
| Format | AWS prefix | Oracle prefix |
| Assignment | At ENI creation | At VNIC creation |
| Changeability | Changes on stop/start | Stable during lifecycle |

**6. Security Groups vs NSG**:

| Feature | AWS Security Groups | OCI Network Security Groups |
|---------|---------------------|------------------------------|
| Default behavior | Stateful | Stateful |
| Attached to | ENI | VNIC or subnet |
| Rules | Allow only | Allow + explicit deny |
| Evaluation | All rules | Order matters (stateless) |

**Migration Impact**: Recreate security rules in OCI

**7. Routing Differences**:

| Feature | AWS | OCI |
|---------|-----|-----|
| Route tables | VPC route table | VCN route table |
| Default gateway | VPC router (.1) | VCN router (.1) |
| Internet gateway | IGW | Internet Gateway |
| NAT | NAT Gateway | NAT Gateway |

**8. IP Addressing**:

| Feature | AWS | OCI |
|---------|-----|-----|
| Private IP | Primary + secondary | Primary + secondary |
| Public IP | Elastic IP | Reserved Public IP |
| IPv6 | Supported | Supported |
| BYOIP | Supported | Supported |

**9. Enhanced Networking**:

| Feature | AWS | OCI |
|---------|-----|-----|
| Technology | SR-IOV (ENA) | SR-IOV |
| Driver | ena | VirtIO |
| Performance | Up to 100 Gbps | Up to 100 Gbps |

**Migration Requirement**: VirtIO drivers instead of ENA

**10. Network Monitoring**:

| Feature | AWS | OCI |
|---------|-----|-----|
| Flow logs | VPC Flow Logs | VCN Flow Logs |
| Packet capture | Traffic Mirroring | Not available |
| Monitoring | CloudWatch | Monitoring service |

---

### SECTION 4: EXPORT & TRANSFER PROCESS

#### Q11: Explain the VM export process in detail. What are the supported formats and why?

**Answer:**

**VM Export Process (AWS)**:

**Supported Export Formats**:

| Format | Extension | Support in OCI | Reason for Selection |
|--------|-----------|----------------|----------------------|
| **VMDK** | .vmdk | ✅ Yes | VMware virtual disk format |
| VHD | .vhd | ❌ No | Microsoft Hyper-V format |
| OVA | .ova (container) | ✅ Yes | Open Virtualization Archive |

**Why VMDK?**
1. **OCI Compatibility**: OCI custom images support VMDK and QCOW2
2. **Industry Standard**: VMware standard format widely supported
3. **Efficient Storage**: Supports thin provisioning
4. **Metadata Support**: When wrapped in OVA (Open Virtualization Archive)

**Container Format: OVA**
- Contains VMDK + OVF descriptor + manifest
- OVF (Open Virtualization Format) provides VM metadata
- Single file for easy transfer
- OCI can extract VMDK from OVA

**Export Command Breakdown**:

```bash
aws ec2 create-instance-export-task \
  --instance-id i-0abcd1234efgh5678 \
  --target-environment vmware \
  --export-to-s3-task \
    DiskImageFormat=vmdk,\
    ContainerFormat=ova,\
    S3Bucket=my-migration-bucket,\
    S3Prefix=rhel-migrations/
```

**Parameter Details**:

**1. --instance-id**:
- Must be stopped before export
- Export captures complete VM configuration
- Includes all attached volumes (single volume in this tutorial)

**2. --target-environment vmware**:
- **vmware**: Creates VMDK format (REQUIRED for OCI)
- microsoft: Creates VHD (not OCI compatible)
- citrix: Creates VHD (not OCI compatible)

**3. DiskImageFormat=vmdk**:
- Specifies disk image format
- Only option compatible with OCI
- Creates virtual disk file

**4. ContainerFormat=ova**:
- Wraps VMDK in OVA container
- Optional but recommended
- Includes VM metadata (vCPU, memory, network)
- Alternative: Export without container (VMDK only)

**5. S3Bucket**:
- Target bucket for export
- Must have proper ACL (configured in Task 1.1)
- Same region as EC2 instance

**6. S3Prefix** (optional):
- Organizes exports in bucket
- Example: `exports/production/`, `migrations/2024/`
- Helps with lifecycle policies

**Export Process Stages**:

**Stage 1: Preparation (5-10 minutes)**
```bash
# AWS validates:
# - Instance is stopped
# - Instance is exportable (not all AMIs allow export)
# - S3 bucket accessible
# - Proper ACL configured

# Check export eligibility first:
aws ec2 describe-instance-attribute \
  --instance-id i-0abcd1234efgh5678 \
  --attribute productCodes

# If AWS Marketplace AMI with restrictions, export fails
```

**Stage 2: Active Export (30 mins - several hours)**
```bash
# Monitor export progress:
aws ec2 describe-export-tasks \
  --export-task-ids export-i-0abcd1234efgh5678

# Output shows:
{
  "ExportTasks": [{
    "ExportTaskId": "export-i-0abcd1234efgh5678",
    "State": "active",
    "StatusMessage": "converting",
    "Progress": "45"  // Percentage
  }]
}
```

**Progress States**:
1. **pending**: Task queued
2. **active**: Export in progress
3. **cancelling**: User cancellation
4. **cancelled**: Cancelled successfully
5. **completed**: Export successful
6. **failed**: Export failed (check StatusMessage)

**Stage 3: Completion**
```bash
# Final status check:
aws ec2 describe-export-tasks \
  --export-task-ids export-i-0abcd1234efgh5678

# Successful output:
{
  "ExportTasks": [{
    "ExportTaskId": "export-i-0abcd1234efgh5678",
    "State": "completed",
    "StatusMessage": "completed",
    "ExportToS3": {
      "S3Bucket": "my-migration-bucket",
      "S3Key": "export-i-0abcd1234efgh5678.ova"
    }
  }]
}
```

**Verify Export in S3**:
```bash
# List objects in bucket
aws s3 ls s3://my-migration-bucket/

# Expected output:
2024-03-15 10:30:45  15728640000  export-i-0abcd1234efgh5678.ova

# Check file size (approximately disk usage)
aws s3api head-object \
  --bucket my-migration-bucket \
  --key export-i-0abcd1234efgh5678.ova \
  --query 'ContentLength' \
  --output text

# Download for verification (optional):
aws s3 cp s3://my-migration-bucket/export-i-0abcd1234efgh5678.ova ./
```

**Export Size Considerations**:

| Disk Size | Export Time | Transfer Time | Total Time |
|-----------|-------------|---------------|------------|
| 10 GB | 15-30 min | 5-10 min | ~45 min |
| 50 GB | 45-90 min | 20-30 min | ~2 hours |
| 100 GB | 1.5-3 hours | 40-60 min | ~4 hours |
| 500 GB | 6-10 hours | 3-5 hours | ~15 hours |

**Common Export Failures**:

**1. AMI Not Exportable**:
```
Error: "The instance i-xxx uses a base image that does not support export"
```
**Cause**: AWS Marketplace AMI with export restrictions
**Solution**: Create fresh RHEL instance from Red Hat official AMI

**2. Insufficient S3 Permissions**:
```
Error: "Access Denied to S3 bucket"
```
**Solution**: Add proper ACL to bucket (Task 1.1)

**3. Instance Not Stopped**:
```
Error: "Instance must be stopped before export"
```
**Solution**: 
```bash
aws ec2 stop-instances --instance-ids i-0abcd1234efgh5678
# Wait until stopped
aws ec2 wait instance-stopped --instance-ids i-0abcd1234efgh5678
```

**4. Region Mismatch**:
```
Error: "S3 bucket not in same region as instance"
```
**Solution**: Use bucket in same region or configure LocationConstraint

**Export Best Practices**:
1. **Verify exportability** before preparation work
2. **Tag export tasks** for tracking
3. **Use S3 lifecycle policies** to auto-delete old exports
4. **Enable S3 versioning** for safety
5. **Compress if possible** (built-in with VMDK)
6. **Document export metadata**: timestamp, source instance, version
7. **Test with small instance first**
8. **Schedule during maintenance window**

**Cancelling Export**:
```bash
# If needed, cancel export:
aws ec2 cancel-export-task \
  --export-task-id export-i-0abcd1234efgh5678
```

---

#### Q12: How does rclone transfer work? What are the performance optimization techniques?

**Answer:**

**Rclone Transfer Mechanism**:

**Basic Transfer Command**:
```bash
rclone copy \
  aws-s3-remote:my-migration-bucket/export-i-0abc.ova \
  oci-storage:oci-migration-bucket \
  -vv
```

**Command Breakdown**:
- `copy`: Copy files from source to destination
- `aws-s3-remote`: Source remote name (from rclone config)
- `:my-migration-bucket/`: S3 bucket and path
- `oci-storage`: Destination remote name
- `:oci-migration-bucket`: OCI bucket
- `-vv`: Very verbose logging (2 levels)

**Rclone Transfer Process**:

**1. Multipart Upload Architecture**:
```
┌─────────────────┐
│   Source (S3)   │
│   File: 50GB    │
└────────┬────────┘
         │ Split into chunks
         ▼
┌────────────────────────────┐
│  Chunk 1: 100MB           │
│  Chunk 2: 100MB           │
│  ...                       │
│  Chunk 500: 100MB         │
└────────┬───────────────────┘
         │ Parallel transfer
         ▼
┌─────────────────────────────┐
│   Destination (OCI)         │
│   Reassemble chunks         │
└─────────────────────────────┘
```

**2. Transfer Parameters**:

**Default Settings**:
```bash
# Chunk size: 5MB (default)
# Concurrency: 4 transfers (default)
# Retries: 3 (default)
# Timeout: 5 minutes (default)
```

**Optimized Settings for Large Transfers**:
```bash
rclone copy \
  aws-s3-remote:my-migration-bucket/export-i-0abc.ova \
  oci-storage:oci-migration-bucket \
  --transfers 16 \
  --checkers 8 \
  --buffer-size 256M \
  --s3-chunk-size 100M \
  --s3-upload-concurrency 8 \
  --retries 5 \
  --low-level-retries 10 \
  --timeout 10m \
  --progress \
  --stats 30s \
  --log-file rclone-transfer.log \
  -vv
```

**Parameter Explanations**:

**--transfers 16**:
- Number of parallel file transfers
- Default: 4
- Recommended: 8-32 depending on bandwidth
- Higher = faster but more memory/bandwidth

**--checkers 8**:
- Number of checkers running in parallel
- Verify file existence and size
- Default: 8
- Increase for many small files

**--buffer-size 256M**:
- In-memory buffer per transfer
- Default: 16M
- Larger = fewer API calls, more memory
- Balance: 128M-512M for large files

**--s3-chunk-size 100M**:
- Multipart upload chunk size
- Default: 5M
- Larger chunks = fewer API calls
- Recommended: 50M-100M for large files
- Max: 5GB per chunk

**--s3-upload-concurrency 8**:
- Concurrent chunks for single file
- Default: 4
- Higher = faster for large single files
- Consumes bandwidth proportionally

**--retries 5**:
- High-level retry count for operations
- Default: 3
- Increase for unstable connections

**--low-level-retries 10**:
- Low-level API call retries
- Default: 10
- Handles transient network errors

**--timeout 10m**:
- Timeout for single operation
- Default: 5m
- Increase for large chunks

**--progress**:
- Show real-time transfer progress
- Updates continuously
- Useful for monitoring

**--stats 30s**:
- Print stats every 30 seconds
- Shows: speed, ETA, errors
- Alternative: --stats 1m

**--log-file**:
- Write detailed logs to file
- Critical for troubleshooting
- Rotates automatically

**Performance Optimization Strategies**:

**1. Network Bandwidth Optimization**:
```bash
# Bandwidth limiting (if needed):
rclone copy source:path dest:path --bwlimit 100M

# Bandwidth scheduling:
# Full speed off-peak, limited during business hours
rclone copy source:path dest:path \
  --bwlimit "08:00,10M 19:00,off"
```

**2. Memory Optimization**:
```bash
# For systems with limited memory:
rclone copy source:path dest:path \
  --transfers 4 \
  --buffer-size 64M \
  --s3-chunk-size 50M

# For memory-rich systems:
rclone copy source:path dest:path \
  --transfers 32 \
  --buffer-size 512M \
  --s3-chunk-size 100M
```

**3. Integrity Verification**:
```bash
# Checksum verification (slower but safer):
rclone copy source:path dest:path --checksum

# Size and modtime only (faster):
rclone copy source:path dest:path --size-only

# Skip verification (fastest, not recommended):
rclone copy source:path dest:path --ignore-checksum
```

**4. Incremental Transfer**:
```bash
# Sync instead of copy (only transfers changes):
rclone sync source:path dest:path

# Warning: sync deletes files not in source!

# Safer: use --dry-run first
rclone sync source:path dest:path --dry-run -vv
```

**5. Compression**:
```bash
# Use compressed transfer (saves bandwidth):
# Note: VMDK already compressed, may not help

# For uncompressed files:
# Not directly supported; use pre/post-compression
```

**Monitoring Transfer Progress**:

**Real-time Monitoring**:
```bash
# In transfer terminal, output shows:
Transferred:   	   15.234 GiB / 50 GiB, 30%, 125 MiB/s, ETA 4m30s
Transferred:            1 / 1, 100%
Elapsed time:      2m5.2s

# Detailed stats with -vv:
2024/03/15 10:45:32 INFO  : export.ova: 30% done, avg 125 MiB/s, ETA 4m30s
```

**Log Analysis**:
```bash
# Monitor log file in real-time:
tail -f rclone-transfer.log

# Search for errors:
grep -i error rclone-transfer.log

# Check transfer summary:
grep "Transferred:" rclone-transfer.log | tail -1
```

**Troubleshooting Common Issues**:

**1. Slow Transfer Speed**:
```bash
# Check network bandwidth:
# AWS CloudShell has limited bandwidth
# OCI VM: Check VNIC bandwidth limit

# Solution: Use OCI VM with higher bandwidth
# Increase --transfers and --s3-upload-concurrency
```

**2. Transfer Interruption**:
```bash
# Rclone automatically resumes from checkpoint
# Retry with same command:
rclone copy source:path dest:path --retries 10

# Check partial uploads in OCI:
oci os object list --bucket-name <bucket> --prefix <path>
```

**3. Authentication Errors**:
```bash
# Error: "403 Forbidden" or "401 Unauthorized"

# Verify AWS credentials:
aws sts get-caller-identity

# Verify OCI credentials:
oci iam user get --user-id <ocid>

# Re-run rclone config if needed
```

**4. Out of Memory**:
```bash
# Reduce memory usage:
rclone copy source:path dest:path \
  --transfers 2 \
  --buffer-size 32M \
  --s3-chunk-size 20M
```

**Transfer Time Estimation**:

| File Size | Bandwidth | Estimated Time | Optimized Time |
|-----------|-----------|----------------|----------------|
| 10 GB | 100 Mbps | ~15 min | ~10 min |
| 50 GB | 100 Mbps | ~70 min | ~45 min |
| 100 GB | 100 Mbps | ~2.5 hours | ~1.5 hours |
| 500 GB | 100 Mbps | ~12 hours | ~7 hours |
| 1 TB | 1 Gbps | ~2.5 hours | ~1.5 hours |

**Post-Transfer Verification**:
```bash
# Verify file in OCI Object Storage:
oci os object list \
  --bucket-name oci-migration-bucket \
  --fields size,name,timeCreated

# Compare sizes:
# AWS S3:
aws s3api head-object \
  --bucket my-migration-bucket \
  --key export-i-0abc.ova \
  --query ContentLength

# OCI Object Storage:
oci os object head \
  --bucket-name oci-migration-bucket \
  --name export-i-0abc.ova \
  --query 'content-length'

# Sizes should match exactly

# Optional: Generate and compare checksums:
# AWS S3 ETag vs OCI Object Storage MD5
```

**Best Practices**:
1. **Test with small file first** (1-2 GB)
2. **Monitor first hour** of large transfers
3. **Use tmux/screen** for long-running transfers
4. **Enable logging** for audit trail
5. **Verify integrity** after transfer
6. **Clean up source** after successful migration
7. **Document transfer parameters** used
8. **Consider S3 Transfer Acceleration** for cross-region

**Alternative: Manual Transfer** (for small files):
```bash
# Download from S3:
aws s3 cp s3://bucket/file.ova ./file.ova

# Upload to OCI:
oci os object put \
  --bucket-name oci-bucket \
  --file ./file.ova \
  --name file.ova
```

---

### SECTION 5: CUSTOM IMAGE & INSTANCE LAUNCH

#### Q13: Explain the custom image creation process in OCI. What are the critical configuration parameters?

**Answer:**

**Custom Image Creation Process**:

**Step 1: Navigate to Custom Images**
```
OCI Console → Compute → Custom Images → Import Image
```

**Step 2: Configure Import Parameters**:

**Critical Parameters**:

**1. Compartment Selection**:
```
Purpose: Defines resource ownership and IAM scope
Consideration:
- Production vs Development compartments
- Cost tracking and billing
- Access control policies
- Resource organization

Best Practice:
- Use dedicated migration compartment
- Move to production after validation
- Apply proper tagging strategy
```

**2. Image Name**:
```
Naming Convention:
rhel-<version>-aws-migrated-<date>-<environment>

Examples:
- rhel-9.3-aws-migrated-2024-03-15-prod
- rhel-8.8-aws-migrated-20240315-dev
- rhel-9-migration-test-v1

Purpose:
- Identify source and purpose
- Version tracking
- Environment identification
```

**3. Operating System**:
```
Selection: Red Hat Enterprise Linux
Options:
- Oracle Linux
- CentOS
- Ubuntu
- Windows
- Custom Linux

CRITICAL: Select "Red Hat Enterprise Linux"
- Affects driver loading
- Impacts licensing
- Determines boot process
- OS-specific optimizations
```

**4. Object Storage Source**:
```
Configuration:
- Bucket Name: oci-migration-bucket
- Object Name: export-i-0abc1234.ova
- Region: us-ashburn-1 (must match)

Validation:
- File must exist in bucket
- Proper IAM permissions required
- Size limits: Up to 400 GB boot volume
```

**5. Launch Mode** (MOST CRITICAL):
```
Options:
a) Paravirtualized Mode (RECOMMENDED)
b) Emulated Mode
c) Native Mode (bare metal only)

Selection: Paravirtualized Mode

Why Paravirtualized?
- 6x faster disk I/O performance
- Lower CPU overhead
- Better memory efficiency
- Native cloud optimization
- Requires VirtIO drivers (already verified)

When to use Emulated?
- Legacy systems without VirtIO drivers
- Temporary fallback during troubleshooting
- Testing compatibility
- NOT recommended for production
```

**Step 3: Import Process Stages**:

**Stage 1: Validation (2-5 minutes)**
```
OCI validates:
✓ Object exists in bucket
✓ File format (VMDK/OVA)
✓ File integrity
✓ IAM permissions
✓ Compartment quotas

Status: "Importing" → Orange icon
```

**Stage 2: Image Creation (15-60 minutes)**
```
Process:
1. Download from Object Storage
2. Extract VMDK from OVA (if applicable)
3. Convert to OCI boot volume format
4. Apply paravirtualization configuration
5. Register as custom image

Progress Indicators:
- Time varies by image size
- 10 GB: ~15 minutes
- 50 GB: ~30 minutes
- 100 GB: ~60 minutes

Status: Still "Importing"
```

**Stage 3: Completion**
```
Final Status: "Available" → Green checkmark

Image Details Available:
- OCID: ocid1.image.oc1.iad.aaa...
- Size: Actual boot volume size
- Created date/time
- Source object reference
```

**Monitoring Import Progress**:

**Via Console**:
```
Compute → Custom Images → <image-name>
- Status: Importing / Available / Failed
- Work Request: View detailed logs
```

**Via CLI**:
```bash
# List custom images:
oci compute image list \
  --compartment-id <compartment-ocid> \
  --display-name "rhel-9.3-aws-migrated"

# Get specific image details:
oci compute image get \
  --image-id <image-ocid>

# Monitor work request:
oci work-requests work-request get \
  --work-request-id <wr-ocid>
```

**Image Creation Failures**:

**Common Failure Scenarios**:

**1. Invalid File Format**:
```
Error: "Image file format not supported"
Cause: Not VMDK or corrupted OVA
Solution:
- Verify file extension: .vmdk or .ova
- Check file integrity (MD5 checksum)
- Re-export from AWS if corrupted
```

**2. Missing VirtIO Drivers** (for Paravirtualized mode):
```
Error: "Image cannot boot in Paravirtualized mode"
Cause: VirtIO drivers not in initramfs
Solution:
- Return to Task 2.3
- Rebuild initramfs with dracut
- Re-export from AWS
```

**3. Insufficient Permissions**:
```
Error: "Access denied to Object Storage"
Cause: Missing IAM policies
Solution:
Allow group <group-name> to manage object-family in compartment <compartment-name>
Allow group <group-name> to manage instance-images in compartment <compartment-name>
```

**4. Quota Exceeded**:
```
Error: "Custom image quota exceeded"
Cause: Reached limit for custom images in compartment
Solution:
- Delete unused custom images
- Request quota increase
- Use different compartment
```

**5. Invalid Boot Configuration**:
```
Error: "Boot volume configuration invalid"
Cause: GRUB misconfiguration or missing kernel
Solution:
- Verify GRUB configuration (Task 2.2)
- Ensure kernel exists in /boot
- Check initramfs presence
```

**Step 4: Image Validation (Before Instance Launch)**:

**Verify Image Properties**:
```bash
# Using OCI CLI:
oci compute image get --image-id <image-ocid>

# Check critical properties:
{
  "data": {
    "display-name": "rhel-9.3-aws-migrated-2024-03-15",
    "operating-system": "Red Hat Enterprise Linux",
    "operating-system-version": "9.3",
    "launch-mode": "PARAVIRTUALIZED",
    "lifecycle-state": "AVAILABLE",
    "size-in-mbs": 51200,  // ~50 GB
    "create-image-allowed": true
  }
}
```

**Key Validation Points**:
- ✅ lifecycle-state: "AVAILABLE" (not DISABLED or DELETED)
- ✅ launch-mode: "PARAVIRTUALIZED"
- ✅ operating-system: Matches source
- ✅ size-in-mbs: Reasonable size

**Image Optimization (Optional)**:

**Create Image Variants**:
```bash
# For different use cases:
1. Development: Smaller shape, minimal config
2. Production: Optimized config, monitoring agents
3. DR: Cross-region copy
```

**Cross-Region Copy**:
```bash
# Copy image to DR region:
oci compute image export to-object \
  --image-id <source-image-ocid> \
  --destination-uri <object-storage-uri>

# Then import in target region:
oci compute image import from-object \
  --compartment-id <compartment-ocid> \
  --source-uri <object-storage-uri>
```

**Image Tagging**:
```bash
# Add metadata tags:
oci compute image update \
  --image-id <image-ocid> \
  --defined-tags '{"Migration":{"Source":"AWS", "Date":"2024-03-15", "Environment":"Production"}}'  \
  --freeform-tags '{"CostCenter":"IT-Ops", "Owner":"migration-team"}'
```

**Step 5: Create Instance from Custom Image**:

Now ready to proceed to Task 5 (covered in next question)

**Best Practices**:
1. **Test in non-production first**
2. **Document image OCID** for repeatability
3. **Tag images** with metadata
4. **Version images** for rollback capability
5. **Clean up unused images** (costs apply for storage)
6. **Cross-region copy** for DR
7. **Automate with Terraform/CLI** for multiple images
8. **Validate boot capability** before production deployment

---

#### Q14: What are all the instance launch configurations, and how do you ensure the migrated instance works correctly?

**Answer:**

**Instance Launch Configuration**:

**Step 1: Initiate Instance Launch**
```
Method 1: From Custom Image page
- Navigate to custom image
- Click "Create Instance"

Method 2: From Compute Instances
- Create Instance → Image and Shape
- Click "Change Image"
- Select Custom Images
- Choose migrated image
```

**Step 2: Configure Instance Details**:

**1. Name and Compartment**:
```
Name: rhel-aws-migrated-prod-01
Naming Convention:
<os>-<source>-migrated-<environment>-<number>

Compartment: Production-Compartment
Purpose:
- Resource organization
- IAM policy scope
- Cost allocation
- Billing separation
```

**2. Placement Configuration**:
```
Availability Domain: AD-1, AD-2, or AD-3
Selection Criteria:
- Workload distribution
- Capacity availability
- Disaster recovery requirements
- Proximity to other resources

Fault Domain (Optional): FD-1, FD-2, or FD-3
Purpose:
- Additional isolation within AD
- Hardware failure protection
- Maintenance event isolation
```

**3. Image and Shape**:
```
Image: <custom-image-name> (pre-selected)
Image OCID: ocid1.image.oc1.iad.aaa...

Shape Selection Considerations:

Standard Shapes (Intel/AMD):
- VM.Standard.E4.Flex (AMD EPYC, flexible OCPU)
- VM.Standard3.Flex (Intel, flexible OCPU)
- VM.Standard.E5.Flex (AMD, latest gen)

Recommendations based on AWS equivalent:
AWS t3.medium (2 vCPU, 4GB) → OCI VM.Standard.E4.Flex (2 OCPU, 8GB)
AWS m5.large (2 vCPU, 8GB) → OCI VM.Standard3.Flex (2 OCPU, 16GB)
AWS m5.xlarge (4 vCPU, 16GB) → OCI VM.Standard.E4.Flex (4 OCPU, 16GB)

Flex Shape Benefits:
- Customize OCPU count (1-64)
- Customize memory (1 GB per OCPU minimum)
- Cost optimization
- Exact resource matching
```

**Example Flex Configuration**:
```
Shape: VM.Standard.E4.Flex
Number of OCPUs: 4
Amount of Memory (GB): 16

Rationale:
- Matches AWS m5.xlarge workload
- AMD EPYC performance
- Cost-effective
- Scalable
```

**4. Networking**:
```
Virtual Cloud Network (VCN): Migration-VCN

Subnet Selection:
a) Public Subnet (for testing/initial validation)
   - Direct internet access via Internet Gateway
   - Public IP automatically assigned
   - Good for: SSH access, testing, development

b) Private Subnet (for production)
   - No direct internet access
   - Requires NAT Gateway for outbound
   - Access via Bastion host or VPN
   - Good for: Production workloads, security compliance

Selection for this tutorial: Public Subnet
Reason: Simplified SSH access for validation

Private IP Address:
- Auto-assign (recommended): DHCP from subnet range
- Manual assignment: Specify IP from subnet CIDR
  Example: 10.0.1.50 (if subnet is 10.0.1.0/24)

Public IP:
Options:
1. No public IP: Private subnet communication only
2. Ephemeral public IP: Temporary, changes on stop/start
3. Reserved public IP: Permanent, survives stop/start

For Tutorial: Ephemeral public IP
Production: Reserved public IP (for stable DNS)

Hostname:
- Auto-generated: instance-20240315-1045
- Custom: rhel-migrated-01.subnet.vcn.oraclevcn.com
```

**5. Boot Volume**:
```
Use default boot volume size: Matches source image
Custom boot volume size: Increase if needed (cannot decrease)

Boot Volume Size: 50 GB (from image)
Increase to: 100 GB (if application needs more space)

Boot Volume Performance:
- Balanced (default): 60 IOPS/GB
- Higher Performance: 75-120 IOPS/GB
- Ultra High Performance: 120+ IOPS/GB

In-transit encryption: Enabled (default, recommended)
Encryption key: Oracle-managed or Customer-managed (Vault)

Boot Volume Backup:
- Enable automatic backups: Yes (recommended)
- Backup policy: Bronze (weekly), Silver (daily), Gold (hourly)
```

**6. SSH Keys** (CRITICAL FOR THIS MIGRATION):
```
Two Options:

Option A: Use Same Keys from AWS (Recommended for continuity)
1. Upload public key (.pem.pub format)
2. AWS key was in .pem format
3. Change extension: mykey.pem → mykey.pem.pub
4. Upload the .pem.pub file
5. Result: ec2-user remains functional with same private key

Option B: Generate New SSH Keys
1. OCI generates new key pair
2. Download private key (save securely)
3. Result: Default opc user, new keys required

Tutorial Approach: Option A
Benefits:
- No workflow change
- Same private key works
- ec2-user account persists
- Familiar environment
```

**SSH Key Format Conversion** (if needed):
```bash
# AWS provides .pem format (contains public key)
# Extract public key from private key:
ssh-keygen -y -f mykey.pem > mykey.pem.pub

# Verify public key format:
cat mykey.pem.pub
# Should start with: ssh-rsa AAAAB3NzaC1yc2EA...

# Upload mykey.pem.pub to OCI instance
```

**7. Advanced Options**:

**Management**:
```
Cloud Agent Plugins:
✓ OS Management Service Agent: System updates, patching
✓ Compute Instance Monitoring: Metrics collection
✓ Block Volume Management: Volume discovery
✓ Bastion: Bastion service integration
✓ Vulnerability Scanning: Security scanning

Recommended: Enable all for comprehensive management
```

**Initialization Script** (cloud-init):
```bash
#!/bin/bash
# Custom initialization for migrated instance

# Update hostname
hostnamectl set-hostname rhel-migrated-prod-01

# Install monitoring agents
yum install -y oracle-cloud-agent

# Configure NTP
systemctl enable chronyd
systemctl start chronyd

# Set timezone
timedatectl set-timezone America/New_York

# Install additional packages
yum install -y vim wget curl net-tools

# Create application user
useradd -m appuser

# Configure firewall rules
firewall-cmd --permanent --add-service=http
firewall-cmd --permanent --add-service=https
firewall-cmd --reload

# Custom application setup
# (Add your application-specific configuration here)

echo "Instance initialization complete" >> /var/log/custom-init.log
```

**Instance Metadata**:
```
Define instance metadata for tracking:
- Environment: Production
- Application: WebApp
- Owner: migration-team
- CostCenter: IT-OPS
- SourceAWS: i-0abc1234efgh5678
- MigrationDate: 2024-03-15
```

**8. Finalize and Launch**:
```
Review all configurations:
✓ Image: Custom RHEL image
✓ Shape: VM.Standard.E4.Flex (4 OCPU, 16 GB)
✓ VCN/Subnet: Public subnet for SSH access
✓ SSH Keys: AWS public key uploaded
✓ Boot Volume: 50 GB, balanced performance

Click "Create"
```

**Step 3: Monitor Instance Launch**:

**Launch Phases**:
```
Phase 1: Provisioning (30-60 seconds)
Status: "Provisioning" (orange)
Activity:
- Resource allocation
- Shape assignment
- Network configuration
- Volume attachment

Phase 2: Starting (1-3 minutes)
Status: "Starting" (orange)
Activity:
- Power on VM
- BIOS/UEFI initialization
- GRUB boot loader
- Kernel loading
- Init system startup

Phase 3: Running (green checkmark)
Status: "Running"
Activity:
- Cloud-init execution
- Network configuration (DHCP)
- Service startup
- Application initialization
```

**Monitoring via Console**:
```
Navigate: Compute → Instances → Instance Details

Key Information:
- Public IP Address: 129.146.10.50
- Private IP Address: 10.0.1.25
- Status: Running
- Shape: VM.Standard.E4.Flex
- OCPU Count: 4
- Memory: 16 GB
- Boot Volume: rhel-boot-volume-20240315
```

**Monitoring via CLI**:
```bash
# Get instance details:
oci compute instance get \
  --instance-id <instance-ocid>

# Check instance status:
oci compute instance list \
  --compartment-id <compartment-ocid> \
  --display-name "rhel-aws-migrated-prod-01" \
  --query 'data[0]."lifecycle-state"'

# Get public IP:
oci compute instance list-vnics \
  --instance-id <instance-ocid> \
  --query 'data[0]."public-ip"'
```

**Step 4: Post-Launch Validation**:

**Validation Checklist**:

**1. SSH Connectivity Test**:
```bash
# From local machine:
ssh -i /path/to/mykey.pem ec2-user@129.146.10.50

# Expected: Successful login
# User: ec2-user (because we used same SSH key)

# If using new keys:
ssh -i /path/to/new-private-key opc@129.146.10.50
# User: opc (OCI default)
```

**First Login Validation**:
```bash
# Check hostname:
hostname
# Output: rhel-migrated-prod-01 (or auto-generated)

# Check OS version:
cat /etc/redhat-release
# Output: Red Hat Enterprise Linux release 9.3 (Plow)

# Verify kernel version:
uname -r
# Output: 5.14.0-362.el9.x86_64

# Check users:
whoami
# Output: ec2-user (confirms key mapping worked)

# Verify sudo access:
sudo -l
# Should show passwordless sudo access
```

**2. Network Configuration Validation**:
```bash
# Check network interfaces:
ip addr show

# Expected output:
1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN
    inet 127.0.0.1/8 scope host lo
    
2: eth0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 9000 qdisc mq state UP
    link/ether 02:00:17:01:56:78 brd ff:ff:ff:ff:ff:ff
    inet 10.0.1.25/24 brd 10.0.1.255 scope global dynamic eth0
    inet6 fe80::17ff:fe01:5678/64 scope link

# Key validations:
✓ New MAC address (02:00:17:... OCI format)
✓ DHCP-assigned IP (10.0.1.25)
✓ MTU 9000 (OCI jumbo frames)
✓ Interface UP and running

# Check routes:
ip route show
# Expected:
default via 10.0.1.1 dev eth0 proto dhcp metric 100
10.0.1.0/24 dev eth0 proto kernel scope link src 10.0.1.25

# Test internet connectivity:
ping -c 4 google.com
# Should succeed from public subnet

# Check DNS resolution:
cat /etc/resolv.conf
# Expected:
nameserver 169.254.169.254
search subnet.vcn.oraclevcn.com

# Test DNS:
nslookup oracle.com
# Should resolve successfully
```

**3. Storage Validation**:
```bash
# Check boot volume:
lsblk
# Expected output:
NAME    MAJ:MIN RM SIZE RO TYPE MOUNTPOINT
sda       8:0    0  50G  0 disk 
├─sda1    8:1    0   1G  0 part /boot
└─sda2    8:2    0  49G  0 part /

# Check disk usage:
df -h
# Verify available space

# Test disk performance:
sudo dd if=/dev/zero of=/tmp/testfile bs=1G count=1 oflag=direct
# Note: Should be significantly faster (6x) than AWS emulated mode

# Clean up test:
sudo rm /tmp/testfile
```

**4. VirtIO Driver Verification**:
```bash
# Confirm VirtIO drivers loaded:
lsmod | grep virtio

# Expected output:
virtio_scsi            18432  2
virtio_net             40960  0
virtio_pci             24576  0
virtio_ring            24576  3 virtio_scsi,virtio_net,virtio_pci
virtio                 16384  3 virtio_scsi,virtio_net,virtio_pci

# Check dmesg for VirtIO initialization:
dmesg | grep -i virtio
# Should show successful device detection and initialization
```

**5. Serial Console Validation**:
```bash
# Test serial console access from OCI Console:
# Navigate to: Instance Details → Console Connection
# Create console connection (if not exists)
# Connect and verify GRUB menu appears on reboot

# Test from CLI:
oci compute instance-console-connection create \
  --instance-id <instance-ocid> \
  --public-key "$(cat ~/.ssh/id_rsa.pub)"

# Get connection string:
oci compute instance-console-connection get \
  --instance-console-connection-id <connection-ocid>

# SSH to serial console:
ssh -i ~/.ssh/id_rsa -o ProxyCommand='ssh -i ~/.ssh/id_rsa -W %h:%p -p 443 ocid1.instanceconsoleconnection.oc1.iad.aaa...@instance-console.us-ashburn-1.oraclecloud.com' ocid1.instance.oc1.iad.aaa...
```

**6. System Services Validation**:
```bash
# Check critical services:
systemctl status sshd
systemctl status NetworkManager
systemctl status chronyd
systemctl status firewalld

# All should show: active (running)

# Check NTP synchronization:
chronyc sources
# Should show OCI time server: 169.254.169.254

# Verify SELinux status (if enabled):
getenforce
# Output: Enforcing (should match AWS configuration)

# Check firewall rules:
sudo firewall-cmd --list-all
# Verify expected ports open
```

**7. Cloud-init Verification**:
```bash
# Check cloud-init logs:
sudo cat /var/log/cloud-init.log
sudo cat /var/log/cloud-init-output.log

# Verify cloud-init completed successfully:
sudo cloud-init status
# Expected: status: done

# Check metadata service:
curl -s http://169.254.169.254/opc/v1/instance/
# Should return instance metadata JSON
```

**8. Performance Baseline**:
```bash
# CPU performance test:
sysbench cpu --cpu-max-prime=20000 run

# Memory performance:
sysbench memory --memory-total-size=10G run

# Disk I/O test (sequential write):
sudo fio --name=sequential-write \
  --ioengine=libaio \
  --iodepth=32 \
  --rw=write \
  --bs=1M \
  --size=5G \
  --numjobs=1 \
  --filename=/tmp/fio-test \
  --direct=1

# Compare results with AWS baseline
# Expected: 6x better disk performance

# Clean up:
sudo rm /tmp/fio-test
```

**9. Application-Specific Validation**:
```bash
# If web application:
sudo systemctl status httpd
# OR
sudo systemctl status nginx

# Test application endpoints:
curl http://localhost:80
curl http://localhost:443

# If database:
sudo systemctl status postgresql
# OR
sudo systemctl status mariadb

# Test database connectivity:
psql -U postgres -c "SELECT version();"

# Application logs:
sudo tail -f /var/log/httpd/access_log
sudo tail -f /var/log/application/app.log
```

**Step 5: Troubleshooting Common Issues**:

**Issue 1: Cannot SSH to Instance**:
```bash
# Diagnosis:
1. Check instance status: Should be "Running"
2. Check public IP: Should be assigned
3. Verify Security List/NSG rules:
   - Ingress rule: 0.0.0.0/0 → TCP/22
4. Check route table: IGW route present
5. Verify SSH key: Correct private key used
6. Check firewall on instance (via serial console):
   sudo firewall-cmd --list-all

# Solution:
# Add Security List rule:
oci network security-list update \
  --security-list-id <sl-ocid> \
  --ingress-security-rules '[
    {
      "protocol": "6",
      "source": "0.0.0.0/0",
      "tcpOptions": {
        "destinationPortRange": {"min": 22, "max": 22}
      }
    }
  ]'
```

**Issue 2: Instance Boots but No Network**:
```bash
# Access via serial console
# Check interface status:
ip link show eth0

# If DOWN:
sudo ip link set eth0 up

# Restart NetworkManager:
sudo systemctl restart NetworkManager

# Check for MAC address hardcoding:
grep -r "02:00:17" /etc/

# If found in old udev rules:
sudo rm /etc/udev/rules.d/*-persistent-net.rules
sudo reboot
```

**Issue 3: Application Not Starting**:
```bash
# Check dependencies:
sudo systemctl list-dependencies <service-name>

# Check logs:
sudo journalctl -u <service-name> -n 50

# Common issues:
1. Configuration files still reference AWS metadata
   - Update from 169.254.169.254/latest to 169.254.169.254/opc/v1
   
2. Listening on wrong interface
   - Update from eth0 IP to new IP
   
3. Database connection strings
   - Update AWS RDS endpoints to OCI Database endpoints

4. File permissions (if boot volume expanded)
   - Verify ownership: ls -la /data
```

**Issue 4: Performance Issues**:
```bash
# Verify Paravirtualized mode:
dmesg | grep -i "Hypervisor detected"
# Should show: KVM

# Check VirtIO drivers:
lsmod | grep virtio
# All required drivers should be loaded

# If using emulated mode by mistake:
# Cannot change after instance creation
# Must recreate instance with correct image launch mode

# Verify shape resources:
nproc  # Should match OCPU count
free -h  # Should match memory allocation
```

**Issue 5: Boot Failure**:
```bash
# Access serial console immediately
# Common causes:

1. GRUB timeout=0 (skips menu)
   - Reboot and press ESC during GRUB
   - Edit /etc/default/grub via rescue mode
   - Set GRUB_TIMEOUT=5

2. Missing initramfs
   - Boot from rescue
   - Rebuild: dracut -f

3. Kernel panic
   - Check kernel parameters in GRUB
   - Boot older kernel from GRUB menu

4. Filesystem errors
   - fsck from rescue mode
   - Check /etc/fstab for invalid entries
```

**Step 6: Post-Migration Optimization**:

**Performance Tuning**:
```bash
# Tune for OCI network (MTU 9000):
sudo ip link set eth0 mtu 9000

# Make permanent:
sudo nmcli connection modify "System eth0" 802-3-ethernet.mtu 9000

# Optimize for cloud workload:
cat <<EOF | sudo tee /etc/sysctl.d/99-oci-tuning.conf
# Network tuning
net.core.rmem_max = 134217728
net.core.wmem_max = 134217728
net.ipv4.tcp_rmem = 4096 87380 67108864
net.ipv4.tcp_wmem = 4096 65536 67108864

# Increase connection tracking
net.netfilter.nf_conntrack_max = 262144

# Disk I/O scheduler (for VirtIO)
# Set via udev rules or kernel parameters
EOF

sudo sysctl -p /etc/sysctl.d/99-oci-tuning.conf
```

**Monitoring Setup**:
```bash
# Install OCI monitoring agent (if not via cloud-agent):
sudo yum install -y oracle-cloud-agent

# Enable metrics:
sudo systemctl enable oracle-cloud-agent
sudo systemctl start oracle-cloud-agent

# Configure custom metrics:
sudo vi /etc/oracle-cloud-agent/plugins/oci-monitoring/monitoring.yaml
```

**Backup Configuration**:
```bash
# Enable boot volume backup:
oci bv boot-volume-backup create \
  --boot-volume-id <boot-volume-ocid> \
  --display-name "Post-migration-baseline-backup"

# Create backup policy:
oci bv volume-backup-policy create \
  --compartment-id <compartment-ocid> \
  --display-name "Daily-backup-policy" \
  --schedules '[
    {
      "period": "ONE_DAY",
      "retention-seconds": 2592000,
      "time-zone": "UTC",
      "hour-of-day": 2
    }
  ]'
```

**Security Hardening**:
```bash
# Update all packages:
sudo yum update -y

# Configure firewall:
sudo firewall-cmd --permanent --remove-service=cockpit
sudo firewall-cmd --permanent --remove-service=dhcpv6-client
sudo firewall-cmd --reload

# Disable unused services:
sudo systemctl disable postfix
sudo systemctl stop postfix

# Configure SELinux (if needed):
sudo setsebool -P httpd_can_network_connect on

# Install security updates automatically:
sudo yum install -y yum-cron
sudo systemctl enable yum-cron
sudo systemctl start yum-cron
```

**Documentation**:
```
Create migration documentation:
- Source AWS instance ID: i-0abc1234efgh5678
- Source AMI ID: ami-0abcdef1234567890
- Migration date: 2024-03-15
- OCI Instance OCID: ocid1.instance.oc1.iad.aaa...
- OCI Image OCID: ocid1.image.oc1.iad.aaa...
- Public IP: 129.146.10.50
- Private IP: 10.0.1.25
- SSH key used: Same as AWS (mykey.pem)
- Default user: ec2-user
- Performance baseline: Document metrics
- Application endpoints: List URLs
- Known issues: None / Document any
- Rollback procedure: AWS instance still available (stopped)
```

**Success Criteria Checklist**:
```
✅ Instance running
✅ SSH access working (ec2-user)
✅ Network connectivity confirmed
✅ VirtIO drivers loaded
✅ Disk I/O performance validated (6x improvement)
✅ Serial console accessible
✅ System services running
✅ Application functional
✅ Monitoring configured
✅ Backups enabled
✅ Security hardened
✅ Documentation complete
```

---

### SECTION 6: ADVANCED SCENARIOS & TROUBLESHOOTING

#### Q15: How would you handle a migration with multiple volumes (boot + data volumes)?

**Answer:**

**Multi-Volume Migration Strategy**:

**Scenario**: AWS EC2 instance with:
- Boot volume (sda): 50 GB (RHEL OS)
- Data volume (sdb): 500 GB (Application data)
- Data volume (sdc): 1 TB (Database files)

**Challenge**: AWS VM export only exports boot volume

**Solution Approach**:

**Method 1: Separate Volume Migration**:

**Step 1: Boot Volume Migration** (as per tutorial):
```bash
# Export boot volume only:
aws ec2 create-instance-export-task \
  --instance-id i-0abc1234 \
  --target-environment vmware \
  --export-to-s3-task DiskImageFormat=vmdk,ContainerFormat=ova,S3Bucket=migration-bucket
```

**Step 2: Data Volume Snapshot and Copy**:
```bash
# Create snapshots of data volumes:
aws ec2 create-snapshot \
  --volume-id vol-data-001 \
  --description "Data volume for migration"

aws ec2 create-snapshot \
  --volume-id vol-data-002 \
  --description "Database volume for migration"

# Export snapshots to S3:
# Note: AWS doesn't directly support snapshot export
# Use AWS Systems Manager or third-party tools

# Alternative: Use dd to create disk images
# Attach volumes to running instance:
sudo dd if=/dev/xvdf of=/mnt/data-volume.img bs=1M status=progress

# Upload to S3:
aws s3 cp /mnt/data-volume.img s3://migration-bucket/
```

**Step 3: Transfer to OCI**:
```bash
# Transfer all images:
rclone copy aws-s3:migration-bucket/boot-volume.ova oci-storage:oci-bucket/
rclone copy aws-s3:migration-bucket/data-volume.img oci-storage:oci-bucket/
rclone copy aws-s3:migration-bucket/db-volume.img oci-storage:oci-bucket/
```

**Step 4: Create OCI Resources**:
```bash
# Import boot volume as custom image (as tutorial):
oci compute image import from-object \
  --compartment-id <compartment-ocid> \
  --source-uri oci-storage:oci-bucket/boot-volume.ova

# Create block volumes from images:
# First, download images to OCI instance:
wget <pre-authenticated-request-url-for-data-volume.img>

# Create block volume:
oci bv volume create \
  --compartment-id <compartment-ocid> \
  --availability-domain AD-1 \
  --display-name "migrated-data-volume" \
  --size-in-gbs 500

# Attach volume to temporary instance:
oci compute volume-attachment attach \
  --instance-id <temp-instance-ocid> \
  --volume-id <volume-ocid> \
  --type paravirtualized

# Restore data:
sudo dd if=/path/to/data-volume.img of=/dev/sdb bs=1M status=progress

# Detach from temp instance, attach to production instance
```

**Method 2: rsync/scp Data Transfer** (Preferred for large data):

**Step 1: Migrate Boot Volume** (as tutorial)

**Step 2: Launch OCI Instance**

**Step 3: Create and Attach Block Volumes in OCI**:
```bash
# Create data volumes:
oci bv volume create \
  --compartment-id <compartment-ocid> \
  --availability-domain AD-1 \
  --display-name "data-volume-500gb" \
  --size-in-gbs 500

oci bv volume create \
  --compartment-id <compartment-ocid> \
  --availability-domain AD-1 \
  --display-name "db-volume-1tb" \
  --size-in-gbs 1024

# Attach to OCI instance:
oci compute volume-attachment attach \
  --instance-id <instance-ocid> \
  --volume-id <data-volume-ocid> \
  --type paravirtualized

# On OCI instance, format and mount:
sudo mkfs.xfs /dev/sdb
sudo mkfs.xfs /dev/sdc

sudo mkdir -p /data
sudo mkdir -p /database

sudo mount /dev/sdb /data
sudo mount /dev/sdc /database

# Add to fstab:
sudo blkid /dev/sdb  # Get UUID
sudo blkid /dev/sdc

echo "UUID=xxxx /data xfs defaults,_netdev 0 2" | sudo tee -a /etc/fstab
echo "UUID=yyyy /database xfs defaults,_netdev 0 2" | sudo tee -a /etc/fstab
```

**Step 4: Direct Data Transfer**:
```bash
# From AWS instance (source):
# Install rsync:
sudo yum install -y rsync

# Create compressed tarball (if network bandwidth limited):
sudo tar czf /tmp/data-backup.tar.gz /data

# Transfer to OCI using rsync over SSH:
rsync -avz -e "ssh -i mykey.pem" \
  /data/ \
  ec2-user@129.146.10.50:/data/

rsync -avz -e "ssh -i mykey.pem" \
  /database/ \
  ec2-user@129.146.10.50:/database/

# For large transfers, use screen/tmux:
screen -S data-migration
rsync -avz --progress -e "ssh -i mykey.pem" \
  /data/ \
  ec2-user@129.146.10.50:/data/

# Detach: Ctrl+A, D
# Reattach: screen -r data-migration

# Verify transfer:
# Source:
du -sh /data
# Destination (on OCI):
du -sh /data

# Should match
```

**Method 3: AWS DataSync to OCI** (Enterprise approach):

**Architecture**:
```
AWS EBS Volumes → AWS DataSync Agent → 
AWS S3 → rclone → OCI Object Storage → 
OCI Block Volumes
```

**Implementation**:
```bash
# 1. Create DataSync agent in AWS




https://chat.deepseek.com/share/rb4w9jich6xippcr3s