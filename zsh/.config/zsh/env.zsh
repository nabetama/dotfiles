# ====================================
# 環境変数と PATH
# ====================================
# PATH は上書きせず、先頭に足していく。/etc/zprofile の path_helper や
# /etc/zshrc (Nix など) が足したものはそのまま残す。
# typeset -U で重複を除く (最初に出てきたものが残る)。
typeset -U path fpath

# ------------------------------------
# Homebrew
# ------------------------------------
# Apple Silicon (/opt/homebrew) と Intel (/usr/local) のどちらでも動くように、
# あるほうの brew shellenv を読む (PATH・MANPATH・INFOPATH)。
if [[ -z "${HOMEBREW_PREFIX:-}" ]]; then
  for _brew in /opt/homebrew/bin/brew /usr/local/bin/brew; do
    [[ -x "$_brew" ]] || continue
    eval "$("$_brew" shellenv zsh)"
    # shellenv は PATH の先頭がすでに Homebrew だと何も出さないので自分で決める
    export HOMEBREW_PREFIX="${_brew:h:h}"
    break
  done
  unset _brew
fi
# Homebrew で入れたコマンドの補完関数を使う。git の補完も Homebrew の git が
# 入れる _git と git-completion.bash をここから読む。
[[ -n "${HOMEBREW_PREFIX:-}" ]] && fpath=("$HOMEBREW_PREFIX/share/zsh/site-functions" $fpath)

# ------------------------------------
# Language / Editor
# ------------------------------------
export LANG=en_US.UTF-8
export EDITOR='nvim'
export VISUAL='nvim'

# Claude Code の不要な通信 (テレメトリなど) を止める
export CLAUDE_CODE_DISABLE_NONESSENTIAL_TRAFFIC=1

# ------------------------------------
# 言語のツールチェーン
# ------------------------------------
# Go (Homebrew)。go install したツールは ~/bin に入る
export GOPATH="$HOME"

# pnpm のグローバルインストール先
export PNPM_HOME="$HOME/Library/pnpm"

# PATH の優先順 (上ほど先に探す)。Homebrew を先頭に置く: path_helper などで
# /usr/bin が先になると git が Apple の古い git に解決され、Homebrew の git 補完
# (git help --aliases-for-completion を呼ぶ) と合わずに補完がエラーになるため。
# Node は fnm (下の fnm env が PATH の先頭に足す)、Python は uv で入れる。Java が要るときは Homebrew の openjdk。
path=(
  ${HOMEBREW_PREFIX:+$HOMEBREW_PREFIX/bin}
  ${HOMEBREW_PREFIX:+$HOMEBREW_PREFIX/sbin}
  "$HOME/.local/bin"   # uv tool などが入れる先
  "$PNPM_HOME"
  "$HOME/.cargo/bin"   # Rust (rustup)
  "$GOPATH/bin"
  $path
)

# Node (fnm)。PATH の先頭に今の Node を足し、cd したときに .node-version /
# .nvmrc を見て切り替える (親ディレクトリもさかのぼって探す)
(( $+commands[fnm] )) && eval "$(fnm env --use-on-cd --version-file-strategy=recursive --shell zsh)"
