helm repo add otomi https://otomi.io/otomi-core && \
helm repo update && \
mkdir -p ~/.otomi/ && \
helm show values otomi/otomi > ~/.otomi/values.yaml && \
code -r /home/atab/.otomi/values.yaml && \
helm install -f ~/.otomi/values.yaml otomi-$(echo "otomi" | base64 | md5sum | head -c 8) otomi/otomi

### alternative install

git clone https://github.com/redkubes/otomi-core.git && \
cd otomi-core && \
nano chart/otomi/Chart.yaml && nano chart/otomi/values.yaml && \
helm install -f chart/otomi/values.yaml my-otomi-release-$(echo "otomi" | base64 | md5sum | head -c 8) chart/otomi

### 