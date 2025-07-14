## AWS Big Data Analytics Architecture - Complete Guide

-----

## Architecture Overview

This document outlines a comprehensive big data analytics architecture using AWS services including EMR Serverless, EKS, ECS, S3, Glue, and Athena for processing and analyzing product review data.

## Architecture Diagram Flow

```
Data Sources → S3 (Raw Data) → EMR Serverless/EKS/ECS → S3 (Processed Data) → Glue Crawler → Athena → Analytics
```

-----

## 1\. Infrastructure Setup

### 1.1 S3 Bucket Configuration

**Create S3 Buckets:**

```bash
# Input data bucket
aws s3 mb s3://bigdata-input-bucket-unique-name

# Output data bucket
aws s3 mb s3://bigdata-output-bucket-unique-name

# Scripts bucket
aws s3 mb s3://bigdata-scripts-bucket-unique-name
```

**Bucket Structure:**

```
bigdata-input-bucket/
├── raw-data/
│   ├── reviews/
│   ├── products/
│   └── categories/
└── scripts/

bigdata-output-bucket/
├── processed-data/
│   ├── parquet/
│   │   ├── reviews/
│   │   ├── products/
│   │   └── categories/
│   └── aggregated/
└── logs/
```

### 1.2 IAM Roles and Policies

**EMR Serverless Role:**

```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "s3:GetObject",
        "s3:PutObject",
        "s3:DeleteObject",
        "s3:ListBucket"
      ],
      "Resource": [
        "arn:aws:s3:::bigdata-*",
        "arn:aws:s3:::bigdata-*/*"
      ]
    }
  ]
}
```

-----

## 2\. EMR Serverless Setup

### 2.1 Create EMR Serverless Application

**Step 1: Get Started with EMR Serverless**

```bash
aws emr-serverless create-application \
    --name "BigDataAnalytics" \
    --type "SPARK" \
    --release-label "emr-6.10.0"
```

**Step 2: Configure Application**

  - Runtime: Spark 3.3.0
  - Architecture: x86\_64
  - Maximum capacity: 10 vCPU, 40 GB memory

### 2.2 Submit ETL Job

**Job Configuration:**

```bash
aws emr-serverless start-job-run \
    --application-id "your-app-id" \
    --execution-role-arn "arn:aws:iam::account:role/EMRServerlessRole" \
    --job-driver '{
        "sparkSubmit": {
            "entryPoint": "s3://bigdata-scripts-bucket/reviews_etl.py",
            "entryPointArguments": [
                "--input-path", "s3://bigdata-input-bucket/raw-data/",
                "--output-path", "s3://bigdata-output-bucket/processed-data/"
            ],
            "sparkSubmitParameters": "--conf spark.executor.cores=2 --conf spark.executor.memory=4g"
        }
    }'
```

### 2.3 ETL Script (reviews\_etl.py)

**Upload to S3:**

```python
from pyspark.sql import SparkSession
from pyspark.sql.functions import *
from pyspark.sql.types import *
import argparse

def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("--input-path", required=True)
    parser.add_argument("--output-path", required=True)
    args = parser.parse_args()
    
    spark = SparkSession.builder.appName("ReviewsETL").getOrCreate()
    
    # Read JSON data
    reviews_df = spark.read.json(f"{args.input_path}/reviews/")
    
    # Data transformations
    processed_df = reviews_df.select(
        col("product_id"),
        col("product_category"),
        col("star_rating").cast("integer").alias("stars"),
        col("review_body"),
        col("review_date"),
        col("verified_purchase")
    ).filter(col("stars").isNotNull())
    
    # Write as Parquet
    processed_df.write.mode("overwrite").parquet(f"{args.output_path}/parquet/reviews/")
    
    spark.stop()

if __name__ == "__main__":
    main()
```

-----

## 3\. EKS Cluster Setup

### 3.1 Create EKS Cluster Step by Step

**Step 1: Create VPC and Subnets**

```bash
# Create VPC
aws ec2 create-vpc --cidr-block 10.0.0.0/16 --tag-specifications 'ResourceType=vpc,Tags=[{Key=Name,Value=EKS-VPC}]'

# Create Public Subnet
aws ec2 create-subnet --vpc-id vpc-xxx --cidr-block 10.0.1.0/24 --availability-zone us-east-1a

# Create Private Subnet
aws ec2 create-subnet --vpc-id vpc-xxx --cidr-block 10.0.2.0/24 --availability-zone us-east-1b
```

**Step 2: Create EKS Cluster**

