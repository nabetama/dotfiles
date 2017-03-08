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
brew tap homebrew/dupes
brew tap homebrew/versions
brew tap homebrew/binary
brew tap thoughtbot/formulae
brew tap caskroom/fonts

# Packages
packages=(
  # GNU core utilities (those that come with OS X are outdated)
  coreutils

  # GNU `find`, `locate`, `updatedb`, and `xargs`, g-prefixed
  findutils

  # recent versions of some OS X tools
  homebrew/dupes/grep
  apple-gcc42

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

  # Emcas
  cask

  # Image
  imagemagick

  #font
  ricty

  # Utils
  ag
  autoconf
  automake
  curl
  direnv
  glide
  libyaml
  markdown
  nkf
  openssl
  peco
  proctools
  readline
  rmtrash
  tree
  wget

  # golang, delve
  # see: https://github.com/derekparker/delve/blob/master/Documentation/installation/osx/install.md
  go-delve/delve/delve

  # Languages
  pyenv
  rbenv
  ruby-build
)
echo "installing binaries..."
brew install ${packages[@]} && brew cleanup

# fonts
fonts=(
  font-m-plus
  font-source-code-pro
  font-clear-sans
  font-roboto
  font-go
)
# install fonts
echo "installing fonts..."
brew cask install ${fonts[@]}
