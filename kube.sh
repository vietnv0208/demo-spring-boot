#1
kubectl apply -f docker-java-kubernetes.yaml
#2
kubectl get deployments
kubectl get services

#test api
minikube service service-entrypoint
#test minikube ip
#Now we can test that the app is exposed outside of the cluster using curl, the IP address of the Node and the externally exposed port:
curl http://"$(minikube ip):$NODE_PORT"

# enabled to check metrics
minikube addons enable metrics-server
minikube addons disable metrics-server

#3 check ooutput
#4 tear down your application
kubectl delete -f docker-java-kubernetes.yaml

minikube stop
# Optional
minikube delete