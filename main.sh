#!/bin/bash

# Variables
HOSTNAME=$(cat /etc/hostname)
loggedAs=$(whoami)
succesfullInstallation=0

# Functions
loadingFunction() {
    bash ./coolFunctions/loadingFunction.sh
}


rootLogin(){
    if [ "$loggedAs" != "root" ]; then
        echo "You're not superuser!"
        sleep 1
        echo "Pls run this script as SuperUser"
        exit
    else
        echo "You are installing Archlinux."
        sleep 0.5
        echo "Detecting installation method."
        sleep 2
    fi
}

tryCatch() {
    if $1; then
        succesfullInstallation=1
    fi
}


runPreInstaller(){
    tryCatch "bash preInstaller.sh"
}

runPostInstaller(){
    tryCatch "bash postInstaller.sh"
}


# Main
main() {

clear
echo "Welcome to this Archlinux installer!!"
sleep 2
echo "Loading!"
loadingFunction

clear
echo "Remember to stay connected to internet in any moment!"
sleep 2
loadingFunction
if [[ "$USER" == "root"  && "$HOSTNAME" == "archiso" ]]; then
    echo "Live Environment Detected!"
    loadingFunction
    runPreInstaller
    sleep 2
else
    echo "Installation Detected!"
    loadingFunction
    runPostInstaller
    sleep 2
fi

if [ "$succesfullInstallation" == 1 ]; then
    echo "Installation finished"
    loadingFunction
    echo "Thanks for using this installer :)"
else
    echo "Installation has failed, run \"main.sh\" again! :("
fi
}

main
