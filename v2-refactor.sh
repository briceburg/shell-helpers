#!/usr/bin/env bash

# helper for refactoring to v2

ignores=(
  CHANGELOG.md
  v2-refactor.sh
  tests/bats/tmp
  common/lib/shell-helpers.sh
)

funcs=(
  __error_code@__exit_code
  __local_docker@docker/local
  __local_docker_compose@docker/local-compose
  __deactivate_machine@docker/deactivate_machine
  clone_or_pull@git/clone_or_pull
  docker_safe_name@docker/safe_name
  error@die
  error_noent@die/noent
  error_perms@die/perms
  error_exception@die/exception
  fetch-url@network/fetch
  get_cmd@find/cmd
  get_group_id@find/gid_from_name
  is_dirty@is/dirty
  line_in_file@file/interpolate
  log@io/log
  normalize_flags@args/normalize
  normalize_flags_first@args/normalize_flags_first
  prompt_confirm@io/prompt_confirm
  prompt_echo@io/prompt
  runfunc@shell/execfn
  set_cmd@_deprecated_
  sed_inplace@file/sed_inplace
  shell_detect@shell/detect
  shell_eval_export@shell/evaluable_export
  shell_eval_message@shell/evaluable_entrypoint
  unrecognized_flag@args/unknown
  unrecognized_arg@args/unknown
  warn@io/warn
)


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

# io/prompt_confirm - pause before continuing
# usage: io/prompt_confirm [message]
# examples:
#  io/prompt_confirm "really?" || exit 0
io/prompt_confirm() {
  while true; do
    case $(io/prompt "${@:-Continue?} [y/n]") in
      [yY]) return 0 ;;
      [nN]) return 1 ;;
      *) io/warn "invalid input"
    esac
  done
}

io/notice(){
  io/blockquote "\e[33m" "➜ " "$@" >&2
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

for fn in "${funcs[@]}"; do
  IFS="@" read -r fn replace <<< "$fn"
  flags=
  for ignore in "${ignores[@]}"; do
    flags+=" --ignore $ignore"
  done

  io/notice "working with $fn  [use $replace as replacement]"
  ag $flags "$fn"
  while io/prompt_confirm "re-print $fn matches (y) or continue (n)" ; do
    io/notice "working with $fn  [use $replace as replacement]"
    ag $flags "$fn"
  done
done