```bash
aws eks create-cluster \
    --name bigdata-cluster \
    --version 1.27 \
    --role-arn arn:aws:iam::account:role/EKSClusterRole \
    --resources-vpc-config subnetIds=subnet-xxx,subnet-yyy,securityGroupIds=sg-xxx
```

**Step 3: Create Node Group**

```bash
aws eks create-nodegroup \
    --cluster-name bigdata-cluster \
    --nodegroup-name workers \
    --subnets subnet-xxx subnet-yyy \
    --instance-types m5.large \
    --ami-type AL2_x86_64 \
    --node-role arn:aws:iam::account:role/EKSNodeRole \
    --scaling-config minSize=1,maxSize=3,desiredSize=2
```

### 3.2 Deploy Spark on EKS

**Kubernetes Deployment:**

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: spark-driver
spec:
  replicas: 1
  selector:
    matchLabels:
      app: spark-driver
  template:
    metadata:
      labels:
        app: spark-driver
    spec:
      containers:
      - name: spark
        image: apache/spark:3.3.0
        command: ["/opt/spark/bin/spark-submit"]
        args:
          - "--class"
          - "org.apache.spark.examples.SparkPi"
          - "/opt/spark/examples/jars/spark-examples_2.12-3.3.0.jar"
```

-----

## 4\. ECS Configuration

### 4.1 Create ECS Cluster

**Step 1: Create ECS Cluster**

```bash
aws ecs create-cluster --cluster-name bigdata-ecs-cluster
```

**Step 2: Task Definition**

```json
{
  "family": "bigdata-task",
  "taskRoleArn": "arn:aws:iam::account:role/ECSTaskRole",
  "executionRoleArn": "arn:aws:iam::account:role/ECSExecutionRole",
  "networkMode": "awsvpc",
  "requiresCompatibilities": ["FARGATE"],
  "cpu": "1024",
  "memory": "2048",
  "containerDefinitions": [
    {
      "name": "spark-container",
      "image": "apache/spark:3.3.0",
      "essential": true,
      "logConfiguration": {
        "logDriver": "awslogs",
        "options": {
          "awslogs-group": "/ecs/bigdata-task",
          "awslogs-region": "us-east-1",
          "awslogs-stream-prefix": "ecs"
        }
      }
    }
  ]
}
```

-----

## 5\. Data Processing Pipeline

### 5.1 Batch Job Execution

**Cron Job Setup:**

```bash
# Edit crontab
crontab -e

# Add job to run daily at 2 AM
0 2 * * * /home/user/scripts/run_etl_job.sh
```

**Backup Script (run\_etl\_job.sh):**

```bash
#!/bin/bash

# Set credentials
export AWS_ACCESS_KEY_ID="your-access-key"
export AWS_SECRET_ACCESS_KEY="your-secret-key"
export AWS_DEFAULT_REGION="us-east-1"

# Backup previous data
aws s3 sync s3://bigdata-output-bucket/processed-data/ s3://bigdata-backup-bucket/$(date +%Y-%m-%d)/

# Submit EMR Serverless job
JOB_RUN_ID=$(aws emr-serverless start-job-run \
    --application-id "your-app-id" \
    --execution-role-arn "arn:aws:iam::account:role/EMRServerlessRole" \
    --job-driver '{
        "sparkSubmit": {
            "entryPoint": "s3://bigdata-scripts-bucket/reviews_etl.py",
            "entryPointArguments": ["--input-path", "s3://bigdata-input-bucket/raw-data/", "--output-path", "s3://bigdata-output-bucket/processed-data/"]
        }
    }' --query 'jobRunId' --output text)

echo "Job submitted with ID: $JOB_RUN_ID"
```

-----

## 6\. AWS Glue Setup

### 6.1 Create Glue Database

```bash
aws glue create-database \
    --database-input '{
        "Name": "reviews_database",
        "Description": "Database for product reviews analytics"
    }'
```

### 6.2 Configure Glue Crawler

**Step 1: Create IAM Role for Crawler**

```json
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "s3:GetObject",
                "s3:PutObject",
                "glue:*"
            ],
            "Resource": "*"
        }
    ]
}
```

**Step 2: Create Data Crawler**

```bash
aws glue create-crawler \
    --name "reviews-data-crawler" \
    --role "arn:aws:iam::account:role/GlueCrawlerRole" \
    --targets '{
        "S3Targets": [
            {
                "Path": "s3://bigdata-output-bucket/processed-data/parquet/"
            }
        ]
    }' \
    --database-name "reviews_database" \
    --configuration '{
        "Version": 1.0,
        "CrawlerOutput": {
            "Partitions": {
                "AddOrUpdateBehavior": "InheritFromTable"
            }
        }
    }'
