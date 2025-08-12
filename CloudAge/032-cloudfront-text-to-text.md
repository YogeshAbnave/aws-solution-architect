# AWS SageMaker AI Deployment Guide

## Complete GenAI Backend and Frontend Setup

### Prerequisites
- AWS Account with appropriate permissions
- Desktop files: `jupyter_notebook.ipynb`, `lambda_function.py`, `generative-ai-api-prod-swagger-apigateway.json`, `index.html`, `logo.jpeg`
- Basic understanding of AWS services

### Pre-Setup Requirements
1. **AWS Account Setup**: Create an AWS account if you don't already have one
2. **IAM Role Configuration**: Navigate to the IAM Console to set up a role with SageMaker permissions: Create a new IAM role with the AmazonSageMakerFullAccess managed policy. Attach an S3 full-access policy to enable data storage and retrieval
3. **Enable IAM Identity Center**: Enable IAM Identity Center in the same AWS Region where you'll deploy SageMaker

---

## Step 1: Amazon SageMaker AI Setup

### 1.1 Domain and User Setup
1. **Login to AWS Console** and navigate to **Amazon SageMaker AI**
2. **Set up SageMaker Domain**: The process involves setting up a SageMaker domain, creating user profiles with appropriate permissions, and establishing shared spaces for collaborative work
3. **Create User Profile**: Go to Studio and create a new user with default settings
4. **Configure Access Controls**: The admin sets up the SageMaker Unified Studio domain for the user and sets the access controls

### 1.2 Studio Launch and JupyterLab Configuration
1. **Launch Studio**: Launch SageMaker Studio and access its various features, including data preparation tools, pre-trained models
2. **Create JupyterLab Space** with default configuration:
   - Instance: `ml.t3.medium`
   - Storage: `5GB`
   - Kernel: Python 3 (Data Science)

### 1.3 Jupyter Notebook Setup
1. **Open Jupyter Notebook** in the launched environment
2. **Import** the `jupyter_notebook.ipynb` file from your desktop
3. **Execute the code** starting from Step 2 through Step 3 at minimum
4. **Continue running** all subsequent code sections
5. **Deploy Model**: Upload artifacts — Package model artifacts like weights and hyperparameters in a .tar.gz file and upload to S3

### 1.4 Model Endpoint Creation
1. **Navigate to SageMaker Console** → **Inference** → **Endpoints**
2. **Deploy Model**: When choosing the model, click on Deploy and SageMaker will get everything ready for you. You can adjust the endpoint to your needs but for this tutorial, you can totally go with the defaults
3. **Wait for Status**: As soon as the model shows its status as In service, everything is ready to be used
4. **Copy Endpoint Name**: copy the name of your deployed endpoint from SageMaker>Inference>endpoints from SageMaker Console

---

## Step 2: AWS Lambda Function Configuration

### 2.1 Lambda Function Creation
1. **Navigate to AWS Lambda** and create a new function
2. **Configure runtime**: Select Python 3.11
3. **Function Name**: Use a descriptive name following your organization's naming convention
4. **Execution Role**: Choose "Create a new role with basic Lambda permissions" or use existing role

### 2.2 IAM Role and Permissions Setup
1. **Ensure the IAM role** has `AmazonSageMakerFullAccess` policy attached
2. **Add SageMaker Invoke Endpoint permissions**: The role needs permissions to invoke SageMaker endpoints
3. **Verify permissions** for API Gateway or your organization's specific policy
4. **Additional Required Policies**:
   - `AWSLambdaBasicExecutionRole`
   - `AmazonSageMakerReadOnly` (minimum required)

### 2.3 Lambda Code Deployment
1. **Copy the code** from the desktop file `lambda_function.py`
2. **Paste it** into the Lambda code editor
3. **Key Lambda Function Components**:
   - Import boto3 for SageMaker runtime
   - Configure SageMaker runtime client
   - Handle JSON parsing for API Gateway requests
   - Implement error handling and logging

### 2.4 Environment Variables Setup
1. **Go to Configurations** → **Environment Variables**
2. **Add Environment Variable**:
   - **Key**: `ENDPOINT_NAME`
   - **Value**: `hf-llm-falcon-7b-instruct-bf16-2025-07-10-07-10-16-076`
   
   > **Best Practice**: Take the endpoint name directly from SageMaker Studio. We will be using the endpoint name while defining the environment variables

3. **Additional Environment Variables** (if needed):
   - `AWS_REGION`: Your deployment region
   - `SAGEMAKER_ENDPOINT_NAME`: Alternative key name

