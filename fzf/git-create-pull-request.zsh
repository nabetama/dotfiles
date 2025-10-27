function gpr() {
  local st local_branch

  gdiff
  local_branch=`git symbolic-ref --short HEAD`
  # if [[ $# -gt 0 && $1 == "safe" ]]; then
  echo "Would you push to origin/${local_branch} and create pull request? yes/no"
  read answer
  case $answer in
    "no" )
      echo "stopped process."
      return
  esac
  st=`git status 2> /dev/null`
  if [[ -n `echo "$st" | egrep "^nothing to commit"` ]]; then
    echo 'working directory is clean'
  else
    echo 'should be clean working directory!!'
    echo 'stopped process'
    return
  fi
  # fi
  url=`git remote -v | sed -e '2!d'`
  url="https://${url[12, -12]}"
  push_url=`echo ${url} | sed 's/:/\//2'`
  echo "pull request to: ${push_url}"
  open "${push_url}/compare/main...${local_branch}"
}
