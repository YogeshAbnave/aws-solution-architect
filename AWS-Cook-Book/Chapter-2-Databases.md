Here is the **detailed document** in **Marathi**, along with a **structured architecture** (written format, not image or code).

---

# **2.1 - Aurora Serverless PostgreSQL डेटाबेस तयार करणे**

---

## 📌 **समस्या (Problem)**

तुम्हाला अशा डेटाबेसची गरज आहे जो अनियमित, मधूनच येणाऱ्या, व अंदाज न लावता येणाऱ्या लोडसाठी वापरला जाईल.

---

## ✅ **उपाय (Solution)**

Aurora Serverless Database Cluster तयार करा ज्यामध्ये एक मजबूत पासवर्ड असतो. त्यात एक स्केलेबल सेटिंग लागू करा आणि निष्क्रियतेनंतर डेटाबेसला ऑटोमॅटिकली "pause" होण्यासाठी सेट करा.

---

## 🔧 **तयारी (Preparation)**

या सोल्युशनमध्ये AWS CDK वापरून आवश्यक संसाधने तयार केली जातात. पुढील स्टेप्स फॉलो करा:

1. प्रोजेक्ट फोल्डरमध्ये जा:
   `cd 401-Creating-an-Aurora-Serverless-DB/cdk-AWS-Cookbook-401/`

2. virtual environment तयार करा:
   `python3 -m venv .venv && source .venv/bin/activate`

3. dependency install करा:
   `pip install -r requirements.txt --no-dependencies`

4. CDK deploy करा:
   `cdk deploy`

5. `helper.py` स्क्रिप्ट वापरून environment variables एक्सपोर्ट करा:
   `python helper.py`

---

## 🧱 **आर्किटेक्चर – रचनात्मक स्वरूपात (Architecture in Structured Format)**

### 1. **User Layer (User / Application)**

* EC2 इंस्टन्स
* API कॉल्स / पायथन स्क्रिप्ट्स / क्लायंट सॉफ्टवेअर

### 2. **Network Layer**

* VPC (Virtual Private Cloud)
* Subnets (Private Subnets for DB)
* Security Groups (Inbound: TCP 5432)

### 3. **Database Layer**

* Amazon Aurora Serverless Cluster (PostgreSQL compatible)

  * DB Subnet Group
  * Parameter Group
  * Serverless Engine Mode
  * AutoPause enabled (300 seconds inactivity)
  * Capacity range (Min: 8, Max: 16)
* Secrets Manager – पासवर्ड स्टोअर करण्यासाठी

### 4. **Operations Layer**

* SSM Parameters

  * Endpoint Parameter
  * MasterPassword Parameter
* Session Manager – EC2 मध्ये लॉगिन
* `psql` tool – PostgreSQL CLI client

### 5. **Cleanup Layer**

* SSM Parameter Delete
* Security Group Ingress Revoke
* RDS Cluster Delete
* Parameter Group Delete
* Subnet Group Delete
* Security Group Delete
* Environment Variable Cleanup

---

## 🧪 **स्टेप्स (Steps Summary)**

1. Secrets Manager वापरून पासवर्ड जेनरेट करा.
2. RDS Subnet Group, Parameter Group तयार करा.
3. VPC साठी सिक्युरिटी ग्रुप तयार करा.
4. RDS Cluster `aurora-postgresql` engine वापरून तयार करा.
5. AutoPause व Scaling साठी modify करा.
6. सत्र सुरू करून `psql` वापरून डेटाबेसला कनेक्ट व्हा.
7. सत्र बंद करा, आणि Capacity शून्यावर जातेय का ते तपासा.

---

## 💡 **महत्वाची टीप (Note)**

* AutoPause सुरू झाल्यावर क्लस्टर 0 Capacity वर जातो.
* काहीही ट्रॅफिक किंवा क्वेरी आल्यावर ते पुन्हा MinCapacity वर स्केल होते.
* हे **अनियमित ट्रॅफिक असलेल्या अनुप्रयोगांसाठी आदर्श** आहे.

---

## 🧼 **Cleanup प्रक्रिया (Cleanup Process)**

* SSM Parameter delete करा.
* Security Group access revoke करा.
* RDS Cluster delete करा.
* Parameter आणि Subnet Groups delete करा.
* Security Group delete करा.
* Environment variable unset करा.
* CDK destroy करा आणि virtualenv deactivate करा.

---

## 📚 **चर्चा (Discussion)**

* आपण एक serverless Aurora PostgreSQL क्लस्टर तयार केला आहे.
* क्लस्टरमध्ये capacity युजरच्या गरजेनुसार वाढते/कमी होते.
* AutoPause feature storage वाचवतो जेव्हा युजर activity नसते.
* हे feature development, staging किंवा unpredictable ट्रॅफिकसाठी उपयोगी आहे.
* Provisioned क्लस्टर वापरणाऱ्यांसाठी migration देखील शक्य आहे.
* Aurora replication 6 copies across 3 AZs करतो, तरीही बॅकअप enabled असावा.

---

## ⚠️ **सावधान (Warning)**

* सर्व engine modes Serverless मध्ये उपलब्ध नसतात. PostgreSQL 10.7+ व MySQL 5.6 compatible आहेत.
* CIDR आणि VPC configuration काळजीपूर्वक ठेवा.

---



खाली दिलेल्या मजकुरामध्ये मी संपूर्ण **“IAM Authentication वापरून RDS Database Access” (Recipe 2.2)** चे **मराठीत भाषांतर** केले आहे आणि **आर्किटेक्चरल स्ट्रक्चर** सुद्धा स्पष्टपणे जोडले आहे — सर्व काही डॉक्युमेंट फॉर्ममध्ये, कोड ब्लॉक न वापरता.

---

# 📘 AWS IAM Authentication सह RDS Database – मराठी दस्तऐवज

---

## 🧩 समस्या (Problem)

तुमच्याकडे एक सर्व्हर आहे जो डेटाबेसमध्ये **पासवर्ड वापरून कनेक्ट** होतो. आता तुम्हाला पासवर्ड ऐवजी **IAM Role आधारित फिरते क्रेडेन्शियल्स (rotating credentials)** वापरायची आहेत.

---

## ✅ उपाय (Solution)

1. RDS डेटाबेसवर **IAM Authentication सक्षम** करा.
2. EC2 इंस्टन्ससाठी योग्य **IAM Role व Policy** सेट करा.
3. RDS मध्ये **IAM आधारित नवीन युजर** तयार करा.
4. EC2 वरून टोकन तयार करून डेटाबेसमध्ये कनेक्ट व्हा.
5. कनेक्शनसाठी **SSL प्रमाणपत्र वापरा**.

---

## 📐 **Architecture – संरचनात्मक स्वरूपात**

---

### 1️⃣ Application/User Layer (अ‍ॅप्लिकेशन / वापरकर्ता स्तर)

