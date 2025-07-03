# DOTFILES

Automated Ubuntu development environment setup — configure your system once, do it right.

## WHAT'S INCLUDED

- **System update & essential packages**
- **Git**
- **Docker** (with Docker Compose)
- **RVM** (Ruby Version Manager)
- **NVM** (Node Version Manager)
- **VS Code** (via Snap)
- **ZSH** (with Oh My Zsh, zsh-autosuggestions, zsh-syntax-highlighting)
- **TMUX**
- **pyenv** (Python version manager)
- **pgAdmin4** (Desktop)
- **Terraform**
- **redis-commander** (via npm)
- **CUDA Toolkit** (if NVIDIA GPU detected)
- **Go (Golang)** (latest version)
- **rclone** (with daily backup script for `$HOME/proj` to OneDrive)

## REQUIREMENTS

- Ubuntu (tested on recent LTS versions)
- Internet connection
- Sudo privileges

## USAGE

Clone this repository and run the setup script:

```bash
git clone https://github.com/marcospedro97/dotfiles.git
cd dotfiles
chmod +x ubuntu-init.sh
./ubuntu-init.sh
```

Or run directly with curl:

```bash
bash <(curl -fsSL https://raw.githubusercontent.com/marcospedro97/dotfiles/refs/heads/master/ubuntu-init.sh)
```

## CUSTOMIZATION

After installation, you can edit your personal configuration files directly:

- `~/.zsh.local` — for custom ZSH settings
- `~/.tmux.conf` — for TMUX configuration

Feel free to adjust these files to fit your workflow.

---

**Note:**  
- Restart your terminal or log out/in to apply all changes.
- Docker and Go require a new shell session for the correct PATH.
- The backup script only overwrites data if there are more than 10 files in the source directory for safety.
