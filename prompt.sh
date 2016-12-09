# prompt/user - prompt for input, useful for assigning variiable values
# usage: prompt/user <prompt message> [fallback value*]
#   * uses fallback value if no input recieved or a tty is not available
# example:
#   name=$(prompt/user "name to encrypt")
#   port=$(prompt/user "port" 8080)
prompt/user(){
  local input=
  local prompt="${1:-value}"
  local default="$2"
  [ -z "$default" ] || prompt+=" [$default]"

  # convert escape sequences in prompt to ansi codes
  prompt="$(echo -e -n "$prompt : ")"

  while [ -z "$input" ]; do
    if [ -t 0 ]; then
      # user input
      read -p "$prompt" input </dev/tty
    else
      # piped input
      read input
    fi

    [[ -n "$default" && -z "$input" ]] && input="$default"
    [ -z "$input" ] && p/warn "invalid input"

  done
  echo "$input"
}

# prompt/confirm - pause before continuing
# usage: prompt/confirm [message]
# examples:
#  prompt/confirm "really?" || exit 0
prompt/confirm() {
  while true; do
    case $(prompt/user "${@:-Continue?} [y/n]") in
      [yY]) return 0 ;;
      [nN]) return 1 ;;
      *) p/warn "invalid input"
    esac
  done
}

# prompt/overwrite - prompt before removing a path
prompt/overwrite(){
  local target="$1"
  local prompt="${2:-overwrite $target ?}"
  local force=${__force:-false}
  [ ! -e "$target" ] || {
    $force || prompt/confirm "$prompt" || return 1
    rm -rf "$target"
  }
}
