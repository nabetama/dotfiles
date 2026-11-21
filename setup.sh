#!/bin/bash
# setup.sh - Mac の環境をこのリポジトリから組み立てる
#
# 新しい Mac で 1 回実行すれば、ツールの導入から設定のリンクまでそろう。
# すでにそろっているものは飛ばすので、何度実行しても安全。
# macOS 標準の bash 3.2 で動くように書いている (Homebrew の bash はまだないため)。
#
# Usage: ./setup.sh [--dry-run] [--only STEP[,STEP...]]
#   -n, --dry-run   何も変えずに、何をするかだけを表示する
#   --only STEPS    指定した手順だけ実行する (カンマ区切り)
#   -h, --help      この説明を表示する
#
# 手順 (この順に実行する):
#   clt     Xcode Command Line Tools
#   brew    Homebrew
#   bundle  Brewfile の CLI・アプリ・Go のツール (brew bundle install)
#   stow    設定ファイルのリンク (GNU Stow)
#   local   追跡しないローカル上書きファイルのテンプレート
#   node    Volta で Node (LTS)
#   rust    rustup で Rust
#   tmux    TPM と tmux のプラグイン
#   nvim    neovim のプラグイン (lazy-lock.json の版で)
set -euo pipefail

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd -P)"
ALL_STEPS="clt brew bundle stow local node rust tmux nvim"

# stow するパッケージ
PACKAGES="zsh git tig tmux herdr nvim xdg ghostty claude"
# ディレクトリごとリンクにせず、ファイル単位でリンクするパッケージ。
# リンク先のディレクトリにアプリがログ・キャッシュ・ソケットなどを書くので、
# ディレクトリをリポジトリへのリンクにするとそれがリポジトリの中にできてしまう。
#   claude:  ~/.claude (ログ・キャッシュ)
#   herdr:   ~/.config/herdr (ログ・ソケット)
#   ghostty: ~/Library/Application Support/com.mitchellh.ghostty
NO_FOLDING_PACKAGES="claude herdr ghostty"

DRY_RUN=0
STEPS="$ALL_STEPS"
FAILED=""

usage() {
  sed -n '2,/^set -euo pipefail/{/^set /d;s/^# \{0,1\}//;p;}' "$0"
}

while [ $# -gt 0 ]; do
  case "$1" in
    -n|--dry-run) DRY_RUN=1 ;;
    --only) [ $# -ge 2 ] || { usage >&2; exit 2; }; STEPS="$(printf '%s' "$2" | tr ',' ' ')"; shift ;;
    --only=*) STEPS="$(printf '%s' "${1#--only=}" | tr ',' ' ')" ;;
    -h|--help) usage; exit 0 ;;
    *) printf 'unknown option: %s\n\n' "$1" >&2; usage >&2; exit 2 ;;
  esac
  shift
done

for s in $STEPS; do
  case " $ALL_STEPS " in
    *" $s "*) ;;
    *) printf 'unknown step: %s (steps: %s)\n' "$s" "$ALL_STEPS" >&2; exit 2 ;;
  esac
done

# ------------------------------------
# helpers
# ------------------------------------
log()  { printf '\033[1;34m==>\033[0m \033[1m%s\033[0m\n' "$*"; }
info() { printf '    %s\n' "$*"; }
warn() { printf '\033[1;33mWarning:\033[0m %s\n' "$*" >&2; }
die()  { printf '\033[1;31mError:\033[0m %s\n' "$*" >&2; exit 1; }

# 変更を伴うコマンドは run を通す。--dry-run では表示だけする
run() {
  if [ "$DRY_RUN" -eq 1 ]; then
    printf '    [dry-run]'
    printf ' %q' "$@"
    printf '\n'
  else
    "$@"
  fi
}

want() {
  case " $STEPS " in *" $1 "*) return 0 ;; esac
  return 1
}

has() { command -v "$1" >/dev/null 2>&1; }

is_no_folding() {
  case " $NO_FOLDING_PACKAGES " in *" $1 "*) return 0 ;; esac
  return 1
}

# Apple Silicon と Intel のどちらの Homebrew でも見つける
find_brew() {
  local b
  for b in /opt/homebrew/bin/brew /usr/local/bin/brew; do
    if [ -x "$b" ]; then
      printf '%s\n' "$b"
      return 0
    fi
  done
  command -v brew 2>/dev/null
}