* EC2 Instance (Amazon Linux/Ubuntu)

  * `mysql` किंवा `psql` client
  * IAM Role attached (with `rds-db:connect`)
  * SSM Agent installed
  * `aws-cli` configured
  * SSL प्रमाणपत्र (`rds-ca-2019-root.pem`) डाउनलोड केलेले

---

### 2️⃣ IAM & Permissions Layer (IAM व परवानगी स्तर)

* IAM Role for EC2 Instance:

  * **Policy Action**: `rds-db:connect`
  * **Resource ARN**:
    `arn:aws:rds-db:<region>:<account_id>:dbuser:<db_resource_id>/db_user`

* **Policy binding**:

  * EC2 Instance Role ला ही policy अटॅच केली जाते.

---

### 3️⃣ Database Layer (डेटाबेस स्तर)

* Amazon RDS (MySQL/PostgreSQL)

  * IAM Authentication: **Enabled**
  * DB User created using AWSAuthenticationPlugin
  * Example:

    ```
    CREATE USER db_user@'%' IDENTIFIED WITH AWSAuthenticationPlugin AS 'RDS';
    ```

* GRANT Assignments:

  * वापरकर्त्याला SELECT अधिकार (किंवा इतर) DB वरून दिले जातात.

---

### 4️⃣ Networking Layer (नेटवर्क स्तर)

* VPC, Subnets, Internet Gateway
* Security Groups:

  * EC2 ते RDS: TCP 3306 (MySQL) किंवा 5432 (PostgreSQL) allow
* Route Tables:

  * Subnet connectivity सुनिश्चित

---

### 5️⃣ Parameter Store / Secrets Layer

* SSM Parameters:

  * `Cookbook402Endpoint` – RDS endpoint साठवतो
  * `Cookbook402AdminPassword` – Admin पासवर्ड साठवतो

* Secrets Manager:

  * RDS Admin क्रेडेन्शियल्स साठवतो (सुरक्षित वापरासाठी)

---

### 6️⃣ Encryption & Secure Access Layer

* IAM Authentication Token:

  * `aws rds generate-db-auth-token` वापरून टोकन तयार
  * वैधता: **15 मिनिटे**

* SSL Certificate:

  * `rds-ca-2019-root.pem` वापरून इन-ट्रान्झिट एन्क्रिप्शन

---

## 🔧 सेटअप प्रक्रिया (Steps)

1. IAM Authentication RDS Instance वर **सक्षम** करा.
2. `policy.json` फाईल तयार करून त्यात IAM user/resource bindings टाका.
3. EC2 Instance Role ला policy अटॅच करा.
4. EC2 वरून mysql client इन्स्टॉल करा.
5. SecretsManager मधून admin पासवर्ड प्राप्त करा.
6. SSM Parameter Store मध्ये endpoint व पासवर्ड स्टोअर करा.
7. RDS मध्ये नवीन युजर तयार करा जो IAM Authentication Plugin वापरतो.
8. `generate-db-auth-token` वापरून टोकन तयार करा.
9. mysql client वापरून **IAM Token + SSL प्रमाणपत्र** वापरून कनेक्ट व्हा.
10. SELECT Query चालवून access verify करा.

---

## 🧼 Cleanup (स्वच्छता प्रक्रिया)

1. SSM Parameters delete करा:

   * `Cookbook402Endpoint`
   * `Cookbook402AdminPassword`
2. IAM Policy detach व delete करा.
3. `helper.py --unset` वापरून env variables काढा.
4. `cdk destroy` वापरून AWS resources हटवा.

---

## 💡 चर्चा (Discussion)

* IAM Authentication वापरल्यामुळे **डेटाबेस क्रेडेन्शियल्स सुरक्षित ठेवता येतात**.
* टोकन वापरून 15 मिनिटांमध्ये **स्वतः expire होणारे authentication**.
* या setup मध्ये SSL प्रमाणपत्र वापरून **डेटा इन-ट्रान्झिट एन्क्रिप्टेड** होतो.
* यामुळे password management, rotation आणि leakage ची गरज राहत नाही.
* IAM policy **authentication पर्यंत मर्यादित** असते, actual DB privileges DB मधून दिले जातात.
* या संरचनेचा उपयोग **horizontal scaling, distributed apps, CI/CD pipelines, आणि multi-environment access control** साठी मोठ्या प्रमाणावर होतो.

---

## 🔐 सुरक्षा फायदे

* **पासवर्डशिवाय authentication**
* **IAM-controlled access**
* **SSL-based encryption**
* **Centralized permission management**
* **Token expiry mechanism**

---

## 🧾 अंतिम निष्कर्ष

AWS IAM Authentication वापरून RDS साठी secure, scalable, आणि centralized डेटाबेस access management तयार करता येतो. या प्रणालीमध्ये पासवर्ड्सची गरज न पडता access control IAM वर आधारित राहतो, जे आधुनिक आणि सुरक्षित उपाय आहे.

---


खाली तुमच्या दिलेल्या RDS Proxy आणि Lambda इंटरग्रेशन साठीचे संपूर्ण कंटेंट **मराठीत रूपांतरित करून डॉक्युमेंट फॉर्ममध्ये सादर** करण्यात आले आहे. यात कोड ब्लॉक्स न देता, फक्त संकल्पना आणि स्ट्रक्चरवर भर दिला आहे — जसे की तुम्ही मागितले होते.

---

# 📘 **AWS RDS Proxy वापरून Lambda कडून Database कनेक्शन – मराठी दस्तऐवज**

---

## 🧩 समस्या (Problem)

तुमच्याकडे एक AWS Lambda function आहे जी एका RDS डेटाबेसशी जोडलेली आहे. परंतु प्रत्येक invocation मध्ये नवीन database connection तयार होत असल्यामुळे डेटाबेसवर लोड येतो. हे टाळण्यासाठी तुम्हाला **connection pooling** लागू करायचे आहे.

---

## ✅ उपाय (Solution)

* RDS Proxy तयार करा.
* Proxy ला तुमच्या MySQL RDS database शी जोडा.
* Lambda function ला RDS Proxy चा endpoint वापरून डेटाबेसशी जोडण्यासाठी configure करा.

---

## 📐 Architecture – संरचनात्मक स्वरूपात

---

### 1️⃣ Application Layer (अ‍ॅप्लिकेशन स्तर)

* **Lambda Function**

  * DB access करण्यासाठी `RDS Proxy Endpoint` वापरते.
  * IAM Role मध्ये `rds-db:connect` अधिकार.

---

### 2️⃣ Middleware Layer (मध्यस्त स्तर)

* **Amazon RDS Proxy**

  * IAM Authentication वापरतो.
  * Secrets Manager मधून DB credentials घेतो.
  * RDS instances सोबत कनेक्शन pool तयार करतो.
  * Proxy endpoint Lambda ला दिला जातो.

---

### 3️⃣ Database Layer (डेटाबेस स्तर)

* **Amazon RDS (MySQL)**

  * Endpoint: Internal, Direct access बंद केला जातो.
  * Proxy मार्फतच access दिला जातो.
  * IAM Auth आणि SSL समर्थित.

---