```

**Step 3: Create Metadata Crawler**

```bash
aws glue create-crawler \
    --name "reviews-metadata-crawler" \
    --role "arn:aws:iam::account:role/GlueCrawlerRole" \
    --targets '{
        "S3Targets": [
            {
                "Path": "s3://bigdata-input-bucket/raw-data/"
            }
        ]
    }' \
    --database-name "reviews_database"
```

**Step 4: Run Crawlers**

```bash
aws glue start-crawler --name "reviews-data-crawler"
aws glue start-crawler --name "reviews-metadata-crawler"
```

-----

## 7\. Athena Configuration

### 7.1 Setup Athena

**Step 1: Create Athena Workgroup**

```bash
aws athena create-work-group \
    --name "BigDataAnalytics" \
    --configuration '{
        "ResultConfiguration": {
            "OutputLocation": "s3://bigdata-output-bucket/athena-results/"
        }
    }'
```

**Step 2: Create Data Source**

  - Data Source: AWS Glue Data Catalog
  - Database: reviews\_database
  - Tables: Automatically discovered by Glue Crawler

### 7.2 Why Parquet Files?

**Benefits of Parquet:**

1.  **Columnar Storage**: Efficient for analytical queries
2.  **Compression**: Reduces storage costs by 75-90%
3.  **Schema Evolution**: Handles changing data schemas
4.  **Performance**: 10x faster queries compared to JSON
5.  **Athena Optimization**: Native support for predicate pushdown

### 7.3 Schema Discovery

**Method 1: Using AWS Glue Crawler**

```bash
# Crawler automatically detects schema
aws glue get-table --database-name reviews_database --name reviews
```

**Method 2: Manual Schema Detection in Athena**

```sql
-- Create external table to discover schema
CREATE EXTERNAL TABLE reviews_temp (
    product_id string,
    product_category string,
    stars int,
    review_body string,
    review_date string,
    verified_purchase boolean
)
STORED AS PARQUET
LOCATION 's3://bigdata-output-bucket/processed-data/parquet/reviews/';

-- Describe table to see schema
DESCRIBE reviews_temp;
```

**Method 3: Using AWS CLI**

```bash
# Get schema from Glue Data Catalog
aws glue get-table \
    --database-name reviews_database \
    --name reviews \
    --query 'Table.StorageDescriptor.Columns'
```

-----

## 8\. Business Questions & Analytics Queries

### 8.1 Key Business Questions

**Customer Satisfaction Analysis:**

  - Which product categories have the highest customer satisfaction?
  - What are the common complaints in low-rated reviews?
  - How does verified purchase impact review ratings?

**Product Performance:**

  - Which products consistently receive 5-star ratings?
  - What categories have the most polarized reviews (high 1-star and 5-star)?
  - How do seasonal trends affect review patterns?

**Market Intelligence:**

  - Which competitor products are gaining/losing market share?
  - What features do customers value most in positive reviews?
  - How do pricing changes correlate with review sentiment?

**Operational Insights:**

  - Which product categories require immediate attention?
  - What is the review response rate for different product launches?
  - How do regional preferences vary across product categories?

### 8.2 Advanced Analytics Queries

-----

#### 1\. Average Rating per Product Category

This query calculates the average rating and total reviews for each product category, along with a satisfaction rate based on reviews with 4 or more stars. The results are ordered by average rating in descending order.

```sql
SELECT
    p.product_category,
    ROUND(SUM(CASE
                WHEN s.stars = 1 THEN 1*s.number_of_reviews
                WHEN s.stars = 2 THEN 2*s.number_of_reviews
                WHEN s.stars = 3 THEN 3*s.number_of_reviews
                WHEN s.stars = 4 THEN 4*s.number_of_reviews
                WHEN s.stars = 5 THEN 5*s.number_of_reviews
              END) / SUM(s.number_of_reviews), 2) AS avg_rating,
    SUM(s.number_of_reviews) AS total_reviews,
    ROUND(100.0 * SUM(CASE WHEN s.stars >= 4 THEN s.number_of_reviews ELSE 0 END) / SUM(s.number_of_reviews), 2) AS satisfaction_rate
FROM product_category_star_ratings s
JOIN product_category_review_counts p
    ON s.product_category = p.product_category
