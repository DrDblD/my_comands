WKSCTL=${HOME}/.wks/bin
export VERSION=0.8.4
# export VERSION=0.10.2
mkdir -p $WKSCTL
curl -sSL https://github.com/weaveworks/wksctl/releases/download/v${VERSION}/wksctl-${VERSION}-linux-x86_64.tar.gz | sudo tar -xz -C $WKSCTL
sudo chmod +x $WKSCTL/wksctl 
# sudo ln -s $WKSCTL/wksctl /usr/local/bin/wksctl