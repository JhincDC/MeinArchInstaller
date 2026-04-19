
# Constants
TOTAL_STEPS=7
CURRENT_STEP=0

# Variables
mbrgptselection=0
pkgDirectory="./pkgBase"

backtitleDialog="ArchLinux Installer"

# Functions
loadingFunction() {
    bash ./coolFunctions/loadingFunction.sh
}

tryCatch() {
    if $1; then
        succesfullInstallation=1
    fi
}


runInstallNecessaryPKG(){
    tryCatch "bash pkgInstaller.sh $pkgDirectory"
}

installDE(){
    tryCatch "pacman -Sy --noconfirm --needed $de"
}


addChaoticAUR() {
    pacman-key --recv-key 3056513887B78AEB
    pacman-key --lsign-key 3056513887B78AEB
    sudo pacman -U --noconfirm 'https://cdn-mirror.chaotic.cx/chaotic-aur/chaotic-keyring.pkg.tar.zst'
    sudo pacman -U --noconfirm 'https://cdn-mirror.chaotic.cx/chaotic-aur/chaotic-mirrorlist.pkg.tar.zst'
    echo -e "\n#Multilib\n[multilib]\nInclude = /etc/pacman.d/mirrorlist" >> /etc/pacman.conf
    echo -e "\n#Chaotic AUR\n[chaotic-aur]\nInclude = /etc/pacman.d/chaotic-mirrorlist" >> /etc/pacman.conf
    sudo sed -i '/# Misc options/a ILoveCandy' /etc/pacman.conf
    sudo sed -i 's/^#Color/Color/' /etc/pacman.conf
}

chooseMBRorGPT() {
while true; do
    choosingMBRorGPT=$(dialog --backtitle "$backtitleDialog" \
        --clear \
        --title "Select an option" \
        --menu "Choose one:" 10 40 2 \
        1 "MBR" \
        2 "GPT" \
        3>&1 1>&2 2>&3)

            case $choosingMBRorGPT in
                1)
                    discoMBRorGPT="grub-install --target=i386-pc /dev/sda"
                    mbrgptselection="MBR"
                    break
                    ;;
                2)
                    discoMBRorGPT="grub-install --target=x86_64-efi --efi-directory=/boot/efi --no-nvram --removable --bootloader-id=ArchBTW"
                    mbrgptselection="GPT"
                    break
                    ;;
                *)
                    echo "Not valid entry."
                    sleep 1
                    ;;
            esac


done
}

machineName() {
    machine=$(dialog --backtitle "$backtitleDialog" \
                    --title "Machine Name" \
                    --stdout \
                    --inputbox "Enter machine name:" 0 0)
}

principalUser() {
    dialog --backtitle "$backtitleDialog" \
        --title "REMEMBER" \
        --msgbox "For now, you'll have just a lonely user.\nYou can add more in postinstallation." 0 0

    user=$(dialog --backtitle "$backtitleDialog" \
                    --title "User name all in lowercase please" \
                    --stdout \
                    --inputbox "Enter your user name that you want to login in the machine, all in lowercase please:" 0 0)
    user=${user,,}
}

update_progress() {
    local message=$1
    ((CURRENT_STEP++))
    local percent=$(( CURRENT_STEP * 100 / TOTAL_STEPS ))
    echo "XXX"
    echo "$message"
    echo "XXX"
    echo "$percent"
}

selectRegion() {
while true; do
    dialog --backtitle "$backtitleDialog" \
        --title "Note" \
        --msgbox "If you don't know, just write UTC next to /usr/share/zoneinfo/\nAnd it looks like this:\n/usr/share/zoneinfo/UTC" 0 0


    region=$(dialog --title "Select your region" \
        --stdout \
        --fselect /usr/share/zoneinfo/  14 70)

     dialog --backtitle "$backtitleDialog" \
                --title "Region Selected" \
                --yesno "The region you've selected is: $region\nAre you sure?" 0 0
            response=$?
        clear
        if [ $response -eq 0 ]; then
            break
        fi
done
}

