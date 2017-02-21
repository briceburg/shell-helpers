#!/usr/bin/env bats

#
# 10 - library tests of non-dependent functions
#

load app

@test "args/normalize supports POSIX short and long flags" {
  args/normalize "" -abc
  [ "${__argv[*]}" = "-a -b -c" ]

  args/normalize "om" -abcooutput.txt --def=jam -mz
  [ "${__argv[*]}" = "-a -b -c -o output.txt --def jam -m z" ]
}

@test "args/normalize handles space-delimited single arguments" {
  args/normalize "om" -abcooutput.txt --def=jam -mz
  [ "${__argv[*]}" = "-a -b -c -o output.txt --def jam -m z" ]
}

@test "args/normalize_flags_first prints flags before args" {
  args/normalize_flags_first "" -abc command -xyz otro
  [  "${__argv[*]}" = "-a -b -c -x -y -z command otro" ]


  args/normalize_flags_first "" -abc command -xyz otro -- -def -xyz
  [  "${__argv[*]}" = "-a -b -c -x -y -z command otro -- -def -xyz" ]
}

@test "args/normalize respects whitepace in arguments" {
  args/normalize "" --book infinite jest
  [ ${#__argv[@]} -eq 3 ]

  args/normalize "" --book "infinite jest"
  [ ${#__argv[@]} -eq 2 ]
}

@test "args/normalize allows key=value arguments" {
  args/normalize "" --book="infinite jest"
  [ ${#__argv[@]} -eq 2 ]
}

@test "remainder of args functions" {
  skip
}
