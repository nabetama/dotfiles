# .zshrc

# completion
# 補完. インストール時のfunctionsをつかう
fpath=(/usr/local/share/zsh/functions ${fpath})
autoload -Uz compinit -C && compinit -C

# Asking
zstyle ':completion:*' verbose yes
zstyle ':completion:*:descriptions' format '%B%d%b'
zstyle ':completion:*:default' menu select=1

# Completion candidate displayed compactly
# 補完候補コンパクトに表示
setopt list_packed

# Color a file completion candidate
# ファイル補完候補に色を付ける
zstyle ':completion:*' list-colorsP

export LSCOLORS=gxfxcxdxbxegedabagacad
export LS_COLORS='di=36:ln=35:so=32:pi=33:ex=31:bd=46;34:cd=43;34:su=41;30:sg=46;30:tw=42;30:ow=43;30'
zstyle ':completion:*' list-colors 'di=36' 'ln=35' 'so=32' 'ex=31' 'bd=46;34' 'cd=43;34'

# ------------------------------------
# Command History
# ------------------------------------
HISTFILE=~/.zsh_history
HISTSIZE=100000
SAVEHIST=100000

# Exclude duplicate history (all duplicates, not just consecutive ones)
# 重複した履歴は除く（連続するものだけでなく、すべての重複）
setopt hist_ignore_all_dups

# Share command input history with other tabs, consoles and other windows
# コンソールの他のタブや、他のウィンドウとコマンド入力履歴を共有
setopt share_history

# Activate history completion on input.
# 入力途中の履歴補完を有効化する
autoload history-search-end
zle -N history-beginning-search-backward-end history-search-end
zle -N history-beginning-search-forward-end history-search-end
bindkey "^P" history-beginning-search-backward-end
bindkey "^N" history-beginning-search-forward-end

# ------------------------------------
# emacs keybind
# ------------------------------------
bindkey -e

# ------------------------------------
# cd
# ------------------------------------
setopt auto_pushd
# that you can get dirs list by cd -[tab]
setopt auto_cd

# ------------------------------------
# Corrected if the entered command name is incorrect
# 入力コマンドが間違ってたら修正してくれる
# ------------------------------------
setopt correct


# ------------------------------------
# Prompt
# ------------------------------------
# Execute variable expansion / command substitution / arithmetic operation
# 変数展開・コマンド置換・算術演算を実行する。
setopt prompt_subst
# Enable replacement function starting with "%"
# 「%」文字から始まる置換機能を有効にする。
setopt prompt_percent
# To make it easy to copy, delete the right prompt after executing the command
# コピペしやすいようにコマンド実行後は右プロンプトを消す。
setopt transient_rprompt

# vcs(mainly git)
autoload -Uz vcs_info
zstyle ':vcs_info:*' formats '[%b]'
zstyle ':vcs_info:*' actionformats '[%b|%a]'

_vcs_precmd () { vcs_info }
autoload -Uz add-zsh-hook
add-zsh-hook precmd _vcs_precmd 
PROMPT='%F{cyan}${HOST}%f %~ %F{yellow}${vcs_info_msg_0_}%f
$ '
RPROMPT=''

# Displayed in prompt when temporarily leaving vim
[[ -n "$VIMRUNTIME" ]] && \
  PROMPT="%{${bg[black]}${fg[green]}%}(vim)%{${reset_color}%} $PROMPT"

# ------------------------------------
# Read settings
# ------------------------------------
[ -f ~/.dotfiles/zsh/git/contrib/completion/git-completion.zsh ] && \
	 zstyle ':completion:*:*:git:*' script ~/.dotfiles/zsh/git/contrib/completion/git-completion.zsh
[ -f ~/.dotfiles/zsh/global    ] && source ~/.dotfiles/zsh/global
[ -f ~/.dotfiles/zsh/alias     ] && source ~/.dotfiles/zsh/alias
[ -f ~/.dotfiles/zsh/functions ] && source ~/.dotfiles/zsh/functions
[ -f ~/.dotfiles/zsh/helper/http_status ] && source ~/.dotfiles/zsh/helper/http_status

# ------------------------------------
# Read local settings
# ------------------------------------
[ -f ~/.localrc ] && source ~/.localrc

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# for Claude Code
export CLAUDE_CODE_DISABLE_NONESSENTIAL_TRAFFIC=1

#THIS MUST BE AT THE END OF THE FILE FOR SDKMAN TO WORK!!!
export SDKMAN_DIR="/Users/nabetama/.sdkman"
[[ -s "/Users/nabetama/.sdkman/bin/sdkman-init.sh" ]] && source "/Users/nabetama/.sdkman/bin/sdkman-init.sh"
# The following lines have been added by Docker Desktop to enable Docker CLI completions.
fpath=(/Users/nabetama/.docker/completions $fpath)
autoload -Uz compinit
compinit
# End of Docker CLI completions

# pnpm
export PNPM_HOME="/Users/nabetama/Library/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac
# pnpm end
export PATH="$HOME/.local/bin:$PATH"
