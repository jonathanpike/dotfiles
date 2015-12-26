#!/bin/sh

echo "Provisioning Vagrant..."

# Update Advanced Packaging Tool
sudo apt-get -y update

# Essentials
echo "Installing Essentials..."
sudo apt-get install -y autoconf bison build-essential libssl-dev libyaml-dev libreadline6 libreadline6-dev zlib1g zlib1g-dev libcurl4-openssl-dev curl wget

# Git
echo "Installing git..."
sudo apt-get install -y git

# NodeJS
echo "Installing NodeJS..."
sudo apt-get install -y nodejs

# Postgresql
echo "Installing Postgresql..."
sudo apt-get install -y postgresql-9.3

# ImageMagick and Rmagick
echo "Installing ImageMagick and Rmagick..."
sudo apt-get install -y imagemagick libmagickwand-dev

# Install rbenv and ruby-build
echo "Installing rbenv and ruby-build..."

git clone https://github.com/sstephenson/rbenv.git ~/.rbenv
echo 'export PATH="$HOME/.rbenv/bin:$PATH"' >> ~/.bashrc
echo 'eval "$(rbenv init -)"' >> ~/.bashrc
git clone https://github.com/sstephenson/ruby-build.git ~/.rbenv/plugins/ruby-build

# Install Latest Ruby and Bundler
echo "Installing Ruby and Bundler..."

export RBENV_ROOT="${HOME}/.rbenv"
export PATH="${RBENV_ROOT}/bin:${PATH}"
export PATH="${RBENV_ROOT}/shims:${PATH}"
rbenv install 2.2.3
rbenv global 2.2.3
gem install bundler
rbenv rehash

# Setup .bashrc

# TO DO -- path /home/vagrant/.bashrc

# Cleanup
echo "Cleaning up..."
sudo apt-get clean