#!/bin/bash

# Install packages
sudo apt update
sudo apt install $(cat dpkg/packagest.txt)
sudo snap install $(cat snap/packagest.txt)

# Install Oh-my-zsh
sh -c "$(wget https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh -O -)"

# Install powerlevel9k theme and fonts
git clone https://github.com/bhilburn/powerlevel9k.git ~/.oh-my-zsh/custom/themes/powerlevel9k
sudo apt install fonts-powerline

#Install Node
curl -sL https://deb.nodesource.com/setup_10.x | sudo -E bash -
sudo apt install -y nodejs
sudo npm install -g $(cat node/packages.txt)

#Install nvm (Node version manager)
wget -qO- https://raw.githubusercontent.com/creationix/nvm/v0.34.0/install.sh | bash

# Install VS Code extensions
cat vscode/extensions.list | grep -v '^#' | xargs -L1 code --install-extension

# Install Dropbox
wget -O - "https://www.dropbox.com/download?plat=lnx.x86_64" | tar xzf - -C ~
~/.dropbox-dist/dropboxd

# Setup vagrant
vagrant plugin install install $(cat vagrant/plugins.txt)
mkdir ~/projectes
git clone -b master git://github.com/Varying-Vagrant-Vagrants/VVV.git ~/vagrant-local

# Install Docker
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
sudo apt update
sudo apt install docker-ce

# Install Boostnote
wget -c "https://github.com/BoostIO/boost-releases/releases/download/v0.11.15/boostnote_0.11.15_amd64.deb"
sudo dpkg -i boostnote_0.11.15_amd64.deb
rm boostnote_0.11.15_amd64.deb

# Create symlinks
DOTFILES_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

ln -sf "$DOTFILES_DIR/.gitconfig" ~
ln -sf "$DOTFILES_DIR/.gitignore_global" ~
ln -sf "$DOTFILES_DIR/zsh/.zshrc" ~
ln -sf "$DOTFILES_DIR/zsh/.zsh_exports" ~
ln -sf "$DOTFILES_DIR/zsh/.zsh_aliases" ~
ln -sf "$DOTFILES_DIR/vscode/settings.json" ~/.config/Code/User/
ln -sf "$DOTFILES_DIR/vscode/keybindings.json" ~/.config/Code/User/
ln -sf "$DOTFILES_DIR/vscode/.eslintrc" ~
ln -sf "$DOTFILES_DIR/.fonts" ~
ln -sf "$DOTFILES_DIR/vagrant/vvv/vvv-custom.yml" ~/vagrant-local
