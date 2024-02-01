kubectl apply -f pod-with-cm.yaml -l app=db
kubectl apply -f pod-with-cm.yaml -l app=application

#config example
 kubectl create cm postgres-config --from-literal=DB=postgres --from-literal=USER=postgres --from-literal=PASSWORD=postgres


 kubectl create secret generic postgres-config --from-literal=DB=postgres --from-literal=USER=postgres --from-literal=PASSWORD=postgres
kubectl get secret postgres-config -o yaml