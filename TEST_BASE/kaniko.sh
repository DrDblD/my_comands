#!/bin/bash


# sudo docker run -d gcr.io/kaniko-project/executor:v1.7.0 --help

# Usage:
#   executor [flags]
#   executor [command]

# Available Commands:
#   help        Help about any command
#   version     Print the version number of kaniko

# Flags:
#       --build-arg multi-arg type                  This flag allows you to pass in ARG values at build time. Set it repeatedly for multiple values.
#       --cache                                     Use cache when building image
#       --cache-copy-layers                         Caches copy layers
#       --cache-dir string                          Specify a local directory to use as a cache. (default "/cache")
#       --cache-repo string                         Specify a repository to use as a cache, otherwise one will be inferred from the destination provided
#       --cache-ttl duration                        Cache timeout in hours. Defaults to two weeks. (default 336h0m0s)
#       --cleanup                                   Clean the filesystem at the end
#       --compressed-caching                        Compress the cached layers. Decreases build time, but increases memory usage. (default true)
#   -c, --context string                            Path to the dockerfile build context. (default "/workspace/")
#       --context-sub-path string                   Sub path within the given context.
#       --customPlatform string                     Specify the build platform if different from the current host
#   -d, --destination multi-arg type                Registry the final image should be pushed to. Set it repeatedly for multiple destinations.
#       --digest-file string                        Specify a file to save the digest of the built image to.
#   -f, --dockerfile string                         Path to the dockerfile to be built. (default "Dockerfile")
#       --force                                     Force building outside of a container
#       --force-build-metadata                      Force add metadata layers to build image
#       --git gitoptions                            Branch to clone if build context is a git repository (default branch=,single-branch=false,recurse-submodules=false)
#   -h, --help                                      help for executor
#       --ignore-path multi-arg type                Ignore these paths when taking a snapshot. Set it repeatedly for multiple paths.
#       --image-fs-extract-retry int                Number of retries for image FS extraction
#       --image-name-tag-with-digest-file string    Specify a file to save the image name w/ image tag w/ digest of the built image to.
#       --image-name-with-digest-file string        Specify a file to save the image name w/ digest of the built image to.
#       --insecure                                  Push to insecure registry using plain HTTP
#       --insecure-pull                             Pull from insecure registry using plain HTTP
#       --insecure-registry multi-arg type          Insecure registry using plain HTTP to push and pull. Set it repeatedly for multiple registries.
#       --label multi-arg type                      Set metadata for an image. Set it repeatedly for multiple labels.
#       --log-format string                         Log format (text, color, json) (default "color")
#       --log-timestamp                             Timestamp in log output
#       --no-push                                   Do not push the image to the registry
#       --oci-layout-path string                    Path to save the OCI image layout of the built image.
#       --push-retry int                            Number of retries for the push operation
#       --registry-certificate key-value-arg type   Use the provided certificate for TLS communication with the given registry. Expected format is 'my.registry.url=/path/to/the/server/certificate'.
#       --registry-mirror multi-arg type            Registry mirror to use as pull-through cache instead of docker.io. Set it repeatedly for multiple mirrors.
#       --reproducible                              Strip timestamps out of the image to make it reproducible
#       --single-snapshot                           Take a single snapshot at the end of the build.
#       --skip-tls-verify                           Push to insecure registry ignoring TLS verify
#       --skip-tls-verify-pull                      Pull from insecure registry ignoring TLS verify
#       --skip-tls-verify-registry multi-arg type   Insecure registry ignoring TLS verify to push and pull. Set it repeatedly for multiple registries.
#       --skip-unused-stages                        Build only used stages if defined to true. Otherwise it builds by default all stages, even the unnecessaries ones until it reaches the target stage / end of Dockerfile
#       --snapshotMode string                       Change the file attributes inspected during snapshotting (default "full")
#       --tarPath string                            Path to save the image in as a tarball instead of pushing
#       --target string                             Set the target build stage to build
#       --use-new-run                               Use the experimental run implementation for detecting changes without requiring file system snapshots.
#   -v, --verbosity string                          Log level (trace, debug, info, warn, error, fatal, panic) (default "info")

# Use "executor [command] --help" for more information about a command.

# docker run \
#     -v "/tmp/la":/workspace \
#     -v "/tmp/.docker/config.json":/kaniko/.docker/config.json \
#     gcr.io/kaniko-project/executor:v1.7.0 \
#     -f "/workspace/Dockerfile" \
#     --no-push \
#     --tarPath "/workspace/tomcat-alpine.tar.gz" \
#     --destination "docker.poidem.ru/ops/tomcat-base:alpine-jdk8-slim" \
#     -v "debug"
JDK_VER="8";
JDK_BUILD="321";
GCLIBS="https://github.com/sgerrand/alpine-pkg-glibc/releases/download/2.32-r0/glibc-2.32-r0.apk";
TOMCAT="https://archive.apache.org/dist/tomcat/tomcat-7/v7.0.109/bin/apache-tomcat-7.0.109.tar.gz";

p="alpine";
tag="jdk8-slim";

if [[-na /tmp/la]];
then 
    mkdir /tmp/la;
    ln -sP /tmp/la ~/builds;
else
    rm -rf /tmp/la/*;
fi
cp ~/lib/jdk-${JDK_VER}u${JDK_BUILD}-linux-x64.tar.gz /tmp/la/jdk.tar.gz;
cp ~/repos/tomcat-base/Dockerfile /tmp/la/Dockerfile;

#If you want to mount a folder so that only that container can access the folder, for example such as your logging daemon, swap out :z with :Z.
docker run --rm \
    -v "/tmp/la":/workspace:Z \
    gcr.io/kaniko-project/executor:v1.7.0 \
    -f "/workspace/Dockerfile" \
    --destination "tomcat-base:$p-${tag}" \
    --no-push \
    --tarPath "tomcat-base-$p-${tag}.tar.gz" \
    --build-arg JDK=jdk.tar.gz --build-arg  GCLIBS=${GCLIBS} --build-arg TOMCAT=${TOMCAT};
    # -v "debug";

pup=$(ls ~/builds/ | grep tomcat | tail -n 1)

if [[ "$pup" == "tomcat-base-$p-$tag.tar.gz" ]]; then
    docker load --input ~/builds/tomcat-base-$p-${tag}.tar.gz;
    docker run -d --name tomcat-test -p 9080:8080 tomcat-base:$p-${tag};
    sleep 3;
    test_val=$(curl -sL -w "%{http_code}\\n" "http://127.0.0.1:8080/" -o /dev/null);
    if [[ "$test_val" == "200" ]]; then
        echo "success";
    else 
        echo "$test_val";
    fi
    # docker stop tomcat-test;
    docker rm --force tomcat-test;
    docker rmi tomcat-base:$p-${tag};
fi
# ls -la /tmp/la | grep tomcat | xargs $(if [[-z {} ]] then echo "bad" fi);

# container_auth_exec_t
# container_config_t
# container_file_t
# container_home_t
# container_kvm_var_run_t
# container_lock_t
# container_log_t
# container_plugin_var_run_t
# container_ro_file_t
# container_runtime_exec_t
# container_runtime_tmp_t
# container_runtime_tmpfs_t
# container_unit_file_t
# container_var_lib_t
# container_var_run_t