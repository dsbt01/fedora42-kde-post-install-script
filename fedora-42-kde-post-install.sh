#!/bin/bash

# Exit on error
set -e

echo "🔄 Updating system..."
sudo dnf update -y

echo "📦 Enabling RPM Fusion repositories..."
sudo dnf install \
  https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm \
  https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm -y

echo "🎥 Enabling OpenH264 codec..."
sudo dnf config-manager setopt fedora-cisco-openh264.enabled=1

echo "🔄 Replacing ffmpeg-free with full ffmpeg..."
sudo dnf swap ffmpeg-free ffmpeg --allowerasing -y

echo "🎶 Updating multimedia group without weak dependencies..."
sudo dnf update @multimedia --setopt="install_weak_deps=False" --exclude=PackageKit-gstreamer-plugin -y

echo "🛠️ Installing Git and Zsh..."
sudo dnf install git zsh -y

echo "⚙️ Setting Zsh as default shell..."
chsh -s $(which zsh)

echo "💡 Preparing Zsh plugins..."
touch ~/.zshrc
mkdir -p ~/.zsh/plugins

git clone https://github.com/zsh-users/zsh-autosuggestions ~/.zsh/plugins/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-syntax-highlighting ~/.zsh/plugins/zsh-syntax-highlighting
git clone https://github.com/zsh-users/zsh-completions ~/.zsh/plugins/zsh-completions

echo "📜 Updating .zshrc with plugin configuration..."
cat << 'EOF' >> ~/.zshrc

# Plugin Paths
fpath+=~/.zsh/plugins/zsh-completions

# Load Plugins
source ~/.zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
source ~/.zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
autoload -Uz compinit && compinit
EOF

echo "🔤 Installing FiraCode Nerd Font..."
mkdir -p ~/.local/share/fonts
wget -O ~/.local/share/fonts/FiraCode.zip https://github.com/ryanoasis/nerd-fonts/releases/latest/download/FiraCode.zip
unzip -o ~/.local/share/fonts/FiraCode.zip -d ~/.local/share/fonts/FiraCode
fc-cache -fv

echo "🚀 Installing Starship prompt..."
curl -sS https://starship.rs/install.sh | sh -s -- -y

echo "🎨 Applying Catppuccin Powerline Starship preset..."
mkdir -p ~/.config
starship preset catppuccin-powerline -o ~/.config/starship.toml
echo 'eval "$(starship init zsh)"' >> ~/.zshrc

echo "🧩 Adding Flathub repository..."
sudo flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo

echo "📦 Adding Terra repository..."
sudo dnf install --nogpgcheck --repofrompath 'terra,https://repos.fyralabs.com/terra$releasever' terra-release -y

echo "🎨 Installing Kvantum and Orchis KDE theme..."
sudo dnf install kvantum -y
cd ~
git clone https://github.com/vinceliuice/Orchis-kde.git
cd Orchis-kde
./install.sh

echo "🎨 Installing Tela Icon Theme..."
cd ~
git clone https://github.com/vinceliuice/Tela-icon-theme.git
cd Tela-icon-theme
./install.sh -d ~/.icons

echo "🧹 Cleaning up temporary folders..."
cd ~
rm -rf Orchis-kde
rm -rf Tela-icon-theme
rm -rf fedora42-kde-post-install-script

echo "🔁 Reloading Zsh configuration..."
exec zsh
