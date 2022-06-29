#!/bin/bash
#sudo cp du_per_user_with_sort.sh /etc/profile.d/ to execute on login

LIST=$(getent passwd | grep /bin/bash | cut -d':' -f1 | cut -d' ' -f2)
#echo $LIST
delete=root
USERLIST=( "${LIST[@]/$delete}" )
USERLIST=($(echo $LIST | tr ":" "\n"))
#echo ${USERLIST[@]}

cd /home/

for i in "${!USERLIST[@]}"
do
    if [ $i -eq "0" ];then
        continue
    else
        DISK_USAGE+=($(du -sh /home/${USERLIST[$i]} 2> >(grep -v 'Permission denied')))
        #echo ${DISK_USAGE[@]}
    fi
done

for i in "${!DISK_USAGE[@]}"
do
    if [ $(($i%2)) -eq 0 ];then
        echo ${DISK_USAGE[$i]} ${DISK_USAGE[$i+1]}
    else
        continue
    fi
done | sort -rh | head -5
