#!/bin/bash

# Ubuntu Setup Script
# This script installs essential development tools for Ubuntu

set -e  # Exit on any error

echo "======================================================"
echo "Ubuntu Development Environment Setup"
echo "======================================================"
echo

# Check if running on Ubuntu
if ! grep -q "Ubuntu" /etc/os-release; then
    echo "This script is designed for Ubuntu only. Exiting..."
    exit 1
fi

echo "======================================================"
echo "Updating System"
echo "======================================================"
echo

sudo apt update && sudo apt upgrade -y

echo "======================================================"
echo "Installing Git"
echo "======================================================"
echo

sudo apt install -y git

echo "======================================================"
echo "Installing Docker"
echo "======================================================"
echo

sudo apt-get update
sudo apt-get install ca-certificates curl
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc

# Add the repository to Apt sources:
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "${UBUNTU_CODENAME:-$VERSION_CODENAME}") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update

# Install Docker
sudo apt update
sudo apt install -y docker-ce docker-ce-cli containerd.io docker-compose-plugin


echo "======================================================"
echo "Installing RVM (Ruby Version Manager)"
echo "======================================================"
echo

# Install RVM dependencies
sudo apt install -y software-properties-common

# Add RVM GPG key
gpg --keyserver keyserver.ubuntu.com --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3 7D2BAF1CF37B13E2069D6956105BD0E739499BDB

# Install RVM
curl -sSL https://get.rvm.io | bash -s stable
source ~/.rvm/scripts/rvm

echo "======================================================"
echo "Installing NVM (Node Version Manager)"
echo "======================================================"
echo

curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.0/install.sh | bash

# Source nvm and install latest Node.js
export NVM_DIR="$HOME/.nvm"
# shellcheck source=/dev/null
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
nvm install node

echo "======================================================"
echo "Installing VS Code"
echo "======================================================"
echo

# Install VS Code from snap
sudo snap install --classic code

echo "======================================================"
echo "Installing ZSH"
echo "======================================================"
echo

sudo apt install -y zsh

echo "======================================================"
echo "Installing Oh My Zsh"
echo "======================================================"
echo

sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended

echo "======================================================"
echo "Copying ZSH Configuration"
echo "======================================================"
echo

curl -fsSL https://raw.githubusercontent.com/marcospedro97/dotfiles/refs/heads/master/rc_files/zshrc -o "$HOME/.zshrc"
echo "Downloaded zshrc to $HOME/.zshrc"

echo "======================================================"
echo "Installing ZSH Plugins"
echo "======================================================"
echo

# Install zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions

# Install zsh-syntax-highlighting
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting

echo "======================================================"
echo "Installing TMUX"
echo "======================================================"
echo

sudo apt install -y tmux

echo "======================================================"
echo "Copying TMUX Configuration"
echo "======================================================"
echo

curl -fsSL https://raw.githubusercontent.com/marcospedro97/dotfiles/refs/heads/master/rc_files/tmux.conf -o "$HOME/.tmux.conf"
echo "Downloaded tmux.conf to $HOME/.tmux.conf"

echo "======================================================"
echo "Installing pyenv"
echo "======================================================"
echo

curl -fsSL https://pyenv.run | bash

echo "======================================================"
echo "Installing pgAdmin4 (Desktop Only)"
echo "======================================================"
echo

# Install pgAdmin4 Desktop (official repo)
curl -fsS https://www.pgadmin.org/static/packages_pgadmin_org.pub | sudo gpg --dearmor -o /usr/share/keyrings/packages-pgadmin-org.gpg
sudo sh -c 'echo "deb [signed-by=/usr/share/keyrings/packages-pgadmin-org.gpg] https://ftp.postgresql.org/pub/pgadmin/pgadmin4/apt/$(lsb_release -cs) pgadmin4 main" > /etc/apt/sources.list.d/pgadmin4.list && apt update'
sudo apt install -y pgadmin4-desktop

echo "======================================================"
echo "Installing Terraform"
echo "======================================================"
echo

# Install Terraform (official HashiCorp repo)
sudo apt-get update && sudo apt-get install -y gnupg software-properties-common
wget -O- https://apt.releases.hashicorp.com/gpg | \
  gpg --dearmor | sudo tee /usr/share/keyrings/hashicorp-archive-keyring.gpg > /dev/null
echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | \
  sudo tee /etc/apt/sources.list.d/hashicorp.list > /dev/null
sudo apt update && sudo apt install -y terraform

echo "======================================================"
echo "Installing redis-commander (via npm)"
echo "======================================================"
echo

# Source .zshrc to ensure nvm and node are available
if [ -f "$HOME/.zshrc" ]; then
    . "$HOME/.zshrc"
