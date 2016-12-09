# shell-helpers - you put your left foot in, your right foot out.
#   https://github.com/briceburg/shell-helpers


# io/cat - support variadic input (either arguments or piped stdin), and
#          normalize output. arguments are output one per line.
#
#          this is a helper fn used by other io/ commands, e.g.
#          io/trim supports trimming arguments or the contents of a file.
# examples:
#   cat my-file | io/cat   =>
#     <contents of my-file...>
#
#   io/cat "hello" "world" =>
#     hello
#     world
io/cat(){
  if [ -t 0 ]; then
    local line
    for line; do echo $line; done
  else
    cat
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
  local prefix="$1" ; shift
  local item

  for item; do
    echo "$prefix$item"
  done

  [ -z "$prefix" ] && return
  io/add-prefix "" "$@"
}
