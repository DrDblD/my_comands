kubectl create namespace argocd
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml
kubectl patch svc argocd-server -n argocd -p '{"spec": {"type": "LoadBalancer"}}'
kubectl port-forward svc/argocd-server -n argocd 8080:443 > /tmp/local-argocd.minikube.log &
kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d; echo

izTjZj1y2dwB1je9

argocd login <ARGOCD_SERVER>
argocd account update-password
kubectl config get-contexts -o name
argocd cluster add current context
argocd app get guestbook 

#@# remove
kubectl get all,cm,ingress,job,secret -n argocd -o name | xargs kubectl delete -n argocd
kubectl delete namespaces argocd