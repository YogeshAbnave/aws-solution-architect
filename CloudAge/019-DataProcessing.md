# AWS EMR Production Guide - Complete Documentation

## Table of Contents
1. [Cloud Service Models Overview](#cloud-service-models-overview)
2. [Big Data Architecture](#big-data-architecture)
3. [Amazon EMR Overview](#amazon-emr-overview)
4. [EMR Deployment Options](#emr-deployment-options)
5. [Production Setup Steps](#production-setup-steps)
6. [EMR Studio Configuration](#emr-studio-configuration)
7. [Serverless vs EC2 Comparison](#serverless-vs-ec2-comparison)
8. [Data Processing Pipeline](#data-processing-pipeline)
9. [Backup and Monitoring](#backup-and-monitoring)
10. [Production Best Practices](#production-best-practices)

---

## Cloud Service Models Overview

### IaaS vs PaaS vs SaaS

#### Infrastructure as a Service (IaaS)
- **Definition**: Provides virtualized computing resources over the internet
- **Examples**: AWS EC2, Google Compute Engine, Azure VMs
- **Control Level**: High - You manage OS, runtime, applications
- **Use Cases**: Custom applications, legacy systems migration

#### Platform as a Service (PaaS)
- **Definition**: Provides platform allowing customers to develop, run, and manage applications
- **Examples**: AWS Elastic Beanstalk, Google App Engine, Heroku
- **Control Level**: Medium - Platform manages infrastructure, you manage applications
- **Use Cases**: Application development, microservices

#### Software as a Service (SaaS)
- **Definition**: Software delivered over the internet on a subscription basis
- **Examples**: Salesforce, Office 365, Gmail
- **Control Level**: Low - Provider manages everything, you just use the software
- **Use Cases**: End-user applications, business software

### Service Classification
- **EMR**: PaaS (Platform as a Service)
- **H2O.ai**: Can be deployed as SaaS or on-premises
- **Athena**: SaaS (Serverless query service)
- **CDP (Cloudera Data Platform)**: Can be PaaS when cloud-managed

---

## Big Data Architecture

### Modern Data Lake Architecture
```
┌─────────────────┐    ┌──────────────────┐    ┌─────────────────┐
│   Data Sources  │────│  Data Ingestion  │────│   Data Storage  │
│                 │    │                  │    │                 │
│ • Databases     │    │ • Kinesis        │    │ • S3 Data Lake  │
│ • APIs          │    │ • Kafka          │    │ • Redshift      │
│ • Files         │    │ • Lambda         │    │ • DynamoDB      │
│ • Streaming     │    │ • Glue ETL       │    │                 │
└─────────────────┘    └──────────────────┘    └─────────────────┘
                                │
                       ┌──────────────────┐
                       │ Data Processing  │
                       │                  │
                       │ • EMR Clusters   │
                       │ • Spark Jobs     │
                       │ • Databricks     │
                       │ • Glue Jobs      │
                       └──────────────────┘
                                │
                       ┌──────────────────┐
                       │   Analytics &    │
                       │   Visualization  │
                       │                  │
                       │ • QuickSight     │
                       │ • Tableau        │
                       │ • Power BI       │
                       └──────────────────┘
```

### Hybrid Architecture Components
- **On-Premises**: Legacy systems, sensitive data
- **Cloud**: Scalable processing, storage, analytics
- **Edge**: IoT devices, real-time processing

---

## Amazon EMR Overview

### What is Amazon EMR?
Amazon EMR (Elastic MapReduce) is a cloud-native big data platform for processing vast amounts of data using open-source tools such as Apache Spark, Apache Hive, Apache HBase, Apache Flink, Apache Hudi, and Presto.

### Key Features
- **Managed Hadoop Framework**: Fully managed Hadoop ecosystem
- **Auto Scaling**: Automatically scales clusters based on workload
- **Cost Optimization**: Spot instances, reserved instances support
- **Security**: Integration with IAM, VPC, encryption
- **Multiple Deployment Options**: EC2, EKS, Serverless

### EMR Applications
- **Apache Spark**: Large-scale data processing
- **Apache Hive**: Data warehousing and SQL queries
- **Apache HBase**: NoSQL database
- **Presto**: Interactive SQL queries
- **Jupyter Hub**: Interactive development
- **Zeppelin**: Web-based notebooks

---

## EMR Deployment Options

### 1. EMR on EC2
- **Best For**: Long-running clusters, custom configurations
- **Benefits**: Full control, custom AMIs, persistent storage
- **Use Cases**: Batch processing, data warehousing

### 2. EMR Serverless
- **Best For**: On-demand workloads, cost optimization
- **Benefits**: No cluster management, automatic scaling
- **Use Cases**: Ad-hoc analytics, periodic jobs

### 3. EMR on EKS
- **Best For**: Kubernetes-native workloads
- **Benefits**: Container orchestration, microservices
- **Use Cases**: Modern applications, CI/CD pipelines

---

## Production Setup Steps

### Step 1: Prerequisites Setup

#### IAM Roles Creation
```bash
# Create EMR Service Role
aws iam create-role --role-name EMR_DefaultRole \
  --assume-role-policy-document file://emr-trust-policy.json

# Create EC2 Instance Profile
aws iam create-role --role-name EMR_EC2_DefaultRole \
  --assume-role-policy-document file://ec2-trust-policy.json

# Attach policies
aws iam attach-role-policy --role-name EMR_DefaultRole \
  --policy-arn arn:aws:iam::aws:policy/service-role/AmazonElasticMapReduceRole

aws iam attach-role-policy --role-name EMR_EC2_DefaultRole \
  --policy-arn arn:aws:iam::aws:policy/service-role/AmazonElasticMapReduceforEC2Role
```

#### Security Group Configuration
```json
{
  "GroupName": "EMR-SecurityGroup",
  "Description": "Security group for EMR cluster",
  "SecurityGroupRules": [
    {
      "IpProtocol": "tcp",
      "FromPort": 22,
      "ToPort": 22,
      "CidrIp": "10.0.0.0/8"
    },
    {
      "IpProtocol": "tcp",
      "FromPort": 8080,
      "ToPort": 8080,
      "CidrIp": "10.0.0.0/8"
    }
  ]
}
```

### Step 2: S3 Bucket Setup
```bash
# Create S3 buckets
aws s3 mb s3://your-emr-data-bucket
aws s3 mb s3://your-emr-logs-bucket
aws s3 mb s3://your-emr-scripts-bucket

# Set up folder structure
aws s3api put-object --bucket your-emr-data-bucket --key input/
aws s3api put-object --bucket your-emr-data-bucket --key output/
aws s3api put-object --bucket your-emr-data-bucket --key scripts/
```

### Step 3: EMR Cluster Creation

#### Using AWS CLI
```bash
aws emr create-cluster \
  --name "Production-EMR-Cluster" \
  --release-label emr-6.9.0 \
  --applications Name=Spark Name=Hive Name=Hadoop Name=JupyterHub \
  --instance-type m5.xlarge \
  --instance-count 3 \
  --ec2-attributes KeyName=your-key-pair,InstanceProfile=EMR_EC2_DefaultRole \
  --service-role EMR_DefaultRole \
  --log-uri s3://your-emr-logs-bucket/logs/ \
  --enable-debugging \
  --auto-terminate
```

#### Using Terraform
```hcl
resource "aws_emr_cluster" "production_cluster" {
  name          = "production-emr-cluster"
  release_label = "emr-6.9.0"
  applications  = ["Spark", "Hive", "Hadoop", "JupyterHub"]

  termination_protection            = false
  keep_job_flow_alive_when_no_steps = true

  ec2_attributes {
    subnet_id                         = var.subnet_id
    emr_managed_master_security_group = aws_security_group.emr_master.id
    emr_managed_slave_security_group  = aws_security_group.emr_slave.id
    instance_profile                  = aws_iam_instance_profile.emr_profile.arn
  }

  master_instance_group {
    instance_type = "m5.xlarge"
  }

  core_instance_group {
    instance_type  = "m5.large"
    instance_count = 2
  }

  log_uri = "s3://${aws_s3_bucket.emr_logs.bucket}/logs/"

  tags = {
    Environment = "production"
    Application = "big-data-processing"
  }
}
```

---

## EMR Studio Configuration

### Step 1: Create EMR Studio

#### Prerequisites
- VPC with private subnets
- S3 bucket for workspace storage
- IAM roles for Studio and users

#### Studio Creation
```bash
aws emr create-studio \
  --name "Production-EMR-Studio" \
  --description "Production EMR Studio for data scientists" \
  --auth-mode SSO \
  --vpc-id vpc-12345678 \
  --subnet-ids subnet-12345678 subnet-87654321 \
  --service-role arn:aws:iam::123456789012:role/EMRStudioServiceRole \
  --user-role arn:aws:iam::123456789012:role/EMRStudioUserRole \
  --workspace-security-group-id sg-12345678 \
  --engine-security-group-id sg-87654321 \
  --default-s3-location s3://your-emr-studio-bucket/
```

### Step 2: Configure Authentication

#### Single Sign-On (SSO) Setup
1. Configure AWS SSO
2. Create user groups
3. Assign permissions
4. Configure OIDC/SAML if using external providers like Okta

#### Okta Integration
```json
{
  "IdentityProviderType": "SAML",
  "SAMLProviderArn": "arn:aws:iam::123456789012:saml-provider/OktaProvider",
  "SessionMappingAttributes": [
    {
      "Key": "Role",
      "Value": "arn:aws:iam::123456789012:role/EMRStudioUserRole"
    }
  ]
}
```

### Step 3: Workspace Management

#### Create Workspace
```python
import boto3

emr = boto3.client('emr')

response = emr.create_workspace(
    Name='DataScience-Workspace',
    Description='Workspace for data science team',
    StudioId='es-1234567890abcdef0',
    SubnetId='subnet-12345678',
    ClusterTemplateId='ct-1234567890abcdef0'
)
```

#### Workspace Configuration
- **Notebook Examples**: Pre-configured templates
- **Kernel Options**: Python 3, Scala, R, PySpark
- **Compute Options**: EMR clusters, serverless applications

---

## Serverless vs EC2 Comparison

### EMR Serverless
#### Advantages
- No cluster management overhead
- Automatic scaling
- Pay-per-use pricing
- Faster startup times
- Built-in monitoring

#### Best Use Cases
- Ad-hoc analytics
- Periodic batch jobs
- Development and testing
- Cost-sensitive workloads

#### Configuration Example
```python
import boto3

emr_serverless = boto3.client('emr-serverless')

application = emr_serverless.create_application(
    name='data-processing-app',
    releaseLabel='emr-6.9.0',
    type='Spark',
    initialCapacity={
        'Driver': {
            'workerCount': 1,
            'workerConfiguration': {
                'cpu': '2 vCPU',
                'memory': '4 GB'
            }
        },
        'Executor': {
            'workerCount': 10,
            'workerConfiguration': {
                'cpu': '4 vCPU',
                'memory': '8 GB'
            }
        }
    }
)
```

### EMR on EC2
#### Advantages
- Full control over configuration
- Custom AMIs support
- Persistent storage options
- Advanced networking
- Cost optimization with reserved instances

#### Best Use Cases
- Long-running clusters
- Custom software requirements
- High-performance computing
- Legacy applications

#### Node Manager Configuration
```xml
<configuration>
  <property>
    <name>yarn.nodemanager.resource.memory-mb</name>
    <value>14336</value>
  </property>
  <property>
    <name>yarn.nodemanager.resource.cpu-vcores</name>
    <value>4</value>
  </property>
  <property>
    <name>yarn.scheduler.maximum-allocation-mb</name>
    <value>14336</value>
  </property>
</configuration>
```

---

## Data Processing Pipeline

### Step Submission Process

#### Custom JAR Submission
```bash
# Add step to running cluster
aws emr add-steps \
  --cluster-id j-1234567890123 \
  --steps Type=Spark,Name="Custom Data Processing",ActionOnFailure=CONTINUE,Args=[
    --class,com.company.DataProcessor,
    --deploy-mode,cluster,
    --master,yarn,
    --conf,spark.sql.adaptive.enabled=true,
    s3://your-bucket/jars/data-processor.jar,
    s3://your-bucket/input/,
    s3://your-bucket/output/
  ]
```

#### Python Script Submission
```python
# EMR step configuration
step_config = {
    'Name': 'Python Data Processing',
    'ActionOnFailure': 'CONTINUE',
    'HadoopJarStep': {
        'Jar': 'command-runner.jar',
        'Args': [
            'spark-submit',
            '--deploy-mode', 'cluster',
            '--py-files', 's3://your-bucket/scripts/utils.py',
            's3://your-bucket/scripts/main.py',
            '--input', 's3://your-bucket/input/',
            '--output', 's3://your-bucket/output/'
        ]
    }
}
```

### Data Processing Example

#### Spark Application (Python)
```python
from pyspark.sql import SparkSession
from pyspark.sql.functions import *
import argparse

def process_data(input_path, output_path):
    spark = SparkSession.builder \
        .appName("DataProcessingJob") \
        .config("spark.sql.adaptive.enabled", "true") \
        .config("spark.sql.adaptive.coalescePartitions.enabled", "true") \
        .getOrCreate()
    
    # Read data
    df = spark.read.option("header", "true").csv(input_path)
    
    # Data processing
    processed_df = df.filter(col("status") == "active") \
                    .groupBy("category") \
                    .agg(count("*").alias("count"),
                         avg("value").alias("avg_value")) \
                    .orderBy("count", ascending=False)
    
    # Write results
    processed_df.coalesce(1).write \
        .mode("overwrite") \
        .option("header", "true") \
        .csv(output_path)
    
    spark.stop()

if __name__ == "__main__":
    parser = argparse.ArgumentParser()
    parser.add_argument("--input", required=True)
    parser.add_argument("--output", required=True)
    args = parser.parse_args()
    
    process_data(args.input, args.output)
```

### Hue Integration
```bash
# Enable Hue on EMR cluster
aws emr create-cluster \
  --applications Name=Hue Name=Spark Name=Hadoop \
  --bootstrap-actions Path=s3://your-bucket/scripts/hue-bootstrap.sh \
  --configurations file://hue-config.json
```

---

## Backup and Monitoring

### S3 Backup Strategy

#### Automated Backup Script
```python
import boto3
import schedule
import time
from datetime import datetime

def backup_to_s3():
    s3 = boto3.client('s3')
    
    # Create timestamp
    timestamp = datetime.now().strftime('%Y%m%d_%H%M%S')
    
    # Backup application logs
    backup_key = f"backups/{timestamp}/application_logs/"
    
    # Copy logs to backup location
    s3.copy_object(
        CopySource={'Bucket': 'production-logs', 'Key': 'application_raw_data_logs'},
        Bucket='backup-bucket',
        Key=backup_key
    )
    
    print(f"Backup completed at {timestamp}")

# Schedule backup every hour
schedule.every().hour.do(backup_to_s3)

while True:
    schedule.run_pending()
    time.sleep(60)
```

#### Cron Job Setup
```bash
# Install required packages
pip3 install faker boto3 schedule

# Configure AWS CLI
aws configure set aws_access_key_id YOUR_ACCESS_KEY
aws configure set aws_secret_access_key YOUR_SECRET_KEY
aws configure set default.region us-east-1

# Add cron job
crontab -e
# Add this line for hourly backups
0 * * * * /usr/bin/python3 /path/to/backup_script.py
```

### Monitoring and Alerting

#### CloudWatch Metrics
```python
import boto3

cloudwatch = boto3.client('cloudwatch')

# Put custom metric
cloudwatch.put_metric_data(
    Namespace='EMR/Processing',
    MetricData=[
        {
            'MetricName': 'JobSuccess',
            'Value': 1,
            'Unit': 'Count',
            'Dimensions': [
                {
                    'Name': 'ClusterName',
                    'Value': 'production-cluster'
                }
            ]
        }
    ]
)
```

#### Log Processing
```bash
# Monitor application logs
tail -f /var/log/spark/spark-history-server.out

# Check cluster status
aws emr describe-cluster --cluster-id j-1234567890123

# Monitor S3 usage
aws s3 ls s3://your-bucket/application_raw_data_logs/ --recursive --human-readable
```

---

## Production Best Practices

### 1. Security Best Practices
- Enable encryption at rest and in transit
- Use VPC with private subnets
- Implement least privilege access
- Regular security audits
- Enable CloudTrail logging

### 2. Cost Optimization
- Use Spot instances for non-critical workloads
- Implement auto-termination
- Right-size instances based on workload
- Use S3 Intelligent Tiering
- Monitor and optimize resource usage

### 3. Performance Optimization
- Tune Spark configurations
- Use appropriate file formats (Parquet, ORC)
- Implement data partitioning
- Cache frequently accessed data
- Monitor and optimize query performance

### 4. Operational Excellence
- Implement Infrastructure as Code
- Automate deployment processes
- Set up comprehensive monitoring
- Establish disaster recovery procedures
- Regular backup and testing

### 5. Data Governance
- Implement data cataloging
- Set up access controls
- Monitor data lineage
- Ensure compliance requirements
- Regular data quality checks

---

## Architecture Diagram

```
┌────────────────────────────────────────────────────────────────┐
│                    Production EMR Architecture                 │
├────────────────────────────────────────────────────────────────┤
│                                                                │
│  ┌─────────────┐    ┌──────────────┐    ┌─────────────────┐    │
│  │   Data      │    │   EMR        │    │   Data          │    │
│  │   Sources   │──▶│   Processing │───▶│   Storage       │    |
│  │             │    │              │    │                 │    │
│  │ • APIs      │    │ • Spark Jobs │    │ • S3 Data Lake  │    │
│  │ • Databases │    │ • Hive       │    │ • Redshift      │    │
│  │ • Files     │    │ • Presto     │    │ • DynamoDB      │    │
│  │ • Streams   │    │ • Jupyter    │    │                 │    │
│  └─────────────┘    └──────────────┘    └─────────────────┘    │
│                                                                │
│  ┌─────────────────────────────────────────────────────────┐   │
│  │              EMR Deployment Options                     │   │
│  │                                                         │   │
│  │  ┌─────────────┐ ┌─────────────┐ ┌─────────────────┐   │   │
│  │  │   EMR on    │ │    EMR      │ │     EMR on      │   │   │
│  │  │     EC2     │ │ Serverless  │ │      EKS        │   │   │
│  │  │             │ │             │ │                 │   │   │
│  │  │ • Custom    │ │ • Auto      │ │ • Container     │   │   │
│  │  │   Config    │ │   Scale     │ │   Native        │   │   │
│  │  │ • Full      │ │ • No Mgmt   │ │ • Kubernetes    │   │   │
│  │  │   Control   │ │ • Pay/Use   │ │   Orchestration │   │   │
│  │  └─────────────┘ └─────────────┘ └─────────────────┘   │   │
│  └─────────────────────────────────────────────────────────┘  │
│                                                               │
│  ┌─────────────────────────────────────────────────────────┐  │
│  │                Management & Monitoring                  │  │
│  │                                                         │  │
│  │ • EMR Studio (Notebooks & Workspaces)                   │  │
│  │ • CloudWatch (Metrics & Logs)                           │  │
│  │ • IAM (Authentication & Authorization)                  │  │
│  │ • VPC (Network Security)                                │  │
│  │ • S3 (Backup & Archival)                                │  │
│  └─────────────────────────────────────────────────────────┘  │
└───────────────────────────────────────────────────────────────┘
```

This comprehensive documentation provides production-ready steps for implementing Amazon EMR in enterprise environments. Each section includes practical examples, code snippets, and best practices for real-world deployment scenarios.