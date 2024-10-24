
#!/bin/bash

# Reference:
# https://docs.aws.amazon.com/eks/latest/userguide/create-cluster.html

REGION="ca-central-1"

# -------------------------------------------------------------------------
# 1. Create role using above policy
aws iam create-role \
  --role-name EKSClusterRole-custom \
  --region $REGION \
  --assume-role-policy-document file://"eks-policy-role.json"

# 2. Attach to our role the default eks policy from AWS
aws iam attach-role-policy \
  --region $REGION \
  --policy-arn arn:aws:iam::aws:policy/AmazonEKSClusterPolicy \
  --role-name EKSClusterRole-custom
# -------------------------------------------------------------------------