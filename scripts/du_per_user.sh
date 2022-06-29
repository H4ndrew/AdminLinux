#!/bin/bash

LIST=$(getent passwd | grep /bin/bash | cut -d':' -f1 | cut -d' ' -f2)
delete=root
USERLIST=( "${LIST[@]/$delete}" )
USERLIST=($(echo $LIST | tr ":" "\n"))

declare -A H
cd /home/

for i in "${!USERLIST[@]}"
do
    if [ $i -eq "0" ];then
        continue
    else
        DISK_USAGE+=($(du -s /home/${USERLIST[$i]} 2> >(grep -v 'Permission denied')))
    fi
done

for i in {0..18}
do
    if [ $(($i%2)) -eq 0 ];then
        H+=( [ ${DISK_USAGE[$i]} ]=${DISK_USAGE[$i+1]} )
    fi
done

function odd_even_sort(){
    n=$1
    array=("$@")
    declare -A dict
    declare -A sorted
    array_key=("${array[@]:0:(${#array[@]}-2)/2}")
    array_value=("${array[@]:(${#array[@]}-2)/2:${#array[@]}}")
    isSorted=0
    tmp=0
    for i in ${!array_key[@]}
    do
        dict+=([${array_key[$i]}]=${array_value[$i]})
    done

    while [ $isSorted -eq 0 ]
    do
        for ((i=1;i<=${#array_key[@]}-2;i+=2));
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
        for ((i=0;i<=${#array_key[@]}-2;i+=2));
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
    done
}

odd_even_sort "${!H[@]}" "${H[@]}"

for i in {0..4}
do
    SH=${H[${array_key[$i]}]}
    echo ${SH[@]}| cut -d'/' -f2-
done