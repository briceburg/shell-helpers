# shell-helpers - you put your left foot in, your right foot out.
#   https://github.com/briceburg/shell-helpers

is/absolute(){
  [[ "${1:0:1}" == / || "${1:0:2}" == ~[/a-z] ]]
}

# is/any <string|pattern> <list...>
#   case insensitive matching (lowercases string/pattern first)
#  use is/in as non-lowercasing alternative
is/any(){
  local pattern="$(io/lowercase "$1")" ; shift
  is/in "$pattern" "$@"
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

# is/in <pattern> <strings...>
#  returns true if a pattern matches _any_ string
#  supports wildcard matching
is/in(){
  #@TODO support piping of pattern

  local pattern="$1" ; shift || true
  local wildcard=false
  local item
  [[ "$pattern" == *"*"* ]] && wildcard=true

  for item; do
    if $wildcard; then
      [[ "$item" == $pattern ]] && return 0
    else
      [ "$item" = "$pattern" ] && return 0
    fi
  done

  return 1
}

# is/in_file <pattern> <file to search>
is/in_file(){
  local pattern="$1"
  local file="$2"
  grep -q "$pattern" "$file" 2>/dev/null
}

# is/in_list <item> <list items...>
#  returns true if <item> matches _any_ list item
is/in_list(){
  #@TODO support piping of item
  #@TODO disallow wildcard matching?

  is/in "$@"
}

# is/matching <string> <patterns...>
#  returns true if string matches _any_ pattern
is/matching(){
  #@TODO support piping of string

  local string="$1" ; shift || true
  local pattern
  for pattern; do
    is/in "$pattern" "$string" && return 0
  done

  return 1
}