GROUP BY p.product_category
ORDER BY avg_rating DESC;
```

-----

#### 2\. Categories with Most 1-Star Reviews

This query identifies the top 15 product categories with the highest number of 1-star reviews. It also calculates the percentage of 1-star reviews within each of those categories. This can help pinpoint problem areas.

```sql
SELECT
    product_category,
    number_of_reviews AS one_star_count,
    ROUND(100.0 * number_of_reviews / (
        SELECT SUM(number_of_reviews)
        FROM product_category_star_ratings
        WHERE product_category = pcsr.product_category
    ), 2) AS one_star_percentage
FROM product_category_star_ratings pcsr
WHERE stars = 1
ORDER BY one_star_count DESC
LIMIT 15;
```

-----

#### 3\. Top 10 Most Reviewed Product Categories

This query lists the top 10 product categories based on the total number of reviews, providing a rank for each. This helps understand which categories are most popular or generate the most feedback.

```sql
SELECT
    product_category,
    number_of_reviews AS total_reviews,
    RANK() OVER (ORDER BY number_of_reviews DESC) as review_rank
FROM product_category_review_counts
ORDER BY total_reviews DESC
LIMIT 10;
```

-----

#### 4\. Categories with Low Rating but High Review Count

This query identifies product categories that have a significant number of reviews (more than 1000) but a low average rating (less than 2.5). These categories represent critical issues that likely require immediate attention due to their poor customer satisfaction despite high engagement.

```sql
WITH category_ratings AS (
    SELECT
        s.product_category,
        SUM(s.number_of_reviews) AS total_reviews,
        ROUND(
            SUM(CASE
                  WHEN s.stars = 1 THEN 1*s.number_of_reviews
                  WHEN s.stars = 2 THEN 2*s.number_of_reviews
                  WHEN s.stars = 3 THEN 3*s.number_of_reviews
                  WHEN s.stars = 4 THEN 4*s.number_of_reviews
                  WHEN s.stars = 5 THEN 5*s.number_of_reviews
                END) / SUM(s.number_of_reviews), 2
        ) AS avg_rating
    FROM product_category_star_ratings s
    GROUP BY s.product_category
)
SELECT
    product_category,
    total_reviews,
    avg_rating,
    'HIGH_PRIORITY' as action_required
FROM category_ratings
WHERE total_reviews > 1000 AND avg_rating < 2.5
ORDER BY total_reviews DESC;
```

-----

#### 8.2.2 Trend Analysis Queries

```sql
-- 5. Monthly Review Trends
SELECT
    EXTRACT(YEAR FROM CAST(review_date AS DATE)) as review_year,
    EXTRACT(MONTH FROM CAST(review_date AS DATE)) as review_month,
    product_category,
    COUNT(*) as monthly_reviews,
    AVG(CAST(stars AS DOUBLE)) as avg_monthly_rating
FROM reviews
WHERE review_date IS NOT NULL
GROUP BY
    EXTRACT(YEAR FROM CAST(review_date AS DATE)),
    EXTRACT(MONTH FROM CAST(review_date AS DATE)),
    product_category
ORDER BY review_year DESC, review_month DESC, monthly_reviews DESC;

-- 6. Seasonal Pattern Analysis
SELECT
    CASE
        WHEN EXTRACT(MONTH FROM CAST(review_date AS DATE)) IN (12, 1, 2) THEN 'Winter'
        WHEN EXTRACT(MONTH FROM CAST(review_date AS DATE)) IN (3, 4, 5) THEN 'Spring'
        WHEN EXTRACT(MONTH FROM CAST(review_date AS DATE)) IN (6, 7, 8) THEN 'Summer'
        WHEN EXTRACT(MONTH FROM CAST(review_date AS DATE)) IN (9, 10, 11) THEN 'Fall'
    END as season,
    product_category,
    COUNT(*) as seasonal_reviews,
    AVG(CAST(stars AS DOUBLE)) as avg_seasonal_rating,
    SUM(CASE WHEN verified_purchase = true THEN 1 ELSE 0 END) as verified_reviews
FROM reviews
WHERE review_date IS NOT NULL
GROUP BY
    CASE
        WHEN EXTRACT(MONTH FROM CAST(review_date AS DATE)) IN (12, 1, 2) THEN 'Winter'
        WHEN EXTRACT(MONTH FROM CAST(review_date AS DATE)) IN (3, 4, 5) THEN 'Spring'
        WHEN EXTRACT(MONTH FROM CAST(review_date AS DATE)) IN (6, 7, 8) THEN 'Summer'
        WHEN EXTRACT(MONTH FROM CAST(review_date AS DATE)) IN (9, 10, 11) THEN 'Fall'
    END,
    product_category
