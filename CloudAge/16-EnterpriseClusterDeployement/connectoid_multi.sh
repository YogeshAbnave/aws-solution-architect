#!/bin/bash
KEY_PATH="/Users/cloudageglobal/Desktop/security.pem"
REGION="ap-south-1"

# List all running instances with Name and Public IP
aws ec2 describe-instances \
  --region "$REGION" \
  --filters Name=instance-state-name,Values=running \
  --query 'Reservations[*].Instances[*].[InstanceId, Tags[?Key==`Name`]|[0].Value, PublicIpAddress]' \
  --output table

read -p "Enter the IP address to connect: " IP

ssh -i "$KEY_PATH" ec2-user@$IP
