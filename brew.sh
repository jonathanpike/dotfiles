#!/usr/bin/env bash

###############################################
# Homebrew 
###############################################

echo "Enter your sudo password to proceed with installation:"
sudo -v

# Keep-alive: update existing sudo time stamp until the script has finished
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

# Fix ownership of /usr/local on El Cap
sudo chown -R $(whoami):admin /usr/local

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

# running "Checking brew-cask install"
# output=$(brew tap | grep cask)
# if [[ $? != 0 ]]; then
# 	action "installing brew-cask"
# 	require_brew caskroom/cask/brew-cask
# fi
# ok

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
    ok "skipped brew package upgrades."
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
require_cask postgres

###############################################
# iTerm
###############################################

running "Syncing iTerm2 Preferences"
cp ./iterm/com.googlecode.iterm2.plist ~/Library/Preferences

ok "Finished installing packages with Homebrew"