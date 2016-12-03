# shell-helpers - you put your left foot in, your right foot out.
#   https://github.com/briceburg/shell-helpers

is/absolute(){
  [[ "${1:0:1}" == / || "${1:0:2}" == ~[/a-z] ]]
}

is/cmd(){
  type "$1" &>/dev/null
}

# is/dirty [path to git repository]
is/dirty(){
  local path="${1:-.}"
  [ -d "$path/.git" ] || {
    io/warn "$path is not a git repository. continuing..."
    return 1
  }

  (
    set -e
    cd $path
    [ ! -z "$(git status -uno --porcelain)" ]
  )
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