fi

if command -v npm >/dev/null 2>&1; then
    npm install -g redis-commander
else
    echo "npm not found. Please open a new shell and run: npm install -g redis-commander"
fi

echo "======================================================"
echo "Setting ZSH as Default Shell"
echo "======================================================"
echo

chsh -s $(which zsh)

# CUDA installation if NVIDIA GPU is present
echo "======================================================"
echo "Checking for NVIDIA GPU and Installing CUDA if present"
echo "======================================================"
echo

if command -v nvidia-smi >/dev/null 2>&1; then
    echo "NVIDIA GPU detected. Installing latest CUDA Toolkit..."
    # Add NVIDIA CUDA repository
    UBUNTU_VERSION=$(lsb_release -rs)
    CUDA_REPO_URL="https://developer.download.nvidia.com/compute/cuda/repos/ubuntu${UBUNTU_VERSION//./}/x86_64/"
    CUDA_KEY_URL="${CUDA_REPO_URL}3bf863cc.pub"
    # Add GPG key
    sudo apt-key adv --fetch-keys "$CUDA_KEY_URL" || true
    # Add repo
    echo "deb ${CUDA_REPO_URL} /" | sudo tee /etc/apt/sources.list.d/cuda.list
    sudo apt update
    # Install the meta-package 'cuda' (always latest)
    sudo apt install -y cuda
    # Add CUDA to PATH and LD_LIBRARY_PATH in .zshrc if not already present
    if ! grep -q '/usr/local/cuda/bin' ~/.zshrc; then
        echo 'export PATH=/usr/local/cuda/bin:$PATH' >> ~/.zshrc
    fi
    if ! grep -q '/usr/local/cuda/lib64' ~/.zshrc; then
        echo 'export LD_LIBRARY_PATH=/usr/local/cuda/lib64:$LD_LIBRARY_PATH' >> ~/.zshrc
    fi
    echo "CUDA Toolkit installation complete."
else
    echo "No NVIDIA GPU detected. Skipping CUDA installation."
fi

echo "======================================================"
echo "Installing latest Go (Golang)"
echo "======================================================"
echo

GO_LATEST=$(curl -s https://go.dev/VERSION?m=text)
GO_TARBALL="${GO_LATEST}.linux-amd64.tar.gz"
GO_URL="https://go.dev/dl/${GO_TARBALL}"

# Remove any previous Go installation
sudo rm -rf /usr/local/go

# Download and extract
curl -LO "$GO_URL"
sudo tar -C /usr/local -xzf "$GO_TARBALL"
rm "$GO_TARBALL"

# Add Go to PATH in .zshrc if not already present
if ! grep -q '/usr/local/go/bin' ~/.zshrc; then
    echo 'export PATH=$PATH:/usr/local/go/bin' >> ~/.zshrc
fi

echo "Go installation complete."

echo "======================================================"
echo "Installing rclone"
echo "======================================================"
echo

curl https://rclone.org/install.sh | sudo bash

echo "rclone installation complete."

echo "======================================================"
echo "Configurando sincronização automática com inotifywait"
echo "======================================================"

# Instala inotify-tools e rsync
sudo apt install -y inotify-tools rsync

# Cria pasta para scripts, caso não exista
mkdir -p "$HOME/.scripts"
mkdir -p "$HOME/.config/systemd/user"

# Copia os arquivos externos para seus locais
curl -fsSL https://raw.githubusercontent.com/marcospedro97/dotfiles/refs/heads/master/backup/rclone-backup.sh -o "$HOME/.scripts/watch-rsync.sh"
curl -fsSL https://raw.githubusercontent.com/marcospedro97/dotfiles/refs/heads/master/backup/rsync-watcher.service -o "$HOME/.config/systemd/user/rsync-watcher.service"

chmod +x "$HOME/.scripts/watch-rsync.sh"

systemctl --user daemon-reexec
systemctl --user daemon-reload
systemctl --user enable --now rsync-watcher.service

echo "Serviço de sincronização criado e iniciado com sucesso!"
echo "Use 'systemctl --user status rsync-watcher.service' para verificar o status."


echo "======================================================"
echo "Setup Complete!"
echo "======================================================"
echo
echo "Please note:"
echo "1. You need to log out and log back in for the docker group membership to take effect"
echo "2. Your default shell has been changed to ZSH - restart your terminal to use it"
echo "3. Docker, RVM, NVM, and pyenv will be available after restarting your shell"
echo "4. Make sure the zshrc and tmux.conf files are in the same directory as this script"
echo
echo "You may want to restart your system or log out/in to ensure all changes take effect."
