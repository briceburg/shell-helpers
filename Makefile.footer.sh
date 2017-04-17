#
# allow usage as a shebang
#
if [[ "$0" = "${BASH_SOURCE[0]}" && ! $# -eq 0 ]]; then
  __shparent="$1"
  shift
  . "$__shparent"
fi
