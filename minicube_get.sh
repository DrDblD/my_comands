PACKAGE=minikube_latest_amd64.deb
curl -LO https://storage.googleapis.com/minikube/releases/latest/$PACKAGE --output /tmp/$PACKAGE
dpkg -i /tmp/$PACKAGE
rm /tmp/$PACKAGE