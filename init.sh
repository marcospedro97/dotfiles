#!/bin/sh

sudo pacman -Syu

echo "======================================================"
echo "Installing Google Chrome."
echo "======================================================"
echo

git clone https://aur.archlinux.org/google-chrome.git
cd google-chrome/
makepkg -s
sudo pacman -U --noconfirm google-chrome-70.0.3538.77-1-x86_64.pkg.tar.xz

#echo "======================================================"
#echo "Installing Spotify."
#echo "======================================================"
#echo

#echo "======================================================"
#echo "Installing Rambox"
#echo "======================================================"
#echo



echo "======================================================"
echo "Installing ZSH"
echo "======================================================"
echo

cp zshrc $HOME/.vimrc


echo "======================================================"
echo "Configuring VIM"
echo "======================================================"
echo

curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
cp vimrc $HOME/.vimrc

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
