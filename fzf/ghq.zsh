# Move to ghq repo selected by fzf (zi-like UI)
function fzf-ghq() {
  local selected_dir=$(ghq list | fzf \
    --height=40% \
    --layout=reverse \
    --border \
    --prompt="repo> " \
    --preview="eza --tree --level=2 --icons --color=always ${GOPATH}/src/{}" \
    --preview-window=right:50% \
    --query "$LBUFFER")
  if [ -n "$selected_dir" ]; then
    BUFFER="cd ${GOPATH}/src/${selected_dir}"
    zle accept-line
  fi
  zle clear-screen
}
zle -N fzf-ghq