load_brew_env() {
  local brew
  brew="$(find_brew)" || return 1
  eval "$("$brew" shellenv bash)"
  # shellenv は PATH の先頭がすでに Homebrew だと何も出さない
  export HOMEBREW_PREFIX="${HOMEBREW_PREFIX:-$(dirname "$(dirname "$brew")")}"
  case ":$PATH:" in
    *":$HOMEBREW_PREFIX/bin:"*) ;;
    *) export PATH="$HOMEBREW_PREFIX/bin:$HOMEBREW_PREFIX/sbin:$PATH" ;;
  esac
}

# zsh の env.zsh と同じ場所を使う
export GOPATH="${GOPATH:-$HOME}"
export VOLTA_HOME="${VOLTA_HOME:-$HOME/.volta}"
export PATH="$VOLTA_HOME/bin:$HOME/.cargo/bin:$GOPATH/bin:$PATH"

# ------------------------------------
# steps
# ------------------------------------
step_clt() {
  log "Xcode Command Line Tools"
  if xcode-select -p >/dev/null 2>&1; then
    info "入っている: $(xcode-select -p)"
    return 0
  fi
  run xcode-select --install
  if [ "$DRY_RUN" -eq 0 ]; then
    die "Command Line Tools のインストーラを開いた。終わったらもう一度 ./setup.sh を実行する"
  fi
}

step_brew() {
  log "Homebrew"
  if load_brew_env; then
    info "入っている: $HOMEBREW_PREFIX"
    return 0
  fi
  if [ "$DRY_RUN" -eq 1 ]; then
    info "[dry-run] Homebrew の公式インストーラ (https://brew.sh) を実行する"
    return 0
  fi
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  load_brew_env || die "Homebrew が見つからない"
}

step_bundle() {
  log "brew bundle ($DOTFILES_DIR/Brewfile)"
  if ! has brew; then
    [ "$DRY_RUN" -eq 1 ] && { info "[dry-run] Homebrew を入れたあとに brew bundle install を実行する"; return 0; }
    die "brew がない"
  fi
  local missing
  if missing="$(brew bundle check --file="$DOTFILES_DIR/Brewfile" --no-upgrade --verbose 2>&1)"; then
    info "Brewfile のものはすべて入っている"
    return 0
  fi
  info "足りないもの:"
  printf '%s\n' "$missing" | grep '^→' | sed 's/^→/     /' || true
  # 既存の Mac で、Brewfile にあるアプリを brew 以外で入れていると
  # (/Applications にすでにある) その cask は失敗する。止めずに先へ進み、最後に知らせる。
  if ! run brew bundle install --file="$DOTFILES_DIR/Brewfile" --no-upgrade; then
    warn "brew bundle install で失敗したものがある。brew bundle check --file=$DOTFILES_DIR/Brewfile --verbose で確かめる"
    FAILED="$FAILED bundle"
  fi
}

# $HOME 直下と ~/.config などに残っている、このリポジトリを指す壊れたリンクを知らせる。
# レイアウトを変えたあとの古いリンク。消すかどうかは人が決めるので、消さない。
report_stale_links() {
  local dir link target stale=""
  for dir in "$HOME" "$HOME/.config" "$HOME/.claude" "$HOME/.claude/hooks"; do
    [ -d "$dir" ] || continue
    for link in "$dir"/.[!.]* "$dir"/*; do
      [ -L "$link" ] || continue
      [ -e "$link" ] && continue
      target="$(readlink "$link")"
      case "$target" in
        *dotfiles*) stale="$stale$link -> $target"$'\n' ;;
      esac
    done
  done
  if [ -n "$stale" ]; then
    warn "dotfiles を指す壊れたリンクがある (古いレイアウトの名残り。確かめて rm で消す):"
    printf '%s' "$stale" | sed 's/^/    /' >&2
  fi
}

# stow を -n (シミュレーション) で試す。衝突があれば 1 を返し、内容を CONFLICTS に足す
STOW_CONFLICTS=""
stow_simulate() {
  local out
  if out="$(stow -d "$DOTFILES_DIR" -t "$HOME" -n -v "$@" 2>&1)"; then
    if [ "$DRY_RUN" -eq 1 ]; then
      # -R は張り直しになるので、外してすぐ同じリンクを張る組 (reverts previous action)
      # は表示しない。実際に変わるものだけが残る
      printf '%s\n' "$out" | awk '
        /^(LINK|UNLINK|MKDIR|RMDIR): / {
          line[++n] = $0
          if ($0 ~ /\(reverts previous action\)$/) {
            path = $0; sub(/^[A-Z]+: /, "", path); sub(/ => .*/, "", path); reverted[path] = 1
          }
        }
        END {
          for (i = 1; i <= n; i++) {
            path = line[i]; sub(/^[A-Z]+: /, "", path); sub(/ => .*/, "", path)
            if (line[i] ~ /\(reverts previous action\)$/) continue
            if (line[i] ~ /^UNLINK: / && (path in reverted)) continue
            print "    " line[i]
          }
        }'
    fi
    return 0
  fi
  STOW_CONFLICTS="$STOW_CONFLICTS$(printf '%s\n' "$out" | grep -E '^(WARNING!|  \*)')"$'\n'
  return 1
}

