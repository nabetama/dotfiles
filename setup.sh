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

# Install Volta (JavaScript toolchain manager)
if ! command -v volta &> /dev/null; then
    echo "Installing Volta..."
    curl https://get.volta.sh | bash -s -- --skip-setup
fi

# Packages to stow
packages=(
    zsh
    git
    tig
    tmux
    herdr
    nvim
    xdg
    ghostty
    claude
)

echo "Stowing packages..."
for pkg in "${packages[@]}"; do
    echo "  - $pkg"
    if [ "$pkg" = "claude" ]; then
        # ~/.claude はログやキャッシュを置く実ディレクトリ。全体や hooks/ を
        # リンクにしないよう、ファイル単位で張る
        mkdir -p "$HOME/.claude"
        stow -R --no-folding -t "$HOME" "$pkg"
    else
        stow -R -t "$HOME" "$pkg"
    fi
done

echo "Done!"
