export VERSION=v0.7.1
# export VERSION=v0.10.0
# export VERSION=v0.8.0
export GOARCH=$(go env GOARCH 2>/dev/null || echo "amd64")

for binary in ignite ignited; do
    echo "Installing ${binary}..."
    curl -sfLo ${binary} https://github.com/weaveworks/ignite/releases/download/${VERSION}/${binary}-${GOARCH}
    chmod +x ${binary}
    sudo mv ${binary} ${HOME}/.wks/bin
done