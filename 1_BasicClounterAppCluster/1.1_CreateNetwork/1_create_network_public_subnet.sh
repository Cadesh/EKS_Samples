
#!/bin/bash

# Create the EKS Network infrastructure with CloudFormation Yaml script.

# Reference: https://docs.aws.amazon.com/eks/latest/userguide/getting-started-console.html
# YAML: https://s3.us-west-2.amazonaws.com/amazon-eks/cloudformation/2020-10-29/amazon-eks-vpc-private-subnets.yaml
# -------------------------------------------------------------------------

REGION="ca-central-1"
ACCOUNT_ID=$(aws sts get-caller-identity --query "Account" --output text)
TEMPLATE_FILE="k8s_vpc_public_subnet_only.yml"
STACK="EKS-Pub-VPC"
DATE=$(date +%Y-%m-%d)

# ---------------------------------------------------------
# 1.0 Create Stack
aws cloudformation create-stack \
    --stack-name $STACK \
    --template-body file://$TEMPLATE_FILE \
    --parameters ParameterKey=DeploymentDate,ParameterValue="$DATE"
# ----------------------------------------------------------------
