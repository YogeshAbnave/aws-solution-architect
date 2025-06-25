#!/bin/bash
KEY_PATH="/Users/cloudageglobal/Desktop/security.pem"
REGION="ap-south-1"

IP=$(aws ec2 describe-instances \
  --region "$REGION" \
  --filters Name=instance-state-name,Values=running \
  --query "Reservations[0].Instances[0].PublicIpAddress" \
  --output text)

ssh -i "$KEY_PATH" ec2-user@$IP
