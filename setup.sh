#!/bin/bash

# download submodules
git submodule update --init --recursive

# identify the platform
platform=`uname`

# install linux specific apps via apt-get - zsh, tmux, vim, htop
if [[ "$platform" == "Linux" ]]; then
	sudo apt-get install zsh tmux vim htop upower python-setuptools libxml2-dev libxslt1-dev python-dev cmake nodejs
	if ! grep -q "zsh" ~/.bashrc; then
		printf "# Enable zsh once ssh'd into box\nzsh\n" | cat - ~/.bashrc > temp && mv temp ~/.bashrc
	fi
	if ! grep -q "battery" ~/.zshrc; then
		printf "# display battery-status with upower\nalias battery='upower -i /org/freedesktop/UPower/devices/battery_BAT0 | grep -E 'state|to\ full|percentage''\n" | cat - ~/.zshrc > temp && mv temp ~/.zshrc
	fi
fi 

# install vundle which manages the vim plugins
git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim

# setup rusbra/vimrc 
# git@github.com:rusbra/vimrc.git
cd vimrc/dotfiles
cp .vimrc ~/
cd -
# install vim plugins
vim +PluginInstall +qall

# configures the user's git environment.
./gitgud/hacks/git-config.sh

# install darwin specific tools: tmux, brew, htop mercurial vim python cmake, node
# configure zsh to be default shell
if [[ "$platform" == "Darwin" ]]; then
	ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
	brew update && brew upgrade && brew doctor
	brew install tmux htop python2 python vim mercurial cmake rbenv ccat tmate
	curl "https://nodejs.org/dist/latest/node-${VERSION:-$(wget -qO- https://nodejs.org/dist/latest/ | sed -nE 's|.*>node-(.*)\.pkg</a>.*|\1|p')}.pkg" > "$HOME/Downloads/node-latest.pkg" && sudo installer -store -pkg "$HOME/Downloads/node-latest.pkg" -target "/"
# For virtual environment install NVM first and then Node via `nvm install node`	
#	curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.33.0/install.sh | bash
	chsh -s /bin/zsh
	pip install pipenv
fi

# Install modified oh-my-zsh that doesn't launch automatically
# https://github.com/rusbra/oh-my-zsh
sh -c "$(curl -fsSL https://raw.github.com/rusbra/oh-my-zsh/master/tools/install.sh)"

# required for vim colorthemes to work correctly
if ! grep -q "xterm-256color" ~/.zshrc; then
	printf "# Required for vim colorthemes\nexport TERM='xterm-256color'\n" | cat - ~/.zshrc > temp && mv temp ~/.zshrc
fi
# kickoff oh-my-zsh
zsh
