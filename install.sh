#!/usr/bin/env bash

# for debugging purposes
set -e

echo "💻 Jason's MacOS Setup Tool"
echo ""

# Ask for the administrator password upfront
sudo -v

# Make sure macOS is fully up to date before doing anything
sudo softwareupdate --install --all

# Install Xcode Command Line Tools
sudo xcode-select --install || true

# Accept Xcode license
sudo xcodebuild -license accept || true

# Homebrew
if ! command -v brew &>/dev/null; then
  curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh | bash
fi

# Disable analytics
# https://docs.brew.sh/Analytics
brew analytics off

# Update Homebrew recipes
brew update

# Install more current ZSH and set as default shell
# https://stackoverflow.com/a/44549662/1438024
brew install zsh
sudo sh -c "echo $(brew --prefix)/bin/zsh >> /etc/shells"
chsh -s "$(brew --prefix)/bin/zsh"

# https://github.com/ohmyzsh/ohmyzsh/issues/6835#issuecomment-390187157
chmod 755 "$(brew --prefix)/share/zsh"
chmod 755 "$(brew --prefix)/share/zsh/site-functions"

# Install all apps from the Brewfile, ignore errors
brew tap homebrew/bundle
brew bundle || true

# Starship
curl -sS https://starship.rs/install.sh | sh

# vim-plug
sh -c 'curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs \
       https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'

# Change new hostname here if necessary
COMPUTER_NAME="jason-mac"

# Quit System Preferences.app if open
osascript -e 'tell application "System Preferences" to quit'

# Ask for the administrator password upfront
sudo -v

# Keep-alive: update existing `sudo` time stamp until this script has finished
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

###############################################################################
# General UI/UX                                                               #
###############################################################################

# Set computer name (as done via System Preferences → Sharing)
sudo scutil --set ComputerName "$COMPUTER_NAME"
sudo scutil --set HostName "$COMPUTER_NAME"
sudo scutil --set LocalHostName "$COMPUTER_NAME"
sudo defaults write /Library/Preferences/SystemConfiguration/com.apple.smb.server NetBIOSName -string "$COMPUTER_NAME"

# Expand save panel by default
defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode -bool true
defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode2 -bool true

# Expand print panel by default
defaults write NSGlobalDomain PMPrintingExpandedStateForPrint -bool true
defaults write NSGlobalDomain PMPrintingExpandedStateForPrint2 -bool true

###############################################################################
# Finder                                                                      #
###############################################################################

# Finder: show all filename extensions
defaults write NSGlobalDomain AppleShowAllExtensions -bool true

# Enable snap-to-grid for icons on the desktop and in other icon views
/usr/libexec/PlistBuddy -c "Set :DesktopViewSettings:IconViewSettings:arrangeBy grid" ~/Library/Preferences/com.apple.finder.plist
/usr/libexec/PlistBuddy -c "Set :FK_StandardViewSettings:IconViewSettings:arrangeBy grid" ~/Library/Preferences/com.apple.finder.plist
/usr/libexec/PlistBuddy -c "Set :StandardViewSettings:IconViewSettings:arrangeBy grid" ~/Library/Preferences/com.apple.finder.plist

# Always open everything in Finder's list view.
# Use list view in all Finder windows by default
# Four-letter codes for the other view modes: `icnv`, `clmv`, `Flwv`
defaults write com.apple.finder FXPreferredViewStyle -string "Nlsv"

###############################################################################
# Finished!                                                                   #
###############################################################################

echo "All done! Some of these changes require a logout/restart to take effect."



















