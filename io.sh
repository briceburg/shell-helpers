# shell-helpers - you put your left foot in, your right foot out.
#   https://github.com/briceburg/shell-helpers


# io/cat - allows io/ funcs to accept either piped input or a list of strings as
#          input. Try to use "-" as first argument to hint stdin.
#          normalizes output, one per-line.
#
# examples:
#   cat my-file | io/cat -   =>
#     <contents of my-file...>
#
#   io/cat "hello" "world" =>
#     hello
#     world
io/cat(){
  # if stdin hint, or we're piped to AND without arguments, read from stdin...
  if [ "$1" = "-" ] || [[ ! -t 0 && ${#@} -eq 0 ]]; then
    cat -
  else
    local line
    for line; do echo $line; done
  fi
}

# strips comments and blank lines
io/no-comments(){
  io/no-empty "$@" | sed -e '/^\s*[#;].*$/d'
}

# strips blank lines
io/no-empty(){
  io/cat "$@" | sed -e '/^\s*$/d'
}

# strips blank lines, as well as leading and trailing whitespace
io/trim(){
  io/cat "$@" | awk '{$1=$1};1'
}

# adds a prefix to items, returning the prefixed items first
# example: io/add-prefix "p" "a" "b" =>
#   pa
#   pb
#   a
#   b
io/add-prefix(){
  local prefix="$1" ; shift || true
  local item

  for item; do
    echo "$prefix$item"
  done

  [ -z "$prefix" ] && return
  io/add-prefix "" "$@"
}

io/lowercase(){
  io/cat "$@" | awk '{print tolower($0)}'
}

io/uppercase(){
  io/cat "$@" | awk '{print toupper($0)}'
}