### 4️⃣ Networking & Security Layer

* **VPC आणि Subnets** (Isolated/private)
* **Security Groups**:

  * Lambda → RDS Proxy (TCP 3306)
  * RDS Proxy → RDS Instance (TCP 3306)

---

### 5️⃣ Identity & Access Management Layer

* **IAM Role for Lambda**:

  * `rds-db:connect` policy
  * `SecretsManagerReadOnlyAccess`

* **IAM Role for RDS Proxy**:

  * `SecretsManagerReadWrite` (production मध्ये narrow scope देणे उत्तम)

---

## 🪜 स्टेप्स (क्रियावली)

---

### A. तयारी

1. AWS CDK प्रोजेक्ट तयार करा.
2. `cdk deploy` चालवा.
3. `helper.py` वापरून environment variables सेट करा.

---

### B. RDS Proxy सेटअप

1. `assume-role-policy.json` वापरून IAM Role तयार करा.
2. RDS Proxy साठी Security Group तयार करा.
3. RDS Proxy तयार करा – SecretsManager व IAM Auth सह.
4. RDS Proxy “available” होईपर्यंत थांबा.
5. Proxy Endpoint environment variable मध्ये सेट करा.

---

### C. IAM Policy व Lambda कॉन्फिगरेशन

1. `policy.json` तयार करा (`rds-db:connect` role साठी).
2. IAM Policy तयार करून Lambda Function च्या Role ला अटॅच करा.
3. RDS Proxy Role ला SecretsManager policy अटॅच करा.
4. RDS Instance साठी Proxy ला access देणारे Security Rule जोडा.

---

### D. Proxy Target Registration

1. RDS Proxy मध्ये DB instance register करा.
2. Proxy target status “AVAILABLE” होईपर्यंत थांबा.
3. Lambda Function ला Proxy Security Group मधून ingress परवानगी द्या.
4. Lambda चा `DB_HOST` environment variable → RDS Proxy Endpoint ने बदला.
5. Lambda invoke करून Test करा.

---

## 🧼 Cleanup प्रक्रिया

1. RDS Proxy delete करा.
2. Proxy ची Elastic Network Interfaces delete करा.
3. Security Group ingress नियम रद्द करा.
4. RDS Proxy साठी वापरलेली Security Group delete करा.
5. IAM Policy detach व delete करा.
6. RDS Proxy Role delete करा.
7. CDK Project destroy करा व `.venv` deactivate करा.

---

## 💡 चर्चा (Discussion)

* **Connection Pooling**: Lambda function concurrency जास्त असल्यास अनेक DB connections तयार होतात. यामुळे डेटाबेसवर लोड वाढतो. RDS Proxy हाच लोड नियंत्रित करतो.
* **IAM Authentication**: प्रत्येक Lambda invocation साठी IAM आधारित टोकन वापरून secure access.
* **Performance Benefit**: Proxy मुळे डेटाबेसवर थेट connection कमी होतो आणि connection reuse होतो.
* **SSL Support**: AWS RDS Proxy SSL प्रमाणपत्र वापरून transit encryption सपोर्ट करतो.
* **Supported Engines**: MySQL आणि PostgreSQL साठी Proxy वापरता येतो.

---

## 🔐 फायदे

| लाभ               | वर्णन                                                       |
| ----------------- | ----------------------------------------------------------- |
| 🛡️ सुरक्षा       | पासवर्डऐवजी IAM Auth वापरल्यामुळे secure access             |
| 🔄 कनेक्शन पूलिंग | RDS Proxy connection reuse करतो                             |
| ⚙️ स्केलेबिलिटी   | Lambda concurrency वाढल्यावरही performance consistent राहते |
| 💰 खर्च नियंत्रण  | Open connections कमी झाल्यामुळे डेटाबेस खर्च कमी            |
| 🔗 Seamless       | Lambda ते RDS प्रवाह मध्ये सुधारणा                          |

---

## 📎 निष्कर्ष

RDS Proxy वापरल्यामुळे serverless applications साठी डेटाबेस access अधिक कार्यक्षम, सुरक्षित आणि स्केलेबल बनतो. हे setup मोठ्या concurrency असलेल्या Lambda functions साठी आदर्श आहे.

---

येथे **"RDS Proxy वापरून Lambda कडून MySQL डेटाबेस कनेक्ट करण्याचे Architecture – Structural Format"** मराठीत सादर केले आहे. हे डॉक्युमेंट कोडविना आहे, आणि शुद्ध आर्किटेक्चरल स्वरूपात, प्रत्येक घटक स्पष्ट करण्यात आला आहे:

---

# 📐 Architecture – Structural Format

**Use Case**: AWS Lambda → RDS Proxy → MySQL (Aurora RDS)
**Technology Stack**: Lambda (Node.js/Python), RDS Proxy, Aurora MySQL, IAM, Secrets Manager, VPC

---

## 🧱 1. Layers Overview (थरांची रचना)

```
User / Trigger
   ↓
Lambda Function
   ↓
IAM Auth + RDS Proxy
   ↓
Connection Pooling + Secrets
   ↓
Amazon Aurora RDS (MySQL)
```

---

## 🧾 2. घटकानुसार आर्किटेक्चर

### 1️⃣ **Application Layer (अ‍ॅप्लिकेशन स्तर)**

| घटक                 | विवरण                                                |
| ------------------- | ---------------------------------------------------- |
| **Lambda Function** | Serverless function जी डेटाबेस access करते           |
| **Trigger Source**  | API Gateway / S3 / EventBridge / CloudWatch (अनुसार) |
| **Language**        | Python / Node.js                                     |
| **DB Host**         | RDS Proxy endpoint                                   |

---

### 2️⃣ **Middleware Layer – RDS Proxy**

| घटक                   | विवरण                                   |
| --------------------- | --------------------------------------- |
| **RDS Proxy**         | कनेक्शन pooling, secrets handling       |
| **Connection Target** | Aurora RDS Instance                     |
| **Endpoint**          | Lambda function ला दिला जाणारा endpoint |
| **Auth**              | IAM Auth enabled                        |
| **SSL**               | In-transit encryption supported         |

---

### 3️⃣ **Database Layer – RDS**

| घटक                    | विवरण                                 |
| ---------------------- | ------------------------------------- |
| **Aurora MySQL**       | Target database instance              |
| **Subnet Group**       | 2+ private subnets मध्ये              |
| **Security Group**     | Proxy व Lambda ला TCP 3306 अलाउ       |
| **IAM Authentication** | Enabled                               |
| **Database Users**     | IAM Auth आधारित, password-less        |
| **Backup/Restore**     | Enable with snapshot or DMS supported |

---

### 4️⃣ **Networking Layer – VPC + Security**

| घटक                 | विवरण                                            |
| ------------------- | ------------------------------------------------ |
| **VPC**             | Lambda, RDS Proxy, आणि RDS सर्वजण एकाच VPC मध्ये |
| **Subnets**         | RDS आणि Proxy साठी private subnets               |
| **Security Groups** |                                                  |

