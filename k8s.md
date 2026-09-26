### scenario-1: Expose the application

```
kubectl get svc

kubectl get endpoints nginx

kubectl apply -f k8s-manifests/broken-service.yaml

kubectl get endpoints broken-nginx

ENDPOINTS   <none>
```

### scenario-2: internal Kubernetes networking.

```
kubectl run curl \
  --image=curlimages/curl \
  -it --rm -- sh

curl http://nginx

<!DOCTYPE html>
<html>
...

```

### scenario-3: Manual scaling

```
kubectl scale deployment nginx --replicas=5

kubectl scale deployment nginx --replicas=2

kubectl get deployment metrics-server -n kube-system

kubectl top nodes

kubectl top pods

kubectl autoscale deployment nginx \
  --cpu-percent=50 \
  --min=2 \
  --max=10

kubectl get hpa

```

### scenario-4: Debug ImagePullBackOff

```
kubectl apply -f bad-image.yaml

kubectl get pods

kubectl describe pod <pod-name>

```

### scenario-5: Deployment rolling update

```
image: nginx:1.27 --> image: nginx:1.28

kubectl apply -f nginx-deployment.yaml

kubectl rollout status deployment/nginx

kubectl get pods -w

```

### Rollback

```
kubectl rollout history deployment/nginx

kubectl rollout undo deployment/nginx

kubectl rollout undo deployment/nginx \
  --to-revision=1 

kubectl rollout status deployment/nginx

kubectl describe deployment nginx

```

### scenario-6: Debug Pending Pod

```
kubectl apply -f pending.yaml

kubectl get pods

kubectl describe pod <pod-name>

```

### scenario-7: Debug a Pod that isn't Ready

```
kubectl apply -f readiness.yaml
```