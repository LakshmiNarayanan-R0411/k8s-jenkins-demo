# k8s-jenkins-demo

Edit only the lines inside `stage('Kubernetes Step')` in the Jenkinsfile.
Use double quotes (not single) on any line that contains ${env.BUILD_NUMBER}.

| Set | Lines for Kubernetes Step |
|---|---|
| 1 Connect/verify | `kubectl config current-context` / `kubectl cluster-info` / `kubectl get nodes` |
| 2, 4 Deployment | `kubectl apply -f k8s/deployment.yaml` / `kubectl rollout status deployment/web-app --timeout=120s` |
| 3 Pod from YAML | `kubectl delete pod web-pod --ignore-not-found` / `kubectl apply -f k8s/pod.yaml` / `kubectl wait --for=condition=Ready pod/web-pod --timeout=120s` |
| 5 Service | `kubectl apply -f k8s/deployment.yaml` / `kubectl apply -f k8s/service.yaml` |
| 6 Scale to 3 | `kubectl apply -f k8s/deployment.yaml` / `kubectl scale deployment/web-app --replicas=3` / `kubectl rollout status deployment/web-app` |
| 7 Update image | `kubectl apply -f k8s/deployment.yaml` / `kubectl set image deployment/web-app web=lakshminarayananr0411/k8s-demo:${env.BUILD_NUMBER}` (double-quoted) / `kubectl rollout status deployment/web-app` |
| 8 ConfigMap | `kubectl apply -f k8s/configmap.yaml` / `kubectl apply -f k8s/deployment.yaml` / `kubectl rollout restart deployment/web-app` / `kubectl exec deploy/web-app -- printenv APP_MESSAGE` |
| 9 PVC | `kubectl apply -f k8s/pvc.yaml` / `kubectl apply -f k8s/pvc-pod.yaml` / `kubectl wait --for=condition=Ready pod/pvc-pod --timeout=120s` / `kubectl get pvc` |
| 10 Readiness probe | `kubectl apply -f k8s/deployment.yaml` / `kubectl describe deployment web-app` |
| 11 GitHub auto-deploy | keep defaults; add `triggers { pollSCM('H/2 * * * *') }` under `agent any`; edit app/index.html, push, wait ~2 min |
| 12, 15 Full CI/CD | keep defaults |
| 13 Rolling update | same as Set 7 + `kubectl rollout history deployment/web-app` |
| 14 Troubleshoot | `kubectl apply -f k8s/deployment.yaml` / `kubectl set image deployment/web-app web=lakshminarayananr0411/k8s-demo:wrong-tag` / `kubectl get pods` / `kubectl describe pods -l app=web-app` / `kubectl rollout undo deployment/web-app` (skip rollout status here) |

Jenkins credentials needed: `dockerhub-creds` (username/password) and `kubeconfig` (secret file).
App URL: http://localhost:30080 (minikube: `minikube service web-svc --url`).
