/bin/sh
sudo apt-get update
sudo apt-get upgrade
sudo apt-get install -y git
sudo apt-get install -y curl
sudo apt-get install -y python3-pip
echo "======================================================"
echo "Installing Google Chrome."
echo "======================================================"
echo

sudo apt install google-chrome-stable

echo "======================================================"
echo "Installing Spotify."
echo "======================================================"
echo

sudo snap install spotify

echo "======================================================"
echo "Installing Rambox"
echo "======================================================"
echo

wget $(curl -s https://api.github.com/repos/ramboxapp/community-edition/releases | grep browser_download_url | grep '64[.]deb' | head -n 1 | cut -d '"' -f 4) -O rambox.deb
sudo dpkg -i rambox.deb
sudo rm -f rambox.deb

echo "======================================================"
echo "Installing SilverSearcher"
echo "======================================================"
echo


sudo apt-get install -y silversearcher-ag

echo "======================================================"
echo "Installing ZSH"
echo "======================================================"
echo

sudo apt-get install zsh
chsh -s $(which zsh)
cp -r zsh /home/$USER/.zsh
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git
cp -r zsh-syntax-highlighting /home/$USER/.zsh-syntax-highlighting
rm -rf zsh-syntax-highlighting
bash ./ubuntu/gnome-terminal-profile import ./ubuntu/profile_colors

echo "======================================================"
echo "Installing TMux"
echo "======================================================"
echo

sudo apt-get install tmux
cp -r tmux.conf /home/$USER/.tmux.conf
cp -r zshrc.local /home/$USER/.zsh.local
cp -r zshenv /home/$USER/.zshenv
cp -r aliases /home/$USER/.aliases
cp -r aliases.local /home/$USER/.alises.local

echo "======================================================"
echo "Configuring VIM"
echo "======================================================"
echo

cp -r vim /home/$USER/.vim
cp -r vimrc /home/$USER/.vimrc
cp -r vimrc.local /home/$USER/.vimrc.local

echo "======================================================"
echo "Installing RVM"
echo "======================================================"
echo
\curl https://raw.githubusercontent.com/rvm/rvm/master/binscripts/rvm-installer | bash -s stable

echo "======================================================"
echo "Installing Go"
echo "======================================================"
echo

wget https://dl.google.com/go/go1.14.linux-amd64.tar.gz
tar -C /usr/local -xzf go1.14.linux-amd64.tar.gz
export PATH=$PATH:/usr/local/go/bin
