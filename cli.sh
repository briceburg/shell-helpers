#
# lib.d/helpers/cli.sh for dex -*- shell-script -*-
#

# normalize_flags - normalize POSIX short and long flags for easier parsing
# usage: normalize_flags <fargs> [<flags>...]
#   <fargs>: string of short flags requiring an argument.
#   <flags>: flag string(s) to normalize, typically passed as "$@"
# examples:
#   normalize_flags "" "-abc"
#     => -a -b -c
#   normalize_flags "om" "-abcooutput.txt" "--def=jam" "-mz"
#     => -a -b -c -o output.txt --def jam -m z"
#   normalize_flags "om" "-abcooutput.txt" "--def=jam" "-mz" "--" "-abcx" "-my"
#     => -a -b -c -o output.txt --def jam -m z -- -abcx -my"
normalize_flags(){
  local fargs="$1"
  local passthru=false
  local output=""
  shift
  for arg in $@; do
    if $passthru; then
      output+=" $arg"
    elif [ "--" = "$arg" ]; then
      passthru=true
      output+=" --"
    elif [ "--" = ${arg:0:2} ]; then
      output+=" ${arg%=*}"
      [[ "$arg" == *"="* ]] && output+=" ${arg#*=}"
    elif [ "-" = ${arg:0:1} ]; then
      local p=1
      while ((p++)); read -n1 flag; do
        [ -z "$flag" ] || output+=" -$flag"
        if [[ "$fargs" == *"$flag"* ]]; then
          output+=" ${arg:$p}"
          break
        fi
      done < <(echo -n "${arg:1}")
    else
      output+=" $arg"
    fi
  done
  printf "%s" "${output:1}"
}

# normalize_flags_first - like normalize_flags, but outputs flags first.
# usage: normalize_flags <fargs> [<flags>...]
#   <fargs>: string of short flags requiring an argument.
#   <flags>: flag string(s) to normalize, typically passed as "$@"
# examples:
#   normalize_flags_first "" "-abc command -xyz otro"
#     => -a -b -c -x -y -z command otro
#   normalize_flags_first "" "-abc command -xyz otro -- -def xyz"
#     => -a -b -c -x -y -z command otro -- -def xyz

normalize_flags_first(){
  local fargs="$1"
  local output=""
  local cmdstr=""
  local passthru=false
  shift
  for arg in $(normalize_flags "$fargs" "$@"); do
    [ "--" = "$arg" ] && passthru=true
    if $passthru || [ ! "-" = ${arg:0:1} ]; then
      cmdstr+=" $arg"
      continue
    fi
    output+=" $arg"
  done
  printf "%s%s" "${output:1}" "$cmdstr"
}


#  get_cmd: Prints the first-found matching command. Uses __cmd_prefix to
#             prefer the "prefixed" version(s) of passed commands.
#  return: 1 if no suitable command found, else command is prints to stdout.
#  usage: get_cmd <command> [<commands>...]
#  example:
#   cmd=$(get_cmd dansible ansible) || error "missing ansible!"
#     => prefers ${__cmd_prefix}dansible ${__cmd_prefix}ansible dansible ansible
get_cmd(){
  local cmd=
  for cmd in "$@"; do
    type ${__cmd_prefix}${cmd} &>/dev/null && {
      echo "${__cmd_prefix}${cmd}"
      return 0
    }
  done

  for cmd in "$@"; do
    type $cmd &>/dev/null && {
      echo "$cmd"
      return 0
    }
  done

  return 1
}

# set_cmd: loops through a list of commands, prefering the "prefixed" version(s)
#   sets `__cmd` to first-found matching command. uses __cmd_prefix
#   returns 1 if no suitable command found.
# @TODO -- deprecate in favor of get_cmd
set_cmd(){
  __cmd=$(get_cmd "$@") || return 1
}


runfunc(){
  [ "$(type -t $1)" = "function" ] || error \
    "$1 is not a valid runfunc target"

  eval "$@"
}

unrecognized_flag(){
  printf "\n\n$1 is an unrecognized flag\n\n"
  display_help 2
}

unrecognized_arg(){

  if [ $__cmd = "main" ]; then
    printf "\n\n$1 is an unrecognized command\n\n"
  else
    printf "\n\n$1 is an unrecognized argument\n\n"
  fi

  display_help 2
}
