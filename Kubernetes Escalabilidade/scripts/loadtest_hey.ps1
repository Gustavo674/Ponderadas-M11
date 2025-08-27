# scripts\loadtest_hey.ps1
$ErrorActionPreference = "Stop"
$ns  = "hpa-demo"
$url = "http://php-apache-svc.$ns.svc.cluster.local:80/?work=80000"  # carga forte

kubectl run hey --rm -i --tty --image=rakyll/hey --restart=Never -n $ns -- `
  -z 120s -c 60 $url
