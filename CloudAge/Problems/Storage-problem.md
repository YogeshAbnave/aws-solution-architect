# AWS Database Solutions: Complete Step-by-Step Guide

## Scenario 1: Creating Amazon Aurora Serverless PostgreSQL Database

**Problem:** Web application requires storage in a relational database with unpredictable requests, needing a solution that scales with usage and is cost-effective, compatible with PostgreSQL.

**Solution Steps:**

### Step 1: Generate Complex Password using Secrets Manager
1. Navigate to **AWS Secrets Manager Console** → **Store a new secret**
2. Select **Other type of secrets**
3. Configure:
   - **Key:** `password`
   - **Value:** Click **Generate random password**
   - **Password length:** 32 characters
   - **Exclude characters:** `!"#$%&'()*+,-./:;<=>?@[\]^_`{|}~` (punctuation)
4. **Secret name:** `awscookbook401/dbpassword`
5. **Description:** Password for Aurora Serverless cluster
6. **Create secret**

### Step 2: Create VPC Subnet Group
1. Navigate to **RDS Console** → **Subnet groups** → **Create DB subnet group**
2. Configure:
   - **Name:** `awscookbook401-subnet-group`
   - **Description:** Subnet group for Aurora Serverless
   - **VPC:** Select your VPC
   - **Availability Zones:** Select at least 2 AZs
   - **Subnets:** Select private subnets from each AZ
3. **Create**

### Step 3: Create VPC Security Group
1. Navigate to **EC2 Console** → **Security Groups** → **Create security group**
2. Configure:
   - **Name:** `awscookbook401-db-sg`
   - **Description:** Security group for Aurora Serverless
   - **VPC:** Select your VPC
   - **Inbound rules:** (Will configure later)
   - **Outbound rules:** Default (All traffic)
3. **Create security group**

### Step 4: Create Aurora Serverless Cluster
1. Navigate to **RDS Console** → **Databases** → **Create database**
2. **Database creation method:** Standard create
3. **Engine options:**
   - **Engine type:** Amazon Aurora
   - **Edition:** Amazon Aurora PostgreSQL-Compatible Edition
   - **Capacity type:** Serverless
   - **Engine version:** 10.7 or later
4. **Settings:**
   - **DB cluster identifier:** `awscookbook401dbcluster`
   - **Master username:** `admin`
   - **Master password:** Manage with AWS Secrets Manager
   - **Secrets Manager secret:** Select the secret created earlier
5. **Capacity settings:**
   - **Scaling configuration:** Aurora Serverless v1
   - **Minimum Aurora capacity unit:** 2 ACUs
   - **Maximum Aurora capacity unit:** 16 ACUs
   - **Pause compute capacity after consecutive minutes of inactivity:** 5 minutes
6. **Connectivity:**
   - **VPC:** Select your VPC
   - **DB subnet group:** Select created subnet group
   - **VPC security groups:** Select created security group
7. **Additional configuration:**
   - **Initial database name:** `cookbook`
8. **Create database**

### Step 5: Wait for Database Availability
Monitor the database status in RDS Console until it shows "Available"

### Step 6: Configure Auto-scaling (Optional for v1)
For Aurora Serverless v2:
1. Select the cluster → **Actions** → **Modify**
2. **Capacity settings:**
   - **Minimum capacity:** 0.5 ACUs
   - **Maximum capacity:** 16 ACUs
3. **Apply changes**

### Step 7: Configure EC2 Security Group Access
1. Navigate to **EC2 Console** → **Security Groups**
2. Select your EC2 instance's security group
3. **Outbound rules** → **Edit outbound rules**
4. **Add rule:**
   - **Type:** PostgreSQL
   - **Protocol:** TCP
   - **Port:** 5432
   - **Destination:** Custom → Select database security group
5. **Save rules**

### Step 8: Update Database Security Group
1. Select the database security group (`awscookbook401-db-sg`)
2. **Inbound rules** → **Edit inbound rules**
3. **Add rule:**
   - **Type:** PostgreSQL
   - **Protocol:** TCP
   - **Port:** 5432
   - **Source:** Custom → Select EC2 security group
4. **Save rules**

### Step 9: Get RDS Cluster Endpoint
1. Navigate to **RDS Console** → **Databases**
2. Select your cluster → **Connectivity & security** tab
3. Copy the **Endpoint** (Writer endpoint)

### Step 10: Retrieve Password and Connect
1. Connect to EC2 instance using Systems Manager Session Manager
2. Install PostgreSQL client:
```bash
sudo yum update -y
sudo yum install postgresql -y
```

3. Retrieve password from Secrets Manager:
```bash
aws secretsmanager get-secret-value --secret-id awscookbook401/dbpassword --query SecretString --output text
```

4. Connect to database:
```bash
psql -h your-cluster-endpoint.cluster-xyz.region.rds.amazonaws.com -U admin -d cookbook
# Enter password when prompted
```

### Step 11: Verify Scaling
1. Run some queries to generate activity
2. Check **RDS Console** → **Monitoring** tab to see capacity scaling
3. After 5 minutes of inactivity, capacity should scale to 0

### CLI Commands:
```bash
# Create secret
aws secretsmanager create-secret --name "awscookbook401/dbpassword" --generate-random-password '{"PasswordLength":32,"ExcludeCharacters":"!\"#$%&'\''()*+,-./:;<=>?@[\\]^_`{|}~"}'

# Create subnet group
aws rds create-db-subnet-group --db-subnet-group-name awscookbook401-subnet-group --db-subnet-group-description "Subnet group for Aurora Serverless" --subnet-ids subnet-12345678 subnet-87654321

# Create Aurora Serverless cluster
aws rds create-db-cluster --db-cluster-identifier awscookbook401dbcluster --engine aurora-postgresql --engine-mode serverless --master-username admin --manage-master-user-password --vpc-security-group-ids sg-12345678 --db-subnet-group-name awscookbook401-subnet-group --scaling-configuration MinCapacity=2,MaxCapacity=16,SecondsUntilAutoPause=300,AutoPause=true --database-name cookbook

# Wait for availability
aws rds wait db-cluster-available --db-cluster-identifier awscookbook401dbcluster

# Get cluster endpoint
aws rds describe-db-clusters --db-cluster-identifier awscookbook401dbcluster --query 'DBClusters[0].Endpoint' --output text
```

