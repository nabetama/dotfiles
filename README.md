# dotfiles

macOS の設定と、使っている CLI・アプリの一覧 (Brewfile)。
[GNU Stow](https://www.gnu.org/software/stow/) でホームディレクトリにリンクする。

## 新しい Mac で

```sh
# git を使うために Command Line Tools を入れる (ダイアログが出る)
xcode-select --install

git clone https://github.com/nabetama/dotfiles.git ~/.dotfiles
cd ~/.dotfiles
./setup.sh --dry-run   # 何をするかだけを見る
./setup.sh
```

clone する場所はどこでもよい (設定はリンク先から読むので、場所に依存しない)。

`setup.sh` は次をこの順に行う。すでにあるものは飛ばすので、何度実行してもよい。

| 手順 | 内容 |
| --- | --- |
| `clt` | Xcode Command Line Tools |
| `brew` | Homebrew (Apple Silicon / Intel のどちらでも) |
| `bundle` | `brew bundle install --no-upgrade` (Brewfile の CLI・アプリ・Go のツール) |
| `stow` | 全パッケージのリンク。既存のファイルと衝突したら何も変えずに止まる |
| `local` | `~/.localrc` と `~/.gitconfig.local` のテンプレート (なければ作る) |
| `node` | Volta で Node (LTS) |
| `rust` | rustup |
| `tmux` | TPM と `.tmux.conf` の `@plugin` |
| `nvim` | lazy.nvim のプラグイン (初回だけ。`lazy-lock.json` の版で) |

一部だけ実行するには `./setup.sh --only stow,local` のようにする。

macOS の設定 (`macos.sh`。キーリピート・Dock・Finder など) は今の設定を上書きするので、
既定では実行しない。`./setup.sh --only macos --dry-run` で内容を見てから
`./setup.sh --only macos` で当てる (`./macos.sh` を直接実行してもよい)。

終わったら新しいシェルを開く。

## パッケージ

| パッケージ | リンク先 |
| --- | --- |
| `zsh` | `~/.zshrc`, `~/.config/zsh/` (env / alias / functions / fzf) |
| `git` | `~/.gitconfig` |
| `tig` | `~/.tigrc` |
| `tmux` | `~/.tmux.conf` |
| `herdr` | `~/.config/herdr/config.toml` |
| `nvim` | `~/.config/nvim/` |
| `xdg` | `~/.config/{git,direnv,karabiner}/` |
| `ghostty` | `~/Library/Application Support/com.mitchellh.ghostty/config` |
| `claude` | `~/.claude/settings.json`, `~/.claude/hooks/` |

`claude` `herdr` `ghostty` はディレクトリごとではなくファイル単位でリンクする
(`stow --no-folding`)。リンク先のディレクトリにアプリがログ・キャッシュ・ソケットを
書くので、ディレクトリをリンクにするとそれがリポジトリの中にできてしまうため。

手で張り直すとき:

```sh
cd ~/.dotfiles
stow -R -t ~ zsh git tig tmux nvim xdg
stow -R -t ~ --no-folding claude herdr ghostty
stow -D -t ~ zsh   # 外す
```

## マシン固有・仕事用の設定

追跡しないファイルに書く。`setup.sh` はなければコメントだけのテンプレートを作り、
あれば触らない。

- `~/.localrc` — zsh。`~/.zshrc` がほかの設定を読んだあと、direnv の hook の前に読む。
  仕事用のツールの初期化、社内の証明書、マシン固有の PATH など
- `~/.gitconfig.local` — git。`~/.gitconfig` の最後で include するので、ここに書いた値が勝つ。
  仕事用のリポジトリでメールアドレスを変える `includeIf` など

## Brewfile

「入っている」だけでなく「使っている」ものだけを書く。依存で入るものは書かない。

```sh
brew bundle check --file=~/.dotfiles/Brewfile --verbose   # 足りないもの
brew bundle add --file=~/.dotfiles/Brewfile <名前>         # 足す (cask は --cask)
brew bundle install --file=~/.dotfiles/Brewfile --no-upgrade

# 入っているのに Brewfile にないものを探す (Brewfile は上書きしない)
brew bundle dump --file=/tmp/Brewfile.now --force
diff <(brew bundle list --all --file=~/.dotfiles/Brewfile | sort) \
     <(brew bundle list --all --file=/tmp/Brewfile.now | sort)
```

Brewfile の cask を、brew を使わずに手で入れたアプリ (`/Applications` にすでにある) は
`brew bundle install` で失敗する。brew の管理に移すには `brew install --cask --adopt <名前>`。

Go のツールは Brewfile の `go "..."` で入れる (`GOPATH=$HOME` なので `~/bin` に入る)。

## Mac App Store

`mas` を入れていないので、App Store のアプリは Brewfile に書かず、手で入れる。

## Claude Code と Herdr

`claude/.claude/settings.json` のフックは `$HOME` を使って書いている。
`herdr integration install` を実行すると、`~/.claude/hooks/herdr-agent-state.sh` が
更新され、`settings.json` に絶対パスの SessionStart のエントリが足される。
そのときは足されたエントリを消し、`$HOME` を使う既存の 1 つにまとめ直す
(`settings.json` はリンクなので、このリポジトリのファイルが書き換わる)。