* Lambda → Proxy: TCP 3306
* Proxy → RDS: TCP 3306 |
  \| **NAT Gateway** | आवश्यक असल्यास इंटरनेटसाठी |
  \| **Route Tables** | Internal communication सक्षम |

---

### 5️⃣ **IAM & Secrets Management Layer**

| घटक                   | विवरण |
| --------------------- | ----- |
| **IAM Role – Lambda** |       |

* `rds-db:connect` (RDS Proxy साठी)
* `secretsmanager:GetSecretValue` (Credentials साठी) |
  \| **IAM Role – Proxy** |
* RDS DB Secrets ला access देणारी policy |
  \| **Secrets Manager** |
* DB username/password साठवलेले |
  \| **SSM Parameters (Optional)** |
* DB Endpoint/Config साठवण्यासाठी |

---

### 6️⃣ **Authentication Flow (IAM Auth)**

1. Lambda IAM Role → `rds-db:connect` वापरून Auth Token मिळवते.
2. हा Auth Token 15 मिनिटांसाठी वैध असतो.
3. Lambda हा Token वापरून Proxy ला कनेक्ट होते.
4. Proxy → Secrets Manager मधून DB credentials fetch करते.
5. Connection established via Proxy → RDS.

---

## 🔁 Flow Diagram (Flow Description in Steps)

1. ✅ User triggers Lambda
2. ✅ Lambda generates IAM Auth token
3. ✅ Lambda connects to RDS Proxy using token + SSL
4. ✅ RDS Proxy verifies IAM permission
5. ✅ RDS Proxy fetches DB credentials from Secrets Manager
6. ✅ RDS Proxy connects to Aurora RDS using pooled connection
7. ✅ Query executed and response returned

---

## 📦 अतिरिक्त बाबी (Optional Integrations)

| Integration             | Purpose                      |
| ----------------------- | ---------------------------- |
| **CloudWatch Logs**     | Lambda execution trace       |
| **CloudTrail**          | IAM Activity auditing        |
| **X-Ray**               | End-to-end trace of latency  |
| **CDK**                 | Infrastructure as Code (IaC) |
| **SSM Session Manager** | EC2 access for testing       |

---

## 📌 निष्कर्ष

ही आर्किटेक्चर सध्या मोठ्या प्रमाणावर AWS मध्ये Serverless, Secure, आणि Highly Scalable database connection साठी वापरली जाते. Connection pooling आणि IAM authentication हे दोन्ही घटक सुरक्षितता आणि कार्यक्षमतेत भर घालतात.

---


खाली दिले आहे: **“Amazon RDS MySQL डेटाबेसचे स्टोरेज एनक्रिप्ट करणे”** याचे **मराठीत रूपांतर आणि आर्किटेक्चर स्ट्रक्चरल फॉरमॅट (Architecture – Structural Format)**.

---

# ✅ **2.4 - Existing Amazon RDS MySQL Database चे Storage Encryption (मराठीत)**

## 📌 समस्या (Problem)

तुमच्याकडे एक *unencrypted* RDS MySQL डेटाबेस आहे आणि तुम्हाला त्याचे **स्टोरेज encryption** करायचे आहे.

---

## 🎯 उपाय (Solution)

1. Existing DB ची **Read Replica** तयार करा
2. Replica वरून **unencrypted snapshot** घ्या
3. त्या snapshot ला **KMS Key वापरून encrypt** करा
4. **Encrypted snapshot** वरून **नवीन encrypted DB** restore करा

---

## 🧱 Architecture – Structural Format (आर्किटेक्चर संरचना)

### 1️⃣ **Preparation & Provisioning Layer**

* CDK वापरून पर्यावरणाची तयारी (`cdk deploy`)
* Python virtual environment सक्रिय करा
* `helper.py` वापरून variables export करा

---

### 2️⃣ **Key Management & Security Layer**

* **KMS Key तयार करा** (`aws kms create-key`)
* **Alias सेट करा** (`alias/awscookbook404`)
* याच Key ने encryption होईल

---

### 3️⃣ **Data Replication & Snapshot Layer**

* Existing DB ची **read-replica तयार करा**
* Replica वरून **unencrypted snapshot** घ्या
* त्या snapshot ला **encrypted snapshot** मध्ये कॉपी करा (KMS वापरून)

---

### 4️⃣ **Encrypted Restoration Layer**

* Encrypted snapshot वरून नवीन DB तयार करा (`awscookbook404db-enc`)
* नवीन DB ची **StorageEncrypted=True** आहे की नाही ते तपासा

---

### 5️⃣ **Networking & DNS Management Layer**

* **Route53 DNS Alias** वापरा downtime कमी करण्यासाठी
* App endpoint नवीन encrypted DB कडे पॉइंट करा

---

### 6️⃣ **Cleanup & Decommissioning Layer**

* **Replica, Snapshot, Encrypted DB delete करा**
* KMS Key disable करा व deletion schedule करा
* Alias delete करा (`alias/awscookbook404`)
* Environment variables unset करा
* `cdk destroy` वापरून सर्व resource cleanup करा

---

## 🌀 **Workflow Summary (कामाची एकूण झलक)**

| टप्पा | क्रिया                                                 |
| ----- | ------------------------------------------------------ |
| 1.    | Existing DB वाचण्यासाठी read-replica तयार केली         |
| 2.    | Replica वरून unencrypted snapshot घेतली                |
| 3.    | Snapshot KMS Key वापरून encrypt केली                   |
| 4.    | Encrypted snapshot वरून नवीन DB restore केली           |
| 5.    | DNS alias वापरून application traffic नवीन DB कडे हलवले |
| 6.    | Cleanup: जुनी replica, snapshots, आणि keys हटवले       |

---

## 🔐 **Security Discussion (सुरक्षा चर्चा)**

* **Encryption-at-rest** AWS Shared Responsibility Model चा भाग आहे
* Regulatory compliance पूर्ण करण्यासाठी encryption आवश्यक
* Encrypted snapshot दुसऱ्या region मध्ये कॉपी केली जाऊ शकते किंवा S3 मध्ये backup साठी वापरता येते

---

## 💡 निष्कर्ष

हे architecture तुम्हाला एक existing unencrypted RDS database **data loss किंवा downtime** शिवाय पूर्णपणे **encrypted** स्वरूपात migration करायला मदत करते. DNS aliasing, KMS, snapshot restoration ही सगळी यंत्रणा वापरून **secure आणि scalable** रचना तयार केली जाते.

---

खाली **“Amazon RDS MySQL Database Storage Encryption”** साठी **संपूर्ण आर्किटेक्चर स्ट्रक्चरल फॉरमॅट** (Architecture Structural Format – Section-wise Layered Breakdown in Marathi) दिला आहे.

---

# ✅ **2.4 - Existing Amazon RDS MySQL Database चे Storage Encryption – आर्किटेक्चर स्ट्रक्चरल फॉरमॅट**

---

## 🧩 **Architecture Structural Layers Overview**

