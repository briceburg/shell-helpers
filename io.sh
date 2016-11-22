#
# lib.d/helpers/git.sh for dex -*- shell-script -*-
#

error(){
  [ -z "$1" ] && set -- "general exception. halting..."

  printf "\e[31m%b\n\e[0m" "$@" >&2
  exit ${__error_code:-1}
}

error_noent() {
  __error_code=127
  error "$@"
}

error_perms() {
  __error_code=126
  error "$@"
}

error_exception() {
  __error_code=2
  error "$@"
}


log(){
  printf "\e[33m%b\n\e[0m" "$@" >&2
}

warn(){
  printf "\e[35m%b\n\e[0m" "$@" >&2
}

# prompt_echo - helper for assigning variable values
# usage: prompt_echo <prompt> [default fallback]
# example:
#   name=$(prompt_echo "name to encrypt")
#   port=$(prompt_echo "port [8080]" 8080)
prompt_echo() {
  local input=
  while ((i++)) ; [ -z "$input" ]; do
    if [ -t 0 ]; then
      # user input
      read -r -p "  ${1:-response} : " input </dev/tty
    else
      # piped input
      read input
    fi
    [[ -n "$2" && -z "$input" ]] && input="$2"
    [ -z "$input" ] && printf "  \033[31m%s\033[0m\n" "invalid input" >&2
  done
  echo "$input"
}

prompt_confirm() {
  while true; do
    case $(prompt_echo "${@:-Continue?} [y/n]") in
      [yY]) return 0 ;;
      [nN]) return 1 ;;
      *) printf "  \033[31m%s\033[0m\n" "invalid input" >&2
    esac
  done
}

# line_in_file : ensure a line exists in a file
###############################################
#
# usage: line_in_file "file" "match" "line"
#    ex: line_in_file "varsfile" "^VARNAME=.*$" "VARNAME=value"
#
line_in_file(){
  local delim=${4:-"|"}
  grep -q "$2" $1 2>/dev/null && sed_inplace $1 "s$delim$2$delim$3$delim" || echo $3 >> $1
}
