# dotfiles

## Setup

```sh
git clone git@github.com:nabetama/dotfiles.git ~/.dotfiles
cd ~/.dotfiles
./setup.sh
```

## Requirements

- [GNU Stow](https://www.gnu.org/software/stow/)

`setup.sh` will install stow via Homebrew if not available.

## Manual

```sh
# Link individual packages
stow -t ~ zsh git nvim

# Unlink
stow -t ~ -D zsh
```

## Customization

### Machine-specific settings

Add local configurations to `~/.localrc` (not tracked by git):

```sh
# Example ~/.localrc
export NODE_EXTRA_CA_CERTS="$HOME/company-ca.pem"
export WORK_PROJECT_PATH="$HOME/work"
```

### Installing Homebrew packages

```sh
brew bundle --file=~/.dotfiles/Brewfile
```

### Go tools

```sh
~/.dotfiles/go/gets.sh
```
