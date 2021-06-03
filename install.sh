#!/bin/bash
function df_log {
    echo "[$(date +"%D %T")] $1: $2" >> install.log;
}

function df_error {
    echo -e "\e[1m\e[38;5;226m[lluispons-dotfiles] \e[196mERROR:$1";
    df_log "Error" $1
}
function df_warning {
    echo -e "\e[1m\e[38;5;226m[lluispons-dotfiles] \e[208mWARNING:$1";
    df_log "Warning" $1
}
function df_notice { echo -e "\e[1m\e[38;5;226m[lluispons-dotfiles] \e[226mNOTICE:$1"; }

# Add apt GPG keys
df_notice "Adding GPG keys..."
wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | sudo apt-key add -
wget -q -O - https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
wget -q -O - https://packages.microsoft.com/keys/microsoft.asc | sudo apt-key add -
wget -q -O - https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add -
df_notice "GPG keys added"

# Add apt repositories
df_notice "Adding repository sources..."
cat dpkg/repositories.list | xargs -L1 sudo apt-add-repository
df_notice "Repository sources added"

# Update apt and install packages
df_notice "Updating apt sources..."
sudo apt update
df_notice "apt sources updated"
df_notice "Installing apt packages..."
sudo apt install -y $(cat dpkg/packages.list)

# Install snap packages
if hash snap 2>/dev/null
then
    df_notice "Installing snap packages..."
    sudo snap install $(cat snap/packages.list)
    df_notice "snap packages installed"
else
    df_error "'snap' command not found. Try installing Snap package manager again by running:\ \ sudo apt install snap"
fi

#Install global Node Modules
df_notice "Installing node packages..."
if hash npm 2>/dev/null
then
    sudo npm install -g $(cat node/packages.list)
    df_notice "node packages installed"
else
    df_error "'npm' command not found. Try installing Node again by running:\ \ sudo apt install nodejs"
fi


# Setup Zsh
df_notice "Setting up Zsh"
if hash zsh 2>/dev/null
then
    # Make zsh default bash
    chsh -s $(which zsh)
    df_notice "Zsh set as default shell"
    df_warning "Remember to log out of your computer and log back in for th changes to take effect"
    # Install Oh-my-zsh
    df_notice "Installing Oh-my-zsh..."
    sh -c "$(wget https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh -O -)"
    df_notice "Oh-my-zsh installed"
    # Install powerlevel9k theme and fonts
    df_notice "Installing powerlevel9k zsh theme..."
    git clone https://github.com/bhilburn/powerlevel9k.git ~/.oh-my-zsh/custom/themes/powerlevel9k
    sudo apt install fonts-powerline
    df_notice "powerlevel9k installed"
else
    df_error "'zsh' not found. Try installing zsh again by running:\ \ sudo apt install zsh"
fi


# Setup VS Code
df_notice "Installing vscode extensions..."
if hash code 2>/dev/null
then
    cat vscode/extensions.list | grep -v '^#' | xargs -L1 code --install-extension
    df_notice "vscode extensions installed"
    sudo su -c "echo 'fs.inotify.max_user_watches=524288' >> /etc/sysctl.conf"
    sudo sysctl -p
else
    df_error "'code' was not found in PATH"
fi

# Setup vagrant
df_notice "Installing vagrant..."
default_vagrant_version='2.2.7'
read -p "Select Vagrant version to install (default is $default_vagrant_version):" vagrant_version
if [ -z "$vagrant_version" ] ; then vagrant_version=$default_vagrant_version ; fi
wget -c "https://releases.hashicorp.com/vagrant/${vagrant_version}/vagrant_${vagrant_version}_x86_64.deb"
sudo dpkg -i "vagrant_${vagrant_version}_x86_64.deb"
rm "vagrant_${vagrant_version}_x86_64.deb"
df_notice "vagrant installed"
df_notice "Installing vvv and vagrant plugins"
if hash vagrant 2>/dev/null
then
    git clone -b master git://github.com/Varying-Vagrant-Vagrants/VVV.git ~/vagrant-local
    vagrant plugin install $(cat vagrant/plugins.list)
    df_notice "vvv and vagrant plugins installed"
else
    df_error "'vagrant' was not found in PATH. Try installing vagrant from https://releases.hashicorp.com/vagrant/${vagrant_version}/vagrant_${vagrant_version}_x86_64.deb"
fi

# Install Boostnote
df_notice "Installing Boostnote..."
wget -c "https://github.com/BoostIO/boost-releases/releases/download/v0.11.15/boostnote_0.11.15_amd64.deb"
sudo dpkg -i boostnote_0.11.15_amd64.deb
rm boostnote_0.11.15_amd64.deb
df_notice "Boostnote installed"

# Create symlinks
df_notice "Creating symlinks..."
DOTFILES_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

ln -sf "$DOTFILES_DIR/git/.gitconfig" ~
ln -sf "$DOTFILES_DIR/git/.gitignore_global" ~
ln -sf "$DOTFILES_DIR/zsh/.zshrc" ~
ln -sf "$DOTFILES_DIR/zsh/.zsh_exports" ~
ln -sf "$DOTFILES_DIR/zsh/.zsh_aliases" ~
ln -sf "$DOTFILES_DIR/vscode/settings.json" ~/.config/Code/User/
ln -sf "$DOTFILES_DIR/vscode/keybindings.json" ~/.config/Code/User/
ln -sf "$DOTFILES_DIR/vscode/.eslintrc" ~
ln -sf "$DOTFILES_DIR/.fonts" ~
ln -sf "$DOTFILES_DIR/vagrant/vvv/vvv-custom.yml" ~/vagrant-local
mkdir ~/.config/terminator
ln -sf "$DOTFILES_DIR/terminator/config" ~/.config/terminator/
df_notice "Symliks created"


# Install Dropbox
df_notice "Installing Dropbox..."
wget -O - "https://www.dropbox.com/download?plat=lnx.x86_64" | tar xzf - -C ~
~/.dropbox-dist/dropboxd
df_notice "Dropbox installed"
