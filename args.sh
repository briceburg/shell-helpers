# shell-helpers - unfurl your arguments
#   https://github.com/briceburg/shell-helpers


# args/normalize - normalize POSIX short and long flags for easier parsing.
#                  flags are assigned to a global array named __argv
#
# usage: args/normalize <fargs> [args...]
#   fargs: string of short flags requiring an argument.
#   args : flag string(s) to normalize, typically passed as "$@"
#
# examples:
#   args/normalize "" -abc
#     => -a -b -c
#   args/normalize "om" -abcoo.txt --def=jam -mz
#     => -a -b -c -o o.txt --def jam -m z"
#
# script usage example:
#    main(){
#      args/normalize "om" "$@"
#      set -- "${__argv[@]}"
#      while [ $# -ne 0 ]; do
#        case "$1" in
#          -h|--help)
#            die/help ;;
#          -t|--target)
#            __target="$2" ; shift ;;
#          ...
#        esac
#        shift
#      done
#      ...
#    }
#    main "$@"
#
args/normalize(){
  __argv=()

  local fargs="$1" ; shift || true
  local passthru=false
  local flag
  local p

  for arg; do
    if ! $passthru && [ "-" = "${arg:0:1}" ]; then
      if [ "--" = "$arg" ]; then
        passthru=true
        __argv+=( "$arg" )
      elif [ "--" = ${arg:0:2} ]; then
        # double-dash "long" flags..., handle --flag=value case.
        __argv+=( "${arg%%=*}" )
        [[ "$arg" == *"="* ]] && __argv+=( "${arg#*=}" )
      else
        # single-dash "short" flags..., handle -ooutput.txt case
        for (( p=1; p < ${#arg}; p++ )) do
          flag="${arg:$p:1}"
          __argv+=( "-$flag" )
          if [[ "$fargs" == *"$flag"* ]]; then
            ((p++))
            [ -n "${arg:$p}" ] && __argv+=( "${arg:$p}" )
            break
          fi
        done
      fi
    else
      # non-flag encountered, or passthru is set.
      __argv+=( "$arg" )
    fi
  done
  return 0
}

# args/normalize_flags_first - like args/normalize, but prioritizes flags.
#
# usage: args/normalize <fargs> [args...]
#   fargs: string of short flags requiring an argument.
#   args : flag string(s) to normalize, typically passed as "$@"
#
# examples:
#   normalize_flags_first "" -abc command -xyz otro
#     => -a -b -c -x -y -z command otro
#   normalize_flags_first "" -abc command -xyz otro -- -def xyz
#     => -a -b -c -x -y -z command otro -- -def xyz
args/normalize_flags_first(){
  local fargs="$1" ; shift || true
  local passthru=false
  local flags=()
  local cmds=()

  args/normalize "$fargs" "$@"
  for arg in "${__argv[@]}"; do
    [ "--" = "$arg" ] && passthru=true
    if $passthru || [ ! "-" = ${arg:0:1} ]; then
      cmds+=( "$arg" )
      continue
    fi
    flags+=( "$arg" )
  done

  __argv=( "${flags[@]}" "${cmds[@]}" )
}

args/unknown(){
  p/shout "\e[1m$1\e[21m is an unrecognized ${2:-argument}"
  die/help 10
}
