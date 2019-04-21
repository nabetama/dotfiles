function ggc() {
  git gc --aggressive
  git prune
  rm -rf .git/refs/original
}
