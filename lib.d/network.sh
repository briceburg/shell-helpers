# shell-helpers - a series of tubes and pipes provided by al gore
#   https://github.com/briceburg/shell-helpers

# usage: network/fetch <url> <target>
network/fetch(){
  local url="$1"
  local target="$2"
  prompt/overwrite "$target" || return 1
  network/print "$url" > "$target"
}

# usage: network/print <url>
# similar to network/fetch but prints a URL to stdout
network/print(){
  local url="$1"
  local wget=${WGET_PATH:-wget}
  local curl=${CURL_PATH:-curl}

  is/url "$url" || {
    p/warn "refusing to fetch $url"
    return 1
  }

  if is/cmd $wget ; then
    $wget -qO - $url
  elif is/cmd $curl ; then
    $curl -Lfs $url
  else
    p/warn "unable to fetch $url" "missing both curl and wget"
    return 1
  fi
}
