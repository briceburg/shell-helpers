# shell-helpers - git thingers
#   https://github.com/briceburg/shell-helpers


# usage: git/clone <repo-path-or-url> <destination>
git/clone(){
  local url="$1"
  local target="$2"
  prompt/overwrite "$target" || return 1

  [ -w $(dirname $target) ] || {
    p/warn "$target parent directory not writable"
    return 126
  }

  local flags=""
  if ! is/url "$url"; then
    # a path to a local repository is passed?
    git/is/dir "$url" || {
      p/warn "$url is not a git repository"
      return 2
    }
    flags+=" --shared"
  fi

  git clone $flags "$url" "$target"
}


# usage: git/pull <repo path>
git/pull(){
  local path="${1:-.}"
  (
    set -e
    cd "$path"
    if git/is/dirty && ! $__force ; then
      prompt/confirm "overwrite working copy changes in $path ?" || return 1
    fi
    git reset --hard @{upstream}
    git pull
  )
}

# git/is/work-tree <path>
# tests if path is inside a valid git working tree
git/is/work-tree(){
  local path="$1"
  eval $(git -C "$path" rev-parse --is-inside-work-tree)
}

# git/is/dir <path>
# tests if path is inside a valid git directory or working tree tree
git/is/dir(){
  local path="$1"
  eval $(git -C "$path" rev-parse --is-inside-git-dir) || \
    git/is/work-tree "$path"
}

# git/is/dirty [path to git repository]
git/is/dirty(){
  local path="${1:-.}"
  git/is/work-tree "$path" || {
    p/warn "$path is not a git working tree."
    return 126
  }
  [ -n "$(git -C "$path" status -uno --porcelain)" ]
}

# git/test/remote <remote> [path to git repository]
# tests communication with a git remote, ensures HEAD is a valid ref.
git/test/remote(){
  local remote="$1"
  local path="${2:-.}"
  git/is/dir "$path" || {
    p/warn "$path is not a git repository."
    return 126
  }

  p/log "testing communication with git remote \e[1m$remote\e[21m ..."
  git -C "$path" ls-remote --exit-code $remote HEAD &>/dev/null
}