step_stow() {
  log "stow ($PACKAGES)"
  if ! has stow; then
    [ "$DRY_RUN" -eq 1 ] && { info "[dry-run] brew bundle で stow を入れたあとにリンクする"; return 0; }
    die "stow がない (brew bundle で入る)"
  fi

  local pkg folding="" no_folding=""
  for pkg in $PACKAGES; do
    if is_no_folding "$pkg"; then
      no_folding="$no_folding $pkg"
    else
      folding="$folding $pkg"
    fi
  done

  # ~/.config や ~/.claude がないとディレクトリごとリンクになり、
  # ほかのアプリが書くファイルがリポジトリの中にできてしまうので先に作る
  if [ "$DRY_RUN" -eq 1 ] && { [ ! -d "$HOME/.config" ] || [ ! -d "$HOME/.claude" ]; }; then
    info "(~/.config と ~/.claude がまだないので、下の表示はそれらを作る前の状態でのシミュレーション)"
  fi
  run mkdir -p "$HOME/.config" "$HOME/.claude"

  # まず全パッケージを試し、衝突があれば何もせずに止める
  local ok=1
  # shellcheck disable=SC2086  # パッケージ名の並びは意図して単語分割する
  stow_simulate -R $folding || ok=0
  # shellcheck disable=SC2086
  stow_simulate -R --no-folding $no_folding || ok=0
  if [ "$ok" -eq 0 ]; then
    printf '%s' "$STOW_CONFLICTS" | sed 's/^/    /' >&2
    die "既存のファイルと衝突するのでリンクしなかった。上のファイルを退避するか消してから、もう一度実行する"
  fi

  if [ "$DRY_RUN" -eq 0 ]; then
    # shellcheck disable=SC2086
    stow -d "$DOTFILES_DIR" -t "$HOME" -R $folding
    # shellcheck disable=SC2086
    stow -d "$DOTFILES_DIR" -t "$HOME" -R --no-folding $no_folding
    info "リンクした:$folding$no_folding"
  fi
  report_stale_links
}

# 追跡しないローカル上書きファイル。なければコメントだけのテンプレートを作る。あれば触らない
write_template() {
  local file="$1" content="$2"
  if [ -e "$file" ] || [ -L "$file" ]; then
    info "あるので触らない: $file"
    return 0
  fi
  if [ "$DRY_RUN" -eq 1 ]; then
    info "[dry-run] テンプレートを作る: $file"
    return 0
  fi
  printf '%s\n' "$content" > "$file"
  info "テンプレートを作った: $file"
}

step_local() {
  log "ローカル上書きファイル"
  write_template "$HOME/.localrc" "\
# ~/.localrc - このマシンだけの zsh の設定 (dotfiles では追跡しない)
# ~/.zshrc がほかの設定を読んだあと、direnv の hook の前に読む。
# 仕事用のツールの初期化、社内の証明書、マシン固有の PATH などをここに書く。
#
# 例:
# export NODE_EXTRA_CA_CERTS=\"\$HOME/path/to/ca.pem\"
# path=(\"\$HOME/path/to/bin\" \$path)
# (( \$+commands[sometool] )) && eval \"\$(sometool env zsh)\""
  write_template "$HOME/.gitconfig.local" "\
# ~/.gitconfig.local - このマシンだけの git の設定 (dotfiles では追跡しない)
# ~/.gitconfig の最後で include するので、ここに書いた値が勝つ。
#
# 例: 仕事用のリポジトリだけメールアドレスを変える
# [includeIf \"gitdir:~/src/github.com/your-org/\"]
#   path = ~/.gitconfig.work"
}

