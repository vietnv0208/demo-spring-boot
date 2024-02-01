kubectl proxy
###
curl localhost:8001/api/v1/namespaces/default/pods/kubia-0/proxy/

curl -X POST -d "Hey there! This greeting was submitted to kubia-0." localhost:8001/api/v1/namespaces/default/pods/kubia-0/proxy/

curl localhost:8001/api/v1/namespaces/default/pods/kubia-0/proxy/
kubectl delete po kubia-0