```
Amazon RDS Encryption Architecture
├── 1. Preparation Layer
│   ├── AWS CDK Deployment
│   ├── Python Virtual Environment Setup
│   └── Environment Variables Export (helper.py)
│
├── 2. Security & Key Management Layer
│   ├── Create KMS Key
│   ├── Assign KMS Alias
│   └── Secure Storage Encryption Key ID
│
├── 3. Data Layer (Replication & Snapshot)
│   ├── Create Read Replica of Existing DB
│   ├── Take Unencrypted Snapshot
│   ├── Copy Snapshot to Encrypted Format (using KMS)
│   └── Validate Snapshot Availability
│
├── 4. Restoration Layer
│   ├── Restore Encrypted Snapshot to New Encrypted DB
│   ├── Verify Storage Encryption Enabled
│   └── Database Status Check
│
├── 5. Application Routing Layer
│   ├── Configure Route53 DNS Alias for New DB Endpoint
│   ├── Switch Application Endpoint to Encrypted DB
│   └── Ensure Minimal Downtime
│
├── 6. Cleanup Layer
│   ├── Delete Read Replica
│   ├── Delete Snapshots (Unencrypted & Encrypted)
│   ├── Disable & Schedule KMS Key for Deletion
│   ├── Delete Key Alias
│   └── Unset Environment Variables & CDK Destroy
```

---

## 📝 **मराठीत प्रत्येक स्तराचे स्पष्टीकरण:**

### 1️⃣ **Preparation Layer – पूर्वतयारी स्तर**

* **Python वर्चुअल एन्व्हायर्नमेंट** तयार करा (`.venv`)
* `cdk deploy` वापरून AWS infrastructure provision करा
* `helper.py` script वापरून आवश्यक environment variables तयार करा

---

### 2️⃣ **Security & Key Management Layer – सुरक्षा व की व्यवस्थापन**

* **KMS (Key Management Service)** वापरून encryption key तयार करा
* त्या key साठी **alias तयार करा** (उदा. `alias/awscookbook404`)
* Key ID सुरक्षित environment मध्ये साठवा

---

### 3️⃣ **Data Layer – डेटा स्तर (Replication व Snapshot)**

* Existing RDS database साठी **read replica** तयार करा
* Replica वरून **unencrypted snapshot** घ्या
* **KMS key वापरून त्या snapshot चे encrypted duplicate** तयार करा
* Snapshot उपलब्ध आहे का ते तपासा (`Status=available`)

---

### 4️⃣ **Restoration Layer – पुनर्संचयन स्तर**

* Encrypted snapshot वापरून **नवीन RDS DB तयार करा**
* Verify करा की DB मध्ये encryption enabled आहे (`StorageEncrypted=True`)
* Database उपलब्ध आहे का ते पाहा (`DBInstanceStatus=available`)

---

### 5️⃣ **Application Routing Layer – अनुप्रयोग रूटिंग स्तर**

* नवीन encrypted database साठी DNS **alias तयार करा**
* Application endpoint DNS रेकॉर्ड अपडेट करून **downtime शिवाय traffic shift करा**
* DNS pointing update करा (`Route53 Alias`)

---

### 6️⃣ **Cleanup Layer – स्वच्छता व संसाधन हटवण्याचा स्तर**

* जुनी **read replica** delete करा
* **unencrypted व encrypted snapshots** हटवा
* KMS Key disable करा व deletion schedule करा (7 दिवसांत delete होईल)
* Key alias delete करा
* Environment variables `unset` करा
* शेवटी `cdk destroy` करून सर्व AWS resource हटवा

---

## 🔄 **संपूर्ण कार्यप्रवाह एक नजरेत (Full Workflow)**

| स्टेप | प्रक्रिया                                | साधन                                           |
| ----- | ---------------------------------------- | ---------------------------------------------- |
| 1     | RDS Existing DB चे Replica तयार करणे     | `aws rds create-db-instance-read-replica`      |
| 2     | Snapshot घेणे                            | `aws rds create-db-snapshot`                   |
| 3     | Snapshot encrypt करणे                    | `aws rds copy-db-snapshot`                     |
| 4     | Encrypted DB तयार करणे                   | `aws rds restore-db-instance-from-db-snapshot` |
| 5     | DNS Routing & Application Migration      | `Route53`                                      |
| 6     | Cleanup (Delete replica, snapshots, key) | AWS CLI, CDK                                   |

---

## 🛡️ **Security Discussion – सुरक्षा विश्लेषण**

* KMS key वापरून storage encryption सुनिश्चित होते
* Snapshot वेगळ्या region मध्ये किंवा S3 मध्ये कॉपी करता येतो
* Encryption-at-rest हे regulatory compliance साठी आवश्यक आहे
* Route53 वापरल्याने Zero-downtime migration शक्य होते

---


खाली **"2.5 Automating Password Rotation for RDS Databases"** साठी मराठी भाषेत रूपांतरण आणि **Architecture – Structural Format** दिला आहे.

---

# ✅ **२.५ - RDS डेटाबेससाठी पासवर्ड रोटेशनचे ऑटोमेशन**

---

## 📌 समस्या (Problem)

तुम्हाला RDS डेटाबेस युजरसाठी **स्वयंचलित पासवर्ड रोटेशन** लागू करायचा आहे.

---

## 🎯 उपाय (Solution)

* एक पासवर्ड तयार करा आणि तो **AWS Secrets Manager** मध्ये स्टोअर करा.
* त्या Secret साठी **Rotation Interval (उदा. 30 दिवस)** सेट करा.
* **AWS प्रदान केलेले Lambda कोड** वापरून एक Lambda Function तयार करा.
* त्या Function ला Password Rotation करण्यासाठी configure करा.

---

## 🧱 **Architecture – Structural Format**

```
RDS Password Rotation Architecture
├── 1. Preparation Layer
│   ├── Python virtualenv तयार करा
│   ├── AWS CDK वापरून Resource Deploy करा
│   └── helper.py script वापरून Environment Variables export करा
│
├── 2. Password Management Layer
│   ├── Random Password Generate करा (RDS Compatible)
│   └── Master Password अपडेट करा (modify-db-instance)
│
├── 3. Secrets Configuration Layer
│   ├── Template JSON फाईल तयार करा (rdscreds.json)
│   ├── Secret Create करा (SecretsManager)
│   └── Rotation Interval सेट करा (30 दिवस)
│
├── 4. Lambda Automation Layer
│   ├── AWS Sample Lambda कोड डाउनलोड करा
│   ├── Zip करून Function तयार करा
│   ├── IAM Role तयार करा (Lambda Execution + SecretsManager Access)
│   ├── Lambda Function तयार करा (PyMySQL Layer सह)
│   └── Lambda ला SecretsManager Invoke Permission द्या
│
├── 5. Networking & Security Layer
│   ├── Lambda साठी Security Group तयार करा
│   ├── RDS Security Group मध्ये ingress rule जोडा
│   └── VPC Subnet ID आणि Security Group Configuration
│
├── 6. Validation Layer
│   ├── SSM Parameter Store मध्ये Endpoint व Password सेट करा
│   ├── EC2 instance वरून MySQL CLI द्वारे कनेक्ट होऊन तपासा
│   └── SELECT statement वापरून authentication validate करा
│
├── 7. Cleanup Layer
│   ├── Lambda, Secrets, IAM Roles, SSM Parameters delete करा
│   ├── Ingress rules revoke करा
│   └── CDK Destroy वापरून सर्व resource हटवा
```

