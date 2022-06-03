if test -d /tmp/la/;
then
    rm -rf /tmp/la/*;
else
    mkdir /tmp/la;
    ln -sP /tmp/la ~/builds;
fi
STPATH=${PWD}
KAPATH=/tmp/la
cp -r $HOME/repos/LISA/lisa-kube/* $KAPATH/
KAPITAN_IMAGE=kapicorp/kapitan:v0.30.0-rc.0

# cd $KAPATH && \
# py yaml_concat.py lisa-dev && \
# find $KAPATH/inventory/targets/ -maxdepth 1 -name lisa-* -type d -exec rm -rf {} \;
# cd $STPATH && \
docker run --rm -i -w /src \
   -v $KAPATH/:/src:Z \
   $KAPITAN_IMAGE $@


# /home/atab/repos/my_comands/kubernetes/kapitan.sh compile --targets lisa-dev --reveal