# Move to branch selected by fzf
function fzf-ghq() {
  local selected_dir=$(ghq list | fzf --query "$LBUFFER")
  if [ -n "$selected_dir" ]; then
    BUFFER="cd ${GOPATH}/src/${selected_dir}"
    zle accept-line
  fi
  zle clear-screen
}
zle -N fzf-ghq
