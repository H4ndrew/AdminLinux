#!/bin/bash

FILE=$1
HOME_PATH="/home/arun/projet/bashrc/"
BASHRC_PATH="${HOME_PATH}.bashrc"
BASH_LOGOUT_PATH="${HOME_PATH}.bash_logout"
BASH_PROFILE_PATH="${HOME_PATH}.bash_profile"
MIN_SIZE=5       
MAX_SIZE=50
NFILES=$(shuf -i 5-10 -n 1)
 

while read line ; do
    USERNAME=$( echo "$line" | cut -d\: -f1 )
    NAME=$( echo "$line" | cut -d\: -f2 )
    SURNAME=$( echo "$line" | cut -d\: -f3 )
    PASSWORD=${line##*:}
    if id "$USERNAME" >/dev/null 2>&1; then
            echo "user already exists"
            continue
        else
        echo "creating ${USERNAME}"
        sudo useradd --create-home --no-user-group --shell /bin/bash --home-dir /home/${USERNAME} $USERNAME -c "${NAME} ${SURNAME}" -p $(perl -e 'print crypt($ARGV[0], "password")' ${PASSWORD})
        sudo loginctl enable-linger ${USERNAME}
        sudo cp $BASHRC_PATH /home/${USERNAME}/
        sudo cp $BASH_PROFILE_PATH /home/${USERNAME}/
        sudo cp $BASH_LOGOUT_PATH /home/${USERNAME}/
        sudo passwd --expire ${USERNAME}
        
        for i in `eval echo {1..$NFILES}`
        do
            sudo dd bs=1M count=$(($RANDOM%MAX_SIZE + $MIN_SIZE)) if=/dev/urandom of=/home/${USERNAME}/file$i
        done
    fi
    GRPS=$( echo "$line" | rev | cut -d":" -f2- | rev | cut -d":" -f 4-)  
    ARR=($(echo $GRPS | tr ":" "\n"))

    for i in "${!ARR[@]}"
    do
        if getent group ${ARR[$i]} >/dev/null 2&>1;then 
            if [ $i -eq "0" ];then
                sudo usermod -g ${ARR[i]} $USERNAME
            else
                sudo usermod -a -G ${ARR[i]} $USERNAME
            fi
        else
            sudo groupadd ${ARR[i]}
            if [ $i -eq "0" ];then
                sudo usermod -g ${ARR[i]} $USERNAME
            else
                sudo usermod -a -G ${ARR[i]} $USERNAME
            fi
        fi
    done

done < ${FILE}
