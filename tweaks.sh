#!/bin/bash

echo "Enjoy :)"

#Next code is for personal Layout, but I'll do it manually
#wget https://github.com/JhincDC/PersonalSetup/raw/refs/heads/main/personalSetup_part_aa
#wget https://github.com/JhincDC/PersonalSetup/raw/refs/heads/main/personalSetup_part_ab
#wget https://github.com/JhincDC/PersonalSetup/raw/refs/heads/main/personalSetup_part_ac
#cat personalSetup_part_* > personalSetup.knsv
#konsave -i personalSetup.knsv
#sleep 1
#konsave -a personalSetup

echo "About ZRAM and SWAPFILE"

sudo pacman -Sy --needed --noconfirm zram-generator
echo "[zram0]
zram-size = ram * 2
compression-algorithm = zstd
swap-priority = 80
fs-type = swap" | sudo tee /etc/systemd/zram-generator.conf
sudo fallocate -l 4G /swapfile
sudo chmod 600 /swapfile
sudo swapon /swapfile
sudo mkswap /swapfile
echo "/swapfile swap swap defaults 0 0" | sudo tee -a /etc/fstab

# I'll try to avoid Clip Studio Paint and FL Studio
#git clone https://github.com/Bisanota/WineConfigs.git
#cd WineConfigs
#bash main.sh

wget https://github.com/JhincDC/PersonalSetup/raw/refs/heads/main/arch-mac-style.zip
unzip arch-mac-style.zip
sudo cp -r ./arch-mac-style /usr/share/plymouth/themes/
sudo plymouth-set-default-theme -R arch-mac-style

echo "Once you install ZSH and Oh My ZSH!, pls, put \"YES\" and type \"EXIT\""
sudo pacman -Sy --noconfirm --needed zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

echo "Finished"

echo "To fix OBS with LSP plugins, use \"Exec=env QT_QPA_PLATFORM=xcb\" before OBS execution"
