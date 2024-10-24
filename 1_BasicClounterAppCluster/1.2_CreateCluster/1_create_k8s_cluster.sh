

# Reference:
# To create VPC and Subnets
# https://docs.aws.amazon.com/eks/latest/userguide/getting-started-console.html
# To create EKS Cluster
# https://docs.aws.amazon.com/eks/latest/userguide/getting-started-eksctl.html

# THIS IS A NON EKSCTL MANAGED CLUSTER CREATED MANUALLY

#CLUSTER_NAME="counter-cluster"
CLUSTER_NAME="k8s-pub-snet-cluster"
REGION="ca-central-1"

SSH_KEY="testKeyPair"      # Your SSH KEy pair created in AWS EC2
#AMI_FAMILY="AmazonLinux2" # for ami-family values check: https://eksctl.io/usage/custom-ami-support/
EC2_TYPE="t3.medium"	
DATE=$(date +%Y-%m-%d-%H-%M-%S)

# Get the IAM role ARNs
cluster_role_name="EKSClusterRole-custom" # Created in prerequisites
node_role_name="AmazonEKSNodeRole-custom" # Created in prerequisites

CLUSTER_ROLE_ARN=$(aws iam get-role \
    --role-name "$cluster_role_name" \
    --query "Role.Arn" \
    --region $REGION \
    --output text)
echo "Using Cluster Role: $CLUSTER_ROLE_ARN"

NODE_ROLE_ARN=$(aws iam get-role \
    --role-name "$node_role_name" \
    --query "Role.Arn" \
    --region $REGION \
    --output text)
echo "Using Node Role: $NODE_ROLE_ARN"

# Add your VPC parameters in the yaml file too, VPC was created in CreateNetworkInfrastructure
VPC_NAME="k8s-vpc" # this name was defined in the cloudformation template
VPC_ID=$(aws ec2 describe-vpcs \
    --filters "Name=tag:Name,Values=$VPC_NAME" \
    --query "Vpcs[0].VpcId" --output text)

SG_NAME="k8s-vpc-sg" # this name was defined in the cloudformation template
SECURITY_GROUP_ID=$(aws ec2 describe-security-groups --filters "Name=tag:Name,Values=$SG_NAME" --query "SecurityGroups[0].GroupId" --output text)
# Public Subnets
SNET_NAME1="k8s-vpc-pub-snet-01" # this name was defined in the cloudformation template
SUBNET_ID_1=$(aws ec2 describe-subnets --filters "Name=tag:Name,Values=$SNET_NAME1" --query "Subnets[0].SubnetId" --output text)
SNET_NAME2="k8s-vpc-pub-snet-02" # this name was defined in the cloudformation template
SUBNET_ID_2=$(aws ec2 describe-subnets --filters "Name=tag:Name,Values=$SNET_NAME2" --query "Subnets[0].SubnetId" --output text)

# ---------------------------------------------------------------------------
# CREATE CLUSTER
# The role-arn is the same created in prerequisites
aws eks create-cluster \
  --region $REGION \
  --name $CLUSTER_NAME \
  --kubernetes-version 1.30 \
  --role-arn $CLUSTER_ROLE_ARN \
  --no-paginate \
  --resources-vpc-config \
    subnetIds=$SUBNET_ID_1,$SUBNET_ID_2,securityGroupIds=$SECURITY_GROUP_ID

aws eks wait cluster-active --name $CLUSTER_NAME --region $REGION

#add context so you can communicate to the cluster. 
aws eks update-kubeconfig --region $REGION --name $CLUSTER_NAME
# sleep 10
# ---------------------------------------------------------------------------

echo "Cluster $CLUSTER_NAME created"
echo "Creating node groups"

# ---------------------------------------------------------------------------
aws eks create-nodegroup \
    --cluster-name $CLUSTER_NAME \
    --nodegroup-name public-ng-1 \
    --node-role $NODE_ROLE_ARN \
    --subnets "$SUBNET_ID_1" "$SUBNET_ID_2" \
    --scaling-config minSize=1,maxSize=3,desiredSize=2 \
    --capacity-type ON_DEMAND \
    --instance-types $EC2_TYPE \
    --disk-size 20 \
    --region $REGION \
    --no-paginate \
    --tags "Name=public-ng-2,Cluster=$CLUSTER_NAME,Date=$DATE"
# ---------------------------------------------------------------------------

# ---------------------------------------------------------------------------
aws eks create-nodegroup \
    --cluster-name $CLUSTER_NAME \
    --nodegroup-name public-ng-2 \
    --node-role $NODE_ROLE_ARN \
    --subnets "$SUBNET_ID_1" "$SUBNET_ID_2" \
    --scaling-config minSize=1,maxSize=3,desiredSize=2 \
    --capacity-type ON_DEMAND \
    --instance-types $EC2_TYPE \
    --disk-size 20 \
    --region $REGION \
    --no-paginate \
    --tags "Name=public-ng-2,Cluster=$CLUSTER_NAME,Date=$DATE"
# ---------------------------------------------------------------------------