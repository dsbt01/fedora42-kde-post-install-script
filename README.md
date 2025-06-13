# 🎉 Fedora 42 KDE Post-Install Script

Automate your Fedora 42 KDE setup with a single script!  
Get codecs, fonts, Zsh, plugins, Starship prompt, and more — fully configured.


![preview](https://github.com/user-attachments/assets/9a4468b6-69bc-415f-b1b7-6410b5d6319d)

---

## 🚀 What This Script Does

- 🔄 Updates system packages
- 📦 Enables RPM Fusion (Free & Non-Free)
- 🎞 Installs OpenH264 & replaces `ffmpeg-free` with full `ffmpeg`
- 🎶 Sets up multimedia group (without weak dependencies)
- ⚙️ Installs Git & Zsh, sets Zsh as default shell
- 💡 Adds essential Zsh plugins: autosuggestions, syntax highlighting, completions
- 🔤 Installs Fira Code Nerd Font
- 🚀 Installs Starship prompt with Catppuccin Powerline theme
- 🧩 Adds Flathub and Terra repositories

---

## 🛠️ How to Use

```bash
sudo dnf install git -y
git clone https://github.com/mahbub-research/fedora42-kde-post-install-script.git
cd fedora42-kde-post-install-script
chmod +x fedora-42-kde-post-install.sh
./fedora-42-kde-post-install.sh


