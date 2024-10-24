# EKS_Samples

[![License: GPL v3](https://img.shields.io/badge/License-GPLv3-blue.svg)](https://www.gnu.org/licenses/gpl-3.0) 

This repository a tutorial for setting up an Amazon Elastic Kubernetes Service (EKS) cluster and deploying a simple counter application to it.

The samples are organized into the following directories:

---

## 1_BasicClounterAppCluster

### 1.0_Prerequisites
This directory contains scripts and configuration files to create the necessary IAM roles for the EKS cluster and worker nodes.

To create the roles, run the following commands:

```bash
# Create the EKS cluster role
./1_create_k8s_role.sh

# Create the node role
./2_create_Node_role.sh
```

---

### 1.1_CreateNetwork
This directory contains a CloudFormation template and a script to create a VPC with public subnets for the EKS cluster.

Run the following script to create the network infrastructure using the yml template:

```bash
./1_create_network_public_subnet.sh
```

---

#### `k8s_vpc_public_subnet_only.yml`
This is a CloudFormation template that creates the following resources:

1. **VPC**: The virtual private cloud that will host the EKS cluster and its resources.
2. **Internet Gateway**: Provides a route for the VPC to access the internet.
3. **Public Route Table**: The route table associated with the public subnets, which routes internet-bound traffic through the internet gateway.
4. **Public Subnets**: Two public subnets in different availability zones, which will be used by the EKS cluster.
5. **Security Group**: A security group for the EKS control plane to communicate with the worker nodes.

The template takes the following parameters:

- `VpcBlock`: The CIDR range for the VPC.
- `PublicSubnet01Block`: The CIDR range for the first public subnet.
- `PublicSubnet02Block`: The CIDR range for the second public subnet.
- `DeploymentDate`: The date of the deployment, used for tagging resources.

---

### 1.2_CreateCluster
This directory contains a script to create the EKS cluster and worker node groups.

Run the following script to create the EKS cluster:

```bash
./1_create_k8s_cluster.sh
```

---

### 1.3_LaunchApp
This directory contains the Kubernetes manifests to deploy the counter application, which consists of the following components:

1. **PostgreSQL Database**:
   - A ConfigMap with the database configuration
   - A persistent volume and volume claim for the database data
   - A stateful set for the PostgreSQL container
   - A service to expose the PostgreSQL server

2. **Counter Application**:
   - A ConfigMap with the application configuration
   - A deployment for the counter application container
   - A service to expose the counter application

3. **Adminer**:
   - A deployment for the Adminer database management tool
   - A service to expose the Adminer web interface

To deploy the application, run the following script:

```bash
./1.0_LaunchApp.sh
```

This script will apply the necessary Kubernetes resources to deploy the PostgreSQL database, the counter application, and the Adminer instance.

---

After the deployment, you can access the counter application using the provided URL, and the Adminer instance using the provided URL.



