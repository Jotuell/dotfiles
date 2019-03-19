!/bin/bash

# Add apt repositories
cat repositories.list | xargs -L1 apt-add-repository

# Add apt GPG keys
wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | sudo apt-key add -
wget -q -O - https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
wget -q -O - https://packages.microsoft.com/keys/microsoft.asc | sudo apt-key add -

# Update apt and install packages
sudo apt update
sudo apt install $(cat dpkg/packagest.list)

# Install snap packages
sudo snap install $(cat snap/packages.list)

#Install global Node Modules
sudo npm install -g $(cat node/packages.list)

#Make zsh default bash
chsh -s $(which zsh)

# Install Oh-my-zsh
sh -c "$(wget https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh -O -)"

# Install powerlevel9k theme and fonts
git clone https://github.com/bhilburn/powerlevel9k.git ~/.oh-my-zsh/custom/themes/powerlevel9k
sudo apt install fonts-powerline

# Setup VS Code
if hash code 2>/dev/null
then
    cat vscode/extensions.list | grep -v '^#' | xargs -L1 code --install-extension
    sudo su -c "echo 'fs.inotify.max_user_watches=524288' >> /etc/sysctl.conf"
    sudo sysctl -p
else
    echo "'code' was not found in PATH"
fi

# Install Dropbox
wget -O - "https://www.dropbox.com/download?plat=lnx.x86_64" | tar xzf - -C ~
~/.dropbox-dist/dropboxd

# Setup vagrant
wget -c "https://releases.hashicorp.com/vagrant/2.2.4/vagrant_2.2.4_x86_64.deb"
sudo dpkg -i vagrant_2.2.4_x86_64.deb
rm vagrant_2.2.4_x86_64.deb
mkdir ~/projectes
if hash vagrant 2>/dev/null
then
    cat vscode/extensions.list | grep -v '^#' | xargs -L1 code --install-extension
    vagrant plugin install $(cat vagrant/plugins.list)
else
    echo "'vagrant' was not found in PATH"
fi

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
ln -sf "$DOTFILES_DIR/termiantor/config" ~/.config/terminator/
