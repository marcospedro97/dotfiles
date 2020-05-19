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

echo "======================================================"
echo "Installing Google Chrome."
echo "======================================================"
echo

git https://aur.archlinux.org/google-chrome.git
cd google-chrome
makepkg -s
sudo pacman --noconfirm -U google-chrome*.tar.xz
cd ..
rm -rf google-chrome

echo "======================================================"
echo "Installing Rambox"
echo "======================================================"
echo

sudo pacman --noconfirm -S rambox

echo "======================================================"
echo "Installing ZSH"
echo "======================================================"
echo

sh -c "$(wget https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh -O -)"
curl -fSs https://raw.githubusercontent.com/marcospedro97/dotfiles/master/zshrc > $HOME/.zshrc
chsh -s $(which zsh)

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
echo "Installing Go"
echo "======================================================"
echo

sudo pacman --noconfirm -S go


echo "======================================================"
echo "Installing Latte Dock"
echo "======================================================"
echo

yaourt latte-dock

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

sudo reboot
