#!/bin/bash
################################	PREINSTALLATION		################################
read -p "User to be added to sudo group" user
read -p "Install nginx / php / mysql? [y/n]: " webinstall
if [$webinstall == 'y']; then
	read -p "enter mysql-server password: " pw
fi

export DEBIAN_FRONTEND='noninteractive'

apt update

# SUDO
apt install sudo
usermod -aG sudo $user

################################	SOFTWARE		################################
## Installing basic software
apt install -y git curl vlc gcc gdb apt-transport-https wireshark zsh terminator
apt install -y qemu-kvm libvirt-clients libvirt-daemon-system # Virtualbox alternative

adduser $user libvirt
adduser $user libvirt-qemu


## zsh customization
chsh -s "$(command -v zsh)" "$user" # change default shell for user
sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"

## nginx / mysql / php
if [$webinstall == 'y']; then
	debconf-set-selections <<< 'mysql-server mysql-server/root_password password $pw'
	debconf-set-selections <<< 'mysql-server mysql-server/root_password_again password $pw'
	apt install -y nginx php7.3-fpm php7.3-mysql mysql-server
fi

## Software with deb packages
echo "Downloading deb packages..."
curl -L https://go.microsoft.com/fwlink/?LinkID=760868 -o code.deb
curl -L https://www.dropbox.com/download?dl=packages/ubuntu/dropbox_2019.02.14_amd64.deb -o dropbox.deb

dpkg -i code.deb
dpkg -i dropbox.deb

apt install -f

## Keyserver Software
curl -s https://typora.io/linux/public-key.asc | apt-key add - # Typora
curl -s https://updates.signal.org/desktop/apt/keys.asc | apt-key add - # signal

apt update && apt install -y typora signal-desktop



export DEBIAN_FRONTEND='dialog'
