#!/bin/bash

FILE=$1
declare -A UNIQUE

while read line ; do
    GRPS=$( echo "$line" | rev | cut -d":" -f2- | rev | cut -d":" -f 4-)  
    ARR+=($(echo $GRPS | tr ":" "\n"))
done < ${FILE}

for i in ${!ARR[@]}
do
    if [[ ! " ${UNIQUE[*]} " =~ " ${ARR[$i]} " ]];then
        UNIQUE[$i]+="${ARR[$i]}"
    fi
done

for i in "${!UNIQUE[@]}"
    do
        if getent group ${UNIQUE[$i]} >/dev/null 2&>1;then 
            sudo groupdel ${UNIQUE[i]}
        else
            echo "group ${UNIQUE[$i]} doesn't exit"
        fi
    done
done
