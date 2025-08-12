# AWS Generative AI Text-to-Image Application Documentation

## Overview
This documentation guides you through building a complete text-to-image generation application using AWS services including SageMaker, Lambda, API Gateway, and CloudFront. The application uses the Stable Diffusion model for image generation.

## Architecture Components
- **AWS SageMaker**: Hosts the ML model endpoint
- **AWS Lambda**: Serverless functions for processing
- **AWS API Gateway**: RESTful API interface
- **AWS S3**: Storage for generated images and web assets
- **AWS CloudFront**: Content delivery network

## Prerequisites
- AWS Account with appropriate permissions
- Basic knowledge of AWS services
- Python 3.11 runtime environment
- SageMaker Studio access

---

## Phase 1: SageMaker Setup

### 1. Initial Setup
1. **Login to AWS Console** and navigate to Amazon SageMaker AI
2. **Create SageMaker User** with default settings in SageMaker AI Studio
3. **Launch JupyterLab Space** with configuration:
   - Instance: `ml.t3.large`
   - Storage: `25GB`
4. **Import Notebook**: Open Jupyter Notebook and import `jupyter_notebook.ipynb` from desktop

### 2. SageMaker Execution Role Permissions
You need to configure S3 permissions for your SageMaker execution role:

#### Steps to Add Permissions:
1. **Access IAM Console** through the AWS Console
2. **Navigate to Roles** section
3. **Search and Select**: `AmazonSageMaker-ExecutionRole-20250717T000062`
4. **Add Permissions**: Click "Add permissions" → "Create inline policy"
5. **Configure S3 Access**: Add `S3FullAccess` policy
6. **Save Configuration**

### 3. Code Execution
- **Run notebook cells** starting from Step 1 through Step 4 minimum
- **Continue execution** of all remaining code sections for complete setup

---

## Phase 2: Lambda Functions Setup

### 1. Endpoint Call Function
Create a Lambda function to call the SageMaker endpoint:

#### Configuration:
- **Function Name**: `Endpoint_Call_Function`
- **Runtime**: Python 3.11
- **Memory**: 512MB
- **Timeout**: 5 minutes
- **Environment Variables**:
  ```
  ENDPOINT_NAME: cloudage-endpoint-text-to-image-model-t-2025-07-17-08-52-23-824
  BUCKET_NAME: cloudage-text-to-image-webapp
  ```

#### Required Permissions:
- `S3:FullAccess`
- `AmazonSageMakerFullAccess`

#### Lambda Layer:
- **Add Layer**: PillowLayer
- **Path**: Lambda → Layers → Add Layer → Upload `pillowlayer.zip` → Runtime Python v3.10 x86_64 → Save
- **Attach to Function**: Lambda → Functions → Endpoint_Call_Functions → Add Layer → Custom Layer → Select Pillow Layer → Save

### 2. Image Processing Function
Create a function to start image processing:

#### Configuration:
- **Function Name**: `Start_Processing_Function`
- **Runtime**: Python 3.11
- **Memory**: 512MB
- **Timeout**: 5 minutes
- **Environment Variables**:
  ```
  PROCESSING_LAMBDA_NAME: Endpoint_Call_Function
  BUCKET_NAME: cloudage-text-to-image-webapp
  ```

#### Required Permissions:
- `S3:FullAccess`
- `AmazonLambda_FullAccess`

### 3. Image Display Function
Create a function to dispatch images to the web application:

#### Configuration:
- **Function Name**: `Display_Image_Function`
- **Runtime**: Python 3.11
- **Memory**: 512MB
- **Timeout**: 5 minutes
- **Environment Variables**:
  ```
  BUCKET_NAME: cloudage-text-to-image-webapp
  ```

#### Required Permissions:
- `S3:FullAccess`
- `CloudFrontFullAccess`

### 4. Deploy Lambda Functions
Deploy all Lambda functions after configuration.

---

## Phase 3: API Gateway Setup

### 1. Create REST API
1. **Navigate to AWS Console** → Search "API Gateway" → Choose REST API
2. **Import API Configuration**: Click "Import" and upload `generative-ai-api-prod-swagger-apigateway.json`

