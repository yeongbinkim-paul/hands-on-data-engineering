kubectl create secret generic airflow-git-ssh-secret \
  --from-file=gitSshKey=/Users/gim-yeongbin/.ssh/airflowsshkey \
  --from-file=known_hosts=/Users/gim-yeongbin/.ssh/known_hosts \
  --from-file=id_ed25519.pub=/Users/gim-yeongbin/.ssh/airflowsshkey.pub \
  -n default
 —

/Users/

kubectl get secret airflow-git-ssh-secret -o yaml
annotations
pgbouncer
celery worker
cp from -> nfs가 필요하다.
go lang {{-  -}}

helm install / upgrade <release name> . —values custom-values.yaml  --namespace data-pipeline-test —create-namespace
rbac / serviceaccount 개념?
quote
kubectl port-forward service/data-pipeline-webserver-test 5555:5555 --namespace <namespace>
local docker <=> local kubernetes
helm upgrade data-pipeline-test . --values test.values.yaml --namespace data-pipeline-test
kubectl logs data-pipeline-webserver-test-c757c67f-v9b22 -c wait-for-airflow-migrations --namespace data-pipeline-test
kubectl logs postgresql-data-pipeline-test-0

kubectl config set-context --current --namespace=data-pipeline-test

minikube docker-env
eval $(minikube -p minikube docker-env)
minikube image ls --format table


psql postgresql://postgres:test@localhost:5432/airflow
kubectl port-forward service/data-pipeline-webserver-test 8080:8080 --namespace tt

kubectl port-forward svc/data-pipeline-webserver-test 8080:8080 --namespace data-pipeline-test



helm install data-pipeline-test . --values test.values.yaml  --namespace data-pipeline-test
kubectl port-forward svc/data-pipeline-webserver-test 8080:8080 --namespace data-pipeline-test

persistent  volume local host가 security context 지원 안함

psql postgresql://postgres:postgres@localhost:5432/airflow


kubectl port-forward svc/data-pipeline-webserver-prod 8080:8080 --namespace data-pipeline

minikube start --cpus 8 --memory 10240

kind load docker-image data_undercurrents/airflow:1.0.0
helm install data-pipeline . --values prod.values.yaml  --namespace data-pipeline
kubectl port-forward svc/data-pipeline-webserver-prod 8080:8080 --namespace data-pipeline

brew install kind
brew install helm
brew install kubectl
kind create cluster --image kindest/node:v1.21.1
