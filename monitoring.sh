#!/bin/bash
PATH='/usr/local/bin:/bin:/usr/bin:/usr/local/sbin:/usr/sbin'

echo -n "#Architecture: " && uname -a

echo -n "#CPU physical : " && nproc

echo -n "#vCPU : " && cat /proc/cpuinfo | grep processor | wc -l

free -h | grep Mem | awk '{printf("#Memory Usage: %d"), $3}'
free -h | grep Mem | awk '{printf("/%dMB "), $2}'
free -t | grep Mem | awk '{printf("(%.2f%%)\n"), $3/$2*100}'

df -h | grep root | awk '{printf("#Disk Usage: %.1f"), $3}'
df -h | grep root | awk '{printf("/%.1fGb "), $4}'
df -h | grep root | awk '{printf("(%d%%)\n"), $5}'

mpstat | grep all | awk '{printf("#CPU load: %.2f%%\n"), 100-$13}'

echo -n "#Last boot: " && uptime -s

if lvscan | grep -q 'ACTIVE';
then
       echo "#LVM use : yes"
else
	echo "#LVM use : no"
fi

echo -n "#Connections TCP : " && netstat -natp | grep LISTEN | wc -l | tr -d '\n' && echo " ESTABLISHED"

echo -n "#User log: " && w -h | wc -l

ip route | grep src | awk '{printf("#Network: IP %s"), $9}'
ip link | grep ether | awk '{printf(" (%s)\n"), $2}'

echo -n "#Sudo : " && grep -a sudo /var/log/sudo/sudo.log | grep COMMAND | wc -l | tr -d '\n' && echo " cmd"
