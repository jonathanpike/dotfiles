#!/usr/bin/env bash

###############################################
# Homebrew 
###############################################

# Check if Homebrew is installed
running "Checking homebrew install"
if ! command -v brew > /dev/null 2>&1; then
    action "installing homebrew"
    if ! /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"; then
        error "unable to install homebrew, script $0 abort!"
        exit 1
    fi
    eval "$(/opt/homebrew/bin/brew shellenv)"
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
    ok "skipped brew package upgrades."
fi

packages=(
    bash-completion@2
    fzf
    git
    rbenv
    ripgrep
    ruby-completion
)

echo "Installing homebrew command-line tools"
for package in "${packages[@]}"; do
    require_brew "$package" 
done

ok "Finished installing packages with Homebrew"