---

## Scenario 2: Using IAM Authentication with RDS Database

**Problem:** Server connecting to database needs to use IAM authentication instead of rotating temporary credentials.

**Solution Steps:**

### Step 1: Enable IAM Authentication on RDS Instance
1. Navigate to **RDS Console** → **Databases**
2. Select your RDS instance → **Modify**
3. **Database authentication:**
   - **Database authentication:** Password and IAM database authentication
4. **Continue** → **Apply immediately** → **Modify DB instance**

### Step 2: Get RDS Resource ID
1. Select your RDS instance
2. **Configuration** tab → Copy **Resource ID**

### Step 3: Create IAM Policy for RDS Connect
1. Create `policy-template.json`:
```json
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "rds-db:connect"
            ],
            "Resource": [
                "arn:aws:rds-db:REGION:ACCOUNT_ID:dbuser:RESOURCE_ID/iamuser"
            ]
        }
    ]
}
```

2. Replace variables:
```bash
sed -i 's/REGION/us-east-1/g' policy-template.json
sed -i 's/ACCOUNT_ID/123456789012/g' policy-template.json
sed -i 's/RESOURCE_ID/db-ABCDEFGHIJKLMNOPQRSTUVWXYZ/g' policy-template.json
```

3. Create IAM policy:
```bash
aws iam create-policy --policy-name AWSCookbook402EC2RDSPolicy --policy-document file://policy-template.json
```

### Step 4: Attach Policy to EC2 Instance Role
1. Get EC2 instance role name:
```bash
aws sts get-caller-identity
ROLE_NAME=$(aws iam list-roles --query 'Roles[?contains(RoleName, `EC2`)].RoleName' --output text)
```

2. Attach policy:
```bash
aws iam attach-role-policy --role-name $ROLE_NAME --policy-arn arn:aws:iam::ACCOUNT_ID:policy/AWSCookbook402EC2RDSPolicy
```

### Step 5: Connect to RDS and Create IAM User
1. Connect to EC2 instance via Systems Manager
2. Install MySQL client:
```bash
sudo yum install mysql -y
```

3. Get RDS admin password:
```bash
aws secretsmanager get-secret-value --secret-id rds-admin-password --query SecretString --output text
```

4. Get RDS endpoint:
```bash
aws rds describe-db-instances --db-instance-identifier your-db-instance --query 'DBInstances[0].Endpoint.Address' --output text
```

5. Connect to database:
```bash
mysql -h your-rds-endpoint.region.rds.amazonaws.com -u admin -p
```

6. Create IAM database user:
```sql
CREATE USER 'iamuser'@'%' IDENTIFIED WITH AWSAuthenticationPlugin AS 'RDS';
GRANT SELECT, INSERT, UPDATE, DELETE ON *.* TO 'iamuser'@'%';
FLUSH PRIVILEGES;
EXIT;
```

### Step 6: Download RDS CA Certificate
```bash
wget https://rds-downloads.s3.amazonaws.com/rds-ca-2019-root.pem
```

### Step 7: Generate IAM Authentication Token
```bash
export AWS_DEFAULT_REGION=us-east-1
export RDS_ENDPOINT="your-rds-endpoint.region.rds.amazonaws.com"

TOKEN=$(aws rds generate-db-auth-token --hostname $RDS_ENDPOINT --port 3306 --region $AWS_DEFAULT_REGION --username iamuser)
```

### Step 8: Connect Using IAM Authentication
```bash
mysql -h $RDS_ENDPOINT -P 3306 --ssl-ca=rds-ca-2019-root.pem --ssl-mode=VERIFY_IDENTITY -u iamuser -p$TOKEN
```

### Step 9: Validate Connection
```sql
SELECT CURRENT_USER();
SELECT NOW();
```

### CLI Alternative Commands:
```bash
# Enable IAM authentication
aws rds modify-db-instance --db-instance-identifier your-db-instance --enable-iam-database-authentication

# Get resource ID
aws rds describe-db-instances --db-instance-identifier your-db-instance --query 'DBInstances[0].DbiResourceId' --output text

# Generate auth token
aws rds generate-db-auth-token --hostname your-endpoint.rds.amazonaws.com --port 3306 --region us-east-1 --username iamuser
```

---

## Scenario 3: Leveraging RDS Proxy for Database Connections from Lambda

**Problem:** Serverless function (Lambda) needs to access relational database with connection pooling to minimize connections and improve performance.

**Solution Steps:**

### Step 1: Create IAM Role for RDS Proxy
1. Create `assume-role-policy.json`:
```json
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Principal": {
                "Service": "rds.amazonaws.com"
            },
            "Action": "sts:AssumeRole"
        }
    ]
}
```

2. Create IAM role:
```bash
aws iam create-role --role-name AWSCookbook403RDSProxy --assume-role-policy-document file://assume-role-policy.json
```

### Step 2: Create Security Group for Lambda
```bash
aws ec2 create-security-group --group-name lambda-sg --description "Security group for Lambda function" --vpc-id vpc-12345678
```

### Step 3: Create RDS Proxy
1. Navigate to **RDS Console** → **Proxies** → **Create proxy**
2. **Proxy configuration:**
   - **Proxy identifier:** `awscookbook403rdsproxy`
   - **Engine compatibility:** MySQL
   - **Require TLS:** Yes
3. **Target group configuration:**
   - **Database:** Select your RDS instance
   - **Connection pool maximum connections:** 100%
4. **Connectivity:**
   - **Subnets:** Select private subnets
   - **VPC security groups:** Create new or select existing
5. **Authentication:**
   - **Secrets Manager secrets:** Select RDS admin secret
   - **IAM role:** Select the role created above
   - **IAM authentication:** Required for IAM auth
6. **Create proxy**

### Step 4: Get RDS Proxy Endpoint
```bash
aws rds describe-db-proxies --db-proxy-name awscookbook403rdsproxy --query 'DBProxies[0].Endpoint' --output text
```

### Step 5: Create IAM Policy for Lambda
1. Create `lambda-policy-template.json`:
```json
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "rds-db:connect"
            ],
            "Resource": [
                "arn:aws:rds-db:REGION:ACCOUNT_ID:dbuser:PROXY_RESOURCE_ID/*"
            ]
        }
    ]
}
```

