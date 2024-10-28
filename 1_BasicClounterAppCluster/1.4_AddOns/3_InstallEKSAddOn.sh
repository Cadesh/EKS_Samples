
#!/bin/bash

# Set the EKS cluster name
CLUSTER_NAME="k8s-pub-snet-cluster"
REGION="ca-central-1"

# VPC-CNI
# https://docs.aws.amazon.com/eks/latest/userguide/managing-vpc-cni.html
aws eks create-addon \
  --cluster-name $CLUSTER_NAME \
  --addon-name vpc-cni \
  --resolve-conflicts OVERWRITE \
  --region $REGION

# S3-MOUNTPOINT
# https://github.com/awslabs/mountpoint-s3-csi-driver/blob/main/docs/install.md
# https://github.com/awslabs/mountpoint-s3-csi-driver/tree/main/examples/kubernetes/static_provisioning
aws eks create-addon \
  --cluster-name $CLUSTER_NAME \
  --addon-name aws-mountpoint-s3-csi-driver \
  --resolve-conflicts OVERWRITE \
  --region $REGION

# Now apply the S3 mountpoint manifest
# ATTENTION the Role AmazonEKSNodeRole-custom must have S3 access to the bucket.
# describe the pod errors with `kubectl describe pod s3-app``
kubectl apply -f static_provisioning.yaml
# Access the container with `kubectl exec -it s3-app -- /bin/sh`
# Go to the mountpoint in `/data` to find the s3 files


