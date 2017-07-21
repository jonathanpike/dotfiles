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
  git config --global init.templatedir '~/.git_template'
  git config --global alias.ctags '!.git/hooks/ctags'
fi

# Set up Github
echo "We can add an SSH key to your GitHub, if you want."
read -r -p "add SSH key? [y|N] " response
if [[ $response =~ ^(y|yes|Y) ]]; then
  if [[ ! -e ~/.ssh/id_rsa ]]; then
    running "Generating new SSH key for GitHub"
    # Generate new SSH Key and save in default file
    echo | ssh-keygen -t rsa -b 4096 -C $git_email
    eval "$(ssh-agent -s)"
    ssh-add ~/.ssh/id_rsa
    gem install bundler > /dev/null
    bundle install > /dev/null
    ruby github-key.rb 
    ok
  else 
    running "Using SSH Key <id_rsa> for Github"
    eval "$(ssh-agent -s)"
    ssh-add ~/.ssh/id_rsa
    gem install bundler > /dev/null
    bundle install > /dev/null
    ruby github-key.rb 
    ok
  fi
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
symlinkifne .vimrc
symlinkifne .vim
symlinkifne .tmux.conf
symlinkifne .psqlrc
symlinkifne .git_template

popd > /dev/null 2>&1

###############################################
# Vim Plugins
###############################################

echo "Installing Vim plugins..."

git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
vim +PluginInstall +qall
ok


###############################################
# Tmux Plugins
###############################################

echo "Installing Tmux Plugin Manager..."

git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
ok

###############################################
# Package Install
###############################################

echo "We can install OS packages to enhance your system, if you want."

read -r -p "install OS packages? [y|N] " response
if [[ $response =~ ^(y|yes|Y) ]]; then
  PACKAGES=true
  source ./brew.sh
else
  PACKAGES=false
  ok "skipped OS package install"
fi

echo
echo "Your computer is all set up!  Enjoy!"
