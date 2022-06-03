curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64
sudo install minikube-linux-amd64 /usr/local/bin/minikube
chmod 0600 $HOME/.minikube/profiles/minikube/config.json
mkdir -p $HOME/.minikube/certs
cp my_company.pem $HOME/.minikube/certs/
minikube start --embed-certs


##########

minikube start --memory=10g --cpus=8 --disk-size=300g --kubernetes-version=v1.21.12 --cni calico && \
minikube addons enable metallb && \
minikube ip && \
minikube addons configure metallb

#########

 minikube start \
    --driver=kvm2 \
    --container-runtime=cri-o \
    --memory=10g \
    --cpus=8 \
    --disk-size=300g \
    --kubernetes-version=v1.21.12 \
    --cni calico \
    --insecure-registry=local-registry.kube-system.svc.cluster.local && \
minikube addons enable metallb && \
minikube ip && \
minikube addons configure metallb && \
minikube addons enable registry && \
kubectl -n kube-system expose rc/registry --type=ClusterIP --port=5000 --target-port=5000 --name=local-registry --selector='actual-registry=true' && \
export REGISTRY_IP=$(kubectl -n kube-system get svc/local-registry -o=template={{.spec.clusterIP}}) && \
minikube ssh "echo '$REGISTRY_IP local-registry.kube-system.svc.cluster.local' | sudo tee -a /etc/hosts" && \
echo "127.0.0.1 local-registry.kube-system.svc.cluster.local" | sudo tee -a /etc/hosts 

kubectl port-forward --namespace kube-system service/local-registry 5000
curl -X GET local-registry.kube-system.svc.cluster.local:5000/v2/_catalog

docker load
docker image tag
docker image push