ORDER BY seasonal_reviews DESC;
```

-----

#### 8.2.3 Product Performance Queries

```sql
-- 7. Top Performing Products by Category
WITH product_performance AS (
    SELECT
        product_id,
        product_category,
        COUNT(*) as total_reviews,
        AVG(CAST(stars AS DOUBLE)) as avg_rating,
        SUM(CASE WHEN stars >= 4 THEN 1 ELSE 0 END) as positive_reviews,
        SUM(CASE WHEN stars <= 2 THEN 1 ELSE 0 END) as negative_reviews
    FROM reviews
    GROUP BY product_id, product_category
    HAVING COUNT(*) >= 10
)
SELECT
    product_category,
    product_id,
    total_reviews,
    ROUND(avg_rating, 2) as avg_rating,
    ROUND(100.0 * positive_reviews / total_reviews, 2) as positive_rate,
    ROUND(100.0 * negative_reviews / total_reviews, 2) as negative_rate,
    ROW_NUMBER() OVER (PARTITION BY product_category ORDER BY avg_rating DESC, total_reviews DESC) as category_rank
FROM product_performance
WHERE avg_rating >= 4.0
ORDER BY product_category, category_rank;

-- 8. Underperforming Products Requiring Attention
SELECT
    product_category,
    product_id,
    COUNT(*) as total_reviews,
    AVG(CAST(stars AS DOUBLE)) as avg_rating,
    SUM(CASE WHEN stars = 1 THEN 1 ELSE 0 END) as one_star_reviews,
    ROUND(100.0 * SUM(CASE WHEN stars = 1 THEN 1 ELSE 0 END) / COUNT(*), 2) as one_star_rate
FROM reviews
GROUP BY product_id, product_category
HAVING COUNT(*) >= 20 AND AVG(CAST(stars AS DOUBLE)) < 2.5
ORDER BY avg_rating ASC, total_reviews DESC;
```

-----

#### 8.2.4 Customer Behavior Analysis

```sql
-- 9. Verified vs Non-Verified Purchase Analysis
SELECT
    product_category,
    verified_purchase,
    COUNT(*) as review_count,
    AVG(CAST(stars AS DOUBLE)) as avg_rating,
    ROUND(100.0 * SUM(CASE WHEN stars >= 4 THEN 1 ELSE 0 END) / COUNT(*), 2) as satisfaction_rate
FROM reviews
GROUP BY product_category, verified_purchase
ORDER BY product_category, verified_purchase;

-- 10. Review Length Impact on Ratings
WITH review_analysis AS (
    SELECT
        product_category,
        stars,
        LENGTH(review_body) as review_length,
        CASE
            WHEN LENGTH(review_body) < 50 THEN 'Short'
            WHEN LENGTH(review_body) BETWEEN 50 AND 200 THEN 'Medium'
            WHEN LENGTH(review_body) > 200 THEN 'Long'
        END as review_type
    FROM reviews
    WHERE review_body IS NOT NULL
)
SELECT
    product_category,
    review_type,
    COUNT(*) as review_count,
    AVG(CAST(stars AS DOUBLE)) as avg_rating,
    MIN(review_length) as min_length,
    MAX(review_length) as max_length,
    AVG(review_length) as avg_length
FROM review_analysis
GROUP BY product_category, review_type
ORDER BY product_category, avg_rating DESC;
```

-----

#### 8.2.5 Market Intelligence Queries

```sql
-- 11. Competitive Analysis - Rating Distribution
SELECT
    product_category,
    stars,
    COUNT(*) as review_count,
    ROUND(100.0 * COUNT(*) / SUM(COUNT(*)) OVER (PARTITION BY product_category), 2) as percentage
FROM reviews
GROUP BY product_category, stars
ORDER BY product_category, stars DESC;

-- 12. Category Growth Analysis
WITH monthly_growth AS (
    SELECT
        product_category,
        EXTRACT(YEAR FROM CAST(review_date AS DATE)) as year,
        EXTRACT(MONTH FROM CAST(review_date AS DATE)) as month,
        COUNT(*) as monthly_reviews
    FROM reviews
    WHERE review_date IS NOT NULL
    GROUP BY
        product_category,
        EXTRACT(YEAR FROM CAST(review_date AS DATE)),
        EXTRACT(MONTH FROM CAST(review_date AS DATE))
),
growth_calc AS (
    SELECT
        *,
        LAG(monthly_reviews, 1) OVER (PARTITION BY product_category ORDER BY year, month) as prev_month_reviews
    FROM monthly_growth
)
SELECT
    product_category,
    year,
    month,
    monthly_reviews,
    prev_month_reviews,
    CASE
        WHEN prev_month_reviews > 0 THEN
            ROUND(100.0 * (monthly_reviews - prev_month_reviews) / prev_month_reviews, 2)
        ELSE NULL
    END as growth_rate
