kubectl apply -f emptydir.yaml
kubectl port-forward fortune 8080:80

curl http://localhost:8080

