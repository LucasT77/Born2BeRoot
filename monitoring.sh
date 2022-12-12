#!/bin/bash
architecture=$(uname -a) #The architecture of your operating system and its kernel version.

physicalCpu=$(cat /proc/cpuinfo | grep "physical id" | sort | uniq | wc -l) #The number of physical processors.
virtualCpu=$(grep "^processor" /proc/cpuinfo | wc -l) #The number of virtual processors.

totalRam=$(free --mega | awk '$1 == "Mem:" {print $2}') #The current available RAM on your server.
usedRam=$(free --mega | awk '$1 == "Mem:" {print $3}') #Used Ram
rateUsedRam=$(free | awk '$1 == "Mem:" {printf("%.2f"), $3/$2*100}') #RAM's utilization rate as a percentage.

totalDisk=$(df -Bg | grep '^/dev/' | grep -v '/boot$' | awk '{ft += $2} END {print ft}') #The current available memory on your server.
usedDisk=$(df -Bm | grep '^/dev/' | grep -v '/boot$' | awk '{ut += $3} END {print ut}') # Used disk
rateUsedDisk=$(df -Bm | grep '^/dev/' | grep -v '/boot$' | awk '{ut += $3} {ft+= $2} END {printf("%d"), ut/ft*100}') #Memory's utilization rate as a percentage.

cpuLoad=$(top -bn1 | grep Cpu | awk '{printf("%.1f%%", $2 + $4)}') #The current utilization rate of your processors as a percentage.
lastReboot=$(who -b | awk '$1 == "system" {print $3 " " $4}') #The date and time of the last reboot.
lvmAux=$(lsblk | grep "lvm" | wc -l)
lvm=$(if [ $lvmAux -eq 0 ]; then echo no; else echo yes; fi) #Whether LVM is active or not.

numConnectionTCP=$(netstat -an | grep ESTABLISHED | wc -l) #The number of active connections

numUsers=$(who | wc -l) #The number of users using the server.
IPv4=$(hostname -I) #The IPv4 address of your server.
MAC=$(ip link show | awk '$1 == "link/ether" {print $2}') #Server's MAC (Media Access Control) address.
numCommandsSudo=$(journalctl _COMM=sudo | grep COMMAND | wc -l) #The number of commands executed with the sudo program.

wall	"	#Architecture: $architecture
			#CPU physical: $physicalCpu
			#vCPU: $virtualCpu
			#Memory Usage: $usedRam/${totalRam}MB (${rateUsedRam}%)
			#Disk Usage: $usedDisk/${totalDisk}Gb (${rateUsedDisk}%)
			#CPU load: $cpuLoad
			#Last boot: $lastReboot
			#LVM use: $lvm
			#Connections TCP: $numConnectionTCP ESTABLISHED
			#User log: $numUsers
			#Network: IP $IPv4 ($MAC)
			#Sudo: $numCommandsSudo cmd
		"