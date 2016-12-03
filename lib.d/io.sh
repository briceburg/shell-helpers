# shell-helpers - you put your left foot in, your right foot out.
#   https://github.com/briceburg/shell-helpers

#
# printf outputs
#

io/error(){
  io/blockquote "\e[31m" "✖ " "$@" >&2
}

io/success(){
  io/blockquote "\e[32m" "✔ " "$@" >&2
}

io/notice(){
  io/blockquote "\e[33m" "➜ " "$@" >&2
}

io/log(){
  io/blockquote "\e[34m" "• " "$@" >&2
}

io/warn(){
  io/blockquote "\e[35m" "⚡ " "$@" >&2
}

io/comment(){
  printf '\e[90m# %b\n\e[0m' "$@" >&2
}

io/shout(){
  printf '\e[33m⚡\n⚡ %b\n⚡\n\e[0m' "$@" >&2
}

io/header(){
  printf "========== \e[1m$1\e[21m ==========\n"
}

io/blockquote(){
  local escape="$1" ; shift
  local prefix="$1" ; shift
  local indent="$(printf '%*s' ${#prefix})"

  while [ $# -ne 0 ]; do
    printf "$escape$prefix%b\n\e[0m" "$1"
    prefix="$indent"
    shift
  done
}
