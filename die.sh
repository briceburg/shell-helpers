# shell-helpers - the art of killing your script
#   https://github.com/briceburg/shell-helpers

die(){
  io/error "${@:-halting...}"
  exit ${__exit_code:-1}
}

die/noent(){
  __error_code=127
  die "$@"
}

die/perms(){
  __error_code=126
  die "$@"
}

die/exception() {
  __error_code=2
  die "$@"
}
