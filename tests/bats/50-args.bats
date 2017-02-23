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

@test "args/normalize_flags_first prints flags before args" {
  args/normalize_flags_first "" -abc command -xyz otro
  [  "${__argv[*]}" = "-a -b -c -x -y -z command otro" ]
}

@test "args/normalize respects passthru (--) delimiter" {
  args/normalize "" -abc -- -def
  [ "${__argv[*]}" = "-a -b -c -- -def" ]

  args/normalize_flags_first "" -abc command -xyz otro -- -def -xyz
  [  "${__argv[*]}" = "-a -b -c -x -y -z command otro -- -def -xyz" ]
}

@test "args/normalize respects whitepace/quoted arguments" {
  args/normalize "" --book infinite jest
  [ ${#__argv[@]} -eq 3 ]

  args/normalize "" --book "infinite jest"
  [ ${#__argv[@]} -eq 2 ]
}

@test "args/normalize allows POSIX key=value arguments" {
  args/normalize "" --book="infinite jest"
  [ ${#__argv[@]} -eq 2 ]
}

@test "args/normalize handles short flag argument expansion" {
  args/normalize "d" -d aaa -dbbb
  [ "${__argv[*]}" = "-d aaa -d bbb" ]
}


@test "remainder of args functions" {
  skip
}
