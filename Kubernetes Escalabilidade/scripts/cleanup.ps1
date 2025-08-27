$ErrorActionPreference = "SilentlyContinue"
kubectl delete -f k8s\hpa.yaml
kubectl delete -f k8s\service.yaml
kubectl delete -f k8s\deployment.yaml
kubectl delete -f k8s\namespace.yaml
