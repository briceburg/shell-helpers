# shell-helpers - git thingers (also see is/dirty)
#   https://github.com/briceburg/shell-helpers

# usage: clone_or_pull <repo-path-or-url> <destination> <force boolean>

git/clone_or_pull(){
  #@TODO rewrite

  local force=${3:-false}
  if [ -d $2 ]; then
    # pull
    (
      cd $2
      $force && git reset --hard HEAD
      git pull
    ) || {
      io/warn "error pulling changes from git"
      return 1
    }
  else
    # clone

    #@TODO support reference repository
    #  [detect if local repo is a bare repo -- but how to find remote?]

    local SHARED_FLAG=

    [ -w $(dirname $2) ] || {
      io/warn "destination directory not writable"
      return 126
    }

    if [[ $1 == /* ]]; then
      # perform a shared clone (URL is a local path starting with '/...' )
      [ -d $1/.git ] || {
        io/warn "$1 is not a path to a local git repository"
        return 1
      }
      SHARED_FLAG="--shared"
    fi

    git clone $SHARED_FLAG $1 $2 || {
      io/warn "error cloning $1 to $2"
      return 1
    }
  fi

  return 0
}
