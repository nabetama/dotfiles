# Check if homebrew is already installed
if test ! $(which brew); then
	echo "Installing homebrew..."
	ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
fi

# Update
printf "update brew (brew update)? [Y/n]: " && read ANS
if [ "${ANS}" = "Y" ]; then
	brew update
fi

# Upgrade all
printf "Upgrade? [Y/n]: " && read ANS
if [ "${ANS}" = "Y" ]; then
	brew upgrade
fi

# Add Repository
brew tap thoughtbot/formulae
brew tap homebrew/cask
brew tap homebrew-cask/fonts
brew tap neovim/neovim
brew tap osx-cross/avr
brew tap universal-ctags/universal-ctags
brew tap sanemat/font

# Packages
packages=(
# editor
neovim

# GNU core utilities (those that come with OS X are outdated)
coreutils

# GNU `find`, `locate`, `updatedb`, and `xargs`, g-prefixed
findutils

# Shell
zsh
bash

# Tmux
tmux
reattach-to-user-namespace 

# Git
git
hub
tig

# Image
imagemagick

# Utils
ag
autoconf
automake
curl
universal-ctags
direnv
glide
libyaml
markdown
nkf
openssl
proctools
readline
ricty --vim-powerline
ripgrep
rmtrash
tree
wget

# golang, delve
# see: https://github.com/derekparker/delve/blob/master/Documentation/installation/osx/install.md
go-delve/delve/delve

# Languages
## python
pyenv

## ruby
rbenv
ruby-build

## lua(for vim)
lua

## javaScript
npm
yarn

## php
brew-php-switcher

## keyboard
dfu-programmer
avr-gcc
)
echo "installing binaries..."
echo ${packages[@]}
brew install ${packages[@]} && brew cleanup

# fonts
fonts=(
font-m-plus
font-source-code-pro
font-clear-sans
font-roboto
font-go
font-fira-code
)
# install fonts
echo "installing fonts..."
brew install --cask ${fonts[@]}

#---  development ---
# Scheme(racket)
brew install --cask racket
# Haskell Platform
brew install --cask ghc cabal-install stack

# GUI app
brew install --cask spectacle
brew install --cask vanilla
