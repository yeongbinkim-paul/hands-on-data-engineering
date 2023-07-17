
kubectl port-forward svc/maindb 4321:4321 --namespace data-pipeline

# psql postgresql://admin:admin@localhost:5432/maindb