4. **Configure Function Settings**:
   - **Timeout**: Set to 30 seconds (or appropriate for your model)
   - **Memory**: 128 MB minimum, adjust based on processing needs

5. **Deploy the Lambda function**

### 2.5 Testing Lambda Function
1. **Create test event** with sample JSON payload
2. **Test the function** to ensure it can invoke the SageMaker endpoint
3. **Check CloudWatch logs** for any errors or issues

---

## Step 3: API Gateway Configuration

### 3.1 REST API Creation Methods

#### Method 1: Direct API Gateway Setup
1. **Navigate to AWS Console** → **API Gateway**
2. **Choose REST API** (not HTTP API)
3. **Create New API** or **Import API**
4. **Click Import** and upload `generative-ai-api-prod-swagger-apigateway.json`

#### Method 2: Lambda-Triggered API Gateway
1. **In the Lambda Function page**, choose **Add trigger**
2. **In Trigger configuration**, choose **API Gateway** and select **Create a new API**
3. **Under API type** select **REST API**
4. **Under Security** select **Open** and choose **Add**

### 3.2 API Gateway Resource Configuration
1. **Review Resources and Stages** after import
2. **Create Resource** (if not imported):
   - Resource Name: e.g., "predict" or "inference"
   - Resource Path: e.g., "/predict"
3. **Create Method**:
   - Method Type: **POST**
   - Integration Type: **Lambda Function**
   - Use Lambda Proxy Integration: **Enabled**

### 3.3 Integration Setup
1. **From the dropdown** in POST Resource, click **Integration Request**
2. **Replace the Lambda Function** with your newly created Lambda function
3. **Configure Integration**:
   - Lambda Function: Select your function
   - Use Default Timeout: **Unchecked** (set to 29 seconds)
   - Use Lambda Proxy Integration: **Enabled**

### 3.4 CORS Configuration (if needed)
1. **Select Resource** → **Actions** → **Enable CORS**
2. **Configure CORS settings**:
   - Access-Control-Allow-Origin: `*` (or specific domain)
   - Access-Control-Allow-Headers: `Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token`
   - Access-Control-Allow-Methods: `GET,POST,OPTIONS`

### 3.5 API Testing
1. **Test the API** using the built-in test functionality
2. **Create test request** with sample JSON payload
3. **Verify response** from SageMaker endpoint

### 3.6 API Deployment
1. **Deploy API** by clicking **Actions** → **Deploy API**
2. **Create a new stage** or select existing stage
3. **Name the stage** according to your organization's naming convention (e.g., "prod", "dev", "staging")
4. **Copy the Invoke URL** - this will be used in the frontend configuration

### 3.7 API Gateway Security (Optional)
1. **API Key Creation**: Create API keys for access control
2. **Usage Plans**: Set up throttling and quota limits
3. **Authorizers**: Configure Lambda authorizers or Cognito for authentication

> **Milestone**: GenAI Backend is now ready. API Gateway receives input data from the consumer that will contain features for ML inference and pass it to AWS Lambda. Lambda will have a direct connection with the ML model endpoint that is hosted in SageMaker (also serverless), and the prediction will be served back to API Gateway.

---

## Step 4: Frontend Preparation

### 4.1 Local File Configuration
1. **Edit `index.html`** on your desktop
2. **Locate the API Gateway URL variable**:
   ```javascript
   var apiGatewayUrl = "{API_GATEWAY_POST_URL}";
   ```
3. **Replace `{API_GATEWAY_POST_URL}`** with your actual API Gateway invoke URL from Step 3.6
4. **Verify file structure**:
   - Ensure all JavaScript functions are properly configured
   - Check that the POST request format matches your Lambda function expectations
   - Validate HTML form elements are correctly linked

### 4.2 Asset Preparation
1. **Prepare files** for upload: `logo.jpeg` and `index.html`
2. **Optimize images**: Ensure logo.jpeg is web-optimized for faster loading
3. **Validate HTML**: Check for any hardcoded URLs or paths that need updating

### 4.3 S3 Bucket Setup
1. **Create S3 bucket** (if not already created):
   - Bucket name: Follow your organization's naming convention
   - Region: Same as your other AWS resources
   - Block public access: Configure based on your security requirements
2. **Upload files** to S3 bucket:
   - `index.html` (main application file)
   - `logo.jpeg` (application logo)
   - Any additional CSS/JS files if present

### 4.4 S3 Bucket Configuration for Web Hosting
1. **Enable Static Website Hosting**:
   - Properties → Static website hosting → Enable
   - Index document: `index.html`
   - Error document: `index.html` (for SPA behavior)
