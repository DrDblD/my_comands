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
# echo "atab" | (read p1; ssh-keygen -f ~/.ssh/$p1; cat $(find . -name $p1.pub) )

### two string way ###
NAME=$@
[ -n $NAME] && (ssh-keygen -f ~/.ssh/$NAME; cat $(find . -name $NAME.pub)) || (cd ~/.ssh && ssh-keygen && ls | cat $(find . -name id_rsa*.pub))