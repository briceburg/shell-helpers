# shell-helpers - the art of killing your script
#   https://github.com/briceburg/shell-helpers

die(){
  p/error "${@:-halting...}"
  exit ${__exit_code:-1}
}

die/noent(){
  __exit_code=127
  die "$@"
}

die/perms(){
  __exit_code=126
  die "$@"
}

die/exception() {
  __exit_code=2
  die "$@"
}

# die/help <exit code> <message text...>
#  calls p/help_[cmd] function. (e.g. calls p/help_main from main() fn)
#  help messages are prefixed w/ any message text, such as warnings about
#  about missing arguments.
die/help(){
  local status="$1" ; shift

  [ -z "$cmd" ] && {
    # functions starting with main_ indicate command name.
    # attempt to auto-detect by examining call stack
    local fn
    for fn in "${FUNCNAME[@]}"; do
      [ "main" = "${fn:0:4}" ] && {
        cmd="${fn//main_/}"
        break
      }
    done
  }

  is/fn "p/help_$cmd" || die/exception "missing p/help_$cmd" \
    "is $cmd a valid command?"

  [ -z "$@" ] || p/shout "$@"

  p/help_$cmd >&2
  exit $status
}

# example p/help_<cmd> function
# p/help_cmd(){
#   cat <<-EOF
#
# util - because you need util
#
# Usage:
#   util cmd [options...] <command>
#
# Options:
#   -h|--help
#     Displays help
#
#   -d|--defaults
#     Temporarily resets the current environment and prints default values
#
# Commands:
#   vars [-d|--defaults] [--] [list...]
#     Prints configuration variables as evaluable output
#
# EOF
# }
