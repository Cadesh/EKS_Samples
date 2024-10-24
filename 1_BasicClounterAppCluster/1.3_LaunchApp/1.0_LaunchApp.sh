
#!/bin/bash

# Reference:
# https://archive.eksworkshop.com/intermediate/200_migrate_to_eks/deploy-counter-db-in-eks/

# If you rerun configmap and want to apply the changes
# kubectl patch statefulset postgres -p '{"spec":{"template":{"spec":{"containers":[{"name":"postgres","envFrom":[{"configMapRef":{"name":"postgres-config"}}]}]}}}}' 

# -------------------------------------------------------------------------

CLUSTER_NAME="k8s-pub-snet-cluster"
REGION="ca-central-1"
aws eks update-kubeconfig --region $REGION --name $CLUSTER_NAME
#aws eks update-kubeconfig --region ca-central-1 --name k8s-pub-snet-cluster

# 1.1 Apply the Postgre ConfigMap
echo "1.1 Deploy PostGres ConfigMap"
kubectl apply -f 1.1_PostGres_configMap.yaml

# 1.2 Apply the Postgre Storage Class, PV, PVC
echo "1.2 Deploy PostGres PV"
kubectl apply -f 1.2_PostGres_persistentVolume.yaml

sleep 10

# 1.3 Apply the Postgres Container
echo "1.3 Deploy PostGres DB"
kubectl apply -f 1.3_PostGres_statefulSet.yaml

# 1.4 Deploy PG Service
echo "1.4 Deploy PostGres Service"
kubectl apply -f 1.4_PostGres_service.yaml

sleep 30

# 2.1 Apply the Counter ConfigMap
echo "2.1 Deploy Counter ConfigMap"
kubectl apply -f 2.1_CounterApp_configMap.yaml

# 2.2 Deploy Counter App
echo "2.2 Deploy Counter App"  
kubectl apply -f 2.2_CounterApp_deployment.yaml

# 2.3 Deploy Counter Service
echo "2.3 Deploy Counter Service"
kubectl apply -f 2.3_CounterApp_service.yaml

# 4. Deploy Adminer App
echo "3.1 Deploy Adminer App"  
kubectl apply -f 3.1_Adminer_deployment.yaml

# 5. Deploy Adminer Service
echo "3.2 Deploy Adminer Service"
kubectl apply -f 3.2_Adminer_service.yaml

sleep 10
# 6. Get the Services URLs
echo "After some minutes your app will be ready"
echo "Counter URL"
echo "http://"$(kubectl get svc counter --output jsonpath='{.status.loadBalancer.ingress[0].hostname}')

echo "Adminer URL"
echo "http://"$(kubectl get svc adminer --output jsonpath='{.status.loadBalancer.ingress[0].hostname}')

echo "Check in configMap the db name, user, password and server values for Adminer login." 
