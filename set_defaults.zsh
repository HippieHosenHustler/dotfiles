#!/usr/bin/env zsh

echo "\n<<< Starting Defaults Setup >>>\n"

# Dock settings
defaults write com.apple.dock "autohide" -bool "true" # Dock is hidden unless used
defaults write com.apple.dock "orientation" -string "left" # Dock is on the left of the screen
defaults write com.apple.dock "tilesize" -int "26" # Set Dock Size
defaults write com.apple.dock "autohide-delay" -float "0" # No delay when hiding and unhiding the dock
defaults write com.apple.dock "show-recents" -bool "false" # Do not show recent items
defaults write com.apple.dock "mineffect" -string "scale" # Set minimizing effect
killall Dock # Reset the Dock with the new settings

# Finder Settings
defaults write com.apple.finder "AppleShowAllFiles" -bool "true" # Show hidden files
defaults write com.apple.finder "ShowPathbar" -bool "true" # Show the Path Bar
defaults write com.apple.finder "FXPreferredViewStyle" -string "clmv" # Set default view to columns
defaults write com.apple.finder "FXRemoveOldTrashItems" -bool "true" # Automatically delete items from trash after 30 days
killall Finder # Reset Finder with the new settings

# Trackpad settings
defaults write com.apple.AppleMultitouchTrackpad "TrackpadThreeFingerDrag" -bool "true" # Enable three finger drag
defaults write com.apple.AppleMultitouchTrackpad "Clicking" -bool "true" # Enable tap to click

# Mission Control Settings
defaults write com.apple.dock "mru-spaces" -bool "false" # Do not reorganize spaces automatically
defaults write NSGlobalDomain "AppleSpacesSwitchOnActivate" -bool "true" # When switching apps, go to space with active app
killall Dock # Reset the Dock with the new settings

# Set Wallpaper
wallpaper ./wallpapers/Blue\ Cat.png