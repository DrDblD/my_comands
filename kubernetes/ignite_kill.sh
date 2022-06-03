# ps aux | grep ignite | grep -v grep  | awk '{print $2}' | xargs sudo kill -9
sudo umount /dev/mapper/ignite-*
sudo ignite rm -f $(sudo ignite ps -aq)
# ls /dev/mapper/ | grep ignite | xargs -n 1 sudo dmsetup info -c 
# ls /dev/mapper/ | grep ignite | xargs -n 1 sudo dmsetup remove -c 
# sudo footloose delete
# /bin/bash -c /home/atab/repos/firekube/wks-quickstart-firekube/cleanup.sh