2. Get proxy resource ID:
```bash
aws rds describe-db-proxies --db-proxy-name awscookbook403rdsproxy --query 'DBProxies[0].DBProxyArn' --output text
```

3. Replace variables and create policy:
```bash
sed -i 's/REGION/us-east-1/g' lambda-policy-template.json
sed -i 's/ACCOUNT_ID/123456789012/g' lambda-policy-template.json
sed -i 's/PROXY_RESOURCE_ID/prx-12345678/g' lambda-policy-template.json

aws iam create-policy --policy-name AWSCookbook403IamPolicy --policy-document file://lambda-policy-template.json
```

### Step 6: Attach Policies to Lambda Role
```bash
# Get Lambda execution role
LAMBDA_ROLE=$(aws lambda get-function --function-name your-lambda-function --query 'Configuration.Role' --output text | cut -d'/' -f2)

# Attach custom policy
aws iam attach-role-policy --role-name $LAMBDA_ROLE --policy-arn arn:aws:iam::ACCOUNT_ID:policy/AWSCookbook403IamPolicy

# Attach SecretsManager policy
aws iam attach-role-policy --role-name $LAMBDA_ROLE --policy-arn arn:aws:iam::aws:policy/SecretsManagerReadWrite
```

### Step 7: Configure Security Group Rules
1. **RDS Security Group** - Add inbound rule:
   - **Type:** MySQL/Aurora
   - **Port:** 3306
   - **Source:** RDS Proxy security group

2. **RDS Proxy Security Group** - Add inbound rule:
   - **Type:** MySQL/Aurora
   - **Port:** 3306
   - **Source:** Lambda security group

```bash
# Add rules via CLI
aws ec2 authorize-security-group-ingress --group-id sg-rds123 --protocol tcp --port 3306 --source-group sg-proxy456
aws ec2 authorize-security-group-ingress --group-id sg-proxy456 --protocol tcp --port 3306 --source-group sg-lambda789
```

### Step 8: Register RDS Proxy Targets
```bash
aws rds register-db-proxy-targets --db-proxy-name awscookbook403rdsproxy --target-group-name default --db-instance-identifiers your-db-instance
```

### Step 9: Update Lambda Function
1. Update Lambda environment variables:
```bash
aws lambda update-function-configuration --function-name your-lambda-function --environment Variables='{DB_HOST=awscookbook403rdsproxy.proxy-xyz.region.rds.amazonaws.com,DB_USER=admin,DB_NAME=mydatabase}'
```

2. Sample Lambda function code:
```python
import json
import boto3
import pymysql
import os

def lambda_handler(event, context):
    # Get RDS Proxy endpoint from environment
    db_host = os.environ['DB_HOST']
    db_user = os.environ['DB_USER']
    db_name = os.environ['DB_NAME']
    
    # Generate auth token
    rds_client = boto3.client('rds')
    token = rds_client.generate_db_auth_token(
        DBHostname=db_host,
        Port=3306,
        DBUsername=db_user
    )
    
    # Connect to database via RDS Proxy
    try:
        connection = pymysql.connect(
            host=db_host,
            user=db_user,
            password=token,
            database=db_name,
            ssl={'use': True}
        )
        
        with connection.cursor() as cursor:
            cursor.execute("SELECT VERSION()")
            result = cursor.fetchone()
            
        return {
            'statusCode': 200,
            'body': json.dumps(f'Connected successfully: {result}')
        }
        
    except Exception as e:
        return {
            'statusCode': 500,
            'body': json.dumps(f'Connection failed: {str(e)}')
        }
    finally:
        if 'connection' in locals():
            connection.close()
```

### Step 10: Test Lambda Function
```bash
aws lambda invoke --function-name your-lambda-function --payload '{}' response.json
cat response.json
```

---

## Scenario 4: Encrypting Storage of Existing Amazon RDS MySQL Database

**Problem:** Need to encrypt the storage of an existing database.

**Solution Steps:**

### Step 1: Verify Current Encryption Status
```bash
aws rds describe-db-instances --db-instance-identifier your-db-instance --query 'DBInstances[0].StorageEncrypted'
```

### Step 2: Create KMS Key for Encryption
1. Navigate to **KMS Console** → **Customer managed keys** → **Create key**
2. **Configure key:**
   - **Key type:** Symmetric
   - **Key usage:** Encrypt and decrypt
   - **Key material origin:** KMS
3. **Add labels:**
   - **Alias:** `alias/cookbook404-rds-key`
   - **Description:** KMS key for RDS encryption
4. **Define key administrative permissions:** Select appropriate users/roles
5. **Define key usage permissions:** Select appropriate users/roles
6. **Create key**

### Step 3: Create KMS Key via CLI (Alternative)
```bash
# Create KMS key
KEY_ID=$(aws kms create-key --description "RDS encryption key" --query 'KeyMetadata.KeyId' --output text)

# Create alias
aws kms create-alias --alias-name alias/cookbook404-rds-key --target-key-id $KEY_ID
```

### Step 4: Create Read Replica of Existing Database
```bash
aws rds create-db-instance-read-replica \
    --db-instance-identifier your-db-instance-replica \
    --source-db-instance-identifier your-db-instance \
    --db-instance-class db.t3.micro
```

### Step 5: Wait for Read Replica Availability
```bash
aws rds wait db-instance-available --db-instance-identifier your-db-instance-replica
```

### Step 6: Create Snapshot of Read Replica
```bash
aws rds create-db-snapshot \
    --db-instance-identifier your-db-instance-replica \
    --db-snapshot-identifier your-db-snapshot-unencrypted
```

### Step 7: Wait for Snapshot Completion
```bash
aws rds wait db-snapshot-completed --db-snapshot-identifier your-db-snapshot-unencrypted
```

### Step 8: Copy Snapshot with Encryption
```bash
# Get KMS key ARN
KMS_KEY_ARN=$(aws kms describe-key --key-id alias/cookbook404-rds-key --query 'KeyMetadata.Arn' --output text)

# Copy snapshot with encryption
aws rds copy-db-snapshot \
    --source-db-snapshot-identifier your-db-snapshot-unencrypted \
    --target-db-snapshot-identifier your-db-snapshot-encrypted \
    --kms-key-id $KMS_KEY_ARN
```