FROM growth_calc
WHERE prev_month_reviews IS NOT NULL
ORDER BY product_category, year DESC, month DESC;
```

-----

#### 8.2.6 Operational Insights Queries

```sql
-- 13. Review Response Time Analysis
SELECT
    product_category,
    AVG(DATEDIFF('day', CAST(review_date AS DATE), CURRENT_DATE)) as avg_days_since_review,
    COUNT(CASE WHEN DATEDIFF('day', CAST(review_date AS DATE), CURRENT_DATE) <= 7 THEN 1 END) as recent_reviews,
    COUNT(CASE WHEN DATEDIFF('day', CAST(review_date AS DATE), CURRENT_DATE) > 30 THEN 1 END) as old_reviews
FROM reviews
WHERE review_date IS NOT NULL
GROUP BY product_category
ORDER BY avg_days_since_review;

-- 14. Quality Metrics Dashboard
SELECT
    product_category,
    COUNT(DISTINCT product_id) as unique_products,
    COUNT(*) as total_reviews,
    AVG(CAST(stars AS DOUBLE)) as avg_rating,
    ROUND(100.0 * SUM(CASE WHEN stars >= 4 THEN 1 ELSE 0 END) / COUNT(*), 2) as satisfaction_rate,
    ROUND(100.0 * SUM(CASE WHEN stars = 1 THEN 1 ELSE 0 END) / COUNT(*), 2) as dissatisfaction_rate,
    SUM(CASE WHEN verified_purchase = true THEN 1 ELSE 0 END) as verified_reviews,
    ROUND(100.0 * SUM(CASE WHEN verified_purchase = true THEN 1 ELSE 0 END) / COUNT(*), 2) as verification_rate
FROM reviews
GROUP BY product_category
ORDER BY satisfaction_rate DESC;

-- 15. Anomaly Detection - Unusual Review Patterns
WITH category_stats AS (
    SELECT
        product_category,
        AVG(CAST(stars AS DOUBLE)) as avg_rating,
        STDDEV(CAST(stars AS DOUBLE)) as rating_stddev,
        COUNT(*) as total_reviews
    FROM reviews
    GROUP BY product_category
),
product_stats AS (
    SELECT
        r.product_id,
        r.product_category,
        AVG(CAST(r.stars AS DOUBLE)) as product_avg_rating,
        COUNT(*) as product_reviews
    FROM reviews r
    GROUP BY r.product_id, r.product_category
    HAVING COUNT(*) >= 10
)
SELECT
    ps.product_category,
    ps.product_id,
    ps.product_avg_rating,
    cs.avg_rating as category_avg_rating,
    ABS(ps.product_avg_rating - cs.avg_rating) as rating_deviation,
    ps.product_reviews,
    CASE
        WHEN ABS(ps.product_avg_rating - cs.avg_rating) > (2 * cs.rating_stddev) THEN 'ANOMALY'
        WHEN ABS(ps.product_avg_rating - cs.avg_rating) > cs.rating_stddev THEN 'OUTLIER'
        ELSE 'NORMAL'
    END as anomaly_status
FROM product_stats ps
JOIN category_stats cs ON ps.product_category = cs.product_category
WHERE ABS(ps.product_avg_rating - cs.avg_rating) > cs.rating_stddev
ORDER BY rating_deviation DESC;
```

-----

### 8.3 Performance Optimization Queries

```sql
-- 16. Partitioned Query for Large Datasets
SELECT
    product_category,
    stars,
    COUNT(*) as review_count
FROM reviews
WHERE year = '2024' AND month = '12'  -- Partition pruning
GROUP BY product_category, stars
ORDER BY product_category, stars;

-- 17. Optimized Join Query with Broadcast Hint
SELECT /*+ BROADCAST(p) */
    r.product_category,
    p.product_name,
    COUNT(*) as review_count,
    AVG(CAST(r.stars AS DOUBLE)) as avg_rating
FROM reviews r
JOIN products p ON r.product_id = p.product_id
WHERE r.review_date >= '2024-01-01'
GROUP BY r.product_category, p.product_name
ORDER BY review_count DESC;
```

-----

### 8.4 Real-time Monitoring Queries

```sql
-- 18. Daily Review Volume Monitoring
SELECT
    DATE(review_date) as review_date,
    product_category,
    COUNT(*) as daily_reviews,
    AVG(CAST(stars AS DOUBLE)) as daily_avg_rating,
    SUM(CASE WHEN stars <= 2 THEN 1 ELSE 0 END) as negative_reviews_today
