
---

### **१.१ क्लाउडमध्ये स्वतःचे प्रायव्हेट व्हर्च्युअल नेटवर्क तयार करणे (VPC द्वारे)**

#### 🛑 **समस्या (Problem):**

तुम्हाला एका विशिष्ट **region** मध्ये तुमची **cloud resources** (उदा. EC2 instances, databases) होस्ट करण्यासाठी एक **नेटवर्क बेस (foundation)** तयार करण्याची गरज आहे.

#### ✅ **उपाय (Solution):**

तुम्ही एक **Amazon Virtual Private Cloud (Amazon VPC)** तयार कराल आणि त्यासाठी एक **CIDR block** (IP पत्त्यांची मर्यादा) कॉन्फिगर कराल.

---

### थोडक्यात स्पष्टीकरण:

* **Amazon VPC** हे तुमचं cloud मधील प्रायव्हेट नेटवर्क असतं, जिथे तुम्ही तुमच्या संसाधनांवर (resources) नियंत्रण ठेवू शकता.
* **CIDR block** हे IP address चा रेंज ठरवतं, उदा. `10.0.0.0/16` – याचा अर्थ तुम्हाला 65,536 IP addresses मिळतील.
* हे VPC region-specific असते – म्हणजे ते एका region मध्ये तयार केलं जातं आणि त्याच region मध्ये ते लागू असतं.

---

**उदाहरण:**
तुम्ही Mumbai region मध्ये VPC तयार करता आणि CIDR block `10.0.0.0/16` सेट करता, म्हणजे तुम्ही त्या VPC मध्ये पुढे सबनेट्स, EC2 instances, आणि इतर सेवा तयार करू शकता.

हवे असल्यास मी याची **स्टेप बाय स्टेप प्रक्रिया**, आर्किटेक्चर डायग्राम किंवा CLI/Console द्वारे setup मार्गदर्शकही देऊ शकतो.

खाली दिलेले **Discussion** चे मराठी भाषांतर आहे, जे तुम्हाला Amazon VPC आणि त्याच्या नेटवर्किंग कॉन्फिगरेशनचा सखोल अर्थ समजून घेण्यासाठी मदत करेल:

---

## 🧩 **चर्चा (Discussion):**

तुम्ही **Amazon Virtual Private Cloud (Amazon VPC)** तयार केली आहे, जी AWS वर एक **तार्किकदृष्ट्या स्वतंत्र (logically isolated)** व्हर्च्युअल नेटवर्क म्हणून काम करते.

तुम्ही एक **IPv4 CIDR block** निवडला आहे, जो VPC मध्ये तयार होणाऱ्या **subnets साठी IP address चा रेंज** ठरवतो. (पुढील recipe मध्ये आपण सबनेट्सबद्दल सविस्तर पाहणार आहोत.)

---

### ⚠️ **महत्वाची सूचना (WARNING):**

**VPC साठी CIDR block निवडताना दोन महत्वाचे मुद्दे लक्षात घ्या:**

1. एकदा VPC साठी CIDR block सेट केला, की तो **बदलता येत नाही**.
   जर तुम्हाला CIDR block बदलायचा असेल, तर **संपूर्ण VPC आणि त्यातील सर्व resources delete करून पुन्हा तयार करावी लागते.**

2. जर तुमचं VPC इतर नेटवर्क्सशी **peering (Recipe 2.11 मध्ये दिलं आहे)** किंवा **gateways** (जसे Transit Gateway किंवा VPN Gateway) च्या माध्यमातून जोडले असेल, तर **CIDR blocks मध्ये IP range overlaping नसावी.**

---

### ➕ **अधिक IPv4 जागा कशी जोडाल?**

जर तुम्हाला जास्त IP space लागलं, तर तुम्ही खालील command ने अतिरिक्त IPv4 CIDR block जोडू शकता:

```
aws ec2 associate-vpc-cidr-block --vpc-id <your-vpc-id> \
--cidr-block <additional-cidr-block>
```

> **टीप:** सर्व वेळेस मोठा CIDR block देणं आवश्यक नाही. जर तुम्हाला खात्री नसेल की किती IPs लागणार आहेत, तर कमी space देऊन सुरुवात करा आणि नंतर गरजेनुसार वाढवा.

---

### 🌐 **IPv6 ची मदत घेणे:**

VPC **IPv6** ला सुद्धा सपोर्ट करतं. तुम्ही `--amazon-provided-ipv6-cidr-block` वापरून **AWS कडून दिलेला IPv6 CIDR block** सेट करू शकता.

#### ✅ **उदाहरण:**

IPv6 CIDR Block सह VPC तयार करणे:

```bash
aws ec2 create-vpc --cidr-block 10.10.0.0/16 \
  --amazon-provided-ipv6-cidr-block \
  --tag-specifications 'ResourceType=vpc,Tags=[{Key=Name,Value=AWSCookbook201-IPv6}]'
```

---

### 🏢 **VPC म्हणजे Regional कॉन्स्ट्रक्ट**

* **VPC हे AWS region मध्ये तयार केलं जातं**, आणि त्या region मधील **सर्व Availability Zones (AZs)** मध्ये ते उपलब्ध असतं.
* **Availability Zones** म्हणजे वेगवेगळे physically isolated data centers.
* प्रत्येक region मध्ये **किमान ३ AZs** असतात.

> तुम्ही VPC ला पुढे **AWS Local Zones**, **Wavelength Zones**, आणि **AWS Outposts** मध्ये extend करू शकता.