step_node() {
  log "Node (Volta)"
  if ! has volta; then
    [ "$DRY_RUN" -eq 1 ] && { info "[dry-run] brew bundle で volta を入れたあとに Node を入れる"; return 0; }
    warn "volta がない (brew bundle で入る)。飛ばす"
    return 0
  fi
  if volta which node >/dev/null 2>&1; then
    info "既定の Node がある: $(volta which node)"
  else
    run volta install node@lts
  fi
}

step_rust() {
  log "Rust (rustup)"
  if [ -x "$HOME/.cargo/bin/rustup" ]; then
    info "入っている: $HOME/.cargo/bin/rustup"
    return 0
  fi
  # 公式のインストーラ。~/.zshenv などに . "$HOME/.cargo/env" を足す
  # (zsh の対話シェルの PATH は env.zsh でも足している)
  if [ "$DRY_RUN" -eq 1 ]; then
    info "[dry-run] curl https://sh.rustup.rs | sh -s -- -y"
    return 0
  fi
  curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
}

step_tmux() {
  log "tmux (TPM とプラグイン)"
  # .tmux.conf の @plugin (TPM 自身も含む) を、TPM と同じ ~/.tmux/plugins/<名前> に
  # clone する。TPM の bin/install_plugins は TPM を読み込んだ tmux サーバーが
  # 動いていないと使えないので使わない。入っているものは飛ばす (更新は prefix + U)
  local conf="$DOTFILES_DIR/tmux/.tmux.conf" plugins_dir="$HOME/.tmux/plugins" plugins plugin dir
  plugins="$(sed -n "s/^[[:space:]]*set\(-option\)\{0,1\}[[:space:]]\{1,\}-g[[:space:]]\{1,\}@plugin[[:space:]]\{1,\}['\"]\([^'\"]*\)['\"].*/\2/p" "$conf")"
  [ -n "$plugins" ] || { warn "$conf に @plugin がない"; return 0; }
  for plugin in $plugins; do
    dir="$plugins_dir/${plugin##*/}"
    if [ -d "$dir" ]; then
      info "入っている: $plugin"
    else
      run git clone --depth 1 "https://github.com/$plugin" "$dir"
    fi
  done
}

step_nvim() {
  log "neovim (lazy.nvim)"
  if ! has nvim; then
    warn "nvim がない。飛ばす"
    return 0
  fi
  local lazy="${XDG_DATA_HOME:-$HOME/.local/share}/nvim/lazy"
  if [ -d "$lazy/lazy.nvim" ]; then
    # 入っている環境で restore すると、手元の版が lazy-lock.json の版に戻るので触らない
    info "入っている: $lazy (更新は nvim で :Lazy)"
    return 0
  fi
  run nvim --headless "+Lazy! restore" +qa
}

# ------------------------------------
# main
# ------------------------------------
[ "$(uname -s)" = Darwin ] || die "macOS 用"
if [ "$DRY_RUN" -eq 1 ]; then
  log "dry-run: 何も変えずに、何をするかだけを表示する"
fi
info "dotfiles: $DOTFILES_DIR"
info "HOME:     $HOME"

# Homebrew が入っていれば、どの手順を選んでも PATH に入れておく (--only stow などのため)
load_brew_env 2>/dev/null || true

# 手順の順番は ALL_STEPS で決まる (--only の並びにはよらない)
for s in $ALL_STEPS; do
  if want "$s"; then
    "step_$s"
  fi
done

if [ -n "$FAILED" ]; then
  warn "失敗した手順がある:$FAILED"
  exit 1
fi

log "完了"
cat <<'EOF'
    手で行うこと:
    - Mac App Store のアプリを入れる (README の「Mac App Store」)
    - 新しいシェルを開く (exec zsh)
    - ~/.localrc と ~/.gitconfig.local にこのマシンだけの設定を書く
EOF
