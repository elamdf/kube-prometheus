./node_exporter &
kubectl delete --ignore-not-found=true -f manifests/ -f manifests/setup
set -e
kubectl apply --server-side -f manifests/setup
kubectl wait \
	--for condition=Established \
	--all CustomResourceDefinition \
	--namespace=monitoring
kubectl apply -f manifests/
sleep 25
kubectl --namespace monitoring port-forward svc/prometheus-k8s 9090
