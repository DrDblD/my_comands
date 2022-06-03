ETCD_VER=v3.5.4

# choose either URL
GOOGLE_URL=https://storage.googleapis.com/etcd
GITHUB_URL=https://github.com/etcd-io/etcd/releases/download
DOWNLOAD_URL=${GITHUB_URL}

BIN=${HOME}/repos/bin/
VENV=${HOME}/repos/.env/

# rm -f /tmp/etcd-${ETCD_VER}-linux-amd64.tar.gz
# rm -rf /tmp/etcd-download-test && mkdir -p /tmp/etcd-download-test
rm -rf ${BIN}/etcd && mkdir -p ${BIN}/etcd

curl -L ${DOWNLOAD_URL}/${ETCD_VER}/etcd-${ETCD_VER}-linux-amd64.tar.gz -o /tmp/etcd-${ETCD_VER}-linux-amd64.tar.gz
tar xzvf /tmp/etcd-${ETCD_VER}-linux-amd64.tar.gz -C ${BIN}/etcd --strip-components=1
rm -f /tmp/etcd-${ETCD_VER}-linux-amd64.tar.gz

${BIN}/etcd/etcd --version
${BIN}/etcd/etcdctl version
${BIN}/etcd/etcdutl version

PWD=$(pwd)

ln -s ${BIN}/etcd/etcd ${VENV}bin/etcd
ln -s ${BIN}/etcd/etcdctl ${VENV}bin/etcdctl
ln -s ${BIN}/etcd/etcdutl ${VENV}bin/etcdutl