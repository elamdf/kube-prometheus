#./node_exporter &
#gnmic --config gnmic-config.yml  --log subscribe & 
kubectl delete --ignore-not-found=true -f manifests/ -f manifests/setup
set -e
kubectl apply --server-side -f manifests/setup
kubectl wait \
	--for condition=Established \
	--all CustomResourceDefinition \
	--namespace=monitoring
kubectl apply -f manifests/
kubectl apply -n istio-system -f ~/istio-1.15.0/samples/addons/extras/prometheus-operator.yaml
sleep 10
kubectl wait --for=condition=ready --namespace monitoring pods/prometheus-k8s-0
kubectl --namespace monitoring port-forward svc/prometheus-k8s 9090
