#!/usr/bin/env bats

#
# 00 - dependencies
#

load helpers

setup() {
  cd $REPO_ROOT
}

@test "makefile compiles $NAMESPACE" {
  rm -rf $REPO_ROOT/lib/$NAMESPACE.sh
  make
  [ -e $REPO_ROOT/lib/$NAMESPACE.sh ]
}

@test "makefile installs $NAMESPACE.sh library" {
  make DESTDIR=$TMPDIR install
  [ -e $TMPDIR/usr/local/lib/$NAMESPACE.sh ]
}

@test "makefile uninstalls $NAMESPACE" {
  make DESTDIR=$TMPDIR uninstall
  [ ! -e $TMPDIR/usr/local/library/$NAMESPACE.sh ]
}

@test "makefile cleans up" {
  make clean
  [ ! -e $REPO_ROOT/lib/$NAMESPACE.sh ]
}
