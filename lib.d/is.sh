# shell-helpers - you put your left foot in, your right foot out.
#   https://github.com/briceburg/shell-helpers

is/absolute(){
  [[ "${1:0:1}" == / || "${1:0:2}" == ~[/a-z] ]]
}

is/cmd(){
  type "$1" &>/dev/null
}

# is/url <string> - returns true on [protocol]://... or user@host:...
is/url(){
  [[ "$1" == *"://"* ]] || [[ "$1" == *"@"* && "$1" == *":"* ]]
}

is/fn(){
  [ "$(type -t $1)" = "function" ]
}

# is/in_file <file> <pattern to match>
is/in_file(){
  grep -q "$1" "$2" 2>/dev/null
}

is/in_list(){
  local match="$1" ; shift
  local item
  for item in "$@"; do
    [ "$item" = "$match" ] && return 0
  done
  return 1
}
