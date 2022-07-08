#!/bin/bash

#copié dans /etc/profile.d pour être executé au lancement de la connexion

LIST=$(getent passwd | grep /bin/bash | cut -d':' -f1 | cut -d' ' -f2) #récupère la liste des utilisateurs humains
delete=root
USERLIST=( "${LIST[@]/$delete}" ) #supprime root de la liste
USERLIST=($(echo ${LIST[@]/$delete} | tr ":" "\n")) #mise en tableau
# echo ${USERLIST[@]}
declare -A H
cd /home/

for i in "${!USERLIST[@]}"
do
    DISK_USAGE+=($(du -s /home/${USERLIST[$i]} 2> >(grep -v 'Permission denied'))) #récupère la taille du répertoire de chaque utilisateur de la liste
done
# echo ${DISK_USAGE[@]}
# echo "${#USERLIST[@]}"
# echo "${#DISK_USAGE[@]}"

for i in "${!DISK_USAGE[@]}"
do
    if [ $(($i%2)) -eq 0 ];then
        H+=( [ ${DISK_USAGE[$i]} ]=${DISK_USAGE[$i+1]} ) #mise en tableau associatif de la taille avec le nom
    fi
done
#fonction de tri pair/impair
function odd_even_sort(){
    n=$1 #taille de la liste à trier
    array=("$@") #liste
    declare -A dict
    array_key=("${array[@]:0:(${#array[@]})/2}") #clé => taille répertoire
    array_value=("${array[@]:(${#array[@]})/2:${#array[@]}}") #valeur => nom répertoire
    isSorted=0
    tmp=0
    for i in ${!array_key[@]}
    do
        if [ $i -eq 0 ]; then
            continue
        else
            dict+=([${array_key[$i]}]=${array_value[$i]}) #tableau associatif 
        fi
    done
    # echo ${array_value[@]}
    while [ $isSorted -eq 0 ] #tant que la liste n'est pas trié
    do
        for ((i=1;i<=${#array_key[@]}-2;i+=2)); #tri indice impair
        do
            if [ ${array_key[$i]} -lt ${array_key[$i+1]} ];then
                tmp=${array_key[$i]}
                array_key[$i]=${array_key[$(($i+1))]}
                array_key[$(($i+1))]=${tmp}
                isSorted=0
            else
                isSorted=1   
            fi
        done
        for ((i=0;i<=${#array_key[@]}-2;i+=2)); #tri indice pair
        do
            if [ ${array_key[$i]} -lt ${array_key[$i+1]} ];then
                tmp=${array_key[$i]}
                array_key[$i]=${array_key[$(($i+1))]}
                array_key[$(($i+1))]=${tmp}
                isSorted=0
            else
                isSorted=1
            fi
        done
        # echo ${array_key[@]}
    done
}

odd_even_sort "${!H[@]}" "${H[@]}" #appel fonction tri

# echo "${H[@]}"
# echo "${!H[@]}"

for i in {0..4} #0..4 car on souhaite les 5 premiers
do
    echo "${H[${array_key[$i]}]}" | cut -d'/' -f3-   #répère juste le nom de la chaine /home/user
done

# echo ${array_key[@]}
# echo ${H[${array_key[0]}]}
# echo ${H[${array_key[1]}]}
# echo ${H[${array_key[2]}]}
# echo ${H[${array_key[3]}]}
# echo ${H[${array_key[4]}]}