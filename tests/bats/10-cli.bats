#!/usr/bin/env bats

#
# 10 - library tests of non-dependent functions
#

load app

@test "cli normalize_flags routine supports POSIX short and long flags" {
  run normalize_flags "" "-abc"
  [ "$(echo $output | tr -d '\n')" = "-a -b -c" ]

  run normalize_flags "om" "-abcooutput.txt" "--def=jam" "-mz"
  [ "$(echo $output | tr -d '\n')" = "-a -b -c -o output.txt --def jam -m z" ]
}

@test "cli normalize_flags routine handles space-delimited single arguments" {
  run normalize_flags "om" "-abcooutput.txt --def=jam -mz"
  [ "$(echo $output | tr -d '\n')" = "-a -b -c -o output.txt --def jam -m z" ]
}

@test "cli normalize_flags_first routine prints flags before args" {
  run normalize_flags_first "" "-abc command -xyz otro"
  [ "$(echo $output | tr -d '\n')" = "-a -b -c -x -y -z command otro" ]
}

@test "remainder of cli functions" {
  skip
}
