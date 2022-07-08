#!/bin/bash

FILE=$1 #Récupère le premier argument et enregistre dans la variable
HOME_PATH="/home/arun/projet/bashrc/" #chemin d'accès aux templates
BASHRC_PATH="${HOME_PATH}.bashrc" #chemin d'accès au bashrc
BASH_LOGOUT_PATH="${HOME_PATH}.bash_logout" #chemin d'accès au bash_logout
BASH_PROFILE_PATH="${HOME_PATH}.bash_profile" #chemin d'accès au bash_profile
MIN_SIZE=5 #taille minimale en Mo des fichiers générés
MAX_SIZE=50 #taille maximale en Mo des fichier générés
NFILES=$(shuf -i 5-10 -n 1) #nombre de fichier à générer, un entier aléatoire entre 5 et 10
 

while read line ; do #Boucle pour lire le fichier ligne par ligne
    USERNAME=$( echo "$line" | cut -d\: -f1 ) #Découpe de la ligne pour récupérer le nom d'utilisateur, prénom, nom, mdp etc...
    NAME=$( echo "$line" | cut -d\: -f2 )
    SURNAME=$( echo "$line" | cut -d\: -f3 )
    PASSWORD=${line##*:}
    if id "$USERNAME" >/dev/null 2>&1; then #vérifie que le user n'existe pas
            echo "user already exists"
            continue
        else
        echo "creating ${USERNAME}"
        sudo useradd --create-home --no-user-group --shell /bin/bash --home-dir /home/${USERNAME} $USERNAME -c "${NAME} ${SURNAME}" -p $(perl -e 'print crypt($ARGV[0], "password")' ${PASSWORD})
        #crée un utilisateut sans groupe à son nom avec un shell bash dont le home directory est /home/$USERNAME -c précise son nom et prénom -p son mdp hashé pour que le système le compte 
        sudo loginctl enable-linger ${USERNAME} #permet de continuer à faire tourner les process de l'utilisateur même s'il se déconnecte
        sudo cp $BASHRC_PATH /home/${USERNAME}/             #copie des templates
        sudo cp $BASH_PROFILE_PATH /home/${USERNAME}/       
        sudo cp $BASH_LOGOUT_PATH /home/${USERNAME}/
        sudo passwd --expire ${USERNAME}    #oblige la modification du mdp au prochain login
        
        for i in `eval echo {1..$NFILES}` #creer n fichier dans le répertoire du user
        do
            sudo dd bs=1M count=$(($RANDOM%MAX_SIZE + $MIN_SIZE)) if=/dev/urandom of=/home/${USERNAME}/file$i #dd permet de copier et créer des fichier de tailles précise 
        done
    fi
    GRPS=$( echo "$line" | rev | cut -d":" -f2- | rev | cut -d":" -f 4-) #Récupère la partie de la ligne sur les groupes
    ARR=($(echo $GRPS | tr ":" "\n")) #met en tableau

    for i in "${!ARR[@]}" #boucle sur les groupes
    do
        if getent group ${ARR[$i]} >/dev/null 2&>1;then #check si le groupe existe déjà 
            if [ $i -eq "0" ];then #si le groupe est le premier de l'utilisateur 
                sudo usermod -g ${ARR[i]} $USERNAME #alors il faut que ca soit son groupe principal
            else
                sudo usermod -a -G ${ARR[i]} $USERNAME #sion il faut que ca soit un groupe secondaire
            fi
        else
            sudo groupadd ${ARR[i]} #ajoute le groupe s'il n'existe pas
            if [ $i -eq "0" ];then
                sudo usermod -g ${ARR[i]} $USERNAME
            else
                sudo usermod -a -G ${ARR[i]} $USERNAME
            fi
        fi
    done

done < ${FILE}
