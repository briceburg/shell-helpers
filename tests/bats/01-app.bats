#!/usr/bin/env bats

#
# 01 - basic behavior and test prerequisites
#

load app

@test "APP exists and is executable" {
  [ -x $APP ]
}

@test "APP is able to be sourced" {
  source $APP
}