### 2. Configure API Resources
Review and configure the imported resources and stages:

#### Integration Configuration:
- **POST Resource**: 
  - Click "Integration Request" 
  - Replace Lambda function with `Start_Processing_Function`
- **GET Resource**:
  - Click "Integration Request"
  - Replace Lambda function with `Display_Image_Function`

### 3. Deploy API
1. **Check Code Changes**: If you made changes to desktop code, verify they're applied
2. **Deploy API**: Create a new stage named according to your organization's naming convention
3. **Note API URL**: Save the API Gateway URL for frontend integration

---

## Phase 4: Frontend Setup

### 1. Frontend Configuration
On your desktop, configure the frontend application:

#### File: `index.html`
```html
<!-- Update line 134 -->
<script>
var apiGatewayUrl = "{API_GATEWAY_POST_URL}";
</script>
```

### 2. S3 Bucket Setup
1. **Upload Assets**: Upload `logo.jpeg` and `index.html` to the S3 bucket chosen in CloudFront
2. **Configure Bucket**: Ensure proper permissions for web hosting

---

## Phase 5: CloudFront Distribution

### 1. Create Distribution
1. **Navigate to CloudFront** → Create Distribution
2. **Configure Origin**: Specify S3 as origin and choose the bucket with uploaded `index.html`

### 2. Distribution Settings
1. **General Settings**: Edit → Set Default Root Object to `index.html`
2. **Origins Configuration**: 
   - Go to CloudFront Distribution → Origins
   - Check "cloudage-gen-ai_" → Edit → Copy S3 Bucket Policy

### 3. S3 Bucket Policy Configuration
1. **Edit Bucket Policy**: Navigate to S3 bucket containing `index.html`
2. **Apply Policy**: Edit the S3 bucket policy with copied CloudFront policy
3. **Alternative Method**: Paste S3 policy from desktop (remember to change the ARN)

### 4. Deployment
1. **Wait for Deployment**: CloudFront distribution deploys to all edge locations (may take 10 minutes depending on application size)
2. **Create Invalidation**: Go to CloudFront Distribution → Invalidations → Create Invalidation → Paste `/*`
3. **Access Application**: Once deployed, access via the distribution domain name

---

## Phase 6: Testing and Validation

### 1. Application Testing
1. **Access Web Application**: Use the CloudFront distribution URL
2. **Test Text-to-Image Generation**: Enter text prompts and verify image generation
3. **Verify End-to-End Flow**: Ensure all components work together properly

### 2. Troubleshooting
- **Check Lambda Logs**: Monitor CloudWatch logs for any errors
- **Verify Permissions**: Ensure all IAM roles have necessary permissions
- **API Gateway Testing**: Use API Gateway test console to verify endpoints
- **S3 Bucket Access**: Confirm proper bucket policies and permissions

---

## Key Configuration Details

### Model Information
- **Model Type**: Stable Diffusion (FM Model)
- **Training Dataset**: AWS Dataset
- **Deployment**: SageMaker AI endpoint
- **Alternative Models**: Multiple options available in SageMaker AI

### Cost Considerations
- **SageMaker Endpoint**: Pay for inference time
- **Lambda Functions**: Pay per execution
- **API Gateway**: Pay per API call
- **CloudFront**: Pay for data transfer
- **S3**: Pay for storage and requests

### Security Best Practices
- **IAM Roles**: Use least privilege principle
- **API Gateway**: Implement authentication if needed
- **S3 Buckets**: Configure proper bucket policies
- **CloudFront**: Use HTTPS for secure content delivery

---

## Conclusion

This documentation provides a complete guide for building a text-to-image generation application using AWS services. The application leverages modern serverless architecture for scalability and cost-effectiveness.

**Project Status**: ✅ Complete
**Praise**: All glory to Almighty God Alone!

### Next Steps
- Consider implementing user authentication
- Add image editing capabilities
- Implement caching for better performance
- Monitor and optimize costs
- Scale based on usage patterns

### Support
For technical issues or questions about AWS services, refer to:
- AWS Documentation
- SageMaker AI Console
- CloudWatch Logs for debugging
- AWS Support (if subscribed)

---

GenaiAWS@7596

