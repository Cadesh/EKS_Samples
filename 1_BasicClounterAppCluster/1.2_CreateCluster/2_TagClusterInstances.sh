#!/bin/bash

# EC2 instances in cluster are not tagged. 
# This script tags the current EC2 instances in the cluster with the node group name and a date tag.

# Set the EKS cluster name
CLUSTER_NAME="k8s-pub-snet-cluster"
# Get the current date
TODAY_DATE=$(date +"%Y-%m-%d")
REGION="ca-central-1"

# Get node groups for cluster
NODE_GROUPS=$(aws eks list-nodegroups \
    --cluster-name $CLUSTER_NAME \
    --query 'nodegroups' \
    --region $REGION \
    --output text)

# Loop  node groups
for NODE_GROUP in $NODE_GROUPS; do
    # Get the instance IDs for the node group
    INSTANCE_IDS=$(aws ec2 describe-instances \
                --filters "Name=tag:eks:nodegroup-name,Values=$NODE_GROUP" "Name=tag:eks:cluster-name,Values=$CLUSTER_NAME" \
                --query 'Reservations[].Instances[].InstanceId' \
                --region $REGION \
                --output text)

    # Loop through each instance
    i=1
    for INSTANCE_ID in $INSTANCE_IDS; do
        # Set the instance name tag
        INSTANCE_NAME="$NODE_GROUP-$i"
        # Add the tags to the instance
        aws ec2 create-tags \
        --resources $INSTANCE_ID \
        --region $REGION \
        --tags Key=Name,Value=$INSTANCE_NAME Key=Date,Value=$TODAY_DATE

        echo "Added tags to instance $INSTANCE_ID: Name=$INSTANCE_NAME, Date=$TODAY_DATE"
        i=$((i+1))
    done
done