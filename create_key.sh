### Long sheet way ###
# DIRECTORY=~/.ssh
# if [ -d "$DIRECTORY" ]; then
#     echo "$DIRECTORY exists."
# else 
#     echo "$DIRECTORY does not exist."
#     mkdir $DIRECTORY
# fi
# cd ~/.ssh && ssh-keygen 
# ls | cat $(find . -name id_rsa*.pub) # | xclip # to copy to clipboard
# cd ~

### one string way ###
# echo "atab" | (read p1; ssh-keygen -f ~/.ssh/$p1; cat $(find . -name $p1.pub); read $host; echo -e "Host $host\n  HostName $host\n  User ${USER} \n  IdentityFile ~/.ssh/$p1\n  IdentitiesOnly yes\n  HostKeyAlgorithms=+ssh-rsa" >> ~/.ssh/config )

### two string way ###
NAME=$@
[ -n $NAME] && (ssh-keygen -f ~/.ssh/$NAME; cat $(find . -name $NAME.pub)) || (cd ~/.ssh && ssh-keygen && ls | cat $(find . -name id_rsa*.pub))


# for i in {1..4}; do
#     host=webapps-test
#     echo -e "Host $host$i\n  HostName $host$i\n  User ${USER} \n  IdentityFile ~/.ssh/${USER}}\n  IdentitiesOnly yes\n" >> ~/.ssh/config
#     host=webapps-dev
#     echo -e "Host $host$i\n  HostName $host$i\n  User ${USER} \n  IdentityFile ~/.ssh/${USER}}\n  IdentitiesOnly yes\n  HostKeyAlgorithms=+ssh-rsa" >> ~/.ssh/config
# done

# Host github.com
#   HostName github.com
#   IdentityFile ~/.ssh/github