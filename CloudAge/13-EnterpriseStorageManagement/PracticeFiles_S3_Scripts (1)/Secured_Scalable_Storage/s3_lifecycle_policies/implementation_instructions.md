# AWS S3 Lifecycle Policy Implementation Instructions

This document provides instructions for implementing the lifecycle policies for your AWS S3 bucket named HDFS. These policies are designed to meet HIPAA compliance requirements while optimizing costs through appropriate storage class transitions and object expiration.

## Prerequisites

1. AWS CLI installed and configured with appropriate permissions
2. Access to the AWS Management Console (alternative method)
3. Appropriate IAM permissions to modify S3 bucket lifecycle configurations

## Implementation Methods

### Method 1: Using AWS CLI

To apply a lifecycle policy using AWS CLI, follow these steps:

1. Select the appropriate policy JSON file based on your specific requirements
2. Replace any placeholders marked with "Replace-Me" with your actual values
3. Run the following AWS CLI command:

```bash
aws s3api put-bucket-lifecycle-configuration \
    --bucket hdfs \
    --lifecycle-configuration file://Users/cloudageglobal/Desktop/storage/selected-policy.json
```

### Method 2: Using AWS Management Console

1. Sign in to the AWS Management Console
2. Navigate to the S3 service
3. Select the "HDFS" bucket
4. Click on the "Management" tab
5. In the "Lifecycle rules" section, click "Create lifecycle rule"
6. Configure the rule according to the JSON policy you've selected:
   - Enter a rule name (use the ID from the JSON file)
   - Set the scope (bucket or prefix)
   - Configure transitions (after 30 days)
   - Configure expirations (after 90 days)
   - Configure cleanup of incomplete multipart uploads (after 7 days)
7. Review and save the rule

## Policy Selection Guide

Choose the appropriate policy based on your specific requirements:

1. **standard_transition_policy.json**: Basic policy that transitions objects to STANDARD_IA after 30 days and expires them after 90 days
2. **glacier_transition_policy.json**: Transitions objects to GLACIER after 30 days for long-term archival
3. **intelligent_tiering_policy.json**: Uses INTELLIGENT_TIERING for objects with unpredictable access patterns
4. **multiple_transitions_policy.json**: Implements a tiered approach with multiple transitions (STANDARD_IA at 30 days, GLACIER at 60 days)
5. **tag_based_policy.json**: Applies lifecycle rules based on object tags
6. **hipaa_compliant_policy.json**: Comprehensive policy with separate rules for different prefixes, designed for HIPAA compliance
7. **abort_multipart_uploads_policy.json**: Focused solely on cleaning up incomplete multipart uploads

## HIPAA Compliance Considerations

For healthcare data subject to HIPAA regulations:

1. Ensure server-side encryption is enabled on the bucket
2. Implement appropriate bucket policies to restrict access
3. Enable versioning to prevent accidental deletion
4. Enable access logging for audit purposes
5. Use the hipaa_compliant_policy.json which includes extended retention for logs (6 years)

## Customization Instructions

Each policy contains placeholders marked with "Replace-Me" that should be customized:

1. **Prefix**: Replace "Replace-Me-With-Prefix/" with your actual folder structure
   - Example: "patient-data/" or "medical-images/"
   - Use empty string ("") to apply to the entire bucket

2. **Tags**: In tag_based_policy.json, replace tag values with your actual tagging scheme
   - Example: Change "DataType" and "Replace-Me-With-Tag-Value" to match your tagging strategy

## Verification

After applying a lifecycle policy, verify it's correctly configured:

```bash
aws s3api get-bucket-lifecycle-configuration --bucket hdfs
```

Or check through the AWS Management Console under the bucket's Management tab.

## Monitoring

Monitor the effects of your lifecycle policy:
1. Use S3 Storage Lens to track storage usage and transitions
2. Set up CloudWatch metrics to monitor transition and expiration activities
3. Review S3 server access logs to audit object lifecycle changes

## Additional Resources

- [AWS S3 Lifecycle Documentation](https://docs.aws.amazon.com/AmazonS3/latest/userguide/object-lifecycle-mgmt.html)
- [HIPAA Compliance on AWS](https://aws.amazon.com/compliance/hipaa-compliance/)
- [S3 Storage Classes](https://aws.amazon.com/s3/storage-classes/)
