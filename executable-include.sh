#
# allows you to use shell-helpers as a shebang, e.g.
#   cp shell-helpers /usr/local/bin/shell-helpers,
#    then start your script with following;
#    #!/usr/bin/env shell-helpers
#
if [[ "$0" = "${BASH_SOURCE[0]}" && ! $# -eq 0 ]] ; then
  __shparent="$1"
  shift
  . "$__shparent"
else
  die "shell-helpers executable must be run from a script. " \
    "  #!/usr/bin/env shell-helpers" \
    "or, you may include shell-helpers.sh as a library"
fi
