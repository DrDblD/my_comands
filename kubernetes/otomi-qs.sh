# minikube start --memory=3096 --cpus=3 --kubernetes-version=v1.22.4 --cni calico --embed-certs=true && \
minikube start --memory=10g --cpus=8 --disk-size=300g --kubernetes-version=v1.21.12 --cni calico && \
minikube addons enable metallb && \
minikube ip && \
minikube addons configure metallb
###
helm install otomi-$( echo "otomi" | md5sum | head -c 6) otomi/otomi \
    --set cluster.k8sVersion="1.21" \
    --set cluster.name=minikube \
    --set cluster.provider=custom \
    --set apps.host-mods.enabled=false \
    --set otomi.hasExternalDNS=false \
    --set otomi.hasExternalIDP=false
###
on stage metrics add deployment arg '--kubelet-insecure-tls'
###
next issue with api
###
kubectl logs jobs/otomi -n default -f