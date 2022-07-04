#!/bin/bash

FILE=$1

while read line ; do
    USERNAME=$( echo "$line" | cut -d\: -f1 )
    if id "$USERNAME" >/dev/null 2>&1; then
        echo "deleting ${USERNAME}"
        sudo passwd -l ${USERNAME}
        sudo killall -9 -u ${USERNAME}
        sudo userdel ${USERNAME}
        sudo rm -rf /home/${USERNAME}/.ssh
        sudo mkdir -p /home/deleted-users/
        sudo mv /home/${USERNAME}/ /home/deleted-users/${USERNAME}/
        echo "successfully deleted ${USERNAME}"    
    else
        echo "user ${USERNAME} does not exist"
        continue
    fi
done < ${FILE}
