#!/bin/bash
set -e

DOTFILES_DIR="$(cd "$(dirname "$0")" && pwd)"
cd "$DOTFILES_DIR"

# Install stow if not available
if ! command -v stow &> /dev/null; then
    echo "Installing stow..."
    brew install stow
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
)

echo "Stowing packages..."
for pkg in "${packages[@]}"; do
    echo "  - $pkg"
    stow -t "$HOME" "$pkg"
done

echo "Done!"