### Step 9: Wait for Encrypted Snapshot
```bash
aws rds wait db-snapshot-completed --db-snapshot-identifier your-db-snapshot-encrypted
```

### Step 10: Restore New Instance from Encrypted Snapshot
```bash
aws rds restore-db-instance-from-db-snapshot \
    --db-instance-identifier your-db-instance-encrypted \
    --db-snapshot-identifier your-db-snapshot-encrypted \
    --db-instance-class db.t3.micro
```

### Step 11: Wait for New Instance Availability
```bash
aws rds wait db-instance-available --db-instance-identifier your-db-instance-encrypted
```

### Step 12: Verify Encryption Status
```bash
aws rds describe-db-instances \
    --db-instance-identifier your-db-instance-encrypted \
    --query 'DBInstances[0].StorageEncrypted'
```

### Step 13: Update Application Connection String
1. Get new endpoint:
```bash
aws rds describe-db-instances \
    --db-instance-identifier your-db-instance-encrypted \
    --query 'DBInstances[0].Endpoint.Address' --output text
```

2. **Optional: Use Route 53 for minimal downtime:**
   - Create CNAME record pointing to old endpoint
   - Update CNAME to point to new endpoint
   - Adjust TTL for faster propagation

### Step 14: Cleanup (After Validation)
```bash
# Delete read replica
aws rds delete-db-instance --db-instance-identifier your-db-instance-replica --skip-final-snapshot

# Delete unencrypted snapshot
aws rds delete-db-snapshot --db-snapshot-identifier your-db-snapshot-unencrypted

# Delete original instance (after full validation)
# aws rds delete-db-instance --db-instance-identifier your-db-instance --skip-final-snapshot
```

---

## Scenario 5: Automating Password Rotation for RDS Databases

**Problem:** Need to implement automatic password rotation for a database user.

**Solution Steps:**

### Step 1: Create Initial Password in Secrets Manager
1. Navigate to **Secrets Manager Console** → **Store a new secret**
2. **Secret type:** Credentials for RDS database
3. **Credentials:**
   - **User name:** `admin`
   - **Password:** Generate or enter password
   - **Encryption key:** Default or select custom KMS key
   - **Database:** Select your RDS instance
4. **Secret name:** `rds-db-credentials/cookbook405`
5. **Description:** RDS admin credentials for rotation
6. **Configure automatic rotation:** (Configure later)
7. **Store**

### Step 2: Update RDS Instance to Use Secrets Manager Password
```bash
# Get secret ARN
SECRET_ARN=$(aws secretsmanager describe-secret --secret-id rds-db-credentials/cookbook405 --query 'ARN' --output text)

# Update RDS master password
aws rds modify-db-instance \
    --db-instance-identifier your-db-instance \
    --manage-master-user-password \
    --master-user-secret-kms-key-id alias/aws/secretsmanager \
    --apply-immediately
```

### Step 3: Create RDS Credentials Template
Create `rdscreds-template.json`:
```json
{
    "engine": "mysql",
    "host": "RDS_ENDPOINT",
    "username": "admin",
    "password": "TEMP_PASSWORD",
    "dbname": "myapp",
    "port": 3306
}
```

### Step 4: Download AWS Lambda Rotation Function
```bash
# Clone AWS samples repository
git clone https://github.com/aws-samples/aws-secrets-manager-rotation-lambdas.git
cd aws-secrets-manager-rotation-lambdas/SecretsManagerRDSMySQLRotationSingleUser
```

### Step 5: Package Lambda Function
```bash
# Install dependencies
pip install -r requirements.txt -t .

# Create deployment package
zip -r mysql-rotation-function.zip .
```

### Step 6: Create Security Group for Lambda
```bash
aws ec2 create-security-group \
    --group-name lambda-rotation-sg \
    --description "Security group for Lambda rotation function" \
    --vpc-id vpc-12345678
```

### Step 7: Configure Security Group Rules
```bash
# Get RDS and Lambda security group IDs
RDS_SG=$(aws rds describe-db-instances --db-instance-identifier your-db-instance --query 'DBInstances[0].VpcSecurityGroups[0].VpcSecurityGroupId' --output text)
LAMBDA_SG=$(aws ec2 describe-security-groups --group-names lambda-rotation-sg --query 'SecurityGroups[0].GroupId' --output text)

# Allow Lambda to connect to RDS
aws ec2 authorize-security-group-ingress \
    --group-id $RDS_SG \
    --protocol tcp \
    --port 3306 \
    --source-group $LAMBDA_SG
```

### Step 8: Create IAM Role for Lambda
1. Create `lambda-assume-role-policy.json`:
```json
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Principal": {
                "Service": "lambda.amazonaws.com"
            },
            "Action": "sts:AssumeRole"
        }
    ]
}
```

2. Create role:
```bash
aws iam create-role \
    --role-name AWSCookbook405Lambda \
    --assume-role-policy-document file://lambda-assume-role-policy.json
```

3. Attach policies:
```bash
# VPC access policy
aws iam attach-role-policy \
    --role-name AWSCookbook405Lambda \
    --policy-arn arn:aws:iam::aws:policy/service-role/AWSLambdaVPCAccessExecutionRole

# Secrets Manager policy
aws iam attach-role-policy \
    --role-name AWSCookbook405Lambda \
    --policy-arn arn:aws:iam::aws:policy/SecretsManagerReadWrite
```

### Step 9: Create Lambda Function
```bash
# Get subnet IDs (private subnets)
SUBNET_IDS=$(aws ec2 describe-subnets --filters "Name=tag:Name,Values=private*" --query 'Subnets[].SubnetId' --output text | tr '\t' ',')

# Create Lambda function
aws lambda create-function \
    --function-name mysql-rotation-function \
    --runtime python3.9 \
    --role arn:aws:iam::ACCOUNT_ID:role/AWSCookbook405Lambda \
    --handler lambda_function.lambda_handler \
    --zip-file fileb://mysql-rotation-function.zip \
    --vpc-config SubnetIds=$SUBNET_IDS,SecurityGroupIds=$LAMBDA_SG \
    --timeout 30 \
    --environment Variables='{SECRETS_MANAGER_ENDPOINT=https://secretsmanager.region.amazonaws.com}'
```

