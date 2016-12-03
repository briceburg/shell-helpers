# prompt - prompt for input, useful for assigning variiable values
# usage: prompt <prompt message> [fallback value*]
#   * uses fallback value if no input recieved or a tty is not available
# example:
#   name=$(prompt  "name to encrypt")
#   port=$(prompt  "port" 8080)
prompt(){
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
    [ -z "$input" ] && io/warn "invalid input"

  done
  echo "$input"
}

# prompt/confirm - pause before continuing
# usage: prompt/confirm [message]
# examples:
#  prompt/confirm "really?" || exit 0
prompt/confirm() {
  while true; do
    case $(prompt "${@:-Continue?} [y/n]") in
      [yY]) return 0 ;;
      [nN]) return 1 ;;
      *) io/warn "invalid input"
    esac
  done
}

# prompt/overwrite - prompt before removing a path
prompt/overwrite(){
  local target="$1"
  local prompt="${2:-overwrite $target ?}"
  local force=${__force:-false}
  if [[ -e "$target" && ! $force ]]; then
    prompt/confirm "$prompt" || return 1
  fi
  rm -rf "$target"
}
