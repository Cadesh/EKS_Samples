

#!/bin/bash

# Creates a Role to be given to the nodes. Check the reference for more details. 

# Reference:
# https://docs.aws.amazon.com/eks/latest/userguide/create-node-role.html


ROLE_NAME="AmazonEKSNodeRole-custom" 
REGION="ca-central-1"

# cat >node-role-trust-relationship.json <<EOF
# {
#   "Version": "2012-10-17",
#   "Statement": [
#     {
#       "Effect": "Allow",
#       "Principal": {
#         "Service": "ec2.amazonaws.com"
#       },
#       "Action": "sts:AssumeRole"
#     }
#   ]
# }
# EOF

aws iam create-role \
  --role-name $ROLE_NAME \
  --assume-role-policy-document file://"node-role-trust-relationship.json" \
  --region $REGION

aws iam attach-role-policy \
  --policy-arn arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy \
  --role-name $ROLE_NAME \
  --region $REGION

aws iam attach-role-policy \
  --policy-arn arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly \
  --role-name $ROLE_NAME \
  --region $REGION

# For IPv4
aws iam attach-role-policy \
  --policy-arn arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy \
  --role-name $ROLE_NAME \
  --region $REGION
