$ErrorActionPreference = "Stop"
$ns = "hpa-demo"
$svc = "php-apache-svc"
$port = 80

$svcIp = (kubectl get svc $svc -n $ns -o jsonpath='{.spec.clusterIP}')
Write-Host "Service ClusterIP: $svcIp"

kubectl run hey --rm -i --tty --image=rakyll/hey --restart=Never -n $ns -- `
  -z 120s -c 50 "http://$svcIp:$port/?work=40000"
