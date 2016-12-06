#!/usr/bin/env bats

#
# 10 - library tests of non-dependent functions
#

load app

@test "is/in_list supports correctly matches empty strings" {
  list=( "" )
  is/in_list "" "${list[@]}"
}

@test "remainder of is functions" {
  skip
}