### Step 10: Grant Secrets Manager Permission to Invoke Lambda
```bash
aws lambda add-permission \
    --function-name mysql-rotation-function \
    --statement-id SecretsManagerInvoke \
    --action lambda:InvokeFunction \
    --principal secretsmanager.amazonaws.com
```

### Step 11: Configure Automatic Rotation
```bash
# Get Lambda function ARN
LAMBDA_ARN=$(aws lambda get-function --function-name mysql-rotation-function --query 'Configuration.FunctionArn' --output text)

# Update secret with rotation configuration
aws secretsmanager update-secret \
    --secret-id rds-db-credentials/cookbook405 \
    --secret-string file://rdscreds-template.json
```

### Step 12: Enable Automatic Rotation
1. **Via Console:**
   - Navigate to **Secrets Manager** → Select your secret
   - **Edit rotation** → **Enable automatic rotation**
   - **Rotation interval:** 30 days
   - **Lambda function:** Select created function
   - **Save**

2. **Via CLI:**
```bash
aws secretsmanager rotate-secret \
    --secret-id rds-db-credentials/cookbook405 \
    --rotation-rules AutomaticallyAfterDays=30 \
    --rotation-lambda-arn $LAMBDA_ARN
```

### Step 13: Test Manual Rotation
```bash
aws secretsmanager rotate-secret --secret-id rds-db-credentials/cookbook405
```

### Step 14: Monitor Rotation Status
```bash
# Check rotation status
aws secretsmanager describe-secret --secret-id rds-db-credentials/cookbook405 --query 'RotationEnabled'

# Get current password
aws secretsmanager get-secret-value --secret-id rds-db-credentials/cookbook405 --query 'SecretString' --output text
```

### Step 15: Validate Database Connection
```bash
# Connect to EC2 instance
aws ssm start-session --target i-1234567890abcdef0

# Install MySQL client
sudo yum install mysql -y

# Get current credentials
SECRET_VALUE=$(aws secretsmanager get-secret-value --secret-id rds-db-credentials/cookbook405 --query 'SecretString' --output text)
DB_HOST=$(echo $SECRET_VALUE | jq -r '.host')
DB_USER=$(echo $SECRET_VALUE | jq -r '.username')
DB_PASS=$(echo $SECRET_VALUE | jq -r '.password')

# Connect to database
mysql -h $DB_HOST -u $DB_USER -p$DB_PASS

# Test query
SELECT USER(), NOW();
```

---

## Scenario 6: Autoscaling DynamoDB Table Provisioned Capacity

**Problem:** DynamoDB table with low provisioned throughput needs to scale up or down based on variable application load.

**Solution Steps:**

### Step 1: Navigate to Application Auto Scaling
```bash
# Set variables
TABLE_NAME="your-dynamodb-table"
REGION="us-east-1"
```

### Step 2: Register Scaling Target for Read Capacity
```bash
aws application-autoscaling register-scalable-target \
    --service-namespace dynamodb \
    --scalable-dimension dynamodb:table:ReadCapacityUnits \
    --resource-id table/$TABLE_NAME \
    --min-capacity 5 \
    --max-capacity 10 \
    --region $REGION
```

### Step 3: Register Scaling Target for Write Capacity
```bash
aws application-autoscaling register-scalable-target \
    --service-namespace dynamodb \
    --scalable-dimension dynamodb:table:WriteCapacityUnits \
    --resource-id table/$TABLE_NAME \
    --min-capacity 5 \
    --max-capacity 10 \
    --region $REGION
```

### Step 4: Create Read Capacity Scaling Policy
Create `read-policy.json`:
```json
{
    "TargetValue": 70.0,
    "PredefinedMetricSpecification": {
        "PredefinedMetricType": "DynamoDBReadCapacityUtilization"
    },
    "ScaleOutCooldown": 300,
    "ScaleInCooldown": 300
}
```

### Step 5: Create Write Capacity Scaling Policy
Create `write-policy.json`:
```json
{
    "TargetValue": 70.0,
    "PredefinedMetricSpecification": {
        "PredefinedMetricType": "DynamoDBWriteCapacityUtilization"
    },
    "ScaleOutCooldown": 300,
    "ScaleInCooldown": 300
}
```

### Step 6: Apply Read Capacity Scaling Policy
```bash
aws application-autoscaling put-scaling-policy \
    --service-namespace dynamodb \
    --scalable-dimension dynamodb:table:ReadCapacityUnits \
    --resource-id table/$TABLE_NAME \
    --policy-name ReadCapacityScalingPolicy \
    --policy-type TargetTrackingScaling \
    --target-tracking-scaling-policy-configuration file://read-policy.json \
    --region $REGION
```

### Step 7: Apply Write Capacity Scaling Policy
```bash
aws application-autoscaling put-scaling-policy \
    --service-namespace dynamodb \
    --scalable-dimension dynamodb:table:WriteCapacityUnits \
    --resource-id table/$TABLE_NAME \
    --policy-name WriteCapacityScalingPolicy \
    --policy-type TargetTrackingScaling \
    --target-tracking-scaling-policy-configuration file://write-policy.json \
    --region $REGION
```

### Step 8: Validate Auto Scaling Configuration
1. **Via Console:**
   - Navigate to **DynamoDB Console** → **Tables** → Select your table
   - **Additional settings** tab → **Read/write capacity** section
   - Verify auto scaling is enabled with correct min/max values

2. **Via CLI:**
```bash
# Check scalable targets
aws application-autoscaling describe-scalable-targets \
    --service-namespace dynamodb \
    --resource-ids table/$TABLE_NAME

# Check scaling policies
aws application-autoscaling describe-scaling-policies \
    --service-namespace dynamodb \
    --resource-id table/$TABLE_NAME
```

### Step 9: Test Scaling (Optional)
1. **Generate load to trigger scaling:**
```python
import boto3
import threading
import time

dynamodb = boto3.resource('dynamodb', region_name='us-east-1')
table = dynamodb.Table('your-dynamodb-table')

def write_items():
    for i in range(1000):
        table.put_item(Item={'id': str(i), 'data': 'test-data-' + str(i)})
        time.sleep(0.01)

# Create multiple threads to generate load
threads = []
for i in range(10):
    t = threading.Thread(target=write_items)
    threads.append(t)
    t.start()

for t in threads:
    t.join()
```