**ताज्या AWS Regions व AZs माहिती साठी:**
👉 [https://aws.amazon.com/about-aws/global-infrastructure/regions\_az/](https://aws.amazon.com/about-aws/global-infrastructure/regions_az/)

---

### 🔜 **पुढील टप्पा:**

एकदा VPC तयार झाला की, तुम्ही त्यामध्ये **सबनेट्स, route tables, gateways, आणि अन्य networking घटक** तयार करायला सुरुवात करू शकता.
➡️ पुढील recipe (2.2) मध्ये आपण **Subnets आणि Route Tables** बद्दल शिकणार आहोत.

---




खालील मजकूर **"1.2 Creating a Network Tier with Subnets and a Route Table in a VPC"** चं मराठीत संपूर्ण भाषांतर दिलं आहे:

---

## **१.२ – VPC मध्ये Subnets आणि Route Table चा वापर करून नेटवर्क स्तर (Tier) तयार करणे**

---

### 🔧 **समस्या (Problem):**

तुमच्याकडे एक VPC आहे आणि त्यात **विभक्त IP जागा (segmentation)** आणि **redundancy** साधण्यासाठी स्वतंत्र Subnets असलेलं एक नेटवर्क लेआउट तयार करायचं आहे.

---

### ✅ **उपाय (Solution):**

* VPC मध्ये एक Route Table तयार करा.
* दोन Subnets वेगवेगळ्या Availability Zones मध्ये तयार करा.
* Route Table त्या Subnets सोबत जोडा.

---

### 🧱 **पूर्वअट (Prerequisites):**

* एक VPC असणं आवश्यक आहे.

---

### 🛠 **तयारी (Preparation):**

```bash
VPC_ID=$(aws ec2 create-vpc --cidr-block 10.10.0.0/23 \
--tag-specifications 'ResourceType=vpc,Tags=[{Key=Name,Value=AWSCookbook202}]' \
--output text --query Vpc.VpcId)
```

---

### 🚀 **पायऱ्या (Steps):**

#### 1️⃣ Route Table तयार करा:

```bash
ROUTE_TABLE_ID=$(aws ec2 create-route-table --vpc-id $VPC_ID \
--tag-specifications 'ResourceType=route-table,Tags=[{Key=Name,Value=AWSCookbook202}]' \
--output text --query RouteTable.RouteTableId)
```

#### 2️⃣ दोन Subnets तयार करा – प्रत्येक वेगळ्या Availability Zone मध्ये:

```bash
SUBNET_ID_1=$(aws ec2 create-subnet --vpc-id $VPC_ID \
--cidr-block 10.10.0.0/24 --availability-zone ${AWS_REGION}a \
--tag-specifications 'ResourceType=subnet,Tags=[{Key=Name,Value=AWSCookbook202a}]' \
--output text --query Subnet.SubnetId)

SUBNET_ID_2=$(aws ec2 create-subnet --vpc-id $VPC_ID \
--cidr-block 10.10.1.0/24 --availability-zone ${AWS_REGION}b \
--tag-specifications 'ResourceType=subnet,Tags=[{Key=Name,Value=AWSCookbook202b}]' \
--output text --query Subnet.SubnetId)
```

📌 **टीप:** `${AWS_REGION}a` आणि `${AWS_REGION}b` हे तुमच्या region नुसार बदलतात. यासाठी:

```bash
aws ec2 describe-availability-zones --region $AWS_REGION
```

#### 3️⃣ Subnets सोबत Route Table Associate करा:

```bash
aws ec2 associate-route-table --route-table-id $ROUTE_TABLE_ID --subnet-id $SUBNET_ID_1
aws ec2 associate-route-table --route-table-id $ROUTE_TABLE_ID --subnet-id $SUBNET_ID_2
```

---

### 🔎 **पडताळणी (Validation Steps):**

```bash
aws ec2 describe-subnets --subnet-ids $SUBNET_ID_1
aws ec2 describe-subnets --subnet-ids $SUBNET_ID_2
```

---

### 🎯 **चॅलेंज (Challenge):**

एक दुसरी Route Table तयार करा आणि ती `$SUBNET_ID_2` सोबत Associate करा.
हे best practice आहे की प्रत्येक AZ साठी स्वतंत्र Route Table असावी — त्यामुळे traffic त्या AZ मध्येच राहतो.

---

### 🧹 **Cleanup (स्वच्छता प्रक्रिया):**

```bash
aws ec2 delete-subnet --subnet-id $SUBNET_ID_1
aws ec2 delete-subnet --subnet-id $SUBNET_ID_2
aws ec2 delete-route-table --route-table-id $ROUTE_TABLE_ID
aws ec2 delete-vpc --vpc-id $VPC_ID
unset VPC_ID
unset ROUTE_TABLE_ID
unset SUBNET_ID_1
unset SUBNET_ID_2
```

---

## 📘 **चर्चा (Discussion):**

* सर्वप्रथम, तुम्ही VPC साठी Route Table तयार केलं.
* ही Route Table तुम्हाला traffic ला योग्य दिशेने नेण्यासाठी मार्ग ठरवण्याची परवानगी देते.
* तुम्ही दोन Subnets तयार केली, दोन्ही वेगवेगळ्या Availability Zones मध्ये.
* प्रत्येक Subnet साठी `/24` आकाराचा CIDR block दिला, म्हणजे प्रत्येकीत सुमारे 251 वापरण्यायोग्य IP addresses उपलब्ध.
* प्रत्येक ENI (Elastic Network Interface) एकाच AZ मध्ये असतो.
* Subnet चे 5 IP पत्ते AWS साठी राखीव असतात:

  * `.0` – नेटवर्क पत्ता
  * `.1` – VPC राउटरसाठी
  * `.2` – DNS साठी
  * `.3` – भविष्य वापरासाठी
  * `.255` – broadcast (जे VPC मध्ये वापरात नाही)

🔗 [Route Table priority guide](https://docs.aws.amazon.com/vpc/latest/userguide/VPC_Route_Tables.html#route-tablespriority)

🔗 [DHCP options set](https://docs.aws.amazon.com/vpc/latest/userguide/VPC_DHCP_Options.html)

---

### 🌍 **प्रत्येक AZ मध्ये Subnet ठेवण्याची Best Practice:**

जर region मध्ये 3 AZs असतील आणि तुमच्याकडे public आणि isolated असे 2 tiers असतील, तर तुम्हाला 2 (tiers) × 3 (AZs) = **6 Subnets** लागतील.

---

तुम्ही सांगितल्यास, याचे संपूर्ण Markdown `.md` डॉक्युमेंट, flowchart किंवा चित्रासह architecture design पण देऊ शकतो.



खाली दिलेले **VPC ला इंटरनेटशी कनेक्ट करण्याची संपूर्ण प्रक्रिया** आहे, जी आपण **Internet Gateway (IGW)** चा वापर करून करणार आहोत. ही प्रक्रिया सोपी आणि मराठीत स्पष्ट केली आहे:

---

## 🔌 **१. समस्या (Problem Statement)**

तुमच्याकडे एका **VPC च्या सबनेटमध्ये EC2 instance** आधीच चालू आहे. आता त्या **इंस्टन्ससाठी इंटरनेट ऍक्सेस (Internet Access)** देण्याची गरज आहे.

---

## 🧩 **२. पूर्वतयारी (Prerequisites)**

* **VPC** तयार केलेले असावे, आणि त्यात **२ Availability Zones (AZs)** मध्ये **सबनेट** असाव्यात.
* **Route Tables** तयार करून सबनेटशी जोडलेले असावेत.
* एक **EC2 instance** आधीच चालू असावा, ज्याच्यावर आपण इंटरनेट कनेक्शनची चाचणी करू.

---

## ⚙️ **३. तयारी (Preparation - AWS CDK वापरून)**

```bash
cd 203-Utilizing-Internet-Gateways/cdk-AWS-Cookbook-203/
test -d .venv || python3 -m venv .venv
source .venv/bin/activate
pip install --upgrade pip setuptools wheel
pip install -r requirements.txt --no-dependencies
cdk deploy
python helper.py    # यामधून मिळणाऱ्या पर्यावरणीय व्हेरिएबल्स (environment variables) कॉपी करा आणि टर्मिनलमध्ये पेस्ट करा
```

---

## 🌐 **४. मुख्य स्टेप्स: VPC ला इंटरनेटशी जोडणे (Using IGW)**

### 🔹 Step 1: Internet Gateway तयार करा

```bash
INET_GATEWAY_ID=$(aws ec2 create-internet-gateway \
--tag-specifications 'ResourceType=internet-gateway,Tags=[{Key=Name,Value=AWSCookbook202}]' \
--output text --query InternetGateway.InternetGatewayId)
```

### 🔹 Step 2: IGW ला VPC सोबत जोडा

```bash
aws ec2 attach-internet-gateway --internet-gateway-id $INET_GATEWAY_ID --vpc-id $VPC_ID
```

### 🔹 Step 3: Route Table मध्ये default route (0.0.0.0/0) IGW कडे पाठवा

```bash
aws ec2 create-route --route-table-id $ROUTE_TABLE_ID_1 --destination-cidr-block 0.0.0.0/0 --gateway-id $INET_GATEWAY_ID

aws ec2 create-route --route-table-id $ROUTE_TABLE_ID_2 --destination-cidr-block 0.0.0.0/0 --gateway-id $INET_GATEWAY_ID
```

### 🔹 Step 4: Elastic IP (EIP) तयार करा

```bash
ALLOCATION_ID=$(aws ec2 allocate-address --domain vpc --output text --query AllocationId)
```

### 🔹 Step 5: ती EIP तुमच्या EC2 इंस्टन्सला जोडा

```bash
aws ec2 associate-address --instance-id $INSTANCE_ID --allocation-id $ALLOCATION_ID
```

---

## ✅ **५. पडताळणी (Validation)**

1. EC2 instance SSM मध्ये रजिस्टर झालं आहे का, ते तपासा:

```bash
aws ssm describe-instance-information --filters Key=ResourceType,Values=EC2Instance \
--query "InstanceInformationList[].InstanceId" --output text
```

2. SSM Session Manager वापरून इंस्टन्समध्ये लॉगिन व्हा:

```bash
aws ssm start-session --target $INSTANCE_ID
```

3. इंटरनेट connectivity तपासण्यासाठी `ping` करा:

```bash
ping -c 4 homestarrunner.com
```

4. इंस्टन्सचा public IP जाणून घ्या:

```bash
curl http://169.254.169.254/latest/meta-data/public-ipv4
```

5. Session मधून बाहेर पडा:

```bash
exit
```

---

## 💻 **६. अतिरिक्त आव्हान (Challenge)**

* EC2 इंस्टन्सवर एक वेब सर्व्हर (जसे की Apache/Nginx) इन्स्टॉल करा.
* Security Group मध्ये इनबाउंड HTTP पोर्ट उघडा.
* तुमच्या संगणकावरून त्या वेब सर्व्हरला ब्राउझरमधून ऍक्सेस करा.

---

## 🧹 **७. Cleanup (संपूर्ण क्लीनअप करा)**

```bash
# EIP डिसअसोसिएट करा
aws ec2 disassociate-address --association-id $(aws ec2 describe-addresses \
--allocation-ids $ALLOCATION_ID --output text --query Addresses[0].AssociationId)

# EIP रिलीज करा
aws ec2 release-address --allocation-id $ALLOCATION_ID

# IGW VPC पासून detach करा
aws ec2 detach-internet-gateway --internet-gateway-id $INET_GATEWAY_ID --vpc-id $VPC_ID

# IGW delete करा
aws ec2 delete-internet-gateway --internet-gateway-id $INET_GATEWAY_ID

# पर्यावरणीय व्हेरिएबल्स unset करा
python helper.py --unset
unset INET_GATEWAY_ID
unset ALLOCATION_ID

# AWS CDK वापरून सगळे resource delete करा
cdk destroy && deactivate && rm -r .venv/ && cd ../..
```

---

## 💬 **८. चर्चा (Discussion)**

* IGW आणि Route Table मध्ये **0.0.0.0/0** टाकून इंटरनेट connectivity मिळवली.
* Instance साठी **Elastic IP** वापरले गेले जे reboot नंतरही तेच राहते.
* Public subnet मध्ये इनबाउंड ऍक्सेससाठी **Security Group** मध्ये नियम (rule) सेट करणे गरजेचे आहे.
* Public subnet फक्त public-facing resources साठी वापरावा (जसे की Load Balancer).
* प्रायव्हेट सबनेटसाठी **NAT Gateway** वापरून फक्त आउटबाउंड इंटरनेट ऍक्सेस द्या.

---

खाली दिले आहे एक **VPC इंटरनेट कनेक्टिव्हिटीसाठी आर्किटेक्चर स्ट्रक्चर (Architecture Structure in Marathi)**, जे दर्शवते की **EC2 instance इंटरनेटशी कसा कनेक्ट होतो Internet Gateway चा वापर करून**:

---

## 🏗️ **VPC इंटरनेट कनेक्टिव्हिटी – आर्किटेक्चर स्ट्रक्चर**

### 📐 घटक (Components):

* **VPC (Virtual Private Cloud)**
* **Public Subnet** (EC2 instance ठेवले जाते)
* **Internet Gateway (IGW)**
* **Route Table**
* **Elastic IP (EIP)**
* **EC2 Instance**
* **Security Group** (इनबाउंड HTTP/SSH ट्रॅफिकसाठी)
* **SSM (AWS Systems Manager)** – Instance मध्ये लॉगिनसाठी

---

### 📊 **Architecture Diagram (Textual View)**

```
                  +----------------------------+
                  |     Internet (Public)      |
                  +-------------+--------------+
                                |
                                | (1) Public Access
                                v
                    +-----------+------------+
                    |  Internet Gateway (IGW)|
                    +-----------+------------+
                                |
                                | (2) Routed via 0.0.0.0/0
                                v
+------------------------------------------------------------+
| VPC: my-vpc                                                |
|                                                            |
|  +--------------------+        +------------------------+  |
|  | Route Table        |        | Elastic IP (EIP)       |  |
|  | 0.0.0.0/0 --> IGW  |        +------------------------+  |
|  |                    |                                  |
|  +--------------------+                                  |
|             |                                           |
|             v                                           |
|     +---------------------+                             |
|     |   Public Subnet     |                             |
|     |   CIDR: 10.0.1.0/24 |                             |
|     |                     |                             |
|     |  +----------------------+                        |
|     |  | EC2 Instance          |                        |
|     |  | - EIP Associated      |                        |
|     |  | - SSM Enabled         |                        |
|     |  | - Security Group:     |                        |
|     |  |   - Allow HTTP, SSH   |                        |
|     |  +----------------------+                        |
|     +---------------------------+                       |
+----------------------------------------------------------+
```

---

### 🔁 **डेटा प्रवाह (Internet Flow)**

1. **Client** ↔ **Elastic IP (EIP)** ↔ **IGW** ↔ **VPC Route Table (0.0.0.0/0)** ↔ **EC2 Instance**

---

### 🔐 **Security Considerations:**

* EC2 instance साठी **public access** दिला असल्यास **Security Group मध्ये inbound rules** योग्यरितीने सेट करणे आवश्यक आहे.
* EC2 instance साठी **Elastic IP वापरल्यास public IP reboot नंतर सुद्धा स्थिर राहतो**.

---

खाली दिले आहे **"NAT Gateway चा वापर करून Private Subnet मधून Outbound Internet Access देणे"** यासाठी सविस्तर **Structural Architecture** स्पष्टीकरण आणि संपूर्ण माहिती **मराठीत**:

---

## 📌 **समस्या (Problem)**

तुमच्याकडे आधीपासूनच **VPC मध्ये Public Subnets** आहेत जे **Internet Gateway** शी जोडलेले आहेत. आता, तुमच्या **Private Subnet मधील EC2 Instance ला फक्त Outbound Internet Access** द्यायची आहे (इनबाउंड नाही).

---

## ✅ **उपाय (Solution Overview)**

1. एका **Public Subnet** मध्ये **NAT Gateway तयार करा**.
2. एक **Elastic IP (EIP)** तयार करून NAT Gateway ला जोडा़.
3. **Private Subnet चे Route Table अपडेट करा** जेणेकरून `0.0.0.0/0` ट्रॅफिक NAT Gateway कडे जाईल.

---

## 🏗️ **Structural Architecture (संरचनात्मक रचना)**

### 🧱 घटक (Components):

* **VPC**
* **2 Public Subnets (AZ1 आणि AZ2 मध्ये)**
* **2 Private Subnets (AZ1 आणि AZ2 मध्ये)**
* **Internet Gateway (IGW)** – Public Subnet साठी
* **NAT Gateway (AZ1 मध्ये, Public Subnet मध्ये)**
* **Elastic IP (EIP) – NAT Gateway साठी**
* **2 EC2 Instances – Private Subnets मध्ये**
* **Route Tables** – Public आणि Private Subnets साठी वेगवेगळे

---

### 🔁 **डेटा फ्लो आणि संरचना (Data Flow and Structure - Textual View)**

```
                   +--------------------------+
                   |      इंटरनेट (Internet) |
                   +------------+-------------+
                                |
                        (1) Elastic IP (EIP)
                                |
                     +----------v-----------+
                     |     NAT Gateway      | <-- सार्वजनिक Subnet मध्ये
                     +----------+-----------+
                                |
                +---------------+-----------------+
                |                                 |
        +-------v-------+                +--------v--------+
        | Public Subnet |                | Public Subnet 2 |
        | (AZ1)         |                | (AZ2)            |
        +---------------+                +------------------+
                |                                  |
                |                                  |
        +-------+-------+                 +--------+--------+
        | IGW (Internet |                 | (Optional) 2nd  |
        |  Gateway)     |                 | NAT Gateway     |
        +---------------+                 +-----------------+
                |
                |
     +------------------------+
     |     VPC – MyVPC       |
     +------------------------+
                |
                |
        +-------+-------+        +----------------+
        | Private Subnet|        | Private Subnet |
        | (AZ1)         |        | (AZ2)          |
        | EC2 Instance  |        | EC2 Instance   |
        +---------------+        +----------------+
                |                         |
                |                         |
        +-------v-------+         +--------v--------+
        | Route Table   |         | Route Table     |
        | 0.0.0.0/0 --> |         | 0.0.0.0/0 -->   |
        | NAT Gateway   |         | NAT Gateway (2) |
        +---------------+         +-----------------+
```

---

## 🔄 **वास्तविक स्टेप्स (Steps in Marathi)**

### 🔹 1. NAT Gateway तयार करणे

```bash
ALLOCATION_ID=$(aws ec2 allocate-address --domain vpc --output text --query AllocationId)

NAT_GATEWAY_ID=$(aws ec2 create-nat-gateway \
--subnet-id $VPC_PUBLIC_SUBNET_1 \
--allocation-id $ALLOCATION_ID \
--output text --query NatGateway.NatGatewayId)
```

### 🔹 2. Private Subnet च्या Route Table मध्ये Default Route जोडा

```bash
aws ec2 create-route \
--route-table-id $PRIVATE_RT_ID_1 \
--destination-cidr-block 0.0.0.0/0 \
--nat-gateway-id $NAT_GATEWAY_ID

aws ec2 create-route \
--route-table-id $PRIVATE_RT_ID_2 \
--destination-cidr-block 0.0.0.0/0 \
--nat-gateway-id $NAT_GATEWAY_ID
```

---

## ✅ **Validation Steps (पडताळणी)**

* EC2 Instance SSM मध्ये Registered आहे का ते तपासा:

```bash
aws ssm describe-instance-information \
--filters Key=ResourceType,Values=EC2Instance \
--query "InstanceInformationList[].InstanceId" --output text
```

* SSM Session Manager वापरून लॉगिन करा:

```bash
aws ssm start-session --target $INSTANCE_ID_1
```

* इंटरनेट connectivity तपासण्यासाठी `ping` करा:

```bash
ping -c 4 aws.amazon.com
```

---

## 🧠 **Discussion (चर्चा)**

* NAT Gateway वापरल्यामुळे **Private Subnet मधील EC2 Instance** ला फक्त **Outbound Internet Access** मिळतो.
* **Inbound access टाळला जातो**, जो सुरक्षा दृष्टिकोनातून योग्य आहे.
* जर सार्वजनिक इंटरनेटवरून सेवांवर (Web App, API) inbound access द्यायचा असेल, तर **Load Balancer (ALB/NLB) सार्वजनिक Subnet मध्ये ठेवावा.**
* एकाच AZ मध्ये NAT Gateway असणे खर्चिक दृष्टिकोनातून फायदेशीर आहे, पण Production साठी **प्रत्येक AZ मध्ये वेगळा NAT Gateway ठेवणे उत्तम.**

---

## 🧹 **Cleanup (संपत्ती हटवणे)**

```bash
aws ec2 delete-nat-gateway --nat-gateway-id $NAT_GATEWAY_ID
# Deleted status येईपर्यंत थांबा:
aws ec2 describe-nat-gateways --nat-gateway-id $NAT_GATEWAY_ID --output text --query NatGateways[0].State

# Elastic IP Release करा
aws ec2 release-address --allocation-id $ALLOCATION_ID

# पर्यावरणीय व्हेरिएबल्स unset करा
python helper.py --unset
unset ALLOCATION_ID
unset NAT_GATEWAY_ID

# CDK destroy करा
cdk destroy && deactivate && rm -r .venv/ && cd ../..
```

---

### 📝 **टीप (Note):**

* **NAT Gateway चे EIP** हे External IP म्हणून कार्य करते.
* IPv6 वापरत असल्यास, **Egress-Only Internet Gateway** वापरण्याचा पर्याय उपलब्ध आहे.

---


खाली मी **AWS EC2 Instances साठी Self-referencing Security Group** वापरून SSH कनेक्टिव्हिटी साठी **संपूर्ण स्ट्रक्चरल आर्किटेक्चर** मराठीत स्पष्टपणे दिले आहे:

---

## 🔐 **1.5 – Dynamic Access साठी Security Group Referencing वापरणे**

---

### 📌 **समस्या (Problem):**

* तुमच्याकडे EC2 Instances चा एक गट आहे (Instance-1 आणि Instance-2).
* हे एकमेकांना SSH द्वारे (port 22) access करू शकले पाहिजे.
* आणि भविष्यात आणखी EC2 Instances या ग्रुपमध्ये जोडल्यावर त्यांना सुद्धा समान access मिळायला हवा — म्हणजे **डायनॅमिक ग्रुपिंग**.

---

### ✅ **समाधान (Solution):**

* एक **Security Group** तयार करा आणि ती दोन्ही EC2 Instances सोबत जोडून द्या.
* या Security Group ला एक **Ingress Rule** द्या, जी स्वतःवरून (Self-reference) TCP Port 22 ला allow करते.
* म्हणजे, **या Security Group मध्ये कोणतीही EC2 जोडली, ती दुसऱ्या कोणत्याही Instance ला SSH करू शकेल.**

---

## 🏗️ **स्ट्रक्चरल आर्किटेक्चर (Structural Architecture – Text Format)**

```
VPC (Virtual Private Cloud)
│
├── Subnet-1 (उदाहरणार्थ: 10.0.1.0/24)
│   │
│   ├── EC2 Instance-1
│   │    └── Security Group: sg-ssh-group
│   │         └── Ingress Rule:
│   │              - Protocol: TCP
│   │              - Port: 22
│   │              - Source: sg-ssh-group (self)
│   │
│   └── EC2 Instance-2
│        └── Security Group: sg-ssh-group (same)
│
└── Subnet-2 (optional future)
     └── EC2 Instance-3 (added later)
          └── Security Group: sg-ssh-group (same)
```

---

## 🧩 **महत्त्वाचे घटक (Key Components):**

| घटक                     | वर्णन                                                       |
| ----------------------- | ----------------------------------------------------------- |
| **Security Group (SG)** | EC2 साठी Virtual Firewall                                   |
| **Ingress Rule**        | SG वरून SG ला TCP:22 चा access                              |
| **Self-reference**      | SG स्वतःलाच source म्हणून वापरते                            |
| **Instances (EC2)**     | एकाच SG सोबत जोडलेले सर्व Instances एकमेकांशी SSH करू शकतात |
| **SSM**                 | Session Manager वापरून लॉगिन करता येतो                      |
| **Dynamic Referencing** | नवीन Instances जोडल्यावरही access आपोआप मिळतो               |

---

## 🔁 **SSH कनेक्टिव्हिटी डेटा फ्लो:**

```plaintext
Instance-1  (SG: sg-ssh-group)
      │
      │──[TCP Port 22 Allowed via Self-reference]──▶
      │
Instance-2  (SG: sg-ssh-group)
```

नवीन EC2 instance (Instance-3) याच SG मध्ये जोडल्यास, तो सुद्धा Instance-1 व Instance-2 ला SSH करू शकतो.

---

## 💡 **लक्षात ठेवा (Important Notes):**

1. **Security Group == Virtual Firewall**: प्रत्येक EC2 साठी वर्तणूक नियंत्रित करते.
2. **Self-referencing Rule** म्हणजे SG ला स्वतःवरून access दिलेले.
3. **डायनॅमिक स्केलेबिलिटी**: यामध्ये IPs टाकण्याची गरज नाही, त्यामुळे स्केलेबल सोल्यूशन आहे.
4. **नवीन Instance जोडताना पुन्हा Ingress rule लिहायची गरज नाही.**

---

## 🛠️ **सराव (Challenge Ideas):**

| क्र. | सराव सुचना                                                              |
| ---- | ----------------------------------------------------------------------- |
| 1️⃣  | एक नवीन EC2 (Instance-3) तयार करा आणि त्याला sg-ssh-group SG असाइन करा. |
| 2️⃣  | Instance-1 किंवा 2 वरून SSH करून Instance-3 पर्यंत पोहोचते का ते तपासा. |
| 3️⃣  | Security Group ला Description द्या: "Allow SSH from same SG"            |
| 4️⃣  | VPC Reachability Analyzer वापरून कनेक्टिव्हिटी तपासा.                   |

---

## 🧹 **Cleanup स्टेप्स (Optional):**

* EC2 Instances terminate करा (Instance-3).
* SSM Parameter delete करा.
* EC2 वरून custom SG detach करून default SG परत द्या.
* Security Group delete करा (`aws ec2 delete-security-group`).
* Python virtual environment बंद करा (`deactivate`).
* AWS CDK वापरून सर्व resource cleanup करा (`cdk destroy`).

---

### 🔚 **निष्कर्ष (Conclusion):**

* या प्रक्रियेत, **Self-referencing Security Group** वापरून एक सोपी, स्केलेबल आणि future-ready SSH कनेक्टिव्हिटी सोल्यूशन तयार केलं.
* हे क्लाउडमधील **ऑटो स्केलिंग**, **क्लस्टर्स**, किंवा **डायनॅमिक सर्व्हर ग्रुप्स** साठी आदर्श पद्धत आहे.

---


खाली **"VPC Reachability Analyzer वापरून नेटवर्क पथ तपासणे आणि समस्यांचे निराकरण करणे"** याचे मराठीतील सविस्तर रूपांतरण आणि संपूर्ण स्ट्रक्चरल आर्किटेक्चर दिले आहे:

---

## 🔍 **1.6 – VPC Reachability Analyzer चा वापर करून नेटवर्क कनेक्टिव्हिटी तपासणे व डीबग करणे**

---

### 📌 **समस्या (Problem):**

तुमच्याकडे दोन EC2 इन्स्टन्स आहेत जे वेगळ्या (Isolated) सबनेटमध्ये आहेत. आता तुम्हाला त्यांच्यामधील SSH कनेक्टिव्हिटी तपासायची आहे, पण काही कारणाने कनेक्ट होत नाहीत.

---

### ✅ **समाधान (Solution):**

* **VPC Reachability Analyzer** वापरून `TCP Port 22` वरील SSH कनेक्टिव्हिटीचे विश्लेषण करा.
* सुरुवातीला सुरक्षा नियम (Security Group Rules) नसल्यामुळे "NetworkPathFound": false असेल.
* मग **Instance-2 च्या Security Group मध्ये Instance-1 च्या SG कडून SSH (port 22) allow करणारा rule जोडा**.
* पुन्हा Reachability Analysis चालवा.
* आता "NetworkPathFound": true असे दिसेल.

---

## 🏗️ **स्ट्रक्चरल आर्किटेक्चर (Text-based Visual Format)**

```
        ┌────────────────────────────────────────┐
        │          AWS VPC (Virtual Network)     │
        │                                        │
        │  ┌──────────────┐        ┌────────────┐│
        │  │ Subnet-1     │        │ Subnet-2   ││
        │  │ (Isolated)   │        │ (Isolated) ││
        │  │              │        │            ││
        │  │ EC2-Instance1│─────┐  │EC2-Instance2││
        │  │ SG-1         │     │  │SG-2         ││
        │  └──────────────┘     │  └────────────┘│
        │                       │                │
        │   🔍 VPC Reachability │                │
        │       Analyzer        │                │
        │                       ▼                │
        │      ❌ No Path Found (ENI_SG_RULES_MISMATCH) │
        └────────────────────────────────────────┘

        👉 SG-2 मध्ये SG-1 वरून TCP:22 Allow करा

        पुनश्च:
        ✅ Path Found (SSH Connectable)
```

---

## 🔢 **टप्पे (Steps):**

### 🔧 **1. Network Insights Path तयार करा:**

```bash
INSIGHTS_PATH_ID=$(aws ec2 create-network-insights-path \
 --source $INSTANCE_ID_1 \
 --destination $INSTANCE_ID_2 \
 --destination-port 22 \
 --protocol tcp \
 --output text \
 --query NetworkInsightsPath.NetworkInsightsPathId)
```

### 🔍 **2. Reachability Analysis सुरु करा:**

```bash
ANALYSIS_ID_1=$(aws ec2 start-network-insights-analysis \
 --network-insights-path-id $INSIGHTS_PATH_ID \
 --output text \
 --query NetworkInsightsAnalysis.NetworkInsightsAnalysisId)
```

### 📋 **3. पहिल्या विश्लेषणाचे परिणाम तपासा:**

```bash
aws ec2 describe-network-insights-analyses \
 --network-insights-analysis-ids $ANALYSIS_ID_1
```

✅ Output: `"NetworkPathFound": false`, `"ExplanationCode": "ENI_SG_RULES_MISMATCH"`

---

### 🔐 **4. Security Group नियम जोडा:**

```bash
aws ec2 authorize-security-group-ingress \
 --protocol tcp --port 22 \
 --source-group $INSTANCE_SG_ID_1 \
 --group-id $INSTANCE_SG_ID_2
```

---

### 🔁 **5. Analysis पुन्हा चालवा:**

```bash
ANALYSIS_ID_2=$(aws ec2 start-network-insights-analysis \
 --network-insights-path-id $INSIGHTS_PATH_ID \
 --output text \
 --query NetworkInsightsAnalysis.NetworkInsightsAnalysisId)
```

```bash
aws ec2 describe-network-insights-analyses \
 --network-insights-analysis-ids $ANALYSIS_ID_2
```

✅ Output: `"NetworkPathFound": true`

---

## 🧪 **तपासणी: SSH पोर्ट ओपन आहे का?**

1. Instance-1 ला SSM द्वारे कनेक्ट व्हा:

```bash
aws ssm start-session --target $INSTANCE_ID_1
```

2. Instance-2 चा Private IP SSM Parameter वरून घ्या:

```bash
INSTANCE_IP_2=$(aws ssm get-parameters \
 --names "Cookbook206Instance2Ip" \
 --query "Parameters[*].Value" --output text)
```

3. `ncat` इंस्टॉल करा आणि पोर्ट तपासा:

```bash
sudo yum -y install nc
nc -vz $INSTANCE_IP_2 22
```

✅ Output: `Connected to 10.10.0.48:22.`

---

## 🧹 **Cleanup स्टेप्स:**

```bash
aws ssm delete-parameter --name "Cookbook206Instance2Ip"
aws ec2 delete-network-insights-analysis --network-insights-analysis-id $ANALYSIS_ID_1
aws ec2 delete-network-insights-analysis --network-insights-analysis-id $ANALYSIS_ID_2
aws ec2 delete-network-insights-path --network-insights-path-id $INSIGHTS_PATH_ID
unset INSIGHTS_PATH_ID
unset ANALYSIS_ID_1
unset ANALYSIS_ID_2
cdk destroy && deactivate && rm -r .venv/ && cd ../..
```

---

## 🗣️ **चर्चा (Discussion – Marathi Summary):**

* तुम्ही EC2 Instance 1 आणि 2 साठी SSH Port (22) च्या संदर्भात Reachability तपासली.
* सुरुवातीला SG नियम नसल्यामुळे Analysis Failed झाले.
* SG Update करून Analysis पुन्हा चालवले, आणि तो यशस्वी झाला.
* Reachability Analyzer हे Troubleshooting साठी **बिनधोक, इन्फ्रास्ट्रक्चर-फ्री** व अत्यंत उपयुक्त टूल आहे.

---

## 🧠 **टिप:**

> `ENI_SG_RULES_MISMATCH` म्हणजे तुम्ही योग्य SG नियम दिलेले नाहीत. Security Group मध्ये योग्य `ingress rule` देऊन हे दुरुस्त केले जाऊ शकते.

---



खालील दिलेले संपूर्ण **"HTTP ते HTTPS Redirect with ALB"** चे मराठीत रूपांतरण, आर्किटेक्चर स्पष्टीकरण आणि टप्प्यांनुसार समजावणी आहे.

---

## 🔐 **1.7 – Application Load Balancer वापरून HTTP ट्रॅफिकचे HTTPS कडे रीडायरेक्शन**

---

### 📌 **समस्या (Problem):**

तुमच्याकडे एक कंटेनराइज्ड वेब अ‍ॅप्लिकेशन आहे जे **Private Subnet** मध्ये चालते. ते इंटरनेट युजर्ससाठी उपलब्ध करायचे आहे, पण त्याचवेळी **सिक्युअर (HTTPS)** ठेवायचे आहे.

---

### ✅ **समाधान (Solution):**

* एक **Application Load Balancer (ALB)** तयार करा.
* ALB साठी **2 Listeners** तयार करा – एक HTTP (port 80) आणि एक HTTPS (port 443).
* Listener Rule वापरून port 80 वर आलेल्या request ला port 443 कडे `HTTP 301 Redirect` पाठवा.
* पोर्ट 443 चे Listener traffic फॉरवर्ड करेल Target Group कडे.
* Target Group मध्ये ECS Fargate वर चालणारा कंटेनर application नोंदवा.

---

## 🏗️ **नेटवर्क आर्किटेक्चर (Visual View)**

```
                          Internet
                             │
                      ┌────────────┐
                      │  ALB (Public) │
                      └────────────┘
                        ┌────┴────┐
               ┌─────▶ 80 (HTTP) ──┐
               │                   │
               │              301 Redirect
               │                   ▼
               └─────▶ 443 (HTTPS) ─────▶ Target Group
                                                │
                                        ┌────────────┐
                                        │ ECS Fargate │
                                        └────────────┘
```

---

## ⚙️ **पूर्वतयारी (Prerequisites):**

* VPC मध्ये 2 public आणि 2 private subnets.
* ECS Cluster आणि Web App असलेले Fargate Tasks (port 80 वर चालणारे).
* AWS CDK वापरून VPC आणि ECS चे Infrastructure तयार.

---

## 🧱 **स्टेप्स (Detailed Steps):**

### 🔑 1. **SSL साठी Certificate तयार करा:**

```bash
openssl genrsa 2048 > my-private-key.pem

openssl req -new -x509 -nodes -sha256 -days 365 \
-key my-private-key.pem -outform PEM -out my-certificate.pem
```

👉 (Self-signed cert आहे; ब्राउझरमध्ये warning येऊ शकतो)

---

### 📥 2. **Certificate IAM मध्ये Upload करा:**

```bash
CERT_ARN=$(aws iam upload-server-certificate \
--server-certificate-name AWSCookbook207 \
--certificate-body file://my-certificate.pem \
--private-key file://my-private-key.pem \
--query ServerCertificateMetadata.Arn --output text)
```

---

### 🔒 3. **Security Groups तयार करा:**

```bash
ALB_SG_ID=$(aws ec2 create-security-group \
--group-name Cookbook207SG --description "ALB Security Group" \
--vpc-id $VPC_ID --output text --query GroupId)

aws ec2 authorize-security-group-ingress --protocol tcp --port 443 --cidr '0.0.0.0/0' --group-id $ALB_SG_ID
aws ec2 authorize-security-group-ingress --protocol tcp --port 80 --cidr '0.0.0.0/0' --group-id $ALB_SG_ID
```

---

### 🛡️ 4. **ALB तयार करा आणि Subnets assign करा:**

```bash
LOAD_BALANCER_ARN=$(aws elbv2 create-load-balancer \
--name aws-cookbook207-alb \
--subnets $VPC_PUBLIC_SUBNETS \
--security-groups $ALB_SG_ID \
--scheme internet-facing \
--output text --query LoadBalancers[0].LoadBalancerArn)
```

---

### 🎯 5. **Target Group तयार करा आणि Fargate App नोंदवा:**

```bash
TARGET_GROUP=$(aws elbv2 create-target-group \
--name aws-cookbook207-tg --vpc-id $VPC_ID \
--protocol HTTP --port 80 --target-type ip \
--output text --query "TargetGroups[0].TargetGroupArn")

aws elbv2 register-targets --targets Id=$CONTAINER_IP_1 \
--target-group-arn $TARGET_GROUP
```

---

### 🔊 6. **HTTPS Listener तयार करा आणि Target Forward करा:**

```bash
HTTPS_LISTENER_ARN=$(aws elbv2 create-listener \
--load-balancer-arn $LOAD_BALANCER_ARN \
--protocol HTTPS --port 443 \
--certificates CertificateArn=$CERT_ARN \
--default-actions Type=forward,TargetGroupArn=$TARGET_GROUP \
--output text --query Listeners[0].ListenerArn)
```

---

### 🔁 7. **Redirect Rule (HTTP → HTTPS):**

```bash
aws elbv2 create-listener --load-balancer-arn $LOAD_BALANCER_ARN \
--protocol HTTP --port 80 \
--default-actions "Type=redirect,RedirectConfig={Protocol=HTTPS,Port=443,Host='#{host}',Query='#{query}',Path='/#{path}',StatusCode=HTTP_301}"
```

---

## 🔬 **तपासणी (Validation):**

```bash
LOAD_BALANCER_DNS=$(aws elbv2 describe-load-balancers \
--names aws-cookbook207-alb --output text --query LoadBalancers[0].DNSName)

echo $LOAD_BALANCER_DNS
```

```bash
curl -v http://$LOAD_BALANCER_DNS   # ➤ 301 Redirect
curl -vkL http://$LOAD_BALANCER_DNS # ➤ Final HTTPS content
```

---

## 🧹 **Cleanup स्टेप्स:**

```bash
aws elbv2 delete-load-balancer --load-balancer-arn $LOAD_BALANCER_ARN
aws elbv2 delete-target-group --target-group-arn $TARGET_GROUP
aws ec2 delete-security-group --group-id $ALB_SG_ID
aws iam delete-server-certificate --server-certificate-name AWSCookbook207
```

```bash
python helper.py --unset
unset TARGET_GROUP ALB_SG_ID CERT_ARN LOAD_BALANCER_ARN HTTPS_LISTENER_ARN CONTAINER_IP_1
cdk destroy && deactivate && rm -r .venv/ && cd ../..
```

---

## 🧠 **महत्वाचे मुद्दे (Discussion – Summary in Marathi):**

* HTTP च्या जागी HTTPS वापरून Web Application सुरक्षित केला.
* Application Load Balancer Layer 7 (OSI) वर काम करतो – म्हणजेच HTTP-level rules.
* ALB ➤ ECS (Fargate) साठी traffic manage करतो आणि health checks चालवतो.
* HTTP 301 Redirect वापरून traffic forcefully HTTPS कडे वळवला.
* Target Group मध्ये कंटेनर आयपीज वापरले.
* ACM वापरून Trusted SSL certificate वापरल्यास browser warning टळेल.

---

खाली **"1.8 – AWS Prefix List वापरून Security Group मध्ये CIDRs चे व्यवस्थापन सुलभ करणे"** याचे सविस्तर मराठी रूपांतर, आर्किटेक्चर, स्टेप्स आणि संकल्पना स्पष्ट केली आहे.

---

## 🔐 **1.8 – Prefix Lists वापरून Security Group मध्ये CIDR व्यवस्थापन सुलभ करणे**

---

### 📌 **समस्या (Problem):**

* दोन ऍप्लिकेशन्स सार्वजनिक सबनेटमध्ये आहेत.
* सामान्य ऑपरेशनमध्ये त्या **Virtual Desktop (Workspace Gateway)** मधून access होतात (दुसऱ्या region मधून).
* परंतु, testing दरम्यान त्या **तुमच्या Home PC** वरून access करायच्या आहेत.

---

### ✅ **समाधान (Solution):**

* AWS द्वारे दिलेल्या `ip-ranges.json` फाईलमधून **Workspaces Gateway च्या CIDR ranges** (`us-west-2`) घ्या.
* त्या CIDRs एकत्र करून एक **Managed Prefix List** तयार करा.
* ती Prefix List दोन्ही EC2 instance च्या Security Groups मध्ये `inbound rule` म्हणून add करा.
* टेस्टिंगसाठी Prefix List मध्ये तुमचा **Home PC चा public IP** (IPv4) add करा.
* नंतर हवे असल्यास Prefix List चे पूर्वीचे version restore करून तुमचा IP access मधून काढून टाका.

---

## 🏗️ **नेटवर्क आर्किटेक्चर (Visual Format):**

```
                                 ┌───────────────────────┐
                                 │   Home PC (Testing)   │
                                 └──────────┬────────────┘
                                            │
                                            ▼
                              ┌────────────────────────────┐
                              │      Prefix List (CIDRs)   │◄─ Workspaces Gateway CIDRs
                              └────────┬───────────────────┘
                                       │
         ┌──────────────────────┐     │     ┌──────────────────────┐
         │  EC2 Instance (App1) │◄────┘────►│  EC2 Instance (App2) │
         │  Public Subnet (AZ1) │           │  Public Subnet (AZ2) │
         └──────────────────────┘           └──────────────────────┘
```

---

## ⚙️ **पूर्वतयारी (Prerequisites):**

* दोन public subnets सह VPC.
* दोन EC2 Instances – प्रत्येकात वेगवेगळे web server (`port 80`) चालू.
* दोन वेगळे security groups – प्रत्येक instance साठी.
* `AWS CDK` वापरून पूर्वनिर्धारित resources तयार.

---

## 🧱 **स्टेप्स (Detailed Steps):**

### 📥 1. **AWS IP रेंज डाउनलोड करा:**

```bash
curl -o ip-ranges.json https://ip-ranges.amazonaws.com/ip-ranges.json
```

### 🔍 2. **`us-west-2` region साठी Workspaces Gateway चे CIDRs मिळवा:**

```bash
jq -r '.prefixes[] | select(.region=="us-west-2") |
select(.service=="WORKSPACES_GATEWAYS") | .ip_prefix' < ip-ranges.json
```

---

### 🗂️ 3. **Prefix List तयार करा:**

```bash
PREFIX_LIST_ID=$(aws ec2 create-managed-prefix-list \
--address-family IPv4 \
--max-entries 15 \
--prefix-list-name allowed-us-east-1-cidrs \
--entries Cidr=44.234.54.0/23,Description=workspaces-us-west-2-cidr1 \
          Cidr=54.244.46.0/23,Description=workspaces-us-west-2-cidr2 \
--output text --query "PrefixList.PrefixListId")
```

---

### 🧪 4. **तपासा की तुमचा घरचा IP access करू शकत नाही:**

```bash
curl -m 2 $INSTANCE_IP_1
curl -m 2 $INSTANCE_IP_2
# (Output: Connection timed out)
```

---

### 🧍‍♂️ 5. **तुमचा Home PC चा public IP मिळवा आणि Prefix List मध्ये जोडा:**

```bash
MY_IP_4=$(curl myip4.com | tr -d ' ')
aws ec2 modify-managed-prefix-list \
--prefix-list-id $PREFIX_LIST_ID \
--current-version 1 \
--add-entries Cidr=${MY_IP_4}/32,Description=my-workstation-ip
```

---

### 🔐 6. **दोन्ही Security Groups मध्ये Prefix List Reference Rule जोडा:**

```bash
aws ec2 authorize-security-group-ingress \
--group-id $INSTANCE_SG_1 --ip-permissions \
IpProtocol=tcp,FromPort=80,ToPort=80,PrefixListIds="[{Description=http-from-prefix-list,PrefixListId=$PREFIX_LIST_ID}]"

aws ec2 authorize-security-group-ingress \
--group-id $INSTANCE_SG_2 --ip-permissions \
IpProtocol=tcp,FromPort=80,ToPort=80,PrefixListIds="[{Description=http-from-prefix-list,PrefixListId=$PREFIX_LIST_ID}]"
```

---

## 🧪 **Validation (चाचणी):**

```bash
curl -m 2 $INSTANCE_IP_1   #✅
curl -m 2 $INSTANCE_IP_2   #✅
```

---

### 🔄 **Rollback/Challenge: Prefix List चे Version पूर्ववत करा:**

```bash
aws ec2 restore-managed-prefix-list-version \
--prefix-list-id $PREFIX_LIST_ID \
--previous-version 1 --current-version 2
```

त्यानंतर पुन्हा चाचणी:

```bash
curl -m 2 $INSTANCE_IP_1   #❌
curl -m 2 $INSTANCE_IP_2   #❌
```

---

## 🧹 **Cleanup:**

```bash
cd cdk-AWS-Cookbook-208/
python helper.py --unset

aws ec2 delete-managed-prefix-list --prefix-list-id $PREFIX_LIST_ID
unset PREFIX_LIST_ID
unset MY_IP_4

cdk destroy && deactivate && rm -r .venv/ && cd ../..
```

---

## 🧠 **Discussion (थोडक्यात चर्चा):**

* Prefix List हे एकमेव स्थान आहे जिथे तुम्ही अनेक Security Groups साठी IP/CIDRs व्यवस्थापित करू शकता.
* CIDRs अपडेट करायची गरज असल्यास प्रत्येक Security Group modify करण्याऐवजी Prefix List मध्येच update करा.
* Versioning फीचर वापरून prefix list reset करणे शक्य आहे.
* Prefix Lists हे **Route Tables**, **Egress Rules**, किंवा **Blacklist (Deny List)** साठी देखील वापरता येतात.
* उदाहरण:

```bash
aws ec2 create-route \
--route-table-id $Sub1RouteTableID \
--destination-prefix-list-id $PREFIX_LIST_ID \
--instance-id $INSTANCE_ID
```

---


खालील माहितीमध्ये दिला आहे **"1.9 – VPC Endpoint वापरून VPC मधून S3 कडे secure, low-cost आणि controlled access"** साठी सविस्तर **मराठी स्पष्टीकरण**:

---

## 🔐 **1.9 – तुमच्या VPC मधून S3 कडे नेटवर्क प्रवेश नियंत्रित करणे (VPC Endpoint वापरून)**

---

### ❓ **समस्या (Problem):**

* कंपनीची सुरक्षा टीम **डेटा एक्सफिल्ट्रेशन** बद्दल काळजी करत आहे.
* VPC मधील resources ना **फक्त एक ठराविक S3 बकेट** access करण्याची परवानगी असावी.
* आणि ह्या S3 ट्रॅफिकने **इंटरनेटवरून जाऊ नये** (सुरक्षिततेसाठी आणि खर्च वाचवण्यासाठी).

---

### ✅ **समाधान (Solution):**

* एक **Gateway VPC Endpoint (S3 साठी)** तयार करा.
* Endpoint ला **route tables शी लिंक** करा.
* त्यासाठी **custom policy** वापरा, जी फक्त एखाद्या S3 bucket ला access करू देते.

---

## 🏗️ **Architecture Overview (चित्रमय आढावा):**

```
                 +----------------------+
                 |    AWS S3 Bucket     |
                 |   (Allowed Bucket)   |
                 +----------+-----------+
                            ▲
                            │  (Internal AWS Backbone)
                            │
           ┌────────────┐   │
           │  Gateway   │◄──┘
           │ VPC Endpoint│
           └────+───────┘
                │
        ┌───────▼─────────┐
        │  Route Tables   │
        └───────▲─────────┘
                │
        ┌───────▼─────────┐
        │  Private Subnet │
        │  EC2 Instances  │
        └─────────────────┘
```

---

## ⚙️ **पूर्वतयारी (Prerequisites):**

* VPC मध्ये 2 Isolated Subnets आणि त्यांचे स्वतंत्र Route Tables.
* एक EC2 instance public subnet मध्ये (टेस्टिंगसाठी).
* एक S3 bucket तयार असलेले.

---

## 🧱 **स्टेप्स (Steps):**

### 🧰 **CDK Setup:**

```bash
cd 209-Using-Gateway-VPC-Endpoints-with-S3/cdk-AWS-Cookbook-209/
python3 -m venv .venv && source .venv/bin/activate
pip install -r requirements.txt
cdk deploy
python helper.py  # Export env vars
cd ..
```

---

### 🔗 **Step 1: Gateway VPC Endpoint तयार करा आणि Route Tables ला लिंक करा:**

```bash
END_POINT_ID=$(aws ec2 create-vpc-endpoint \
--vpc-id $VPC_ID \
--service-name com.amazonaws.$AWS_REGION.s3 \
--route-table-ids $RT_ID_1 $RT_ID_2 \
--query VpcEndpoint.VpcEndpointId --output text)
```

---

### 📜 **Step 2: Endpoint Policy तयार करा (S3 access मर्यादित):**

#### `policy-template.json`:

```json
{
  "Statement": [
    {
      "Sid": "RestrictToOneBucket",
      "Principal": "*",
      "Action": ["s3:GetObject", "s3:PutObject"],
      "Effect": "Allow",
      "Resource": [
        "arn:aws:s3:::S3BucketName",
        "arn:aws:s3:::S3BucketName/*"
      ]
    }
  ]
}
```

#### Replace करा:

```bash
sed -e "s/S3BucketName/${BUCKET_NAME}/g" policy-template.json > policy.json
```

---

### ✏️ **Step 3: Endpoint ची Policy Update करा:**

```bash
aws ec2 modify-vpc-endpoint \
--policy-document file://policy.json \
--vpc-endpoint-id $END_POINT_ID
```

---

## ✅ **Validation Steps:**

### 📌 SSM Parameter मध्ये S3 Bucket चे नाव स्टोअर करा:

```bash
aws ssm put-parameter \
--name "Cookbook209S3Bucket" \
--type "String" \
--value $BUCKET_NAME
```

### 🖥️ EC2 Instance वरून SSM Session सुरू करा:

```bash
aws ssm start-session --target $INSTANCE_ID
```

### 🌎 Region Auto-set करा:

```bash
export AWS_DEFAULT_REGION=$(curl --silent \
http://169.254.169.254/latest/dynamic/instance-identity/document | awk -F'"' '/region/ {print $4}')
```

### 📥 S3 Bucket चे नाव get करा:

```bash
BUCKET=$(aws ssm get-parameters \
--names "Cookbook209S3Bucket" \
--query "Parameters[*].Value" --output text)
```

### 📂 फाइल डाउनलोड करून चाचणी करा:

```bash
aws s3 cp s3://${BUCKET}/test_file /home/ssm-user/
```

📥 **Output:**

```
download: s3://<bucket>/test_file to ./test_file
```

---

### ❌ **बाहेरील सार्वजनिक बकेट एक्सेस करताना AccessDenied मिळेल:**

```bash
aws s3 ls s3://osm-pds/
# Output: AccessDenied
```

---

## 💡 **Challenge (अतिरिक्त सुरक्षा):**

S3 बकेट policy मध्ये हे अ‍ॅड करा – फक्त VPC Endpoint वरूनच access allow करा:

```json
{
  "Effect": "Deny",
  "Principal": "*",
  "Action": "s3:*",
  "Resource": "arn:aws:s3:::your-bucket-name/*",
  "Condition": {
    "StringNotEquals": {
      "aws:sourceVpce": "vpce-xxxxxxxxxxxx"
    }
  }
}
```

---

## 🧹 **Cleanup Steps:**

```bash
aws ssm delete-parameter --name "Cookbook209S3Bucket"
aws ec2 delete-vpc-endpoints --vpc-endpoint-ids $END_POINT_ID
cd cdk-AWS-Cookbook-209/
python helper.py --unset
unset END_POINT_ID
cdk destroy && deactivate && rm -r .venv/ && cd ../..
```

---

## 🧠 **Discussion (थोडक्यात चर्चा):**

* Gateway VPC Endpoint वापरल्यामुळे **Internet Gateway ची गरज नाही**.
* तुमचा S3 ट्रॅफिक **AWS च्या Backbone नेटवर्क** वरच राहतो.
* Policy documents वापरून तुम्ही access **खूप सूक्ष्म स्तरावर नियंत्रित** करू शकता – bucket, IPs, VPC IDs, etc.
* Interface Endpoints ही एक पर्याय आहेत पण ते **costly** असतात.
* Gateway VPC Endpoints **फुकट** आहेत आणि **S3, DynamoDB** साठी वापरता येतात.

---


खाली **"1.10 – Transit Gateway वापरून Transitive Cross-VPC Connectivity"** चं मराठीत सविस्तर रूपांतरण, आर्किटेक्चर स्पष्टीकरण, स्टेप्स आणि उपयोग दिले आहेत.

---

## 🌐 **1.10 – Transit Gateway वापरून Transitive Cross-VPC Connectivity सक्षम करणे**

---

### ❓ **समस्या (Problem):**

#### ✅ पर्याय 1:

* सर्व VPCs मधील ट्रॅफिक एकमेकांशी जोडायचा आहे.
* एक VPC (Shared Services VPC) मधील **NAT Gateway सर्व VPCs साठी शेअर** करायचा आहे.
* म्हणजे प्रत्येक VPC मध्ये NAT Gateway न ठेवता **cost बचत** करता येईल.

#### ✅ पर्याय 2:

* सर्व VPCs एकमेकांशी communicate करू शकतील.
* **VPC Peering connections कमी ठेवायचे आहेत.**

#### ✅ पर्याय 3:

* AWS डॉक्युमेंटेशनमध्ये सांगितल्याप्रमाणे **on-premise किंवा VPN नेटवर्क्स Transit Gateway मध्ये कनेक्ट करता येतात**, पण या उदाहरणात ते लागू होत नाही.

---

### ✅ **समाधान (Solution):**

* **Transit Gateway (TGW)** तयार करा.
* सर्व VPCs ला **Transit Gateway Attachments** द्वारे TGW शी जोडा.
* प्रत्येक VPC च्या **Route Tables अपडेट करा**, जेणेकरून traffic Transit Gateway कडे जाईल.
* Shared NAT Gateway असलेल्या VPC2 मधून **internet egress traffic share** करा.

---

Here's the **Transit Gateway with Multiple VPCs – Structural Architecture Format** to help you clearly visualize the components and their interactions in a hub-and-spoke model with shared NAT Gateway for internet egress:

---

## 📐 **Structural Architecture Diagram (Text Format)**

```
                          ┌──────────────────────┐
                          │   Internet Gateway   │
                          └─────────┬────────────┘
                                    │
                              ┌─────▼─────┐
                              │  VPC #2   │ Shared Services VPC
                              │  (10.10.2.0/26)  │
                              └─────┬─────┬──────┘
                                    │     │
                 ┌──────────────────┘     └──────────────────┐
                 │                                            │
        ┌────────▼───────┐                            ┌───────▼────────┐
        │ Public Subnet 1│                            │ Public Subnet 2│
        │ NAT Gateway #1 │                            │ NAT Gateway #2 │
        └──────┬─────────┘                            └────────┬───────┘
               │                                                  │
        ┌──────▼─────────┐                            ┌──────────▼───────┐
        │ Route Table    │                            │ Route Table      │
        │ (Attachment)   │                            │ (Attachment)     │
        └──────┬─────────┘                            └──────────┬────────┘
               │                                                  │
               └─────────────┬───────────────┬────────────────────┘
                             │               │
                     ┌───────▼──────┐ ┌──────▼────────┐
                     │  Transit     │ │  Gateway (TGW)│
                     │  Gateway     │ └───────────────┘
                     └──────┬───────┘
                            │
      ┌─────────────────────┼───────────────────────┐
      │                     │                       │
┌─────▼─────┐         ┌─────▼─────┐           ┌─────▼─────┐
│  VPC #1   │         │  VPC #2   │           │  VPC #3   │
│ 10.10.0.0/26 │       │ 10.10.2.0/26 │       │ 10.10.1.0/26 │
└─────┬─────┘         └─────┬─────┘           └─────┬─────┘
      │                     │                       │
┌─────▼─────┐         ┌─────▼─────┐           ┌─────▼─────┐
│ Private   │         │ Private   │           │ Private   │
│ Subnets   │         │ Subnets   │           │ Subnets   │
└─────┬─────┘         └─────┬─────┘           └─────┬─────┘
      │                     │                       │
┌─────▼────────┐      ┌─────▼────────┐        ┌─────▼────────┐
│ Route Table  │      │ Route Table  │        │ Route Table  │
│ (to TGW)     │      │ (to TGW + IGW)│       │ (to TGW)     │
└──────────────┘      └──────────────┘        └──────────────┘

Legend:
- All VPCs are connected to TGW (hub).
- VPC2 has the NAT Gateways and Internet Gateway.
- VPC1 & VPC3 send internet-bound traffic to TGW, then routed to NAT Gateway in VPC2.
```

---

## 🧭 **Key Points in Architecture:**

| Component                        | Role                                                     |
| -------------------------------- | -------------------------------------------------------- |
| **Transit Gateway**              | Central hub for all VPC communication                    |
| **VPC #1 & #3**                  | Spoke VPCs using TGW for outbound and VPC-to-VPC traffic |
| **VPC #2**                       | Shared Services VPC containing NAT & IGW                 |
| **NAT Gateway**                  | Centralized internet egress via VPC2                     |
| **Dedicated Attachment Subnets** | Used for precise TGW connections in each VPC             |

---

## 🔁 **Traffic Flow:**

1. **Outbound to Internet**:

   * EC2 in VPC1 → Route Table → TGW → TGW Route → VPC2 → NAT Gateway → IGW → Internet

2. **Inter-VPC Communication**:

   * EC2 in VPC1 → TGW → VPC3 via TGW Route Table

3. **Optional Restriction**:

   * Use TGW Route Tables and VPC Route Tables to restrict which VPCs communicate.

---



---

## ⚙️ **पूर्वतयारी (Prerequisites):**

* एकाच region मध्ये 3 VPCs – प्रत्येकात private, isolated subnet tiers
* VPC2 मध्ये Internet Gateway आणि दोन NAT Gateways
* AWS CDK वापरून infrastructure setup करायचा

---

## 🧱 **स्टेप्स (Steps):**

### 📦 Step 0 – CDK Setup

```bash
cd 210-Using-a-Transit-Gateway/cdk-AWS-Cookbook-210/
python3 -m venv .venv && source .venv/bin/activate
pip install --upgrade pip setuptools wheel
pip install -r requirements.txt
cdk deploy
python helper.py  # Export env vars
```

---

### 🛠️ Step 1 – Transit Gateway तयार करा

```bash
TGW_ID=$(aws ec2 create-transit-gateway \
--description "AWSCookbook210" \
--options AmazonSideAsn=65010,AutoAcceptSharedAttachments=enable,DefaultRouteTableAssociation=enable,DefaultRouteTablePropagation=enable,VpnEcmpSupport=enable,DnsSupport=enable \
--output text --query TransitGateway.TransitGatewayId)
```

---

### 🔗 Step 2 – Transit Gateway Attachments

```bash
TGW_ATTACH_1=$(aws ec2 create-transit-gateway-vpc-attachment \
--transit-gateway-id $TGW_ID \
--vpc-id $VPC_ID_1 \
--subnet-ids $ATTACHMENT_SUBNETS_VPC_1 \
--query TransitGatewayVpcAttachment.TransitGatewayAttachmentId --output text)

TGW_ATTACH_2=$(aws ec2 create-transit-gateway-vpc-attachment \
--transit-gateway-id $TGW_ID \
--vpc-id $VPC_ID_2 \
--subnet-ids $ATTACHMENT_SUBNETS_VPC_2 \
--query TransitGatewayVpcAttachment.TransitGatewayAttachmentId --output text)

TGW_ATTACH_3=$(aws ec2 create-transit-gateway-vpc-attachment \
--transit-gateway-id $TGW_ID \
--vpc-id $VPC_ID_3 \
--subnet-ids $ATTACHMENT_SUBNETS_VPC_3 \
--query TransitGatewayVpcAttachment.TransitGatewayAttachmentId --output text)
```

---

### 🗺️ Step 3 – Private Subnet Route Tables अपडेट करा

```bash
aws ec2 create-route --route-table-id $VPC_1_RT_ID_1 --destination-cidr-block 0.0.0.0/0 --transit-gateway-id $TGW_ID
aws ec2 create-route --route-table-id $VPC_1_RT_ID_2 --destination-cidr-block 0.0.0.0/0 --transit-gateway-id $TGW_ID

aws ec2 create-route --route-table-id $VPC_3_RT_ID_1 --destination-cidr-block 0.0.0.0/0 --transit-gateway-id $TGW_ID
aws ec2 create-route --route-table-id $VPC_3_RT_ID_2 --destination-cidr-block 0.0.0.0/0 --transit-gateway-id $TGW_ID
```

---

### 🌐 Step 4 – VPC2 (NAT असलेला) मध्ये Route Add करा:

```bash
aws ec2 create-route --route-table-id $VPC_2_RT_ID_1 --destination-cidr-block 10.10.0.0/24 --transit-gateway-id $TGW_ID
aws ec2 create-route --route-table-id $VPC_2_RT_ID_2 --destination-cidr-block 10.10.0.0/24 --transit-gateway-id $TGW_ID
```

---

### 🌉 Step 5 – NAT Gateway साठी Routing

```bash
NAT_GW_ID_1=$(aws ec2 describe-nat-gateways --filter "Name=subnet-id,Values=$VPC_2_PUBLIC_SUBNET_ID_1" --query NatGateways[*].NatGatewayId --output text)
NAT_GW_ID_2=$(aws ec2 describe-nat-gateways --filter "Name=subnet-id,Values=$VPC_2_PUBLIC_SUBNET_ID_2" --query NatGateways[*].NatGatewayId --output text)

aws ec2 create-route --route-table-id $VPC_2_ATTACH_RT_ID_1 --destination-cidr-block 0.0.0.0/0 --nat-gateway-id $NAT_GW_ID_1
aws ec2 create-route --route-table-id $VPC_2_ATTACH_RT_ID_2 --destination-cidr-block 0.0.0.0/0 --nat-gateway-id $NAT_GW_ID_2
```

---

### 🧭 Step 6 – Transit Gateway मध्ये Static Route Add करा

```bash
TRAN_GW_RT=$(aws ec2 describe-transit-gateways \
--transit-gateway-ids $TGW_ID \
--query TransitGateways[0].Options.AssociationDefaultRouteTableId --output text)

aws ec2 create-transit-gateway-route \
--destination-cidr-block 0.0.0.0/0 \
--transit-gateway-route-table-id $TRAN_GW_RT \
--transit-gateway-attachment-id $TGW_ATTACH_2
```

---

### ✅ Step 7 – Validation:

1. **Instance SSM Registered Check**:

```bash
aws ssm describe-instance-information \
--filters Key=ResourceType,Values=EC2Instance \
--query "InstanceInformationList[].InstanceId" --output text
```

2. **SSM Session Start**:

```bash
aws ssm start-session --target $INSTANCE_ID_1
```

3. **Internet Ping Test**:

```bash
ping -c 4 aws.amazon.com
```

---

## 🎯 **Challenges:**

* 🔒 **Challenge 1**: VPC3 साठी फक्त `10.10.0.0/24` पर्यंतच route द्या (इंटरनेट access रोखा).
* 🚫 **Challenge 2**: VPC1 आणि VPC3 मध्ये एकमेकांशी communication नको असल्यास वेगळी TGW route table वापरा.
* ➕ **Challenge 3**: आणखी एक /26 VPC जोडून Transit Gateway मध्ये अटॅच करा.

---

## 🧹 **Cleanup:**

```bash
aws ec2 delete-transit-gateway-vpc-attachment --transit-gateway-attachment-id $TGW_ATTACH_1
aws ec2 delete-transit-gateway-vpc-attachment --transit-gateway-attachment-id $TGW_ATTACH_2
aws ec2 delete-transit-gateway-vpc-attachment --transit-gateway-attachment-id $TGW_ATTACH_3

aws ec2 delete-transit-gateway --transit-gateway-id $TGW_ID

python helper.py --unset

unset TGW_ID
unset TRAN_GW_RT
unset NAT_GW_ID_1
unset NAT_GW_ID_2
unset ATTACHMENT_SUBNETS_VPC_1
unset ATTACHMENT_SUBNETS_VPC_2
unset ATTACHMENT_SUBNETS_VPC_3

cdk destroy && deactivate && rm -r .venv/ && cd ../..
```

---

## 📌 **Discussion (सारांश):**

* Transit Gateway मुळे **कमी Peering Connections** आणि **centralized network management** शक्य.
* **Hub & Spoke मॉडेल** मध्ये एकाच TGW ला अनेक VPC जोडता येतात.
* **Cross-Region**, **Cross-Account**, आणि **on-premises connectivity** देखील शक्य आहे.
* Dedicated Attachment Subnets वापरल्यामुळे **granular control** मिळतो.

---


खाली दिलेले "VPC Peering" चे संपूर्ण स्पष्टीकरण **मराठीत** भाषांतरित केले असून त्यात एक **आर्किटेक्चर स्ट्रक्चरल डायग्राम** देखील जोडले आहे जे **दोन VPC मध्ये नेटवर्क कम्युनिकेशन** कसे कार्य करते ते दाखवते.

---

## 🔧 समस्या (Problem)

तुम्हाला दोन स्वतंत्र VPCs मध्ये असलेल्या EC2 instances मध्ये **नेटवर्क कम्युनिकेशन** सक्षम करायचे आहे, तेही **सोप्या आणि खर्चिकदृष्ट्या प्रभावी पद्धतीने**.

---

## ✅ उपाय (Solution)

1. दोन VPCs मध्ये VPC Peering कनेक्शन विनंती करा.
2. Peering कनेक्शन स्वीकारा.
3. दोन्ही VPC च्या Route Tables मध्ये योग्य CIDR Range साठी Route जोडा.
4. एक EC2 Instance वरून दुसऱ्या Instance ला Ping करून कनेक्टिव्हिटी तपासा.

---

## 🏗️ आर्किटेक्चर स्ट्रक्चर (Structural Architecture Format)

```
                   ╔══════════════╗                        ╔══════════════╗
                   ║   VPC 1      ║                        ║   VPC 2      ║
                   ║ 10.0.0.0/16  ║                        ║ 10.1.0.0/16  ║
                   ╚══════╦═══════╝                        ╚══════╦═══════╝
                          │                                      │
                ┌─────────▼─────────┐                 ┌──────────▼──────────┐
                │   Subnet 1        │                 │   Subnet 2         │
                │ (Private)         │                 │ (Private)          │
                └─────────┬─────────┘                 └──────────┬──────────┘
                          │                                      │
                ┌─────────▼─────────┐                 ┌──────────▼──────────┐
                │   EC2 Instance 1  │                 │   EC2 Instance 2    │
                └───────────────────┘                 └─────────────────────┘
                          │                                      ▲
                          └────────────────────┬─────────────────┘
                                               ▼
                                ╔════════════════════════╗
                                ║   VPC Peering (PCX)    ║
                                ║ Enables bidirectional  ║
                                ║    traffic flow        ║
                                ╚════════════════════════╝
```

---

## 📝 पूर्वअट (Prerequisites)

* दोन VPCs (प्रत्येकी दोन AZs मध्ये Subnets)
* प्रत्येकी एक EC2 इंस्टन्स (Connectivity साठी)
* AWS CLI किंवा CDK वापरण्याची तयारी

---

## ⚙️ पायऱ्या (Steps)

1. **VPC Peering कनेक्शन तयार करा:**

```bash
VPC_PEERING_CONNECTION_ID=$(aws ec2 create-vpc-peering-connection \
--vpc-id $VPC_ID_1 --peer-vpc-id $VPC_ID_2 \
--output text --query VpcPeeringConnection.VpcPeeringConnectionId)
```

2. **Peering कनेक्शन स्वीकारा:**

```bash
aws ec2 accept-vpc-peering-connection \
--vpc-peering-connection-id $VPC_PEERING_CONNECTION_ID
```

3. **Route Table मध्ये Entry जोडा (दोन्ही बाजूंसाठी):**

```bash
aws ec2 create-route --route-table-id $VPC_SUBNET_RT_ID_1 \
--destination-cidr-block $VPC_CIDR_2 \
--vpc-peering-connection-id $VPC_PEERING_CONNECTION_ID

aws ec2 create-route --route-table-id $VPC_SUBNET_RT_ID_2 \
--destination-cidr-block $VPC_CIDR_1 \
--vpc-peering-connection-id $VPC_PEERING_CONNECTION_ID
```

4. **Security Group Rule जोडा (ICMP साठी):**

```bash
aws ec2 authorize-security-group-ingress \
--protocol icmp --port -1 \
--source-group $INSTANCE_SG_1 \
--group-id $INSTANCE_SG_2
```

---

## 🧪 चाचणी (Validation)

* **Instance 2 चा Private IP मिळवा**:

```bash
aws ec2 describe-instances --instance-ids $INSTANCE_ID_2 \
--output text --query Reservations[0].Instances[0].PrivateIpAddress
```

* **SSM Session वापरून Instance 1 मध्ये लॉगिन करा:**

```bash
aws ssm start-session --target $INSTANCE_ID_1
```

* **Ping Test:**

```bash
ping -c 4 <INSTANCE_IP_2>
```

---

## 🚨 टीप:

* VPC Peering **Non-Transitive** असते: VPC1 ↔ VPC2 चालेल, पण VPC1 ↔ VPC3 ↔ VPC2 अशी चेन काम करणार नाही.
* त्यामुळे एकमेकांशी बोलण्यासाठी प्रत्येक VPC ला प्रत्येकाशी Peering हवे.

---

## 🧩 Challenge Ideas

1. **Cross-region Peering:** वेगळ्या Region मधील VPC ला Peering करून पहा.
2. **Cross-account Peering:** वेगळ्या AWS Account मधील VPCs मध्ये Peering करा.

---

## 🧹 Cleanup

```bash
# Security Group rule delete करा
aws ec2 revoke-security-group-ingress --protocol icmp --port -1 \
--source-group $INSTANCE_SG_1 --group-id $INSTANCE_SG_2

# Peering connection delete करा
aws ec2 delete-vpc-peering-connection \
--vpc-peering-connection-id $VPC_PEERING_CONNECTION_ID
```

---

## 📌 चर्चा (Discussion - Summary in Marathi)

* VPC Peering म्हणजे दोन VPC मध्ये **Private Network Communication** सुरू करणे.
* या साठी CIDR Ranges Overlap नसाव्यात.
* प्रत्येक VPC ला त्याच्या Peer साठी Route Table मध्ये एंट्री द्यावी लागते.
* जर बऱ्याच VPC जोडायच्या असतील, तर Transit Gateway वापरणे योग्य ठरते.

---


खालील माहितीचे मराठीत भाषांतर केले आहे आणि त्यात **आर्किटेक्चर स्ट्रक्चर फॉरमॅट** देखील समाविष्ट केला आहे. या प्रक्रियेमध्ये आपण **Amazon S3 आणि CloudFront वापरून Static Web Content जगभरातील युजर्ससाठी जलद लोड** कसे करू शकतो हे शिकणार आहोत.

---

## 🎯 समस्या (Problem)

तुम्ही सध्या Static Web Content साठी **S3 बकेट वापरत आहात**. आता तुम्हाला **ग्लोबल युजर्ससाठी जलद आणि सुरक्षित डेटा लोड** करायचा आहे.

---

## 🔧 उपाय (Solution)

तुमच्या S3 बकेटसाठी **CloudFront Distribution** तयार करा आणि Origin Access Identity (OAI) वापरून बकेटमध्ये **फक्त CloudFront कडूनच अ‍ॅक्सेस** होईल याची खात्री करा.

---

## 🏗️ आर्किटेक्चर (Structural Format Diagram)

```
                        🌍 End User (Global)
                               │
                               ▼
                  ┌──────────────────────────────┐
                  │     Amazon CloudFront         │
                  │ (Content Delivery Network)    │
                  └────────────┬──────────────────┘
                               │
            Uses Origin Access Identity (OAI)
                               │
                               ▼
                   ┌────────────────────────┐
                   │     Amazon S3 Bucket    │
                   │ (Static Web Content)    │
                   └────────────────────────┘
```

---

## ✅ पूर्वअट (Prerequisites)

* Static Web Content असलेला S3 बकेट
* `index.html` फाइल तयार करा:

```bash
echo AWSCookbook > index.html
```

---

## 🧱 टप्प्याटप्प्याने कृती (Step-by-Step)

### 1. 🪣 S3 बकेट तयार करा आणि फाइल अपलोड करा

```bash
BUCKET_NAME=awscookbook213-$(aws secretsmanager get-random-password \
--exclude-punctuation --exclude-uppercase --password-length 6 \
--require-each-included-type --output text --query RandomPassword)

aws s3api create-bucket --bucket $BUCKET_NAME
aws s3 cp index.html s3://$BUCKET_NAME/
```

---

### 2. 🆔 CloudFront OAI तयार करा

```bash
OAI=$(aws cloudfront create-cloud-front-origin-access-identity \
--cloud-front-origin-access-identity-config \
CallerReference="awscookbook",Comment="AWSCookbook OAI" \
--query CloudFrontOriginAccessIdentity.Id --output text)
```

---

### 3. 🧾 CloudFront Distribution तयार करा

```bash
# Template मध्ये OAI व Bucket बदल
sed -e "s/CLOUDFRONT_OAI/${OAI}/g" \
    -e "s|S3_BUCKET_NAME|${BUCKET_NAME}|g" \
    distribution-template.json > distribution.json

# CloudFront Distribution तयार करा
DISTRIBUTION_ID=$(aws cloudfront create-distribution \
--distribution-config file://distribution.json \
--query Distribution.Id --output text)

# Distribution तयार होईपर्यंत थांबा
aws cloudfront get-distribution --id $DISTRIBUTION_ID
```

---

### 4. 🔐 S3 बकेट Policy अपडेट करा

```bash
sed -e "s/CLOUDFRONT_OAI/${OAI}/g" \
    -e "s|S3_BUCKET_NAME|${BUCKET_NAME}|g" \
    bucket-policy-template.json > bucket-policy.json

aws s3api put-bucket-policy --bucket $BUCKET_NAME \
--policy file://bucket-policy.json
```

---

### 5. 🌐 CloudFront Domain Name मिळवा

```bash
DOMAIN_NAME=$(aws cloudfront get-distribution --id $DISTRIBUTION_ID \
--query Distribution.DomainName --output text)
```

---

## 🧪 व्हॅलिडेशन स्टेप्स (Validation)

### 🔒 बकेट थेट अ‍ॅक्सेस नाकारावा लागतो

```bash
curl https://$BUCKET_NAME.s3.$AWS_REGION.amazonaws.com/index.html
# Output: Access Denied
```

### ✅ CloudFront द्वारे यशस्वी अ‍ॅक्सेस

```bash
curl $DOMAIN_NAME
# Output: AWSCookbook
```

---

## 🧩 Challenge

* S3 ऑब्जेक्टसाठी **TTL (Time To Live)** 30 दिवसांसाठी सेट करा.
* त्यानंतर `aws cloudfront update-distribution` वापरून अपडेट करा.

---

## 🧹 Cleanup

```bash
# CloudFront Distribution delete करा
aws cloudfront delete-distribution --id $DISTRIBUTION_ID \
--if-match $(aws cloudfront get-distribution --id $DISTRIBUTION_ID --query ETag --output text)

# OAI delete करा
aws cloudfront delete-cloud-front-origin-access-identity --id $OAI \
--if-match $(aws cloudfront get-cloud-front-origin-access-identity --id $OAI --query ETag --output text)

# S3 cleanup
aws s3 rm s3://$BUCKET_NAME/index.html
aws s3api delete-bucket --bucket $BUCKET_NAME

# Environment variables unset करा
unset DISTRIBUTION_ID
unset DOMAIN_NAME
unset OAI
```

---

## 💬 चर्चा (Discussion in Marathi)

* आपण CloudFront Origin Access Identity वापरून S3 Bucket ला प्रायव्हेट ठेवले.
* CloudFront हा **CDN (Content Delivery Network)** आहे जो ग्लोबली थेट AWS Regions ला जोडतो.
* यामुळे तुमचा कंटेंट **Fast, Secure आणि Low Latency** मध्ये जगभर पोहोचतो.
* CloudFront कंटेंट कॅश करतो म्हणून S3 वरची **प्रत्येक request कमी होते**, ज्यामुळे खर्चही कमी होतो.
* तुम्ही CloudFront वर Custom Domain, HTTPS, Cache Behavior, आणि Lambda\@Edge ही फिचर्स वापरू शकता.

---
