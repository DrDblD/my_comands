PACKAGE=minikube_latest_amd64.deb
curl -LO https://storage.googleapis.com/minikube/releases/latest/$PACKAGE --output /tmp/$PACKAGE
dpkg -i $PACKAGE
rm /tmp/$PACKAGE