kubectl apply -f hello-deploy.yaml
kubectl rollout status deploy hello-app

kubectl set image deployment hello-app hello-app=080196/hello-app:v2
kubectl set image deployment hello-app hello-app=080196/hello-app:v3

kubectl rollout history deploy hello-app

kubectl rollout undo deployment hello-app --to-revision=2