### Step 10: Monitor Scaling Activity
```bash
# Check scaling activities
aws application-autoscaling describe-scaling-activities \
    --service-namespace dynamodb \
    --resource-id table/$TABLE_NAME

# Monitor CloudWatch metrics
aws cloudwatch get-metric-statistics \
    --namespace AWS/DynamoDB \
    --metric-name ConsumedReadCapacityUnits \
    --dimensions Name=TableName,Value=$TABLE_NAME \
    --start-time $(date -u -d '1 hour ago' +%Y-%m-%dT%H:%M:%S) \
    --end-time $(date -u +%Y-%m-%dT%H:%M:%S) \
    --period 300 \
    --statistics Sum
```

### Alternative: Enable Auto Scaling via Console
1. **DynamoDB Console** → **Tables** → Select table → **Additional settings**
2. **Read/write capacity settings** → **Edit**
3. **Capacity mode:** Provisioned
4. **Read capacity:** Auto scaling enabled
   - **Minimum capacity units:** 5
   - **Maximum capacity units:** 10
   - **Target utilization:** 70%
5. **Write capacity:** Auto scaling enabled
   - **Minimum capacity units:** 5
   - **Maximum capacity units:** 10
   - **Target utilization:** 70%
6. **Save changes**

---

## Scenario 7: Migrating Databases to Amazon RDS Using AWS DMS

**Problem:** Need to move data from a source database to a target database.

**Solution Steps:**

### Step 1: Create Security Group for DMS
```bash
aws ec2 create-security-group \
    --group-name dms-replication-sg \
    --description "Security group for DMS replication instance" \
    --vpc-id vpc-12345678
```

### Step 2: Configure Security Group Rules
```bash
# Get source and target database security group IDs
SOURCE_DB_SG="sg-source123"
TARGET_DB_SG="sg-target456"
DMS_SG=$(aws ec2 describe-security-groups --group-names dms-replication-sg --query 'SecurityGroups[0].GroupId' --output text)

# Allow DMS to connect to source database
aws ec2 authorize-security-group-ingress \
    --group-id $SOURCE_DB_SG \
    --protocol tcp \
    --port 3306 \
    --source-group $DMS_SG

# Allow DMS to connect to target database
aws ec2 authorize-security-group-ingress \
    --group-id $TARGET_DB_SG \
    --protocol tcp \
    --port 3306 \
    --source-group $DMS_SG
```

### Step 3: Create IAM Role for DMS
1. Create `dms-assume-role-policy.json`:
```json
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Principal": {
                "Service": "dms.amazonaws.com"
            },
            "Action": "sts:AssumeRole"
        }
    ]
}
```

2. Create and attach role:
```bash
# Create role
aws iam create-role \
    --role-name dms-vpc-role \
    --assume-role-policy-document file://dms-assume-role-policy.json

# Attach managed policy
aws iam attach-role-policy \
    --role-name dms-vpc-role \
    --policy-arn arn:aws:iam::aws:policy/service-role/AmazonDMSVPCManagementRole
```

### Step 4: Create Replication Subnet Group
```bash
# Get private subnet IDs
SUBNET_IDS=$(aws ec2 describe-subnets \
    --filters "Name=tag:Name,Values=private*" \
    --query 'Subnets[].SubnetId' \
    --output text)

# Create replication subnet group
aws dms create-replication-subnet-group \
    --replication-subnet-group-identifier dms-subnet-group \
    --replication-subnet-group-description "DMS replication subnet group" \
    --subnet-ids $SUBNET_IDS
```

### Step 5: Create DMS Replication Instance
```bash
aws dms create-replication-instance \
    --replication-instance-identifier dms-replication-instance \
    --replication-instance-class dms.t3.micro \
    --vpc-security-group-ids $DMS_SG \
    --replication-subnet-group-identifier dms-subnet-group \
    --publicly-accessible false
```

### Step 6: Wait for Replication Instance Availability
```bash
aws dms wait replication-instance-available \
    --filters "Name=replication-instance-id,Values=dms-replication-instance"
```

### Step 7: Get Database Passwords from Secrets Manager
```bash
# Get source database password
SOURCE_PASSWORD=$(aws secretsmanager get-secret-value \
    --secret-id source-db-credentials \
    --query 'SecretString' --output text | jq -r '.password')

# Get target database password
TARGET_PASSWORD=$(aws secretsmanager get-secret-value \
    --secret-id target-db-credentials \
    --query 'SecretString' --output text | jq -r '.password')

# Get database endpoints
SOURCE_ENDPOINT=$(aws rds describe-db-instances \
    --db-instance-identifier source-db-instance \
    --query 'DBInstances[0].Endpoint.Address' --output text)

TARGET_ENDPOINT=$(aws rds describe-db-instances \
    --db-instance-identifier target-db-instance \
    --query 'DBInstances[0].Endpoint.Address' --output text)
```

### Step 8: Create Source Endpoint
```bash
aws dms create-endpoint \
    --endpoint-identifier source-mysql-endpoint \
    --endpoint-type source \
    --engine-name mysql \
    --server-name $SOURCE_ENDPOINT \
    --port 3306 \
    --username admin \
    --password $SOURCE_PASSWORD \
    --database-name sourcedb
```

### Step 9: Create Target Endpoint
```bash
aws dms create-endpoint \
    --endpoint-identifier target-mysql-endpoint \
    --endpoint-type target \
    --engine-name mysql \
    --server-name $TARGET_ENDPOINT \
    --port 3306 \
    --username admin \
    --password $TARGET_PASSWORD \
    --database-name targetdb
```

### Step 10: Test Endpoint Connections
```bash
# Test source endpoint
aws dms test-connection \
    --replication-instance-arn arn:aws:dms:region:account:rep:dms-replication-instance \
    --endpoint-arn arn:aws:dms:region:account:endpoint:source-mysql-endpoint

# Test target endpoint
aws dms test-connection \
    --replication-instance-arn arn:aws:dms:region:account:rep:dms-replication-instance \
    --endpoint-arn arn:aws:dms:region:account:endpoint:target-mysql-endpoint
```

