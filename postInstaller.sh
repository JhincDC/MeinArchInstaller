
pkgDirectory="./packagesList"
plasma="sddm plasma konsole dolphin ark kate okular gwenview kcalc filelight kdeconnect partitionmanager ksshaskpass konsave"

loadingFunction() {
    bash ./coolFunctions/loadingFunction.sh
}

tryCatch() {
    if $1; then
        succesfullInstallation=1
    else
        succesfullInstallation=0
    fi
}

installPKGs() {
    tryCatch "bash pkgInstaller.sh ./pkgDirectory"
}

installDE() {
    tryCatch "pacman -Sy --noconfirm --needed $plasma"
}

validationInstallPKGS() {
    if [ "$succesfullInstallation" != 1 ]; then
    echo "Packages were not installed, at least not all"
    sleep 1
    loadingFunction
        return 1
    fi
}


main() {

echo "You will install, in fact, personal bundle of apps."
loadingFunction
sleep 1
areUSure=$(echo -n "Are you sure you don't need changes? [Y/N]: ")
sleep .5

if [[ "$areUSure" == "N" || "$areUSure" == "n" ]]; then
    exit
fi

clear
loadingFunction

echo "Installation of apps is starting"
sleep 1
installPKGs
validationInstallPKGS
clear

echo "Installation of the Desktop Environment starting"
sleep 1
installDE
validationInstallPKGS
clear


echo "Setting up few things"
sleep 1



sed -i 's/^HOOKS=.*/HOOKS=(base systemd plymouth autodetect microcode modconf kms keyboard keymap sd-vconsole block filesystems fsck)/' /etc/mkinitcpio.conf

printf "[Theme]\nCurrent=breeze\n" > /etc/sddm.conf
set -e
if [ -d "/etc/brave" ]; then
    POLICY_DIR="/etc/brave/policies/managed"
elif [ -d "/etc/opt/brave" ]; then
    POLICY_DIR="/etc/opt/brave/policies/managed"
else
    POLICY_DIR="/etc/brave/policies/managed"
fi
sudo mkdir -p "$POLICY_DIR"
sudo tee "$POLICY_DIR/brave_policies.json" > /dev/null <<EOF
{
  "BraveRewardsDisabled": true,
  "BraveWalletDisabled": true,
  "BraveVPNDisabled": true,
  "BraveAIChatEnabled": false,
  "BraveStatsPingEnabled": false
}
EOF

chmod 644 "$POLICY_DIR/brave_policies.json"
chown root:root "$POLICY_DIR/brave_policies.json"

grub-mkconfig -o /boot/grub/grub.cfg
mkinitcpio -P

systemctl enable sddm.service
systemctl enable cups
systemctl enable bluetooth
systemctl enable avahi-daemon.service
systemctl enable tlp.service
systemctl enable fstrim.timer

echo "Post-Installation Complete :)"
sleep 1
echo "Remember to use \"tweaks.sh\" to really finish personal configuration"
loadingFunction
}

main