---

## 🛠️ स्टेप्स थोडक्यात (Steps Summary)

| टप्पा | क्रिया                                               |
| ----- | ---------------------------------------------------- |
| 1     | CDK वापरून वातावरण तयार करा                          |
| 2     | Random Password Generate करा (`get-random-password`) |
| 3     | Master Password अपडेट करा (`modify-db-instance`)     |
| 4     | `rdscreds.json` तयार करा                             |
| 5     | AWS GitHub वरून Lambda कोड डाउनलोड करा               |
| 6     | IAM Role व Lambda तयार करा                           |
| 7     | Secret तयार करा व रोटेशन लावून Lambda जोडून द्या     |
| 8     | SSM parameters सेट करा                               |
| 9     | EC2 वरून कनेक्ट होऊन रोटेशन व काम पडताळा             |
| 10    | सर्व Resource Cleanup करा                            |

---

## 🔐 सुरक्षितता व धोरणे (Security & Best Practices)

* SecretsManagerReadWrite IAM policy वापरली, परंतु Production साठी ती **Scoped** असावी.
* Lambda Function साठी PyMySQL आवश्यक असल्यामुळे **Lambda Layer** वापरले.
* Password रोटेशन साठी **SecretsManager → Lambda → RDS** हे त्रिकोण वापरण्यात आले.
* Secure Configuration साठी SSM Parameter Store वापरले.
* DNS वापर न करता direct hostname वापरले (उदा. DB Connectivity).

---

## 🔄 पासवर्ड रोटेशनची प्रक्रिया (Password Rotation Flow)

```
Rotation Flow
1. Generate New Password → 2. Store in Secret → 3. Lambda Rotates in DB →
4. Validate using EC2/MySQL CLI
```

---

## ✅ फायनल टिप्पण्या (Final Discussion – मराठीत):

* हे संपूर्ण Automation स्क्रिप्ट्स, Lambda कोड, आणि AWS Services चा योग्य वापर करून तयार केलेले आहे.
* हे मॉडेल non-admin युजरसाठीही वापरले जाऊ शकते.
* Application ला SecretsManager मधून Secrets retrieve करण्यासाठी configure करता येते.
* Production मध्ये वापरताना IAM Policies कडेकोट असाव्यात.

---


खाली **“2.6 – Auto Scaling DynamoDB Table Provisioned Capacity”** चं मराठी रूपांतरण आणि त्याचं **Architecture – Structural Format** सुसंगत पद्धतीनं दिलं आहे:

---

# ✅ **२.६ – DynamoDB साठी Provisioned Capacity चे Auto Scaling**

---

## 📌 समस्या (Problem)

तुमच्याकडे एक **DynamoDB टेबल आहे ज्यामध्ये कमी Provisioned Throughput आहे**, आणि तुमच्या Application साठी **अधिक क्षमता** लागते.

---

## 🎯 उपाय (Solution)

* DynamoDB टेबलसाठी **Read व Write Capacity Auto Scaling** सेट करा.
* Scaling Target आणि Scaling Policy सेट करून **AWS Application Auto Scaling** वापरा.

---

## 🧱 **Architecture – Structural Format**

```
DynamoDB Auto Scaling Architecture
├── 1. Preparation Layer
│   ├── DynamoDB टेबल तयार करा (Provisioned Mode)
│   └── प्रारंभीक डेटा insert करा
│
├── 2. Scaling Target Configuration Layer
│   ├── Read Capacity Scaling Target सेट करा
│   └── Write Capacity Scaling Target सेट करा
│
├── 3. Scaling Policy Layer
│   ├── Read Scaling Policy JSON तयार करा
│   ├── Write Scaling Policy JSON तयार करा
│   └── दोन्ही Policy लागू करा (put-scaling-policy)
│
├── 4. Monitoring Layer
│   └── DynamoDB Console मध्ये Scaling Parameters तपासा
│
├── 5. Cleanup Layer
│   └── Table delete करा
```

---

## 📝 **प्रक्रिया तपशीलवार (Detailed Steps in Marathi)**

### 1️⃣ **तयारी (Preparation)**

* Provisioned capacity: 1 Read आणि 1 Write Capacity Unit

```sh
aws dynamodb create-table \
--table-name 'AWSCookbook406' \
--attribute-definitions 'AttributeName=UserID,AttributeType=S' \
--key-schema 'AttributeName=UserID,KeyType=HASH' \
--sse-specification 'Enabled=true,SSEType=KMS' \
--provisioned-throughput 'ReadCapacityUnits=1,WriteCapacityUnits=1'
```

* काही sample records insert करा:

```sh
aws ddb put AWSCookbook406 '[{UserID: value1}, {UserID: value2}]'
```

---

### 2️⃣ **Scaling Target Set करणे**

* Read Capacity Auto Scaling target:

```sh
aws application-autoscaling register-scalable-target \
--service-namespace dynamodb \
--resource-id "table/AWSCookbook406" \
--scalable-dimension "dynamodb:table:ReadCapacityUnits" \
--min-capacity 5 \
--max-capacity 10
```

* Write Capacity Auto Scaling target:

```sh
aws application-autoscaling register-scalable-target \
--service-namespace dynamodb \
--resource-id "table/AWSCookbook406" \
--scalable-dimension "dynamodb:table:WriteCapacityUnits" \
--min-capacity 5 \
--max-capacity 10
```

---

### 3️⃣ **Scaling Policy तयार करणे आणि लागू करणे**

#### 🟢 Read Scaling Policy (read-policy.json)

```json
{
  "PredefinedMetricSpecification": {
    "PredefinedMetricType": "DynamoDBReadCapacityUtilization"
  },
  "ScaleOutCooldown": 60,
  "ScaleInCooldown": 60,
  "TargetValue": 50.0
}
```

#### 🟣 Write Scaling Policy (write-policy.json)

```json
{
  "PredefinedMetricSpecification": {
    "PredefinedMetricType": "DynamoDBWriteCapacityUtilization"
  },
  "ScaleOutCooldown": 60,
  "ScaleInCooldown": 60,
  "TargetValue": 50.0
}
```

#### ➕ Apply Read Policy:

```sh
aws application-autoscaling put-scaling-policy \
--service-namespace dynamodb \
--resource-id "table/AWSCookbook406" \
--scalable-dimension "dynamodb:table:ReadCapacityUnits" \
--policy-name "AWSCookbookReadScaling" \
--policy-type "TargetTrackingScaling" \
--target-tracking-scaling-policy-configuration file://read-policy.json
```

#### ➕ Apply Write Policy:

```sh
aws application-autoscaling put-scaling-policy \
--service-namespace dynamodb \
--resource-id "table/AWSCookbook406" \
--scalable-dimension "dynamodb:table:WriteCapacityUnits" \
--policy-name "AWSCookbookWriteScaling" \
--policy-type "TargetTrackingScaling" \
--target-tracking-scaling-policy-configuration file://write-policy.json
```

---

### 4️⃣ **Auto Scaling तपासणी (Monitoring Layer)**

* AWS Console → DynamoDB → Table → Additional Settings → Auto Scaling तपासा.
* CLI वापरून तपासणी:

```sh
aws application-autoscaling describe-scalable-targets \
--service-namespace dynamodb \
--resource-id "table/AWSCookbook406"
```

---

### 5️⃣ **Cleanup (संपूर्ण साफसफाई)**

* Table delete करा:

```sh
aws dynamodb delete-table --table-name 'AWSCookbook406'
```

---

## 🧠 चर्चा (Discussion)

* Provisioned capacity मध्ये Throughput manually ठरवला जातो.
* Auto Scaling वापरल्याने आपण **min आणि max सीमा** सेट करून AWS ला flexible scaling करण्याची परवानगी देतो.
* Application लोड जास्त असताना scaling होते आणि inactivity असल्यास scaling कमी होते.
* On-Demand mode पेक्षा Provisioned + Auto Scaling स्वस्त पडू शकतो जर usage predictable असेल.

---

## 🔍 सल्ला (Recommendation)

* जर **तुमचं workload बदलत असतं, परंतु predictable आहे**, तर Provisioned Capacity + Auto Scaling योग्य आहे.
* जर **अनपेक्षित spikes** असतील तर On-Demand mode विचारात घ्या.

---


खाली **"Amazon RDS वर डेटाबेस माइग्रेशन Amazon DMS वापरून (2.7)"** याचे पूर्ण मराठी अनुवाद **व आर्किटेक्चर स्ट्रक्चरल फॉरमॅट** दिले आहे. कोणतेही कोड किंवा इमेज यामध्ये समाविष्ट केलेले नाहीत – केवळ सुसंगत **मार्गदर्शक, रचना आणि स्पष्टीकरण** दिले आहे.

---

## 🧭 **२.७ – Amazon DMS वापरून डेटाबेस Amazon RDS मध्ये माइग्रेट करणे**

---

### 📌 समस्या (Problem):

तुम्हाला **एक डेटाबेस दुसऱ्या डेटाबेसमध्ये माइग्रेट** करायचा आहे (उदा. ऑन-प्रिमायस DB → Amazon RDS).

---

### ✅ उपाय (Solution):

* **DMS साठी नेटवर्क, सुरक्षा गट व IAM परवानग्या तयार** करा.
* **Source व Target साठी DMS Endpoints** तयार करा.
* **Replication Task** कॉन्फिगर करा व सुरू करा.
* डेटा माइग्रेट झाल्यावर **साफसफाई व हटवण्याचे टप्पे** पूर्ण करा.

---

## 🏗️ **Architecture – Structural Format (रचना)**

```
Amazon DMS Based Database Migration Architecture
├── 1. Preparation Layer
│   ├── CDK वापरून AWS संसाधने तयार करा
│   ├── Lambda वापरून sample data seed करा
│   └── environment variables export करा
│
├── 2. Networking Layer
│   ├── VPC, Subnets आणि Security Groups तयार करा
│   └── DMS साठी सुरक्षा गट Source व Target RDS ला जोडले
│
├── 3. IAM & Access Layer
│   ├── IAM Role तयार करा (dms-vpc-role)
│   └── DMSVPCManagementRole policy संलग्न करा
│
├── 4. DMS Infrastructure Layer
│   ├── Replication Subnet Group तयार करा
│   ├── Replication Instance तयार करा
│   └── Status “available” होईपर्यंत प्रतीक्षा करा
│
├── 5. Secrets Management Layer
│   ├── SecretsManager मधून Source व Target चे पासवर्ड retrieve करा
│   └── Environment Variables मध्ये सेव्ह करा
│
├── 6. Endpoint Configuration Layer
│   ├── Source Endpoint तयार करा (MySQL DB – source)
│   └── Target Endpoint तयार करा (MySQL DB – destination)
│
├── 7. Replication Task Layer
│   ├── Table Mapping JSON वापरून Replication Task तयार करा
│   └── Status “ready” येईपर्यंत प्रतीक्षा करा
│
├── 8. Task Execution Layer
│   ├── Replication Task सुरू करा (full-load migration)
│   └── Migration Status तपासा (describe-replication-tasks)
│
├── 9. Post-Migration Verification
│   ├── DMS Console मधून किंवा CLI वापरून Data Validate करा
│   └── Task Stats तपासून पूर्णता पुष्टी करा
│
├── 10. Cleanup Layer
│   ├── Replication Task व Instance delete करा
│   ├── Security Group आणि Endpoints delete करा
│   ├── IAM Role आणि Policy detach/delete करा
│   └── Subnet Group, Variables व CDK destroy करा
```

---

## 📋 **मुख्य टप्पे (Key Steps in Marathi)**

### 1️⃣ **पूर्वतयारी (Preparation)**

* AWS CDK वापरून आवश्यक VPC, Subnet, DB तयार करा.
* `helper.py` स्क्रिप्ट वापरून environment variables सेट करा.
* Lambda वापरून sample टेबल seed करा.

### 2️⃣ **नेटवर्किंग व परवानग्या (Networking & Permissions)**

* DMS साठी नवीन Security Group तयार करा.
* Source आणि Target DB साठी ingress rules जोडा (port 3306).
* IAM Role (dms-vpc-role) तयार करा आणि policy संलग्न करा.

### 3️⃣ **Replication Setup (DMS Core Infrastructure)**

* Replication Subnet Group तयार करा.
* Replication Instance तयार करा आणि उपलब्ध होईपर्यंत प्रतीक्षा करा.

### 4️⃣ **सीक्रेट्स व एंडपॉइंट्स (Secrets & Endpoints)**

* Secrets Manager मधून Source आणि Target चा पासवर्ड मिळवा.
* DMS Source आणि Target Endpoint तयार करा.

### 5️⃣ **Replication Task तयार करणे व चालवणे**

* Table mapping वापरून Replication Task तयार करा.
* Task चालू करा (migration सुरू होतो).
* Status तपासण्यासाठी describe-replication-tasks वापरा.

### 6️⃣ **डाटा सत्यापन व तपासणी (Validation)**

* Migration नंतर DMS Console मधून टेबल तपासा.
* CLI वापरून replication status आणि stats तपासा.

### 7️⃣ **साफसफाई (Cleanup Layer)**

* Replication Task आणि Instance delete करा.
* Security Groups व Endpoints काढा.
* IAM Role व Policies हटवा.
* Subnet Group व CDK संसाधने destroy करा.

---

## 💡 चर्चात्मक मुद्दे (Discussion in Marathi)

