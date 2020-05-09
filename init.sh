#!/bin/sh

sudo pacman -Syu

echo "======================================================"
echo "Installing SNAP, CURL and Git."
echo "======================================================"
echo

sudo pacman -S git
sudo pacman -S curl
sudo pacman -S snapd
sudo systemctl enable --now snapd.socket

echo "======================================================"
echo "Installing Google Chrome."
echo "======================================================"
echo

git clone https://aur.archlinux.org/google-chrome.git
cd google-chrome/
makepkg -s
sudo pacman -U --noconfirm google-chrome-70.0.3538.77-1-x86_64.pkg.tar.xz
cd ..

echo "======================================================"
echo "Installing Spotify."
echo "======================================================"
echo

git clone https://aur.archlinux.org/spotify.git
cd spotify/
makepkg -s
sudo pacman -U --noconfirm spotify-1.0.92.390-1-x86_64.pkg.tar.xz
cd ..

echo "======================================================"
echo "Installing Rambox"
echo "======================================================"
echo

sudo snap install rambox

echo "======================================================"
echo "Installing ZSH"
echo "======================================================"
echo

curl -fSs https://raw.githubusercontent.com/marcospedro97/dotfiles/master/zshrc > $HOME/.zshrc

echo "======================================================"
echo "Configuring VIM"
echo "======================================================"
echo

sudo pacman -S vim
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

sudo pacman -S go
