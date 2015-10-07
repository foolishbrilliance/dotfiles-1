#!/usr/bin/env bash
# Homebrew
# based on https://github.com/mathiasbynens/dotfiles/blob/master/brew.sh
#
# This installs some of the common dependencies needed (or at least desired)
# using Homebrew.

# Ask for the administrator password upfront.
echo "  Installing Homebrew packages for you."
sudo -v

# Keep-alive: update existing `sudo` time stamp until the script has finished.
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

# Make sure we’re using the latest Homebrew.
brew update

# Upgrade any already-installed formulae.
brew upgrade

# Install GNU core utilities (those that come with OS X are outdated).
# Don’t forget to add `$(brew --prefix coreutils)/libexec/gnubin` to `$PATH`.
brew install coreutils
if [ ! -e /usr/local/bin/sha256sum ]; then
  echo "  Linking /usr/local/bin/sha256sum -> /usr/local/bin/gsha256sum for you."
  sudo ln -s /usr/local/bin/gsha256sum /usr/local/bin/sha256sum
fi

# Install GNU `find`, `locate`, `updatedb`, and `xargs`, `g`-prefixed.
brew install findutils
# Install GNU `sed`, overwriting the built-in `sed`.
brew install gnu-sed --with-default-names
# Install Bash 4.
# Note: don’t forget to add `/usr/local/bin/bash` to `/etc/shells` before
# running `chsh`.
brew install bash
brew install bash-completion

# Install `wget` with IRI support.
#brew install wget --with-iri

# Install more recent versions of some OS X tools.
brew install vim --override-system-vi
brew install homebrew/dupes/grep
brew install homebrew/dupes/openssh

# Install some CTF tools; see https://github.com/ctfs/write-ups.
brew install ucspi-tcp # `tcpserver` etc.

# For pbcopy support in tmux per http://superuser.com/a/413233
brew install reattach-to-user-namespace --wrap-pbcopy-and-pbpaste

# Ruby
# for fish support per https://coderwall.com/p/hmousw/using-rbenv-with-fish-the-right-way
brew install rbenv --HEAD
brew install ruby-build

# Install other useful binaries.
brew install ack
brew install awscli
brew install fish
brew install git
brew install jq
brew install mtr
brew install p7zip
brew install pv
brew install rename
brew install rhino
brew install speedtest_cli
brew install tmux
brew install trash
brew install tree
brew install zsh

# Casks
brew cask install 1password
brew cask install alfred
brew cask install amazon-zocalo
brew cask install awareness
brew cask install bartender
brew cask install betterzipql
brew cask install bittorrent-sync
brew cask install cord
brew cask install crashplan
brew cask install cyberduck
brew cask install disk-inventory-x
brew cask install fantastical
brew cask install flux
brew cask install google-chrome
brew cask install google-hangouts
brew cask install iterm2
brew cask install keyboard-cleaner
brew cask install lastpass
brew cask install league-of-legends
brew cask install licecap
brew cask install lightpaper
# brew cask install macvim # yosemite issues per http://awebfactory.com/node/541, use `brew install macvim` instead
brew install macvim
brew cask install mailbox
brew cask install nomachine
brew cask install qlcolorcode
brew cask install qlimagesize
brew cask install qlmarkdown
brew cask install qlprettypatch
brew cask install qlstephen
brew cask install quicklook-csv
brew cask install quicklook-json
brew cask install shiftit
brew cask install slimbatterymonitor
brew cask install spotify
brew cask install sublime-text
brew cask install suspicious-package
brew cask install trim-enabler
brew cask install vagrant
brew cask install voicemac
brew cask install xmarks-safari

# Specific versions of software
brew tap caskroom/versions
brew cask install textexpander3

# ==> As of v2.6, Alfred now has first-class support for Casks out of the box!
# ==> So there's no more need for `brew cask alfred`. Go upgrade your Alfred! :)
brew cask alfred # Modify Alfred's scope to include the Homebrew Cask apps:

# Remove outdated versions from the cellar.
brew cleanup

echo "Homebrew packages installed!"

exit 0
