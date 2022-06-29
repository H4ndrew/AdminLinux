#!/bin/bash
if [ -f "/home/arun/projet/log/sidlog" ];then
    sudo find / \( -perm -4000 -o -perm -2000 \) -type f 2> >(grep -v 'No such file or directory') | grep -v ELF > /home/arun/projet/log/sidlog.new
    d=$(diff /home/arun/projet/log/sidlog.new /home/arun/projet/log/sidlog | cut -d'<' -f2 | cut -s -d'/' -f1-)
else
    sudo find / \( -perm -4000 -o -perm -2000 \) -type f 2> >(grep -v 'No such file or directory') | grep -v ELF > /home/arun/projet/log/sidlog
fi

if [[ ! -z "$d" ]]; then
    ls -lah $d
else
    echo "no changes detected"
    mv /home/arun/projet/log/sidlog.new /home/arun/projet/log/sidlog
fi 