2. **Configure bucket permissions** (will be refined in CloudFront setup)

---

## Step 5: CloudFront Distribution Setup

### 5.1 Distribution Creation
1. **Navigate to AWS CloudFront**
2. **Create Distribution**
3. **Origin Configuration**:
   - **Origin Domain**: Select your S3 bucket
   - **Origin Access**: Origin Access Control (OAC) - recommended for security
   - **Origin Path**: Leave blank (unless files are in subdirectory)

### 5.2 Distribution Behavior Settings
1. **Default Cache Behavior**:
   - **Viewer Protocol Policy**: Redirect HTTP to HTTPS
   - **Allowed HTTP Methods**: GET, HEAD, OPTIONS, PUT, POST, PATCH, DELETE
   - **Cache Policy**: Managed-CachingOptimized
   - **Origin Request Policy**: Managed-CORS-S3Origin
2. **Compress Objects Automatically**: Yes

### 5.3 Distribution Configuration
1. **Go to CloudFront Distribution** → **General** → **Edit**
2. **Distribution Settings**:
   - **Default Root Object**: Set to `index.html`
   - **Error Pages**: Add custom error response (403, 404 → `/index.html`)
   - **Price Class**: Choose based on your requirements
   - **Supported HTTP Versions**: HTTP/2 and HTTP/3
3. **Security Settings**:
   - **SSL Certificate**: Use CloudFront SSL certificate or custom SSL
   - **Security Headers**: Consider adding security headers policy

### 5.4 Origin Access Control (OAC) Setup
1. **Create OAC** (if not already created):
   - Name: descriptive name for your distribution
   - Signing behavior: Sign requests
   - Origin type: S3
2. **Update S3 bucket policy** with OAC permissions

### 5.5 S3 Bucket Policy Configuration
1. **Go to CloudFront Distribution** → **Origins** → **Edit**
2. **Copy the S3 bucket policy** provided by CloudFront
3. **Navigate to S3 Bucket** → **Permissions** → **Bucket Policy**
4. **Paste the policy** or use the desktop policy template:
   ```json
   {
     "Version": "2012-10-17",
     "Statement": [
       {
         "Sid": "AllowCloudFrontServicePrincipal",
         "Effect": "Allow",
         "Principal": {
           "Service": "cloudfront.amazonaws.com"
         },
         "Action": "s3:GetObject",
         "Resource": "arn:aws:s3:::YOUR-BUCKET-NAME/*",
         "Condition": {
           "StringEquals": {
             "AWS:SourceArn": "arn:aws:cloudfront::ACCOUNT-ID:distribution/DISTRIBUTION-ID"
           }
         }
       }
     ]
   }
   ```
   
   > **Important**: Replace `YOUR-BUCKET-NAME`, `ACCOUNT-ID`, and `DISTRIBUTION-ID` with your actual values

### 5.6 Deployment and Cache Management
1. **Deploy the distribution** (automatic after creation)
2. **Wait for CloudFront Distribution** to deploy to all edge locations
   - Status will change from "Deploying" to "Deployed"
   - This may take 5-15 minutes depending on web application size and global distribution
3. **Create Cache Invalidation**:
   - **Go to CloudFront Distribution** → **Invalidations**
   - **Create Invalidation** → Enter `/*` to invalidate all cached content
   - **Submit** and wait for completion

### 5.7 Testing and Verification
1. **Test the CloudFront URL**: Access the application via the Distribution Domain Name
2. **Verify functionality**:
   - Check that the web application loads correctly
   - Test API calls to ensure they reach your SageMaker endpoint
   - Verify all assets (images, CSS, JS) load properly
3. **Check HTTPS**: Ensure the application works over HTTPS

### 5.8 Performance Optimization
1. **Enable Gzip compression** (should be enabled by default)
2. **Configure caching headers** for static assets
3. **Set up monitoring** with CloudWatch metrics
4. **Consider AWS WAF** for additional security if needed

---

## Final Notes

### Usage Guidelines and Best Practices
- **Ask bigger questions** to test the system effectively
- **Remember**: This is a Foundation Model trained on AWS dataset
- **Alternative models** from Hugging Face can be deployed for different use cases
- **Cost consideration**: Your organization will bear the costs for model usage, endpoint hosting, and API Gateway requests

