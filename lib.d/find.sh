# shell-helpers - look up. climb tree. look down. look around.
#   https://github.com/briceburg/shell-helpers

#
# get/ returns single-value string
# find/ returns multi-value lists
#

# usage: find/dirs <path> [filter]
find/dirs(){
  local path="$1"
  local filter="$2"
  [ -z "$filter" ] && filter="*"
  [ -d "$path" ] || die "$FUNCNAME - invalid path: $path"
  (
    cd "$path"
    ls -1d $filter/ 2>/dev/null | sed 's|/$||'
  )
}


# find/matching <pattern> <list items...>
#  returns a filtered list of items matching pattern.
find/filtered(){
  local pattern="$1" ; shift || true
  local item
  local found=false

  for item; do
    is/in "$pattern" "$item" && {
      echo "$item"
      found=true
    }
  done

  $found
}
