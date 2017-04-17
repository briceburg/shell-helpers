#
# allow usage as a shebang
#
[ "$0" = "${BASH_SOURCE[0]}" ] && [ ! $# -eq 0 ] && {
  __shparent="$1"
  shift
  . "$__shparent"
}
