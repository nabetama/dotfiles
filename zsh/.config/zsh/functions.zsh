# ====================================
# 関数
# ====================================
# Execute after moving directory
# ディレクトリを移動したら実行する
chpwd() {
    # stdout が端末でない場合 (Claude Code 等のエージェントが実行する Bash) は
    # 出力がコンテキストを消費するだけなので何も出さない
    [[ -t 1 ]] || return 0
    ls_abbrev
    show_git_status
}

# There are too many files to display with ls
# lsで表示するにはファイルが多すぎる
ls_abbrev() {
    # -C : Force multi-column output.
    # -F : Append indicator (one of */=>@|) to entries.
    local cmd_ls='ls'
    local -a opt_ls
    opt_ls=('-CF' '--color=always')
    case "${OSTYPE}" in
        freebsd*|darwin*)
            if type gls > /dev/null 2>&1; then
                cmd_ls='gls'
            else
                # -G : Enable colorized output.
                opt_ls=('-aCFG')
            fi
            ;;
    esac

    local ls_result
    ls_result=$(CLICOLOR_FORCE=1 COLUMNS=$COLUMNS command $cmd_ls ${opt_ls[@]} | sed $'/^\e\[[0-9;]*m$/d')

    local ls_lines=$(echo "$ls_result" | wc -l | tr -d ' ')

    if [ $ls_lines -gt 5 ]; then
        echo "$ls_result" | head -n 3
    else
        echo "$ls_result"
    fi
}

function show_git_status() {
    if [ "$(git rev-parse --is-inside-work-tree 2> /dev/null)" = 'true' ]; then
        echo
        git status -sb
    fi
    return 0
}

function do_enter() {
    if [ -n "$BUFFER" ]; then
        zle accept-line
        return 0
    fi
    echo
    ls_abbrev
    if [ "$(git rev-parse --is-inside-work-tree 2> /dev/null)" = 'true' ]; then
        echo
        git status -sb
        echo
    fi
    zle reset-prompt
    return 0
}

zle -N do_enter
bindkey '^m' do_enter

# ------------------------------------
# Dev process management
# ------------------------------------
# Kill process(es) holding a given TCP port (default: 8080)
# Usage: killport [port]
function killport() {
    local port="${1:-8080}"
    local pids
    pids=$(lsof -ti ":$port" 2>/dev/null)
    if [ -z "$pids" ]; then
        echo "no process on port $port"
        return 0
    fi
    echo "killing: $pids"
    echo "$pids" | xargs kill
}

# ------------------------------------
# Pull request
# ------------------------------------
# 差分を見せてから、今のブランチと main の比較ページをブラウザで開く
# Usage: gpr
function gpr() {
  local st local_branch

  gdiff
  local_branch=`git symbolic-ref --short HEAD`
  echo "Would you push to origin/${local_branch} and create pull request? yes/no"
  read answer
  case $answer in
    "no" )
      echo "stopped process."
      return
  esac
  st=`git status 2> /dev/null`
  if [[ -n `echo "$st" | grep -E "^nothing to commit"` ]]; then
    echo 'working directory is clean'
  else
    echo 'should be clean working directory!!'
    echo 'stopped process'
    return
  fi
  url=`git remote -v | sed -e '2!d'`
  url="https://${url[12, -12]}"
  push_url=`echo ${url} | sed 's/:/\//2'`
  echo "pull request to: ${push_url}"
  open "${push_url}/compare/main...${local_branch}"
}
