#!/bin/bash
# Notification フック: Claude が入力や許可を待っているときに macOS のデスクトップ通知を出す。
# 標準入力のフック JSON から message と cwd を取り、どのリポジトリのセッションかをタイトルに出す。
input=$(cat)
message=$(printf '%s' "$input" | jq -r '.message // "入力を待っています"')
project=$(basename "$(printf '%s' "$input" | jq -r '.cwd // empty')")

# 文字列は argv で渡し、AppleScript に埋め込まない（引用符でスクリプトが壊れないように）
osascript - "Claude Code${project:+ — $project}" "$message" <<'APPLESCRIPT' >/dev/null 2>&1
on run argv
  display notification (item 2 of argv) with title (item 1 of argv) sound name "Glass"
end run
APPLESCRIPT
exit 0
