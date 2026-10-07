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

echo "Welcome to your computer.  We're going to automatically set it up for you."
echo

###############################################
# Git and Github
###############################################

# Set up Git
if [[ ! -e ~/.gitconfig ]]; then
  echo "We're going to set up your Git user name and e-mail."

  echo "What name do you want to use for Git?"
  read git_name

  echo "What e-mail do you want to use for Git?"
  read git_email

  running "Setting up Git..."
  git config --global user.name $git_name
  git config --global user.email $git_email
  git config --global core.editor vim;ok
fi

# Set up Github
echo "We can add an SSH key to your GitHub, if you want."
read -r -p "add SSH key? [y|N] " response
if [[ $response =~ ^(y|yes|Y) ]]; then
  if [[ ! -e ~/.ssh/id_ed25519 ]]; then
    running "Generating new SSH key for GitHub"
    ssh-keygen -t ed25519 -C "$(git config --global user.email)" -f ~/.ssh/id_ed25519
  fi
  ssh-add --apple-use-keychain ~/.ssh/id_ed25519
  pbcopy < ~/.ssh/id_ed25519.pub
  echo "Public key copied to clipboard. Add it at https://github.com/settings/ssh/new"
  read -r -p "Press enter once the key is added to GitHub..."
  ok
else
  ok "skipped adding SSH key to GitHub";
fi

###############################################
# Dotfiles
###############################################

echo "Creating symlinks for dotfiles..."

pushd ~ > /dev/null 2>&1

symlinkifne .bashrc
symlinkifne .bash_profile
symlinkifne .bash

popd > /dev/null 2>&1

###############################################
# Package Install
###############################################

echo "We can install OS packages to enhance your system, if you want."

read -r -p "install OS packages? [y|N] " response
if [[ $response =~ ^(y|yes|Y) ]]; then
  source ./brew.sh
else
  ok "skipped OS package install"
fi

echo
echo "Your computer is all set up!  Enjoy!"
