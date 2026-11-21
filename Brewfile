# Brewfile - `brew bundle` で入れるもの
#
# 入れる:     ./setup.sh (中で brew bundle install --file=Brewfile を実行する)
# 足りないか: brew bundle check --file=Brewfile --verbose
# 足す:       brew bundle add --file=Brewfile <名前>  (cask は --cask)
#
# 「入っている」だけでなく「使っている」ものだけを書く。依存で入るものは書かない。
# Mac App Store のアプリは mas を入れていないのでここには書かない (README を参照)。

# ------------------------------------
# 基本
# ------------------------------------
brew "coreutils"     # gls (zsh の ls_abbrev が使う)
brew "stow"          # dotfiles のリンク
brew "bash"          # macOS の bash は 3.2 と古い
brew "zsh"

# ------------------------------------
# エディタ・端末
# ------------------------------------
brew "neovim"
brew "vim"
brew "tmux"
brew "herdr"
cask "ghostty"
cask "visual-studio-code"

# ------------------------------------
# Git / GitHub
# ------------------------------------
brew "git"           # zsh の git 補完もこれが入れる _git を使う
brew "git-delta"     # git の pager
brew "tig"
brew "ghq"
brew "gh"
brew "act"           # GitHub Actions をローカルで動かす

# ------------------------------------
# 検索・ファイル操作
# ------------------------------------
brew "fzf"
brew "ripgrep"
brew "fd"            # nvim の telescope が使う
brew "tree"
brew "eza"           # fzf-ghq のプレビューが使う
brew "bat"
brew "zoxide"
brew "jq"            # claude の通知フックも使う
brew "gnu-sed"
brew "direnv"

# ------------------------------------
# 言語・ツールチェーン
# ------------------------------------
# Go。go install したツールは GOPATH (= $HOME) の bin に入る
brew "go"
go "golang.org/x/tools/cmd/goimports"   # nvim (conform) の Go の整形

# JavaScript。Node は Volta だけで管理する (setup.sh が LTS を入れる)
brew "volta"
brew "pnpm"

# Python。uv だけで管理する (uv python install / uv tool install)
brew "uv"

# Java は今は使っていない。要るときは brew "openjdk" を足す

# Rust。rustup 本体は公式のインストーラで入れる (setup.sh)
brew "cargo-make"
brew "cargo-llvm-cov"
brew "mold"          # リンカ

# ------------------------------------
# そのほかの CLI
# ------------------------------------
brew "ffmpeg"
brew "cowsay"
brew "fortune"

# ------------------------------------
# AI
# ------------------------------------
cask "claude-code"
cask "codex"
cask "claude"
cask "chatgpt"

# ------------------------------------
# GUI アプリ
# ------------------------------------
cask "1password"
cask "google-chrome"
cask "google-japanese-ime"
cask "karabiner-elements"   # 設定は xdg/.config/karabiner
cask "raycast"
cask "rectangle"
cask "appcleaner"
cask "docker-desktop"       # docker CLI もこれが入れる
cask "obsidian"
cask "smoothcsv"
cask "discord"
cask "zoom"
cask "vlc"
cask "calibre"
cask "transmission"
cask "adobe-creative-cloud"

# ------------------------------------
# フォント
# ------------------------------------
cask "font-moralerspace"    # ghostty で使う
cask "font-fira-code"
cask "font-source-code-pro"
