#!/usr/bin/env bash

# source helpers if not loaded
[ $HELPERS_LOADED ] || . "$BATS_TEST_DIRNAME/helpers.bash"

APP="$TMPDIR/usr/local/lib/$NAMESPACE.sh"
SKIP_NETWORK_TEST=${SKIP_NETWORK_TEST:-false}

#
# runtime fns
#

make_app(){
  (
    cd "$REPO_ROOT"
    make DESTDIR="$TMPDIR" install
  )
  [ -x "$APP" ] || die "failed installing application binary"
}

[ -e "$APP" ] || make_app &>/dev/null

# source $APP (this is a library)
source "$APP"
