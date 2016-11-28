# conditionals

is/absolute(){
  [[ "${1:0:1}" == / || "${1:0:2}" == ~[/a-z] ]]
}

is/function(){
  [ "$(type -t $1)" = "function" ]
}
