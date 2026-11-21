# .zshrc
#
# 分けたファイルは ~/.config/zsh/ に置く (stow の zsh パッケージがリンクする)。
# このリポジトリをどこに clone しても、リンク先から読むので動く。
# マシン固有・仕事用の設定は ~/.localrc に書く (追跡しない)。

ZSH_CONFIG_DIR="${XDG_CONFIG_HOME:-$HOME/.config}/zsh"

# PATH・環境変数。補完の fpath もここで決まるので compinit より前に読む
source "$ZSH_CONFIG_DIR/env.zsh"

# ------------------------------------
# Completion
# ------------------------------------
autoload -Uz compinit && compinit

zstyle ':completion:*' verbose yes
zstyle ':completion:*:descriptions' format '%B%d%b'
zstyle ':completion:*:default' menu select=1

# 補完候補をコンパクトに表示
setopt list_packed

# ファイル補完候補に色を付ける
export LSCOLORS=gxfxcxdxbxegedabagacad
export LS_COLORS='di=36:ln=35:so=32:pi=33:ex=31:bd=46;34:cd=43;34:su=41;30:sg=46;30:tw=42;30:ow=43;30'
zstyle ':completion:*' list-colors 'di=36' 'ln=35' 'so=32' 'ex=31' 'bd=46;34' 'cd=43;34'

# ------------------------------------
# Command History
# ------------------------------------
HISTFILE=~/.zsh_history
HISTSIZE=100000
SAVEHIST=100000

# 重複した履歴は除く（連続するものだけでなく、すべての重複）
setopt hist_ignore_all_dups

# コンソールの他のタブや、他のウィンドウとコマンド入力履歴を共有
setopt share_history

# ------------------------------------
# Key bindings
# ------------------------------------
bindkey -e

# 入力途中の文字列で履歴を前方一致検索する
autoload history-search-end
zle -N history-beginning-search-backward-end history-search-end
zle -N history-beginning-search-forward-end history-search-end
bindkey "^P" history-beginning-search-backward-end
bindkey "^N" history-beginning-search-forward-end

# ------------------------------------
# cd
# ------------------------------------
setopt auto_pushd
setopt auto_cd

# 入力コマンドが間違ってたら修正してくれる
setopt correct

# ------------------------------------
# Prompt
# ------------------------------------
# 変数展開・コマンド置換・算術演算を実行する
setopt prompt_subst
# 「%」文字から始まる置換機能を有効にする
setopt prompt_percent
# コピペしやすいようにコマンド実行後は右プロンプトを消す
setopt transient_rprompt

# vcs (主に git)
autoload -Uz vcs_info
zstyle ':vcs_info:*' formats '[%b]'
zstyle ':vcs_info:*' actionformats '[%b|%a]'

_vcs_precmd () { vcs_info }
autoload -Uz add-zsh-hook
add-zsh-hook precmd _vcs_precmd
PROMPT='%F{cyan}${HOST}%f %~ %F{yellow}${vcs_info_msg_0_}%f
$ '
RPROMPT=''

# vim から一時的にシェルに出たときにプロンプトに出す
[[ -n "$VIMRUNTIME" ]] && \
  PROMPT="%{${bg[black]}${fg[green]}%}(vim)%{${reset_color}%} $PROMPT"

# ------------------------------------
# 分けた設定
# ------------------------------------
source "$ZSH_CONFIG_DIR/alias.zsh"
source "$ZSH_CONFIG_DIR/functions.zsh"
source "$ZSH_CONFIG_DIR/fzf.zsh"

# zoxide (smart cd)
(( $+commands[zoxide] )) && eval "$(zoxide init zsh)"

# ------------------------------------
# マシン固有・仕事用の設定 (追跡しない)
# ------------------------------------
[[ -f ~/.localrc ]] && source ~/.localrc

# direnv: repo の .envrc (nix devShell など) を cd 時に読み込む。
# PATH を触る設定 (~/.localrc を含む) より後に置く。
(( $+commands[direnv] )) && eval "$(direnv hook zsh)"
