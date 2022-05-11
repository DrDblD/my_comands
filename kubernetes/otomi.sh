helm repo add otomi https://otomi.io/otomi-core \
helm repo update
mkdir -p ~/.otomi/
helm show values otomi/otomi > ~/.otomi/values.yaml
helm install -f ~/.otomi/values.yaml otomi-$(echo "otomi" | md5sum | head -c 16) otomi/otomi