# DOTFILES

Ubuntu development environment — automate your setup, do it once and do it well.

## WHAT WILL BE INSTALLED

- **System update**
- **Git**
- **Docker** (with Docker Compose)
- **RVM** (Ruby Version Manager)
- **NVM** (Node Version Manager)
- **VS Code** (via snap)
- **ZSH** (with Oh My Zsh, zsh-autosuggestions, zsh-syntax-highlighting)
- **TMUX**
- **pyenv** (Python version manager)
- **pgAdmin4** (Desktop)
- **Terraform**
- **redis-commander** (via npm)
- **CUDA Toolkit** (if NVIDIA GPU is detected)
- **Go (Golang)** (latest version)
- **rclone** (with daily backup script for `$HOME/proj` to OneDrive)

## PREREQUISITES

- Ubuntu
- Internet connection
- Sudo privileges

## HOW TO USE

Clone the repository and run the script:

```bash
git clone https://github.com/marcospedro97/dotfiles.git
cd dotfiles
chmod +x ubuntu-init.sh
./ubuntu-init.sh
```

Or run directly via curl:

```bash
bash <(curl -fsSL https://raw.githubusercontent.com/marcospedro97/dotfiles/master/ubuntu-init.sh)

## CUSTOMIZATION

You can edit the `.zsh.local` and `.tmux.conf` configuration files directly in your home directory after installation.
