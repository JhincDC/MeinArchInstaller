#!/bin/bash

# Variables
core="base linux linux-firmware linux-headers grub efibootmgr networkmanager base-devel bash-completion os-probers"
packages="$core"
succesfullInstallation=0

# Functions
loadingFunction() {
    bash ./coolFunctions/loadingFunction.sh
}

tryCatch() {
    if $1; then
        succesfullInstallation=1
    fi
}

runningInsideChroot(){
    tryCatch "arch-chroot /mnt bash /installer.sh"
}

# Main
main(){

echo "Remember. All of this is for personal uses, so, some packages is not here due doesn't match with my current hardware"

while true; do
succesfullInstallation=1
clear
    echo "Partition Drives"
    echo "This part is manual"
    echo "Do not forget to mount your partition!!!"
    echo "You can use \"cfdisk\""
    echo "Mount partitions with this command: \"mount /directory\""
    echo "Mount root on /mnt , and EFI on /mnt/boot/efi"
    bash
    echo -n "Are you sure that you has mounted every partitions? [Y/N]: "
    read partDrivesSure
    if [[ "$partDrivesSure" == "Y" || "$partDrivesSure" == "y" ]]; then
        break
    fi
done

pacman -Sy --noconfirm archlinux-keyring
pacstrap -K /mnt $packages
genfstab -U /mnt >> /mnt/etc/fstab

cp installer.sh /mnt
cp pkgInstaller.sh /mnt
cp -r pkgBase /mnt
runningInsideChroot

if [ "$succesfullInstallation" != 1 ]; then
    echo "Something went wrong :("
    sleep 1
    return 1
fi

clear
echo "Finishing!"
rm /mnt/installer.sh
rm /mnt/pkgInstaller.sh
rm -r /mnt/pkgBase
loadingFunction
umount -R /mnt

echo "Use PostInstaller for setting up and install everything else"
}

main
