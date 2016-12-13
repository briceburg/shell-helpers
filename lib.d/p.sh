# shell-helpers - taming of the print
#   https://github.com/briceburg/shell-helpers

#
# printf outputs
#

p/error(){
  p/blockquote "\e[31m" "✖ " "$@" >&2
}

p/success(){
  p/blockquote "\e[32m" "✔ " "$@" >&2
}

p/notice(){
  p/blockquote "\e[33m" "➜ " "$@" >&2
}

p/log(){
  p/blockquote "\e[34m" "• " "$@" >&2
}

p/warn(){
  p/blockquote "\e[35m" "⚡ " "$@" >&2
}

p/comment(){
  printf '\e[90m# %b\n\e[0m' "$@" >&2
}

p/shout(){
  printf '\e[33m⚡\n⚡ %b\n⚡\n\e[0m' "$@" >&2
}

p/header(){
  printf "========== \e[1m$1\e[21m ==========\n"
}

p/blockquote(){
  local escape="$1" ; shift || true
  local prefix="$1" ; shift || true
  local indent="$(printf '%*s' ${#prefix})"

  while [ $# -ne 0 ]; do
    printf "$escape$prefix%b\n\e[0m" "$1"
    prefix="$indent"
    shift
  done
}
