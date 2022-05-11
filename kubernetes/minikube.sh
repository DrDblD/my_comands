curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64
sudo install minikube-linux-amd64 /usr/local/bin/minikube
chmod 0600 $HOME/.minikube/profiles/minikube/config.json
mkdir -p $HOME/.minikube/certs
cp my_company.pem $HOME/.minikube/certs/
minikube start --embed-certs