### Step 11: Create Replication Task
1. Create `table-mappings.json`:
```json
{
    "rules": [
        {
            "rule-type": "selection",
            "rule-id": "1",
            "rule-name": "1",
            "object-locator": {
                "schema-name": "sourcedb",
                "table-name": "%"
            },
            "rule-action": "include"
        }
    ]
}
```

2. Create replication task:
```bash
aws dms create-replication-task \
    --replication-task-identifier mysql-migration-task \
    --source-endpoint-arn arn:aws:dms:region:account:endpoint:source-mysql-endpoint \
    --target-endpoint-arn arn:aws:dms:region:account:endpoint:target-mysql-endpoint \
    --replication-instance-arn arn:aws:dms:region:account:rep:dms-replication-instance \
    --migration-type full-load-and-cdc \
    --table-mappings file://table-mappings.json
```

### Step 12: Wait for Task Ready Status
```bash
aws dms wait replication-task-ready \
    --filters "Name=replication-task-id,Values=mysql-migration-task"
```

### Step 13: Start Replication Task
```bash
aws dms start-replication-task \
    --replication-task-arn arn:aws:dms:region:account:task:mysql-migration-task \
    --start-replication-task-type start-replication
```

### Step 14: Monitor Replication Progress
```bash
# Check task status
aws dms describe-replication-tasks \
    --filters "Name=replication-task-id,Values=mysql-migration-task" \
    --query 'ReplicationTasks[0].Status'

# Get detailed statistics
aws dms describe-table-statistics \
    --replication-task-arn arn:aws:dms:region:account:task:mysql-migration-task
```

### Step 15: Monitor via Console
1. Navigate to **DMS Console** → **Database migration tasks**
2. Select your task to view:
   - **Table statistics** - Row counts, validation status
   - **CloudWatch logs** - Detailed migration logs
   - **Task details** - Overall progress and status

### Step 16: Validate Migration
```bash
# Connect to target database
mysql -h $TARGET_ENDPOINT -u admin -p$TARGET_PASSWORD targetdb

# Compare row counts
SELECT COUNT(*) FROM table1;
SELECT COUNT(*) FROM table2;

# Validate sample data
SELECT * FROM table1 LIMIT 10;
```

---

## Scenario 8: Enabling REST Access to Aurora Serverless Using RDS Data API

**Problem:** PostgreSQL database needs to connect without having the application manage persistent database connections.

**Solution Steps:**

### Step 1: Enable Data API on Aurora Serverless Cluster
1. **Via Console:**
   - Navigate to **RDS Console** → **Databases**
   - Select Aurora Serverless cluster → **Modify**
   - **Additional configuration** → **Data API** → **Enable**
   - **Continue** → **Apply immediately** → **Modify cluster**

2. **Via CLI:**
```bash
aws rds modify-db-cluster \
    --db-cluster-identifier your-aurora-cluster \
    --enable-http-endpoint \
    --apply-immediately
```

### Step 2: Verify Data API Status
```bash
aws rds describe-db-clusters \
    --db-cluster-identifier your-aurora-cluster \
    --query 'DBClusters[0].HttpEndpointEnabled'
```

### Step 3: Test Data API from CLI
```bash
# Get cluster ARN and secret ARN
CLUSTER_ARN=$(aws rds describe-db-clusters \
    --db-cluster-identifier your-aurora-cluster \
    --query 'DBClusters[0].DBClusterArn' --output text)

SECRET_ARN=$(aws secretsmanager describe-secret \
    --secret-id aurora-cluster-credentials \
    --query 'ARN' --output text)

# Test Data API connection
aws rds-data execute-statement \
    --resource-arn $CLUSTER_ARN \
    --secret-arn $SECRET_ARN \
    --database cookbook \
    --sql "SELECT version();"
```

### Step 4: Use RDS Query Editor (Console)
1. Navigate to **RDS Console** → **Query Editor**
2. **Connect to database:**
   - **Database instance or cluster:** Select your Aurora Serverless cluster
   - **Database username:** Select stored credentials from Secrets Manager
   - **Secrets Manager secret:** Select your secret
   - **Enter name of database:** cookbook
3. **Connect to database**
4. **Run queries in the editor:**
```sql
-- Create sample table
CREATE TABLE users (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100),
    email VARCHAR(150),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Insert sample data
INSERT INTO users (name, email) VALUES 
    ('John Doe', 'john@example.com'),
    ('Jane Smith', 'jane@example.com');

-- Query data
SELECT * FROM users;
```

### Step 5: Create IAM Policy for Data API Access
1. Create `data-api-policy-template.json`:
```json
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "rds-data:BatchExecuteStatement",
                "rds-data:BeginTransaction",
                "rds-data:CommitTransaction",
                "rds-data:ExecuteStatement",
                "rds-data:RollbackTransaction"
            ],
            "Resource": "CLUSTER_ARN"
        },
        {
            "Effect": "Allow",
            "Action": [
                "secretsmanager:GetSecretValue",
                "secretsmanager:DescribeSecret"
            ],
            "Resource": "SECRET_ARN"
        }
    ]
}
```

2. Replace variables and create policy:
```bash
# Replace placeholders
sed -i "s|CLUSTER_ARN|$CLUSTER_ARN|g" data-api-policy-template.json
sed -i "s|SECRET_ARN|$SECRET_ARN|g" data-api-policy-template.json

# Create IAM policy
aws iam create-policy \
    --policy-name AWSCookbook408RDSDataPolicy \
    --policy-document file://data-api-policy-template.json
```

### Step 6: Attach Policy to EC2 Instance Role
```bash
# Get EC2 instance role
INSTANCE_ROLE=$(aws sts get-caller-identity --query 'Arn' --output text | cut -d'/' -f2)

# Attach policy
aws iam attach-role-policy \
    --role-name $INSTANCE_ROLE \
    --policy-arn arn:aws:iam::ACCOUNT_ID:policy/AWSCookbook408RDSDataPolicy
```

