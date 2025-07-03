#!/bin/bash

set -euo pipefail

echo "======================================================"
echo "Ubuntu Development Environment Setup"
echo "======================================================"
echo

# Verificação de distribuição
if ! grep -q "Ubuntu" /etc/os-release; then
  echo "Este script é exclusivo para Ubuntu."
  exit 1
fi

echo "Atualizando sistema..."
sudo apt update && sudo apt upgrade -y

echo "Instalando pacotes base..."
sudo apt install -y git zsh tmux curl wget ca-certificates software-properties-common gnupg lsb-release inotify-tools rsync

# ---------------------------------------
# Docker
# ---------------------------------------
echo "Instalando Docker..."
sudo install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg |
  sudo gpg --dearmor -o /etc/apt/keyrings/docker.asc
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] \
  https://download.docker.com/linux/ubuntu $(. /etc/os-release && echo "${UBUNTU_CODENAME:-$VERSION_CODENAME}") stable" |
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

sudo apt update
sudo apt install -y docker-ce docker-ce-cli containerd.io docker-compose-plugin

if ! command -v docker >/dev/null; then
  echo "Erro: Docker não instalado corretamente." >&2
  exit 1
fi

# ---------------------------------------
# RVM
# ---------------------------------------
echo "Instalando RVM..."
gpg --keyserver hkps://keyserver.ubuntu.com --recv-keys \
  409B6B1796C275462A1703113804BB82D39DC0E3 \
  7D2BAF1CF37B13E2069D6956105BD0E739499BDB

curl -sSL https://get.rvm.io | bash -s stable
source "$HOME/.rvm/scripts/rvm"

# ---------------------------------------
# NVM + Node
# ---------------------------------------
echo "Instalando NVM..."
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.0/install.sh | bash

export NVM_DIR="$HOME/.nvm"
source "$NVM_DIR/nvm.sh"
nvm install node

# ---------------------------------------
# VS Code
# ---------------------------------------
echo "Instalando VS Code via Snap..."
sudo snap install --classic code

# ---------------------------------------
# ZSH + Plugins + Config
# ---------------------------------------
echo "Configurando ZSH..."
sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
curl -fsSL https://raw.githubusercontent.com/marcospedro97/dotfiles/refs/heads/master/rc_files/zshrc -o "$HOME/.zshrc"

git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting

chsh -s "$(which zsh)"

# ---------------------------------------
# Tmux
# ---------------------------------------
echo "Configurando Tmux..."
curl -fsSL https://raw.githubusercontent.com/marcospedro97/dotfiles/refs/heads/master/rc_files/tmux.conf -o "$HOME/.tmux.conf"

# ---------------------------------------
# pyenv
# ---------------------------------------
echo "Instalando pyenv..."
curl -fsSL https://pyenv.run | bash

# ---------------------------------------
# Terraform
# ---------------------------------------
echo "Instalando Terraform..."
wget -O- https://apt.releases.hashicorp.com/gpg | \
  gpg --dearmor | sudo tee /usr/share/keyrings/hashicorp-archive-keyring.gpg > /dev/null
echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] \
  https://apt.releases.hashicorp.com $(lsb_release -cs) main" |
  sudo tee /etc/apt/sources.list.d/hashicorp.list > /dev/null
sudo apt update && sudo apt install -y terraform

# ---------------------------------------
# redis-commander
# ---------------------------------------
echo "Instalando redis-commander..."
source "$NVM_DIR/nvm.sh"
npm install -g redis-commander

# ---------------------------------------
# Go
# ---------------------------------------
echo "Instalando Go..."
GO_LATEST=$(curl -s https://go.dev/VERSION?m=text)
GO_TARBALL="${GO_LATEST}.linux-amd64.tar.gz"
curl -LO "https://go.dev/dl/${GO_TARBALL}"
sudo rm -rf /usr/local/go
sudo tar -C /usr/local -xzf "$GO_TARBALL"
rm "$GO_TARBALL"
grep -q '/usr/local/go/bin' "$HOME/.zshrc" || echo 'export PATH=$PATH:/usr/local/go/bin' >> "$HOME/.zshrc"

# ---------------------------------------
# rclone
# ---------------------------------------
echo "Instalando rclone..."
curl https://rclone.org/install.sh | sudo bash

# ---------------------------------------
# OneDrive Sync com systemd
# ---------------------------------------
echo "Configurando backup automático..."
mkdir -p "$HOME/.scripts" "$HOME/.config/systemd/user" "$HOME/OneDrive"

curl -fsSL https://raw.githubusercontent.com/marcospedro97/dotfiles/refs/heads/master/backup/watch-rsync.sh -o "$HOME/.scripts/watch-rsync.sh"
chmod 700 "$HOME/.scripts/watch-rsync.sh"

curl -fsSL https://raw.githubusercontent.com/marcospedro97/dotfiles/refs/heads/master/backup/onedrive-mount.service -o "$HOME/.config/systemd/user/onedrive-mount.service"
curl -fsSL https://raw.githubusercontent.com/marcospedro97/dotfiles/refs/heads/master/backup/rsync-watcher.service -o "$HOME/.config/systemd/user/rsync-watcher.service"

chmod 600 "$HOME/.scripts/rsync-watcher.log"

systemctl --user daemon-reexec
systemctl --user daemon-reload
systemctl --user enable --now onedrive-mount.service
systemctl --user enable --now rsync-watcher.service

echo "======================================================"
echo "Setup completo!"
echo "======================================================"
echo
echo "Notas importantes:"
echo "1. Reinicie o terminal ou faça logout/login para aplicar alterações."
echo "2. Docker e Go exigem reinício do shell para PATH correto."
echo "3. Para garantir segurança do backup, dados só serão sobrescritos se houver mais de 10 arquivos no SRC."
