#!/bin/bash
set -e

DOTFILES_DIR="$(cd "$(dirname "$0")" && pwd)"
cd "$DOTFILES_DIR"

# Install Homebrew if not available
if ! command -v brew &> /dev/null; then
    echo "Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    eval "$(/opt/homebrew/bin/brew shellenv)"
fi

# Install packages from Brewfile
if [ -f "$DOTFILES_DIR/Brewfile" ]; then
    echo "Installing packages from Brewfile..."
    brew bundle --file="$DOTFILES_DIR/Brewfile"
fi

# Packages to stow
packages=(
    zsh
    git
    tig
    tmux
    vim
    nvim
    ctags
    xdg
    ghostty
)

echo "Stowing packages..."
for pkg in "${packages[@]}"; do
    echo "  - $pkg"
    stow -t "$HOME" "$pkg"
done

echo "Done!"
