kubectl apply -f hello-service.yaml

kubectl run hello-redis --image=080196/hello-redis

kubectl logs hello-redis

 kubectl delete pod hello-redis
kubectl delete pod hello-redis
kubectl delete -f hello-service.yaml
kubectl port-forward pod/hello-kube 3000:3000
kubectl port-forward hello-rs-mh4gz 3000:3000
kubectl port-forward 10.106.144.229 3000:3000


## lay ip call node cho minikube NodePort

minikube ip