#!/usr/bin/env bats

#
# 10 - library tests of non-dependent functions
#

load app

@test "args/normalize supports POSIX short and long flags" {
  run args/normalize "" "-abc"
  [ "$(echo $output | tr -d '\n')" = "-a -b -c" ]

  run args/normalize "om" "-abcooutput.txt" "--def=jam" "-mz"
  [ "$(echo $output | tr -d '\n')" = "-a -b -c -o output.txt --def jam -m z" ]
}

@test "args/normalize handles space-delimited single arguments" {
  run args/normalize "om" "-abcooutput.txt --def=jam -mz"
  [ "$(echo $output | tr -d '\n')" = "-a -b -c -o output.txt --def jam -m z" ]
}

@test "args/normalize_flags_first prints flags before args" {
  run args/normalize_flags_first "" "-abc command -xyz otro"
  [ "$(echo $output | tr -d '\n')" = "-a -b -c -x -y -z command otro" ]
}

@test "remainder of args functions" {
  skip
}
