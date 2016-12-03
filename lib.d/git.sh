# shell-helpers - git thingers (also see is/dirty)
#   https://github.com/briceburg/shell-helpers


# usage: git/clone <repo-path-or-url> <destination>
git/clone(){
  local url="$1"
  local target="$2"
  prepare/overwrite "$target" || return 1

  [ -w $(dirname $target) ] || {
    io/warn "$target parent directory not writable"
    return 126
  }

  local flags=""
  if ! is/url "$url"; then
    [ -d "$url/.git" ] || {
      io/warn "$url is not a git repository"
      return 2
    }
    flags+=" --shared"
  fi

  git clone $flags "$url" "$target"
}


# usage: git/pull <repo path>
git/pull(){
  local path="${1:.}"
  (
    cd "$path"
    if is/dirty && ! $__force ; then
      io/confirm "overwrite working copy changes in $path ?" || return 1
    fi
    git reset --hard HEAD
    git pull
  )
}
