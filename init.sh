#!/bin/sh
echo "======================================================"
echo "Updating System"
echo "======================================================"

sudo pacman --noconfirm -Syu

echo "======================================================"
echo "Installing SNAP, CURL and Git."
echo "======================================================"
echo

sudo pacman --noconfirm -S git
sudo pacman --noconfirm -S curl
sudo pacman --noconfirm -S snapd
sudo systemctl enable --now snapd.socket
sudo snap install spt
yay -S toilet

echo "======================================================"
echo "Installing ZSH"
echo "======================================================"
echo

sh -c "$(wget https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh -O -)"
curl -fSs https://raw.githubusercontent.com/marcospedro97/dotfiles/master/zshrc > $HOME/.zshrc
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting

echo "======================================================"
echo "Configuring VIM"
echo "======================================================"
echo

sudo pacman --noconfirm -S vim
curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
curl -fSs https://raw.githubusercontent.com/marcospedro97/dotfiles/master/vimrc > $HOME/.vimrc
vim +PlugInstall +qall

echo "======================================================"
echo "Installing RVM"
echo "======================================================"
echo

curl -L get.rvm.io > rvm-install
bash < ./rvm-install
source ~/.bash_profile

echo "======================================================"
echo "Installing NVM"
echo "======================================================"
echo

sudo pacman --noconfirm nvm
echo 'source /usr/share/nvm/init-nvm.sh' >> ~/.zshrc

echo "======================================================"
echo "Installing Go"
echo "======================================================"
echo

sudo pacman --noconfirm -S go

echo "======================================================"
echo "Installing CODE"
echo "======================================================"
echo

sudo pacman --noconfirm -S code

echo "======================================================"
echo "Installing rclone"
echo "======================================================"

sudo pacman --noconfirm -S rclone
rclone config

echo "======================================================"
echo "Installing TMUX"
echo "======================================================"

sudo pacman --noconfirm -S tmux
curl -fSs https://raw.githubusercontent.com/marcospedro97/dotfiles/master/tmux.conf > $HOME/.tmux.conf

echo "======================================================"
echo "Reboot"
echo "======================================================"

chsh -s $(which zsh)

sudo reboot
