#!/usr/bin/env bash

###############################################
# Based on the OSX bot by Adam Eivy
# https://github.com/atomantic/dotfiles
# Modified by Jonathan Pike
###############################################

source ./lib.sh

# make a backup directory for overwritten dotfiles

if [[ ! -e ~/.dotfiles_backup ]]; then
    mkdir ~/.dotfiles_backup
fi

###############################################
# Git and Github
###############################################

# Set up Git
echo "We're going to set up your Git user name and e-mail"
echo
echo "What name do you want to use for Git?"
read git_name
echo
echo "What e-mail do you want to use for Git?"
readh git_email

running "Setting up Git..."
git config --global user.name $git_name
git config --global user.email $git_email
git config --global core.editor vim;ok

# Set up Github

if [[ ! -e ~/.ssh/id_rsa ]]; then
	running "Generating new SSH key for GitHub"
	# Generate new SSH Key and save in default file
	echo | ssh-keygen -t rsa -b 4096 -C $git_email
	eval "$(ssh-agent -s)"
	ssh-add ~/.ssh/id_rsa
	bundle install > /dev/null
	ruby github-key.rb 
	ok
else 
	running "Using SSH Key <id_rsa> for Github"
	eval "$(ssh-agent -s)"
	ssh-add ~/.ssh/id_rsa
	bundle install > /dev/null
	ruby github-key.rb 
	ok
fi


###############################################
# Dotfiles
###############################################

echo "Creating symlinks for dotfiles..."

pushd ~ > /dev/null 2>&1

symlinkifne .bashrc
symlinkifne .bash_profile
symlinkifne .bash
symlinkifne .vimrc
symlinkifne .vim

popd > /dev/null 2>&1

###############################################
# Homebrew 
###############################################

# Check if Homebrew is installed

running "Checking homebrew install"
brew_bin=$(which brew) 2>&1 > /dev/null
if [[ $? != 0 ]]; then
	action "installing homebrew"
    ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
    if [[ $? != 0 ]]; then
    	error "unable to install homebrew, script $0 abort!"
    	exit -1
	fi
fi
ok

running "Checking brew-cask install"
output=$(brew tap | grep cask)
if [[ $? != 0 ]]; then
	action "installing brew-cask"
	require_brew caskroom/cask/brew-cask
fi
ok

# Make sure we’re using the latest Homebrew
running "Updating homebrew"
brew update
ok

echo "Before installing brew packages, we can upgrade any outdated packages."
read -r -p "run brew upgrade? [y|N] " response
if [[ $response =~ ^(y|yes|Y) ]];then
    # Upgrade any already-installed formulae
    action "upgrade brew packages..."
    brew upgrade
    ok "brews updated..."
else
    ok "skipped brew package upgrades.";
fi

echo "Installing homebrew command-line tools"
require_brew ack
require_brew bash-completion
require_brew git
require_brew hub
require_brew node
require_brew rbenv
require_brew the_silver_searcher
require_brew vim

echo "Installing homebrew gui tools"
require_cask 1password
require_cask dropbox
require_cask flux
require_cask google-chrome
require_cask iterm2

###############################################
# rbenv
###############################################

running "Installing latest Ruby with rbenv"
rbenv install 2.2.3
rbenv global 2.2.3
gem install bundler
rbenv rehash
ok

###############################################
# iTerm
###############################################

running "Syncing iTerm2 Preferences"
cp ./iterm/com.googlecode.iterm2.plist ~/Library/Preferences
ok