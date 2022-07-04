#!/bin/bash

LIST=$(getent passwd | grep /bin/bash | cut -d':' -f1 | cut -d' ' -f2)
delete=root
USERLIST=( "${LIST[@]/$delete}" )
USERLIST=($(echo ${LIST[@]/$delete} | tr ":" "\n"))
# echo ${USERLIST[@]}
declare -A H
cd /home/

for i in "${!USERLIST[@]}"
do
    DISK_USAGE+=($(du -s /home/${USERLIST[$i]} 2> >(grep -v 'Permission denied')))
done
# echo ${DISK_USAGE[@]}
# echo "${#USERLIST[@]}"
# echo "${#DISK_USAGE[@]}"

for i in "${!DISK_USAGE[@]}"
do
    if [ $(($i%2)) -eq 0 ];then
        H+=( [ ${DISK_USAGE[$i]} ]=${DISK_USAGE[$i+1]} )
    fi
done

function odd_even_sort(){
    n=$1
    array=("$@")
    declare -A dict
    array_key=("${array[@]:0:(${#array[@]})/2}")
    array_value=("${array[@]:(${#array[@]})/2:${#array[@]}}")
    isSorted=0
    tmp=0
    for i in ${!array_key[@]}
    do
        if [ $i -eq 0 ]; then
            continue
        else
            dict+=([${array_key[$i]}]=${array_value[$i]})
        fi
    done
    # echo ${array_value[@]}
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
        # echo ${array_key[@]}
    done
}

odd_even_sort "${!H[@]}" "${H[@]}"

# echo "${H[@]}"
# echo "${!H[@]}"

for i in {0..4}
do
    #echo ${H[${array_key[$i]}]}| cut -d'/' -f3
    echo "${H[${array_key[$i]}]}" | cut -d'/' -f3-   
done

# echo ${array_key[@]}
# echo ${H[${array_key[0]}]}
# echo ${H[${array_key[1]}]}
# echo ${H[${array_key[2]}]}
# echo ${H[${array_key[3]}]}
# echo ${H[${array_key[4]}]}