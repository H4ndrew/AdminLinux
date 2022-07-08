#!/bin/bash
if [ -f "/home/arun/projet/log/sidlog" ];then #check si le fichier existe
    sudo find / \( -perm -4000 -o -perm -2000 \) -type f 2> >(grep -v 'No such file or directory') | grep -v ELF > /home/arun/projet/log/sidlog.new #cherche les fichiers avec les permissions
    d=$(diff /home/arun/projet/log/sidlog.new /home/arun/projet/log/sidlog | cut -d'<' -f2 | cut -s -d'/' -f1-) #compare l'archive existante de suid sgid avec la nouvelle et enregistre la différence dans d
else
    sudo find / \( -perm -4000 -o -perm -2000 \) -type f 2> >(grep -v 'No such file or directory') | grep -v ELF > /home/arun/projet/log/sidlog
fi

if [[ ! -z "$d" ]]; then #si différence 
    ls -lah $d #alors afficher ls -lah des fichiers
else
    echo "no changes detected" #sinon echo et créer l'archive
    mv /home/arun/projet/log/sidlog.new /home/arun/projet/log/sidlog
fi 