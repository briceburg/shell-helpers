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

# is/in_list <match> <list...>
is/in_list(){
  is/matching "$@"
}

# is/matching <pattern> <string>
# is/matching <match> <list...>
#  supports wildcard matching
is/matching(){
  local match="$1" ; shift
  local wildcard=false
  local item
  [[ "$match" == *"*"* ]] && wildcard=true

  for item; do
    if $wildcard; then
      [[ "$item" == $match ]] && return 0
    else
      [ "$item" = "$match" ] && return 0
    fi
  done

  return 1
}