# Main
main(){

runInstallNecessaryPKG
if [ "$succesfullInstallation" != 1 ]; then
    return 1
fi


dialog --backtitle "$backtitleDialog" \
        --title "HOW TO USE THIS" \
        --msgbox "Just write the direction where the file region are, based on the two windows above text region.\nDO NOT PRESS OK IF YOU HAVE NOT SELECTED YOUR REGION\n\nPress ENTER if you are sure" 0 0

selectRegions

ln -sf ${region} /etc/localtime
hwclock --systohc
clear

dialog --backtitle "$backtitleDialog" \
        --title "Language" \
        --msgbox "At the moment, installer is available US_English Only" 0 0
echo "en_US.UTF-8 UTF-8" > /etc/locale.gen
locale-gen
echo "LANG=en_US.UTF-8" > /etc/locale.conf

addChaoticAUR

while true; do
    choice=$(dialog --clear \
        --backtitle "$backtitleDialog" \
        --title "Main Menu" \
        --menu "Choose an option:" 15 50 4 \
        1 "Choose MBR or GPT" \
        2 "Choose Machine Name" \
        3 "Choose Main Username" \
        4 "Continue" \
        3>&1 1>&2 2>&3)

    status=$?
    clear

    if [ $status -ne 0 ]; then
        break
    fi

    case "$choice" in
        1)
            chooseMBRorGPT
            ;;
        2)
            machineName
            ;;
        3)
            principalUser
            ;;
        4)
            dialog --backtitle "$backtitleDialog" \
                --title "SUMMARY" \
                --yesno "Disk Style: $mbrgptselection\nMachineName: $machine\nUser name (lowercase): $user\nAre you sure?" 0 0
            response=$?
            clear
            if [ $response -eq 0 ]; then
                break
            fi
            ;;
    esac
done

useradd -m -G wheel -s /bin/bash "$user"


password=$(dialog --backtitle "$backtitleDialog" \
                --title "$user Password" \
                --stdout \
                --insecure \
                --passwordbox "Introduce User Password:" 0 0)
echo "$user:$password" | chpasswd

dialog --backtitle "$backtitleDialog" \
       --title "Root Password" \
       --yesno "Same User Password for Root?" 0 0
       response=$?
       clear

if [ $response -eq 0 ]; then
clear
else
password=$(dialog --backtitle "$backtitleDialog" \
                --title "Root Password" \
                --stdout \
                --insecure \
                --passwordbox "Introduce Root Password:" 0 0)
fi
echo "root:$password" | chpasswd
password=0

dialog --backtitle "$backtitleDialog" \
       --title "FINISHING!" \
       --msgbox "This is the last step." 0 0

(
    update_progress "Enabling sudoers"
    sed -i 's/^# %wheel ALL=(ALL:ALL) ALL/%wheel ALL=(ALL:ALL) ALL/' /etc/sudoers
    sleep 1

    update_progress "Enabling GRUB"
    sed -i '/GRUB_DISABLE_OS_PROBER=/d' /etc/default/grub
    echo "GRUB_DISABLE_OS_PROBER=false" >> /etc/default/grub
    sleep 1

    update_progress "Enabling hosts"
    echo "$machine" > /etc/hostname
    bash -c "cat <<EOF > /etc/hosts
127.0.0.1   localhost
::1         localhost
127.0.1.1   $machine.localdomain $machine
EOF"
    sleep 1

    update_progress "Installing grub"
    $discoMBRorGPT
    sed -i 's/^GRUB_CMDLINE_LINUX_DEFAULT=.*/GRUB_CMDLINE_LINUX_DEFAULT="loglevel=3 quiet splash video=1366x768"/' /etc/default/grub
    sed -i 's/^#GRUB_GFXMODE=.*$/GRUB_GFXMODE=1366x768x32/' /etc/default/grub
    sed -i 's/^#GRUB_GFXPAYLOAD_LINUX=.*$/GRUB_GFXPAYLOAD_LINUX=keep/' /etc/default/grub
    grub-mkconfig -o /boot/grub/grub.cfg
    sleep 1

    update_progress "Enabling Networks"
    systemctl enable NetworkManager
    sleep 1

    update_progress "Making some Tweaks"
    sleep 1

    update_progress "Finishing Main Installation"
    sleep 2

) | dialog --backtitle "$backtitleDialog" \
    --title "Installing System" \
    --gauge "Starting..." 10 75 0

clear
echo "Basic Installation Complete :)"
sleep 2
loadingFunction

}

main
