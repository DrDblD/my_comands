# https://artifacthub.io/packages/olm/community-operators/flux?modal=install
# kubectl apply -f https://github.com/operator-framework/operator-lifecycle-manager/releases/download/0.14.1/crds.yaml
# kubectl apply -f https://github.com/operator-framework/operator-lifecycle-manager/releases/download/0.14.1/olm.yaml
# kubectl create -f https://operatorhub.io/install/stable/flux.yaml
# kubectl get csv -n operators
# https://github.com/artazar/kubernetes-cluster-sample

brew install flux

personal access token

flux chechk --pre 
flux install

export GITLAB_TOKEN=<your-token> # api, read_api personal access token

flux bootstrap gitlab \
  --ssh-hostname=gitlab.poidem.ru \
  --hostname=gitlab.poidem.ru \
  --owner=ops \
  --repository=k8s-test \
  --branch=dev \
  --path=clusters/my-mini
