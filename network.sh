# shell-helpers - a series of tubes and pipes provided by al gore
#   https://github.com/briceburg/shell-helpers

# usage: network/fetch <url> <target> [force boolean]
network/fetch(){
  local url="$1"
  local target="$2"
  local force=${3:-false}

  [[ ! $force && -e "$target" ]] && {
    io/confirm "overwrite $target ?" || return 1
  }
  rm -rf "$target"

  network/print "$url" > "$target"
  [ -e $target ]
}

# usage: network/print <url>
# similar to network/fetch but prints a URL to stdout
network/print(){
  local url="$1"
  local wget=${WGET_PATH:-wget}
  local curl=${CURL_PATH:-curl}

  if is/cmd $wget ; then
    $wget -qO - $url
  elif is/cmd $curl ; then
    $curl -Lfs $url
  else
    io/warn "unable to fetch $url" "missing both curl and wget"
    return 1
  fi
}
