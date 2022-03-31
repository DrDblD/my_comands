DIRECTORY=~/.ssh
if [ -d "$DIRECTORY" ]; then
    echo "$DIRECTORY exists."
else 
    echo "$DIRECTORY does not exist."
    mkdir 
fi
cd ~/.ssh && ssh-keygen
ls | cat $(find . -name id_rsa*.pub) # | xclip # to copy to clipboard
cd ~
