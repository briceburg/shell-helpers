# shell-helpers - the art of killing your script
#   https://github.com/briceburg/shell-helpers

die(){
  io/error "${@:-halting...}"
  exit ${__exit_code:-1}
}

die/noent(){
  __exit_code=127
  die "$@"
}

die/perms(){
  __exit_code=126
  die "$@"
}

die/exception() {
  __exit_code=2
  die "$@"
}
