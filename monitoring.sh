#!/bin/bash
arch=$(uname -a) #The architecture of your operating system and its kernel version.
phyCpu=$(cat /proc/cpuinfo | grep "physical id" | sort | uniq | wc -l) #The number of physical processors.
virCpu=$(grep "^processor" /proc/cpuinfo | wc -l) #The number of virtual processors.
avRam=$(grep "MemAvailable" /proc/meinfo) #The current available RAM on your server.
utiRam=$(free | awk '$1 == "Mem:" {printf("%.2f"), $3/$2*100}') #RAM's utilization rate as a percentage.

avMem=$() #The current available memory on your server.
utiMem=$() #Memory's utilization rate as a percentage.

utiCpu=$(top -bn1 | grep '^%Cpu' | cut -c 9- | xargs | awk '{printf("%.1f%%"), $1 + $3}') #The current utilization rate of your processors as a percentage.
lastReb=$(who -b | awk '$1 == "system" {print $3 " " $4}') #The date and time of the last reboot.
lvmAux=$(lsblk | grep "lvm" | wc -l)
lvm=$(if [ $lvmAux -eq 0 ]; then echo no; else echo yes; fi) #Whether LVM is active or not.

numCon=$(cat /proc/net/sockstat{,6} | awk '$1 == "TCP:" {print $3}') #The number of active connections

numUsers=$(who | wc -l) #The number of users using the server.
IPv4=$(hostname -I) #The IPv4 address of your server.
MAC=$(ip link show | awk '$1 == "link/ether" {print $2}') #Server's MAC (Media Access Control) address.
numConSudo=$(sudo grep sudo /var/log/auth.log | wc -l) #The number of commands executed with the sudo program.

wall	"	#Architecture:
			#CPU physical:
			#vCPU:
			#Memory Usage:
			#Disk Usage:
			#CPU load:
			#Last boot:
			#LVM use:
			#Connections TPC:
			#User log:
			#Network:
			#Sudo:
		"