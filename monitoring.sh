#!/bin/bash
architecture=$(uname -a) #The architecture of your operating system and its kernel version.

physicalCpu=$(cat /proc/cpuinfo | grep "physical id" | sort | uniq | wc -l) #The number of physical processors.
virtualCpu=$(grep "^processor" /proc/cpuinfo | wc -l) #The number of virtual processors.

totalRam=$(free --mega | awk '$1 == "Mem:" {print $2}') #The current available RAM on your server.
usedRam=$(free --mega | awk '$1 == "Mem:" {print $3}') #Used Ram
rateUsedRam=$(free | awk '$1 == "Mem:" {printf("%.2f"), $3/$2*100}') #RAM's utilization rate as a percentage.

totalDisk=$() #The current available memory on your server.
usedDisk=$() # Used disk
retaUsedDisk=$() #Memory's utilization rate as a percentage.

cpuLoad=$(top -bn1 | grep '^%Cpu' | cut -c 9- | xargs | awk '{printf("%.1f%%"), $1 + $3}') #The current utilization rate of your processors as a percentage.
lastReboot=$(who -b | awk '$1 == "system" {print $3 " " $4}') #The date and time of the last reboot.
lvmAux=$(lsblk | grep "lvm" | wc -l)
lvm=$(if [ $lvmAux -eq 0 ]; then echo no; else echo yes; fi) #Whether LVM is active or not.

numConnectionTCP=$(cat /proc/net/sockstat{,6} | awk '$1 == "TCP:" {print $3}') #The number of active connections

numUsers=$(who | wc -l) #The number of users using the server.
IPv4=$(hostname -I) #The IPv4 address of your server.
MAC=$(ip link show | awk '$1 == "link/ether" {print $2}') #Server's MAC (Media Access Control) address.
numCommandsSudo=$(sudo grep sudo /var/log/auth.log | wc -l) #The number of commands executed with the sudo program.

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