### Step 7: Store Configuration in SSM Parameter Store
```bash
# Store database configuration
aws ssm put-parameter \
    --name "/cookbook408/database-name" \
    --value "cookbook" \
    --type "String"

aws ssm put-parameter \
    --name "/cookbook408/cluster-arn" \
    --value "$CLUSTER_ARN" \
    --type "String"

aws ssm put-parameter \
    --name "/cookbook408/secret-arn" \
    --value "$SECRET_ARN" \
    --type "String"
```

### Step 8: Connect to EC2 Instance and Test Data API
```bash
# Connect via SSM Session Manager
aws ssm start-session --target i-1234567890abcdef0

# Set AWS region
export AWS_DEFAULT_REGION=us-east-1

# Retrieve parameters
DATABASE_NAME=$(aws ssm get-parameter --name "/cookbook408/database-name" --query 'Parameter.Value' --output text)
CLUSTER_ARN=$(aws ssm get-parameter --name "/cookbook408/cluster-arn" --query 'Parameter.Value' --output text)
SECRET_ARN=$(aws ssm get-parameter --name "/cookbook408/secret-arn" --query 'Parameter.Value' --output text)

# Execute SQL via Data API
aws rds-data execute-statement \
    --resource-arn "$CLUSTER_ARN" \
    --secret-arn "$SECRET_ARN" \
    --database "$DATABASE_NAME" \
    --sql "CREATE TABLE IF NOT EXISTS products (id SERIAL PRIMARY KEY, name VARCHAR(100), price DECIMAL(10,2));"

# Insert data
aws rds-data execute-statement \
    --resource-arn "$CLUSTER_ARN" \
    --secret-arn "$SECRET_ARN" \
    --database "$DATABASE_NAME" \
    --sql "INSERT INTO products (name, price) VALUES ('Laptop', 999.99), ('Mouse', 29.99);"

# Query data
aws rds-data execute-statement \
    --resource-arn "$CLUSTER_ARN" \
    --secret-arn "$SECRET_ARN" \
    --database "$DATABASE_NAME" \
    --sql "SELECT * FROM products;"
```

### Step 9: Advanced Data API Usage
1. **Using transactions:**
```bash
# Begin transaction
TRANSACTION_ID=$(aws rds-data begin-transaction \
    --resource-arn "$CLUSTER_ARN" \
    --secret-arn "$SECRET_ARN" \
    --database "$DATABASE_NAME" \
    --query 'transactionId' --output text)

# Execute statements within transaction
aws rds-data execute-statement \
    --resource-arn "$CLUSTER_ARN" \
    --secret-arn "$SECRET_ARN" \
    --database "$DATABASE_NAME" \
    --transaction-id "$TRANSACTION_ID" \
    --sql "UPDATE products SET price = price * 0.9 WHERE id = 1;"

# Commit transaction
aws rds-data commit-transaction \
    --resource-arn "$CLUSTER_ARN" \
    --secret-arn "$SECRET_ARN" \
    --transaction-id "$TRANSACTION_ID"
```

2. **Batch execute statements:**
```bash
# Create JSON file for batch execution
cat > batch-statements.json << EOF
[
    {
        "sql": "INSERT INTO products (name, price) VALUES ('Keyboard', 79.99);"
    },
    {
        "sql": "INSERT INTO products (name, price) VALUES ('Monitor', 299.99);"
    }
]
EOF

# Execute batch
aws rds-data batch-execute-statement \
    --resource-arn "$CLUSTER_ARN" \
    --secret-arn "$SECRET_ARN" \
    --database "$DATABASE_NAME" \
    --sql-statements file://batch-statements.json
```

### Step 10: Programming Language Examples
1. **Python example:**
```python
import boto3
import json

client = boto3.client('rds-data')

def execute_sql(sql, parameters=None):
    kwargs = {
        'resourceArn': 'your-cluster-arn',
        'secretArn': 'your-secret-arn',
        'database': 'cookbook',
        'sql': sql
    }
    
    if parameters:
        kwargs['parameters'] = parameters
    
    response = client.execute_statement(**kwargs)
    return response

# Example usage
result = execute_sql("SELECT * FROM products WHERE price > :min_price", 
                    [{'name': 'min_price', 'value': {'doubleValue': 50.0}}])
print(json.dumps(result, indent=2, default=str))
```

2. **Node.js example:**
```javascript
const AWS = require('aws-sdk');
const rdsdataservice = new AWS.RDSDataService();

async function executeSQL(sql, parameters = []) {
    const params = {
        resourceArn: 'your-cluster-arn',
        secretArn: 'your-secret-arn',
        database: 'cookbook',
        sql: sql,
        parameters: parameters
    };
    
    try {
        const result = await rdsdataservice.executeStatement(params).promise();
        return result;
    } catch (error) {
        console.error('Error executing SQL:', error);
        throw error;
    }
}

// Example usage
executeSQL('SELECT * FROM products')
    .then(result => console.log(JSON.stringify(result, null, 2)))
    .catch(error => console.error(error));
```

---

## Additional Best Practices and Tips

### Security Best Practices:
1. **Always use encryption at rest and in transit**
2. **Implement least privilege IAM policies**
3. **Enable VPC Flow Logs for network monitoring**
4. **Use AWS CloudTrail for API call auditing**
5. **Regular security group rule reviews**
6. **Enable GuardDuty for threat detection**

### Performance Optimization:
1. **Use connection pooling (RDS Proxy) for Lambda functions**
2. **Monitor CloudWatch metrics and set up alarms**
3. **Use read replicas for read-heavy workloads**
4. **Implement proper indexing strategies**
5. **Use DynamoDB Global Secondary Indexes efficiently**

### Cost Optimization:
1. **Use Aurora Serverless for unpredictable workloads**
2. **Implement DynamoDB auto scaling**
3. **Use Reserved Instances for predictable workloads**
4. **Monitor and optimize data transfer costs**
5. **Implement automated backup retention policies**

### Monitoring and Maintenance:
1. **Set up CloudWatch dashboards**
2. **Enable Enhanced Monitoring for RDS**
3. **Use AWS Personal Health Dashboard**
4. **Implement automated patching schedules**
5. **Regular disaster recovery testing**

### Migration Considerations:
1. **Test migrations in non-production environment first**
2. **Plan for minimal downtime with read replicas**
3. **Use AWS Schema Conversion Tool for heterogeneous migrations**
4. **Validate data integrity post-migration**
5. **Have rollback procedures ready**