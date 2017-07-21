# Install custom prompt
brew install npm
npm install --global pure-prompt

# Install k from https://github.com/supercrabtree/k
git clone git@github.com:subercrabtree/k.git $HOME/k

# Set default shell
echo "Setting default shell for $USER to be $(which zsh) ..."
chsh -s `which zsh`
