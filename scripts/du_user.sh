#!/bin/bash

#copié dans /etc/profile.d pour être executé au lancement de la connexion

DISK_USAGE=($(du -sb /home/$USER 2> >(grep -v 'Permission denied'))) #calcul de la taille du répertoire utilisateur
GO=$(($DISK_USAGE/1000000000)) # conversion en go
DISK_USAGE=$(($DISK_USAGE-GO*1000000000))
MO=$(($DISK_USAGE/1000000)) # conversion en mo
DISK_USAGE=$(($DISK_USAGE-MO*1000000))
KO=$(($DISK_USAGE/1000)) # conversion en ko
DISK_USAGE=$(($DISK_USAGE-KO*1000))
T=$(($DISK_USAGE)) # reste = octects

#On a décider de ne pas afficher 0 Go ou 0 Mo, si l'utilisateur ne consomme que 10 Ko, alors la partie Go et Mo ne sera pas affiché 

if [ $GO -eq 0 ]; then
    sed -i 's/USER_SIZE=0/echo -e "${USER} : $MO Mo, $KO ko et $T octets"/g' /home/$USER/.bash_profile #sed permet de remplacer l'occurence de la chaine 'USER_SIZE=0' par echo ... 
elif [ $MO -eq 0 ]; then                                                                                #dans le fichier bash_profile de l'utilisateur à la connexion
    sed -i 's/USER_SIZE=0/echo -e "${USER} : $KO ko et $T octets"/g' /home/$USER/.bash_profile
elif [ $KO -eq 0 ]; then
    sed -i 's/USER_SIZE=0/echo -e "${USER} : $T octets"/g' /home/$USER/.bash_profile
else 
    sed -i 's/USER_SIZE=0/echo -e "${USER} : $GO Go, $MO Mo, $KO ko et $T octets"/g' /home/$USER/.bash_profile
fi

if [ $GO -ge 1 ]||[ $MO -gt 100 ]; then
    sed -i 's/WARNING=0/echo -e "${red}Vous occupez plus que les 100 Mo autorisé"/g' /home/$USER/.bash_profile
fi
