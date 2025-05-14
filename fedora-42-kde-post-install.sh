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

echo "🌈 Installing Oh My Posh..."
curl -s https://ohmyposh.dev/install.sh | bash -s

echo "🎨 Downloading TechJotters Oh My Posh theme..."
mkdir -p ~/.config/oh-my-posh
curl -o ~/.config/oh-my-posh/techjotters_conda.omp.json https://raw.githubusercontent.com/mahbub-research/techjotters-ohmyposh-theme/main/techjotters_conda.omp.json

echo "⚡ Applying Oh My Posh config..."
echo 'eval "$(oh-my-posh init zsh --config ~/.config/oh-my-posh/techjotters_conda.omp.json)"' >> ~/.zshrc

echo "🧩 Adding Flathub repository..."
flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo

echo "📦 Adding Terra repository..."
sudo dnf install --nogpgcheck --repofrompath 'terra,https://repos.fyralabs.com/terra$releasever' terra-release -y

echo "🔁 Reloading Zsh configuration..."
exec zsh
