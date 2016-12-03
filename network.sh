# shell-helpers - a series of tubes and pipes provided by al gore
#   https://github.com/briceburg/shell-helpers


# usage: network/fetch <url> <target> [force boolean]
network/fetch(){
  local wget=${WGET_PATH:-wget}
  local curl=${CURL_PATH:-curl}
  local url="$1"
  local target="$2"
  local force=${3:-false}

  [[ ! $force && -e "$target" ]] && {
    io/confirm "overwrite $target ?" || return 1
  }
  rm -rf "$target"

  if is/cmd $wget ; then
    $wget -qO "$target" $url || { rm -rf "$target" ; }
  elif is/cmd $curl ; then
    $curl -Lfso "$target" $url
  else
    io/warn "unable to fetch $url" "missing both curl and wget"
  fi

  [ -e $target ]
}
