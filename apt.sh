#!/usr/bin/env bash

###############################################
# apt
###############################################

echo "Enter your sudo password to proceed with installation:"
sudo -v

# Keep-alive: update existing sudo time stamp until the script has finished
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

action "Updating apt"
sudo apt-get -qq update && sudo apt-get -qq dist-upgrade
ok

packages=(
    autoconf 
    bison 
    build-essential 
    libssl-dev 
    libyaml-dev 
    libreadline6 
    libreadline6-dev 
    git 
    nodejs
    postgresql 
    zlib1g 
    zlib1g-dev 
    libcurl4-openssl-dev 
    curl 
    wget
    silversearcher-ag
    vim
    openssl 
)

for package in "${packages[@]}"; do
    require_apt "$package" 
done


# Install rbenv and ruby-build
echo "Installing rbenv and ruby-build..."

git clone https://github.com/rbenv/rbenv.git ~/.rbenv
pushd ~ > /dev/null 2>&1
cd ~/.rbenv && src/configure && make -C src
popd > /dev/null 2>&1
git clone https://github.com/rbenv/ruby-build.git ~/.rbenv/plugins/ruby-build

export RBENV_ROOT="${HOME}/.rbenv"
export PATH="${RBENV_ROOT}/bin:${PATH}"
export PATH="${RBENV_ROOT}/shims:${PATH}"
