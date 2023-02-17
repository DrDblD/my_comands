kubectl get pods -o jsonpath={..metadata.name}

kubectl get nodes --no-headers -o custom-columns=":metadata.name" | grep node | xargs kubectl describe nodes | less

k -n kube-system get po --no-headers -o custom-columns=":metadata.name" | grep filebeat  | xargs kubectl -n kube-system delete po