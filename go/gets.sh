#!/bin/bash

set -e

# NOTE: ghq is installed via Homebrew (see Brewfile)
# NOTE: LSP features (gocode, godef, gotags) are now provided by gopls

PKGS=(
    # Go tools
    golang.org/x/tools/cmd/goimports
    golang.org/x/tools/cmd/present

    # Debugging and development
    github.com/k0kubun/pp/v3@latest
    github.com/x-motemen/gore/cmd/gore@latest
    github.com/tcnksm/ghr@latest
)

for pkg in ${PKGS[@]}
do
    go install -v $pkg
done
