#!/bin/bash

USER=awang
HOSTS="vb01 vb02 vb03 vb04 vb05 vb06 vb07 vb08 vb09 vb10"
PORT=8053


for host in $HOSTS 
do
    ssh $USER@$host "ps -ef | egrep \"/usr/bin/ipbenchd -p $PORT\"  | egrep 'python3' | egrep -v 'egrep' | sed -r 's/\s+/ /g' | cut -d' ' -f2 | xargs kill"
    ssh $USER@$host "nohup ipbenchd -p $PORT > /dev/null 2>&1 </dev/null &"
done
