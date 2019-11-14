#!/bin/bash
################################	PREINSTALLATION		################################
read -p "User to be added to sudo group: " user
read -p "Install nginx / php / mysql? [y/n]: " webinstall
read -p "Installing on a Laptop? [y/n]" laptop

if [$webinstall == "y"]; then
	read -p "enter mysql-server password: " pw
fi

export DEBIAN_FRONTEND='noninteractive'

apt update

# SUDO
apt install sudo
usermod -aG sudo $user

################################	SOFTWARE		################################
## Driver installation
if [$laptop == "y"]; then
    apt install firmware-linux-nonfree firmware-iwlwifi
fi

## Installing basic software
apt install -y git curl vlc gcc gdb apt-transport-https wireshark zsh terminator tldr

## nginx / mysql / php
if [$webinstall == "y"]; then
	debconf-set-selections <<< 'mysql-server mysql-server/root_password password $pw'
	debconf-set-selections <<< 'mysql-server mysql-server/root_password_again password $pw'
	apt install -y nginx php7.3-fpm php7.3-mysql mysql-common
fi

## Software with deb packages
echo "Downloading deb packages..."
curl -L https://go.microsoft.com/fwlink/?LinkID=760868 -o code.deb

dpkg -i code.deb

apt install -f

## Keyserver Software
curl -s https://typora.io/linux/public-key.asc | apt-key add - # Typora
curl -s https://updates.signal.org/desktop/apt/keys.asc | apt-key add - # signal

apt update && apt install -y typora signal-desktop

## zsh customization
chsh -s "$(command -v zsh)" "$user" # change default shell for user
sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"

## looks and feel, desktop
apt-get install gnome-core

git clone https://github.com/EliverLara/Ant-Bloody.git
mv Ant-Bloody /usr/share/themes
gsettings set org.gnome.desktop.interface gtk-theme "Ant-Bloody"
gsettings set org.gnome.desktop.wm.preferences theme "Ant-Bloody"

git clone https://github.com/PapirusDevelopmentTeam/papirus-icon-theme.git
mv papirus-icon-theme/Papirus /usr/share/icons
rm -rf ./papirus-icon-theme

gsettings set org.gnome.settings-daemon.plugins.media-keys custom-keybindings "[\
'/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom4/', \
'/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom7/' \
]"
gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom4/ name "Terminator"
gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom4/ command "terminator"
gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom4/ binding "<SUPER>r"

gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom7/ name "Explorer"
gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom7/ command "nautilus"
gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom7/ binding "<SUPER>e"


export DEBIAN_FRONTEND='dialog'
