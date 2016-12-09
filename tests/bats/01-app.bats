#!/usr/bin/env bats

#
# 00 - test dependencies
#

load app

@test "APP exists and is executable" {
  [ -x $APP ]
}

@test "APP is able to be sourced" {
  source $APP
}
