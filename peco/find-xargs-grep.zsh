function fxg() {
  if [ $# -ne 3 ]; then
    echo "Ex: fxg \".\" \"py\" \"Item\""
    return
  fi
  vim $(find "$1" -type f -name "*.$2" | xargs grep -n "$3" | peco --query "$LBUFFER" | awk -F : '{print "-c " $2 " " $1}')
}
