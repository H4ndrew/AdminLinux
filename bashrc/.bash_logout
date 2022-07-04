# ~/.bash_logout: executed by bash(1) when login shell exits.

# when leaving the console clear the screen to increase privacy

if [ "$SHLVL" = 1 ]; then
    [ -x /usr/bin/clear_console ] && /usr/bin/clear_console -q
fi

sed  -i 's/echo -e "${red}Vous occupez plus que les 100 Mo autorisé"/WARNING=0/g' /home/$USER/.bash_profile

sed  -i 's/echo -e "${USER} : $GO Go $MO Mo $KO ko $T octets"/USER_SIZE=0/g' /home/$USER/.bash_profile