* तुम्ही Amazon DMS वापरून पूर्णपणे **full-load migration** पूर्ण केली.
* तुमच्या Source आणि Target database मध्ये differences असल्यास, DMS मध्ये transformation configuration वापरता येते.
* जर तुम्हाला **low-downtime migration** हवी असेल तर full-load-and-cdc (change data capture) वापरून सतत डेटा sync करता येतो.
* Connectivity validation DMS console किंवा CLI द्वारे करता येतो.
* जर Source PostgreSQL आणि Target MySQL सारखी mismatched DB असतील, तर AWS Schema Conversion Tool वापरून mapping generate करता येते.

---

## 📌 अतिरिक्त टिप्स

* Endpoints तयार केल्यावर connectivity टेस्ट करणं गरजेचं आहे.
* Task सुरू करण्याआधी table-mappings.json योग्यरित्या सानुकूलित असावी.
* रिअल टाइम डेटा साठी CDC (Change Data Capture) ऑप्शन विचारात घ्या.
* सर्व resources नंतर हटवणे विसरू नका – हे अनावश्यक खर्च व सुरक्षा धोके टाळते.

---

खाली **"2.8 – Aurora Serverless साठी Web Services द्वारे Data API सक्षम करणे"** याचा **संपूर्ण मराठी अनुवाद** आणि **शिस्तबद्ध आर्किटेक्चर संरचना** दिली आहे – कोणताही कोड नाही, केवळ स्पष्टीकरण, प्रक्रिया आणि रचना.

---

## 🧩 **२.८ – Aurora Serverless साठी Data API सक्रिय करणे (Web Services साठी)**

---

### 🎯 समस्या (Problem)

तुमच्याकडे एक **PostgreSQL database** आहे आणि तुम्हाला **application कडून persistent connections व्यवस्थापित न करता** ते वापरायचे आहे.

---

### ✅ उपाय (Solution)

* **Aurora Serverless Cluster** साठी **Data API सक्षम** करा.
* **IAM भूमिका व परवानग्या** सेट करा.
* **CLI व RDS Console** वापरून API कनेक्शन तपासा.

---

## 🏗️ **Architecture – संरचना रचना (Structural Format)**

```
Aurora Serverless with Data API for Web Services
├── 1. Preparation Layer
│   ├── AWS CDK वापरून वातावरण तयार करा
│   └── helper.py वापरून environment variables सेट करा
│
├── 2. Database Layer
│   ├── Aurora Serverless Cluster तयार करा
│   └── Data API सक्षम करा (Enable HTTP Endpoint)
│
├── 3. IAM आणि Security Layer
│   ├── EC2 साठी IAM भूमिका तयार करा
│   ├── policy-template वापरून IAM Policy बनवा
│   └── EC2 Role वर Policy जोडणे
│
├── 4. Parameter Store Layer
│   ├── SecretsArn, ClusterArn, DatabaseName हे parameters SSM मध्ये सेव्ह करा
│   └── EC2 instance मधून हे parameters retrieve करा
│
├── 5. Testing Layer
│   ├── CLI वापरून Aurora वर SQL क्वेरी चालवा (rds-data)
│   └── AWS Console मधील RDS Query Editor वापरून क्वेरी तपासा
│
├── 6. Cleanup Layer
│   ├── SSM Parameters delete करा
│   ├── IAM Policy detach व delete करा
│   ├── CDK वापरून resource destroy करा
│   └── Python virtual environment बंद करा
```

---

## 📋 **टप्पा-टप्प्याने मराठीत प्रक्रिया (Steps in Marathi)**

### 1️⃣ **पूर्वतयारी (Preparation)**

* CDK प्रोजेक्ट चालवा आणि `cdk deploy` करून संसाधने तयार करा.
* `helper.py` वापरून variables (`SecretArn`, `ClusterArn`, `DatabaseName`) सेट करा.

---

### 2️⃣ **Aurora Serverless साठी Data API सक्षम करणे**

* `enable-http-endpoint` वापरून Aurora Serverless Cluster वर Data API चालू करा.
* `describe-db-clusters` वापरून `HttpEndpointEnabled` सत्यापित करा.

---

### 3️⃣ **CLI आणि RDS Console मधून क्वेरी चालवणे**

* `aws rds-data execute-statement` वापरून SQL क्वेरी CLI मधून चालवा.
* AWS Console → RDS → Query Editor मध्ये लॉगिन करून `pg_user` वर SELECT क्वेरी चालवा.

---

### 4️⃣ **IAM भूमिका व परवानग्या सेट करणे (EC2 साठी)**

* `policy-template.json` मध्ये IAM अधिकार लिहा.
* `sed` वापरून `SecretArn` replace करून `policy.json` तयार करा.
* ही Policy IAM मध्ये तयार करा आणि EC2 Role वर जोडावी.

---

### 5️⃣ **SSM Parameter Store वापरून सेटिंग्ज स्टोअर करणे**

* `Cookbook408DatabaseName`, `Cookbook408ClusterArn`, `Cookbook408SecretArn` हे parameters SSM मध्ये सेव्ह करा.
* EC2 instance SSM agent ने register झाला आहे का ते तपासा (`describe-instance-information` वापरून).
* SSM Session वापरून EC2 मध्ये प्रवेश करा आणि parameters retrieve करा.

---

### 6️⃣ **EC2 Instance मधून Database वर क्वेरी चालवणे**

* CLI मधून `rds-data execute-statement` वापरून SQL क्वेरी execute करा.
* Region सेट करा (`export AWS_DEFAULT_REGION=us-east-1`).

---

### 7️⃣ **साफसफाई (Cleanup)**

* `aws ssm delete-parameter` वापरून parameters delete करा.
* IAM Policy detach आणि delete करा.
* Python virtual environment बंद करा (`deactivate`) आणि CDK resources destroy करा (`cdk destroy`).

---

## 💬 **चर्चा (Discussion in Marathi)**

* तुम्ही **Aurora Serverless Cluster साठी Data API सक्षम** केले.
* ही API तुम्हाला **HTTPS वरून SQL क्वेरी चालवू देते**, ज्यामुळे traditional DB connections आवश्यक राहत नाहीत.
* IAM authentication वापरून access नियंत्रित केला जातो.
* Data API चे सर्व कॉल्स synchronous असतात आणि **45 सेकंद timeout** आहे.
* हे सर्व कॉल्स **CloudTrail मध्ये लॉग होतात**, जे सुरक्षितता व ऑडिटिंग साठी उपयुक्त ठरते.
* Developer किंवा DBA लोकांसाठी **RDS Query Editor** वेब-आधारित environment देते.

---

## 💡 **महत्त्वाच्या टीपा (Tips)**

* Web Services किंवा Serverless environment साठी ही API **खूप उपयुक्त** ठरते.
* तुमच्या EC2, Lambda किंवा अन्य compute सेवा साठी **IAM आधारित policy सुस्पष्ट असावी**.
* तुम्ही Data API ला फक्त वाचण्याचा access देखील देऊ शकता (read-only access).

---

