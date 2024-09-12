#!/usr/bin/env zsh

echo "\n<<<< Starting Node Setup >>>>\n"

# Node versions are managed with 'n', which is in the Brewfile
# See zshrc for N_PREFIX variable and addition to $path array.

if exists node; then
    echo "Node $(node --version) & NPM $(npm --version) already installed\n"
else
    echo "Installing Node & NPM with n...\n"
    n latest
    n lts
fi

npm i -g @salesforce/cli
npm i -g @dxatscale/sfpowerscripts
npm i -g vlocity
npm i -g @nestjs/cli
npm i -g @hubspot/cli@6.0.0


echo "\nGlobal NPM Packages installed: \n"
npm ls -g --depth=0
