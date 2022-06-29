#!/bin/bash
MIN_SIZE=5       
MAX_SIZE=50
NFILES=$(shuf -i 5-10 -n 1)

for i in `eval echo {1..$NFILES}`
    do
        sudo dd bs=1M count=$(($RANDOM%MAX_SIZE + $MIN_SIZE)) if=/dev/urandom of=/home/${USER}/file$i
    done