### Production Readiness Checklist
- [ ] **Security**: Implement proper authentication and authorization
- [ ] **Monitoring**: Set up CloudWatch alarms for Lambda, API Gateway, and SageMaker
- [ ] **Logging**: Configure detailed logging for debugging and auditing
- [ ] **Error Handling**: Implement comprehensive error handling in Lambda function
- [ ] **Rate Limiting**: Configure API Gateway throttling and usage plans
- [ ] **Cost Monitoring**: Set up billing alerts and cost monitoring
- [ ] **Backup**: Implement backup strategies for your models and configurations
- [ ] **Documentation**: Document API endpoints, request/response formats, and deployment process

### Architecture Overview
The complete solution follows this flow:
1. **User Request**: Web application (CloudFront) → API Gateway
2. **Processing**: API Gateway → Lambda Function
3. **Inference**: Lambda → SageMaker Endpoint
4. **Response**: SageMaker → Lambda → API Gateway → Web Application

### Performance Optimization
- **Lambda**: Optimize function memory and timeout settings
- **API Gateway**: Implement caching for frequently requested data
- **SageMaker**: Consider auto-scaling for variable workloads
- **CloudFront**: Configure appropriate cache behaviors and TTL settings

### Security Considerations
- **SageMaker endpoints** can only be accessed within the account using IAM policies
- **API Gateway** provides the public interface while Lambda handles authentication
- **Use HTTPS** for all communications
- **Implement proper CORS** settings for web applications
- **Consider AWS WAF** for additional protection against common web exploits

### Project Completion
✅ **Great Work! Project Completed.**

> **All Praise Be To Almighty GOD Alone.**

---

## Troubleshooting Tips

### Common Issues and Solutions

#### SageMaker Issues
- **Endpoint not in service**: Check CloudWatch logs for deployment errors
- **Resource limits exceeded**: Verify your AWS account limits and request increases if needed
- **Model loading failures**: Ensure model artifacts are correctly packaged and uploaded to S3
- **Instance type not available**: Try different instance types or regions

#### Lambda Function Issues
- **Timeout errors**: Increase timeout value in Lambda configuration (max 15 minutes)
- **Permission errors**: Verify IAM roles have correct SageMaker and CloudWatch permissions
- **Memory issues**: Increase Lambda memory allocation
- **Cold start delays**: Consider provisioned concurrency for consistent performance

#### API Gateway Issues
- **CORS errors**: Ensure CORS is properly configured for your domain
- **Integration timeout**: Check Lambda function timeout settings
- **Request format errors**: Validate request/response mapping templates
- **Authentication failures**: Verify API key configuration and authorizer setup

#### CloudFront and S3 Issues
- **404 errors**: Ensure default root object is set to `index.html`
- **Cache issues**: Create invalidations after updating files
- **Access denied**: Verify S3 bucket policy allows CloudFront access
- **SSL certificate issues**: Ensure certificate is properly configured for your domain

#### General Debugging Steps
1. **Check CloudWatch Logs**: Monitor all service logs for detailed error messages
2. **Test Components Individually**: Verify each service works independently
3. **Validate Permissions**: Ensure all IAM roles have necessary permissions
4. **Review Network Configuration**: Check VPC, subnets, and security groups if using
5. **Monitor Costs**: Keep track of resource usage and costs during testing

### Monitoring and Maintenance

#### CloudWatch Metrics to Monitor
- **Lambda**: Duration, Errors, Throttles, Concurrent Executions
- **API Gateway**: Count, Latency, 4XXError, 5XXError
- **SageMaker**: Invocations, ModelLatency, OverheadLatency
- **CloudFront**: Requests, BytesDownloaded, OriginLatency

#### Regular Maintenance Tasks
- **Update Lambda runtime** when new versions are available
- **Review and optimize costs** monthly
- **Update security patches** and dependencies
- **Backup model artifacts** and configurations
- **Test disaster recovery** procedures

### Scaling Considerations

#### Auto-scaling Configuration
- **SageMaker Endpoints**: Configure auto-scaling based on invocation metrics
- **Lambda Concurrency**: Set reserved concurrency for predictable performance
- **API Gateway**: Implement throttling and usage plans
- **CloudFront**: Utilize global edge locations for optimal performance

#### Load Testing
- **Gradual increase**: Start with low traffic and gradually increase
- **Monitor all components**: Watch for bottlenecks across the entire stack
- **Performance baselines**: Establish baseline performance metrics
- **Stress testing**: Test beyond expected peak loads

### Next Steps and Enhancements
- **Implement A/B testing** for different models
- **Add authentication** with AWS Cognito
- **Set up CI/CD pipeline** for automated deployments
- **Implement model versioning** and rollback capabilities
- **Add comprehensive logging** and monitoring dashboards
- **Consider implementing** caching layers for frequently requested predictions
- **Document API endpoints** with OpenAPI/Swagger specifications