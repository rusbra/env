#!/bin/bash

# Confirm removal
echo "This script will remove all tools"
echo "installed by rusbra/env."
echo "ONLY run this script if you have"
echo "installed rusbra/env on this machine."

while true; do
	read -p "Would you like to proceed y/n?" yn
	case $yn in 
		[Yy]* ) break;;
		[Nn]* ) echo "Exiting without changes" ; exit ;;
		* ) echo "Please answer yes or no.";;
	esac
done

# identify the platform
platform=`uname`

# Resets the git configurations set by rusbra/git-hacker
./git-hacker/hacks/reset-git-config.sh

# remove rusbra/env vim plugins
rm -rf ~/.vim/bundle/

# remove ./vimrc created by rusbra/env
rm ~/.vimrc
touch ~/.vimrc

if [[ "$platform" == "Darwin" ]]; then
	# uninstall brew formulas and remove brew
	brew uninstall tmux htop vim mercurial cmake rbenv macvim ccat tmate python2 python
	ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/uninstall)"
	# uninstall node
	sudo rm -rf /usr/local/bin/npm /usr/local/lib/dtrace/node.d ~/.npm ~/.node-gyp
	sudo rm -rf /opt/local/bin/node /opt/local/include/node /opt/local/lib/node_modules
	sudo rm -rf /usr/local/bin/npm /usr/local/share/man/man1/node.1 /usr/local/lib/dtrace/node.d
fi 

# uninstall oh-my-zsh
sh $ZSH/tools/uninstall.sh

# remove rusbra/env .zshrc
rm ~/.zshrc 
touch ~/.zshrc 

# change default shell to bash
chsh -s /bin/bash
exec bash

echo "Thanks for checking out my environment"