FROM reviews
WHERE DATE(review_date) >= DATE_ADD('day', -7, CURRENT_DATE)
GROUP BY DATE(review_date), product_category
ORDER BY review_date DESC, daily_reviews DESC;

-- 19. Alert Query for Sudden Rating Drops
WITH daily_ratings AS (
    SELECT
        DATE(review_date) as review_date,
        product_category,
        AVG(CAST(stars AS DOUBLE)) as daily_rating,
        COUNT(*) as daily_count
    FROM reviews
    WHERE review_date >= DATE_ADD('day', -14, CURRENT_DATE)
    GROUP BY DATE(review_date), product_category
    HAVING COUNT(*) >= 5
),
rating_changes AS (
    SELECT
        *,
        LAG(daily_rating, 1) OVER (PARTITION BY product_category ORDER BY review_date) as prev_day_rating
    FROM daily_ratings
)
SELECT
    product_category,
    review_date,
    daily_rating,
    prev_day_rating,
    (daily_rating - prev_day_rating) as rating_change,
    daily_count,
    'ALERT: Significant Rating Drop' as alert_message
FROM rating_changes
WHERE (daily_rating - prev_day_rating) <= -1.0 AND daily_count >= 10
ORDER BY rating_change ASC;

-- 20. Weekly Performance Summary
SELECT
    YEAR(review_date) as year,
    WEEK(review_date) as week,
    product_category,
    COUNT(*) as weekly_reviews,
    AVG(CAST(stars AS DOUBLE)) as weekly_avg_rating,
    SUM(CASE WHEN stars >= 4 THEN 1 ELSE 0 END) as positive_reviews,
    SUM(CASE WHEN stars <= 2 THEN 1 ELSE 0 END) as negative_reviews,
    ROUND(100.0 * SUM(CASE WHEN verified_purchase = true THEN 1 ELSE 0 END) / COUNT(*), 2) as verification_rate
FROM reviews
WHERE review_date >= DATE_ADD('week', -4, CURRENT_DATE)
GROUP BY YEAR(review_date), WEEK(review_date), product_category
ORDER BY year DESC, week DESC, weekly_reviews DESC;
```

-----

### 8.5 Business Intelligence Reporting Queries

```sql
-- 21. Executive Dashboard Summary
SELECT
    'Total Reviews' as metric,
    COUNT(*)::VARCHAR as value,
    'All Time' as period
FROM reviews
UNION ALL
SELECT
    'Average Rating' as metric,
    ROUND(AVG(CAST(stars AS DOUBLE)), 2)::VARCHAR as value,
    'All Time' as period
FROM reviews
UNION ALL
SELECT
    'Categories Analyzed' as metric,
    COUNT(DISTINCT product_category)::VARCHAR as value,
    'All Time' as period
FROM reviews
UNION ALL
SELECT
    'Products Reviewed' as metric,
    COUNT(DISTINCT product_id)::VARCHAR as value,
    'All Time' as period
FROM reviews
UNION ALL
SELECT
    'Reviews This Month' as metric,
    COUNT(*)::VARCHAR as value,
    'Current Month' as period
FROM reviews
WHERE EXTRACT(YEAR FROM CAST(review_date AS DATE)) = EXTRACT(YEAR FROM CURRENT_DATE)
  AND EXTRACT(MONTH FROM CAST(review_date AS DATE)) = EXTRACT(MONTH FROM CURRENT_DATE);

-- 22. Category Performance Scorecard
WITH category_metrics AS (
    SELECT
        product_category,
        COUNT(*) as total_reviews,
        AVG(CAST(stars AS DOUBLE)) as avg_rating,
        COUNT(DISTINCT product_id) as unique_products,
        SUM(CASE WHEN stars >= 4 THEN 1 ELSE 0 END) as satisfied_customers,
        SUM(CASE WHEN stars <= 2 THEN 1 ELSE 0 END) as dissatisfied_customers,
        SUM(CASE WHEN verified_purchase = true THEN 1 ELSE 0 END) as verified_reviews
    FROM reviews
    GROUP BY product_category
)
SELECT
    product_category,
    total_reviews,
    unique_products,
    ROUND(avg_rating, 2) as avg_rating,
    ROUND(100.0 * satisfied_customers / total_reviews, 1) as satisfaction_rate,
    ROUND(100.0 * dissatisfied_customers / total_reviews, 1) as dissatisfaction_rate,
    ROUND(100.0 * verified_reviews / total_reviews, 1) as verification_rate,
    CASE
        WHEN avg_rating >= 4.5 AND (100.0 * satisfied_customers / total_reviews) >= 80 THEN 'EXCELLENT'
        WHEN avg_rating >= 4.0 AND (100.0 * satisfied_customers / total_reviews) >= 70 THEN 'GOOD'
        WHEN avg_rating >= 3.0 AND (100.0 * satisfied_customers / total_reviews) >= 50 THEN 'AVERAGE'
        ELSE 'NEEDS_IMPROVEMENT'
    END as performance_grade
