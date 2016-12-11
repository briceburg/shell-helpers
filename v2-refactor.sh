#!/usr/bin/env bash

# helper for refactoring to v2

ignores=(
  CHANGELOG.md
  v2-refactor.sh
  tests/bats/tmp
  common/lib/shell-helpers.sh
)

funcs=(
  docker/deactivate_machine@docker/deactivate-machine
  docker/safe_name@docker/get/safe-name
  find/dockerfiles@docker/find/dockerfiles
  get/dockerfile-tag@docker/get/dockerfile-tag
  get/docker-name@docker/get/repotag
  io/@p/
  find/cmd@get/cmd
  find/gid_from_name@get/gid_from_name
  find/gid_from_path@get/gid_from_path
  find/dockerfile-tag@get/dockerfile-tag
  prompt\ \"@prompt/user
)
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

prompt/confirm() {
  while true; do
    case $(prompt/user "${@:-Continue?} [y/n]") in
      [yY]) return 0 ;;
      [nN]) return 1 ;;
      *) p/warn "invalid input"
    esac
  done
}


p/notice(){
  p/blockquote "\e[33m" "➜ " "$@" >&2
}

p/blockquote(){
  local escape="$1" ; shift
  local prefix="$1" ; shift
  local indent="$(printf '%*s' ${#prefix})"

  while [ $# -ne 0 ]; do
    printf "$escape$prefix%b\n\e[0m" "$1"
    prefix="$indent"
    shift
  done
}

for fn in "${funcs[@]}"; do
  IFS="@" read -r fn replace <<< "$fn"
  flags=
  for ignore in "${ignores[@]}"; do
    flags+=" --ignore $ignore"
  done

  p/notice "working with $fn  [use $replace as replacement]"
  ag $flags "$fn"
  while prompt/confirm "re-print $fn matches (y) or continue (n)" ; do
    p/notice "working with $fn  [use $replace as replacement]"
    ag $flags "$fn"
  done
done
