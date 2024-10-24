
#!/bin/bash

# Delete Counter App resources
kubectl delete service counter
kubectl delete deployment counter

# Delete Adminer resources
kubectl delete service adminer
kubectl delete deployment adminer

# Delete PostGres resources
kubectl delete service postgres
kubectl delete statefulset postgres
kubectl delete pvc postgres-pv-claim
kubectl delete pv postgres-pv-volume
kubectl delete configmap postgres-config 
kubectl delete configmap counter-config