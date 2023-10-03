#!/usr/bin/env zsh

echo "\n<<<< Starting Rust Setup >>>>\n"

# Node versions are managed with 'n', which is in the Brewfile
# See zshrc for N_PREFIX variable and addition to $path array.

if exists cargo; then
    echo "Rust and cargo $(cargo --version) already installed\n"
else
    echo "Installing rust\n"
    rustup-init
fi

rustup target add wasm32-unknown-unknown

cargo install bacon
cargo install trunk
cargo install cargo-leptos

echo "\nGlobal Cargo Packages installed: \n"
cargo install --list
