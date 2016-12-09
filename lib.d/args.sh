# shell-helpers - unfurl your arguments
#   https://github.com/briceburg/shell-helpers


# args/normalize - normalize POSIX short and long flags for easier parsing
# usage: args/normalize <fargs> [<flags>...]
#   <fargs>: string of short flags requiring an argument.
#   <flags>: flag string(s) to normalize, typically passed as "$@"
# examples:
#   args/normalize "" "-abc"
#     => -a -b -c
#   args/normalize "om" "-abcooutput.txt" "--def=jam" "-mz"
#     => -a -b -c -o output.txt --def jam -m z"
#   args/normalize "om" "-abcooutput.txt" "--def=jam" "-mz" "--" "-abcx" "-my"
#     => -a -b -c -o output.txt --def jam -m z -- -abcx -my"
args/normalize(){
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

# args/normalize_flags_first - like args/, but outputs flags first.
# usage: args/normalize_flags_first <fargs> [<flags>...]
#   <fargs>: string of short flags requiring an argument.
#   <flags>: flag string(s) to normalize, typically passed as "$@"
# examples:
#   normalize_flags_first "" "-abc command -xyz otro"
#     => -a -b -c -x -y -z command otro
#   normalize_flags_first "" "-abc command -xyz otro -- -def xyz"
#     => -a -b -c -x -y -z command otro -- -def xyz

args/normalize_flags_first(){
  local fargs="$1"
  local output=""
  local cmdstr=""
  local passthru=false
  shift
  for arg in $(args/normalize "$fargs" "$@"); do
    [ "--" = "$arg" ] && passthru=true
    if $passthru || [ ! "-" = ${arg:0:1} ]; then
      cmdstr+=" $arg"
      continue
    fi
    output+=" $arg"
  done
  printf "%s%s" "${output:1}" "$cmdstr"
}

args/unknown(){
  p/shout "\e[1m$1\e[21m is an unrecognized ${2:-argument}"
  p/help 10
}
