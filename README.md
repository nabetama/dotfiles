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
stow -t ~ zsh git vim nvim

# Unlink
stow -t ~ -D zsh
```
