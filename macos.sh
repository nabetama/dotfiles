#!/bin/bash
# macos.sh - macOS の設定 (defaults) をこのリポジトリの値にそろえる
#
# 値は、もとの Mac で `defaults read` して読み取ったもの。
# そのマシンで明示的に設定していたキーだけを書いている (既定のままのものは書かない)。
# 書き込むと今の設定が上書きされるので、setup.sh からは `--only macos` を指定したときだけ動く。
# macOS 標準の bash 3.2 で動くように書いている。
#
# Usage: ./macos.sh [--dry-run]
#   -n, --dry-run   何も変えずに、書き込む内容だけを表示する
#   -h, --help      この説明を表示する
set -euo pipefail

DRY_RUN=0
case "${1:-}" in
  -n|--dry-run) DRY_RUN=1 ;;
  -h|--help) sed -n '2,/^set -euo pipefail/{/^set /d;s/^# \{0,1\}//;p;}' "$0"; exit 0 ;;
  "") ;;
  *) printf 'unknown option: %s\n' "$1" >&2; exit 2 ;;
esac

[ "$(uname -s)" = Darwin ] || { echo "macOS 用" >&2; exit 1; }

run() {
  if [ "$DRY_RUN" -eq 1 ]; then
    printf '    [dry-run]'
    printf ' %q' "$@"
    printf '\n'
  else
    "$@"
  fi
}

# defaults write の薄い包み。何を書くかを表示してから書く
w() {
  printf '    %s %s = %s\n' "$1" "$2" "${*:4}"
  run defaults write "$@"
}

echo "==> キーボード"
w NSGlobalDomain KeyRepeat -int 2               # キーリピートの速さ (小さいほど速い)
w NSGlobalDomain InitialKeyRepeat -float 25     # リピートが始まるまで
w NSGlobalDomain com.apple.keyboard.fnState -bool true   # F1〜F12 を標準のファンクションキーとして使う

echo "==> 外観・トラックパッド"
w NSGlobalDomain AppleInterfaceStyle -string Dark
w NSGlobalDomain com.apple.swipescrolldirection -bool true   # ナチュラルスクロール
w com.apple.AppleMultitouchTrackpad Clicking -bool true      # タップでクリック
w com.apple.driver.AppleBluetoothMultitouch.trackpad Clicking -bool true
w com.apple.menuextra.clock ShowSeconds -bool true           # メニューバーの時計に秒を出す

echo "==> Dock"
w com.apple.dock orientation -string left
w com.apple.dock autohide -bool true
w com.apple.dock tilesize -float 32
w com.apple.dock magnification -bool true
w com.apple.dock largesize -float 128

echo "==> Finder"
w NSGlobalDomain AppleShowAllExtensions -bool true   # 拡張子をすべて表示
w com.apple.finder AppleShowAllFiles -string TRUE    # 隠しファイルを表示
w com.apple.finder FXPreferredViewStyle -string glyv # アイコン表示
w com.apple.finder NewWindowTarget -string PfHm      # 新しいウインドウでホームを開く
w com.apple.finder NewWindowTargetPath -string "file://$HOME/"

echo "==> スクリーンショット"
run mkdir -p "$HOME/Pictures/screenshots"
w com.apple.screencapture location -string "$HOME/Pictures/screenshots"
w com.apple.screencapture type -string jpg

# 書いた設定を読み直させる
if [ "$DRY_RUN" -eq 0 ]; then
  for app in Dock Finder SystemUIServer; do
    killall "$app" >/dev/null 2>&1 || true
  done
  echo "==> 完了 (キーボードとトラックパッドの設定は、ログインし直すと効く)"
fi
