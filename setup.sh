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
# Homebrew
###############################################

running "Checking homebrew install"
if ! command -v brew > /dev/null 2>&1; then
  action "installing homebrew"
  if ! /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"; then
    error "unable to install homebrew, script $0 abort!"
    exit 1
  fi
  for brew in /opt/homebrew/bin/brew /usr/local/bin/brew; do
    [[ -x $brew ]] && eval "$("$brew" shellenv)" && break
  done
fi
ok

running "Installing packages from Brewfile"
brew bundle --file=./Brewfile;ok

bash_path="$(brew --prefix)/bin/bash"
if [[ $SHELL != "$bash_path" ]]; then
  running "Setting login shell to $bash_path"
  grep -qx "$bash_path" /etc/shells || echo "$bash_path" | sudo tee -a /etc/shells > /dev/null
  chsh -s "$bash_path";ok
fi

###############################################
# Git and Github
###############################################

if [[ ! -e ~/.gitconfig.local ]]; then
  echo "What e-mail do you want to use for Git on this machine?"
  read -r git_email
  git config --file ~/.gitconfig.local user.email "$git_email"
fi

# Set up Github
echo "We can add an SSH key to your GitHub, if you want."
read -r -p "add SSH key? [y|N] " response
if [[ $response =~ ^(y|yes|Y) ]]; then
  if [[ ! -e ~/.ssh/id_ed25519 ]]; then
    running "Generating new SSH key for GitHub"
    ssh-keygen -t ed25519 -C "$(git config --file ~/.gitconfig.local user.email)" -f ~/.ssh/id_ed25519
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

running "Removing symlinks to dotfiles that no longer exist"
for link in "$HOME"/.[!.]* "$HOME"/.config/*; do
  if [[ -L $link && ! -e $link && $(readlink "$link") == "$HOME/.dotfiles/"* ]]; then
    rm "$link"
  fi
done;ok

echo "Creating symlinks for dotfiles..."

mkdir -p ~/.config
pushd ~ > /dev/null 2>&1

symlinkifne .bashrc
symlinkifne .bash_profile
symlinkifne .bash
symlinkifne .gitconfig
symlinkifne .config/ghostty

popd > /dev/null 2>&1

echo
echo "Your computer is all set up!  Enjoy!"
