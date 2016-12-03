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


#
# user input
#


# io/prompt - prompt for input, useful for assigning variiable values
# usage: io/prompt <prompt message> [fallback value*]
#   * uses fallback value if no input recieved or a tty is not available
# example:
#   name=$(io/prompt  "name to encrypt")
#   port=$(io/prompt  "port" 8080)
io/prompt(){
  local input=
  local prompt="${1:-value}"
  local default="$2"

  [ -z "$default" ] || prompt+=" [$default]"

  while ((i++)) ; [ -z "$input" ]; do
    if [ -t 0 ]; then
      # user input
      read -r -p "  $prompt : " input </dev/tty
    else
      # piped input
      read input
    fi
    [[ -n "$default" && -z "$input" ]] && input="$default"
    [ -z "$input" ] && io/warn "invalid input"
  done
  echo "$input"
}

# io/confirm - pause before continuing
# usage: io/confirm [message]
# examples:
#  io/confirm "really?" || exit 0
io/confirm() {
  while true; do
    case $(io/prompt "${@:-Continue?} [y/n]") in
      [yY]) return 0 ;;
      [nN]) return 1 ;;
      *) io/warn "invalid input"
    esac
  done
}

# prepare/overwrite - prepare a path to be overwritten
prepare/overwrite(){
  local target="$1"
  local force=${__force:-false}
  if [[ -e "$target" && $force ]]; then
    io/confirm "overwrite $target ?" || return 1
  fi
  rm -rf "$target"
}
