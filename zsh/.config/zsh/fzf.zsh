# ====================================
# fzf
# ====================================
(( $+commands[fzf] )) || return 0

# fzf 本体のキーバインドと補完 (fzf 0.48 以降)。
#   ^R: 履歴検索 / ^T: ファイル選択 / Esc-c: ディレクトリ移動 / **<Tab>: 補完
source <(fzf --zsh)

# ghq で管理しているリポジトリへ移動する (zi に近い見た目)
function fzf-ghq() {
  local root selected_dir
  root=$(ghq root)
  selected_dir=$(ghq list | fzf \
    --height=40% \
    --layout=reverse \
    --border \
    --prompt="repo> " \
    --preview="eza --tree --level=2 --icons --color=always ${root}/{}" \
    --preview-window=right:50% \
    --query "$LBUFFER")
  if [ -n "$selected_dir" ]; then
    BUFFER="cd ${root}/${selected_dir}"
    zle accept-line
  fi
  zle clear-screen
}
zle -N fzf-ghq

# ブランチを選んで checkout する (リモートブランチはローカル名にする)
function fzf-git-branch-checkout() {
  local selected_branch_name="$(git branch -a | fzf | tr -d ' ')"
  case "$selected_branch_name" in
    *-\>* )
      selected_branch_name="$(echo ${selected_branch_name} | perl -ne 's/^.*->(.*?)\/(.*)$/\2/;print')";;
    remotes* )
      selected_branch_name="$(echo ${selected_branch_name} | perl -ne 's/^.*?remotes\/(.*?)\/(.*)$/\2/;print')";;
  esac
  if [ -n "$selected_branch_name" ]; then
    BUFFER="git checkout ${selected_branch_name}"
    zle accept-line
  fi
  zle clear-screen
}
zle -N fzf-git-branch-checkout

bindkey '^j' fzf-ghq
bindkey '^g' fzf-git-branch-checkout
