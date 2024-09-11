#!/bin/bash

# Automated Zsh Installation Script
# This script installs Zsh, Oh My Zsh, and essential plugins for a better terminal experience

# Check if the user is running the script with sudo or root permissions
if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root or with sudo privileges." 
   exit 1
fi

# Install Zsh
echo "Installing Zsh..."
apt update && apt install -y zsh curl git  # Use apt for Debian/Ubuntu-based systems
# Uncomment and adjust the following lines if using other package managers
# yum install -y zsh curl git # For RedHat/CentOS-based systems
# pacman -S --noconfirm zsh curl git # For Arch-based systems

# Install Oh My Zsh
echo "Installing Oh My Zsh..."
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# Install Zsh Plugins
echo "Installing Zsh plugins..."
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting

# Configure .zshrc with Oh My Zsh theme and plugins
echo "Configuring .zshrc..."
ZSHRC=~/.zshrc
if [ ! -f "$ZSHRC" ]; then
    touch $ZSHRC
fi

sed -i '/^ZSH_THEME=/d' $ZSHRC
echo 'ZSH_THEME="agnoster"' >> $ZSHRC
sed -i '/^plugins=/d' $ZSHRC
echo 'plugins=(git zsh-autosuggestions zsh-syntax-highlighting)' >> $ZSHRC

echo 'source ~/.oh-my-zsh/custom/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh' >> $ZSHRC
echo 'source ~/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh' >> $ZSHRC

# Change the default shell to Zsh
echo "Changing default shell to Zsh..."
chsh -s $(which zsh)

echo "Installation complete! Restart your terminal or run 'zsh' to start using it."
