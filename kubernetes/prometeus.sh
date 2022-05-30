# helm repo add stable https://charts.helm.sh/stable
# link is https://artifacthub.io/packages/helm/prometheus-community/kube-prometheus-stack
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm search repo prometheus-community
kubectl create namespace monitoring
# helm install prometheus stable/prometheus --namespace monitoring
helm install [RELEASE_NAME] prometheus-community/kube-prometheus-stack --namespace monitoring
kube-prometheus-stack


helm install kube-prometheus-stack prometheus-community/kube-prometheus-stack --namespace monitoring


# ####
helm uninstall [RELEASE_NAME]
kubectl delete crd alertmanagerconfigs.monitoring.coreos.com
kubectl delete crd alertmanagers.monitoring.coreos.com
kubectl delete crd podmonitors.monitoring.coreos.com
kubectl delete crd probes.monitoring.coreos.com
kubectl delete crd prometheuses.monitoring.coreos.com
kubectl delete crd prometheusrules.monitoring.coreos.com
kubectl delete crd servicemonitors.monitoring.coreos.com
kubectl delete crd thanosrulers.monitoring.coreos.com
kubectl delete namespace monitoring