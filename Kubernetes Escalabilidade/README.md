# Horizontal Pod Autoscaler (HPA) - Kubernetes

Este documento descreve a implementação e os testes realizados com o **Horizontal Pod Autoscaler (HPA)** no cluster Kubernetes utilizando o Minikube.

---

## 🔹 Etapa 1 — Pré-requisitos
Ativar o `metrics-server` no Minikube para permitir que o cluster colete métricas de uso de CPU e memória:

```bash
minikube addons enable metrics-server
```

Verificar se está funcionando corretamente:

```bash
kubectl top nodes
kubectl top pods
```

---

## 🔹 Etapa 2 — Criação do Deployment
O deployment `php-apache` foi criado com **requests/limits** para CPU e memória, garantindo que o HPA tenha parâmetros para calcular a utilização:

```yaml
resources:
  requests:
    cpu: "100m"
    memory: "128Mi"
  limits:
    cpu: "500m"
    memory: "256Mi"
```

---

## 🔹 Etapa 3 — Criando o HPA
Foi configurado o HPA para o deployment `php-apache`, mirando **50% de utilização de CPU**, com mínimo de 1 e máximo de 10 réplicas:

```bash
kubectl autoscale deployment php-apache --cpu-percent=50 --min=1 --max=10
```

Verificando o status do HPA:

```bash
kubectl get hpa
kubectl describe hpa php-apache
```

---

## 🔹 Etapa 4 — Geração de Carga
Como não foi possível usar imagens externas (`hey`, `bombardier`), a carga foi gerada diretamente pelo **PowerShell** no Windows, utilizando `curl.exe` em paralelo.

Script utilizado:

```powershell
# ===== Parâmetros =====
$Url = "http://127.0.0.1:57553/?work=400000"
$Workers = 40     # jobs em paralelo
$Requests = 2500  # requisições por job (total = Workers * Requests)
# ======================

$jobs = 1..$Workers | ForEach-Object {
  Start-Job -ScriptBlock {
    param($u, $n)
    for ($i=0; $i -lt $n; $i++) {
      curl.exe $u > $null 2>&1
    }
  } -ArgumentList $Url, $Requests
}

Get-Job | Wait-Job
Get-Job | Remove-Job
```

---

## 🔹 Etapa 5 — Monitoramento
Durante o teste, foram utilizados os seguintes comandos para observar o comportamento do HPA:

```bash
kubectl get hpa -w
kubectl get deploy php-apache -w
kubectl top pods
```

---

## 🔹 Evidências

### HPA detectando carga:
```
NAME         REFERENCE               TARGETS   MINPODS   MAXPODS   REPLICAS   AGE
php-apache   Deployment/php-apache   199%/50%  1         10        4          39m
```

### Consumo de CPU pelos pods:
```
NAME                             CPU(cores)   MEMORY(bytes)
php-apache-564d97f4cd-kt6w9      184m         36Mi
php-apache-564d97f4cd-tj7tp      199m         38Mi
```

## 🔹 Limpeza
Para remover os recursos criados:

```bash
kubectl delete hpa php-apache
kubectl delete deploy php-apache
kubectl delete svc php-apache
```