FROM category_metrics
ORDER BY avg_rating DESC, total_reviews DESC;

-- 23. Product Recommendation Query
SELECT
    product_category,
    product_id,
    COUNT(*) as review_count,
    AVG(CAST(stars AS DOUBLE)) as avg_rating,
    ROUND(100.0 * SUM(CASE WHEN stars >= 4 THEN 1 ELSE 0 END) / COUNT(*), 1) as satisfaction_rate,
    ROUND(100.0 * SUM(CASE WHEN verified_purchase = true THEN 1 ELSE 0 END) / COUNT(*), 1) as verification_rate,
    'RECOMMENDED' as recommendation_status
FROM reviews
GROUP BY product_category, product_id
HAVING COUNT(*) >= 50
   AND AVG(CAST(stars AS DOUBLE)) >= 4.0
   AND (100.0 * SUM(CASE WHEN stars >= 4 THEN 1 ELSE 0 END) / COUNT(*)) >= 75
ORDER BY product_category, avg_rating DESC, review_count DESC;

-- 24. Customer Loyalty Analysis
WITH customer_behavior AS (
    SELECT
        product_category,
        CASE
            WHEN stars >= 4 THEN 'Promoter'
            WHEN stars = 3 THEN 'Passive'
            ELSE 'Detractor'
        END as customer_type,
        verified_purchase
    FROM reviews
)
SELECT
    product_category,
    customer_type,
    COUNT(*) as customer_count,
    ROUND(100.0 * COUNT(*) / SUM(COUNT(*)) OVER (PARTITION BY product_category), 2) as percentage,
    SUM(CASE WHEN verified_purchase = true THEN 1 ELSE 0 END) as verified_customers
FROM customer_behavior
GROUP BY product_category, customer_type
ORDER BY product_category, customer_count DESC;

-- 25. Text Analytics Preparation Query
SELECT
    product_category,
    stars,
    verified_purchase,
    LENGTH(review_body) as review_length,
    CASE
        WHEN review_body LIKE '%excellent%' OR review_body LIKE '%amazing%' OR review_body LIKE '%perfect%' THEN 'Positive Keywords'
        WHEN review_body LIKE '%terrible%' OR review_body LIKE '%awful%' OR review_body LIKE '%worst%' THEN 'Negative Keywords'
        WHEN review_body LIKE '%quality%' THEN 'Quality Mention'
        WHEN review_body LIKE '%price%' OR review_body LIKE '%cost%' OR review_body LIKE '%expensive%' THEN 'Price Mention'
        WHEN review_body LIKE '%shipping%' OR review_body LIKE '%delivery%' THEN 'Shipping Mention'
        ELSE 'General Review'
    END as review_theme,
    review_body
FROM reviews
WHERE LENGTH(review_body) > 20
ORDER BY product_category, stars, review_length DESC;
```

-----

### 8.6 Advanced Analytics & Machine Learning Prep

```sql
-- 26. Feature Engineering for ML Models
SELECT
    product_id,
    product_category,
    AVG(CAST(stars AS DOUBLE)) as avg_rating,
    COUNT(*) as review_count,
    SUM(CASE WHEN stars = 5 THEN 1 ELSE 0 END) as five_star_count,
    SUM(CASE WHEN stars = 1 THEN 1 ELSE 0 END) as one_star_count,
    AVG(LENGTH(review_body)) as avg_review_length,
    ROUND(100.0 * SUM(CASE WHEN verified_purchase = true THEN 1 ELSE 0 END) / COUNT(*), 2) as verification_rate,
    STDDEV(CAST(stars AS DOUBLE)) as rating_variance,
    DATEDIFF('day', MIN(CAST(review_date AS DATE)), MAX(CAST(review_date AS DATE))) as review_span_days
FROM reviews
WHERE review_body IS NOT NULL AND review_date IS NOT NULL
GROUP BY product_id, product_category
HAVING COUNT(*) >= 10
ORDER BY product_category;
```