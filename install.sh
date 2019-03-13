# Install packages
sudo apt install $(cat dpkg/packagest.txt)

# Instal Oh My Zsh
sh -c "$(wget https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh -O -)"

#Install Node
curl -sL https://deb.nodesource.com/setup_10.x | sudo -E bash -
sudo apt install -y nodejs

#Install nvm (Node version manager)
wget -qO- https://raw.githubusercontent.com/creationix/nvm/v0.34.0/install.sh | bash

# Install VS Code extensions
cat extensions.list | grep -v '^#' | xargs -L1 code --install-extension