#!/bin/bash

DISK_USAGE=($(du -sb /home/$USER 2> >(grep -v 'Permission denied')))
GO=$(($DISK_USAGE/1000000000))
DISK_USAGE=$(($DISK_USAGE-GO*1000000000))
MO=$(($DISK_USAGE/1000000))
DISK_USAGE=$(($DISK_USAGE-MO*1000000))
KO=$(($DISK_USAGE/1000))
DISK_USAGE=$(($DISK_USAGE-KO*1000))
T=$(($DISK_USAGE))

# sed  -i "s/GO/$GO/g" /home/$USER/.bash_profile
# sed  -i "s/MO/$MO/g" /home/$USER/.bash_profile
# sed  -i "s/KO/$KO/g" /home/$USER/.bash_profile
# sed  -i "s/T/$T/g" /home/$USER/.bash_profile

# sed -i 's/USER_SIZE=0/echo -e "${USER} : $GO Go $MO Mo $KO ko $T octets"/g' /home/$USER/.bash_profile
if [ $GO -eq 0 ]; then
    sed -i 's/USER_SIZE=0/echo -e "${USER} : $MO Mo, $KO ko et $T octets"/g' /home/$USER/.bash_profile
elif [ $MO -eq 0 ]; then
    sed -i 's/USER_SIZE=0/echo -e "${USER} : $KO ko et $T octets"/g' /home/$USER/.bash_profile
elif [ $KO -eq 0 ]; then
    sed -i 's/USER_SIZE=0/echo -e "${USER} : $T octets"/g' /home/$USER/.bash_profile
else 
    sed -i 's/USER_SIZE=0/echo -e "${USER} : $GO Go, $MO Mo, $KO ko et $T octets"/g' /home/$USER/.bash_profile
fi

if [ $GO -ge 1 ]||[ $MO -gt 100 ]; then
    sed -i 's/WARNING=0/echo -e "${red}Vous occupez plus que les 100 Mo autorisé"/g' /home/$USER/.bash_profile
fi
