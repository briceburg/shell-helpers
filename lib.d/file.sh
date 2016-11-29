# shell-helpers - file/fs manipulation
#   https://github.com/briceburg/shell-helpers


# file/sed_inplace - cross-platform sed "in place" file substitution
# usage: sed_inplace "file" "sed regex pattern"
#    ex: sed_inplace "/tmp/file" "s/CLIENT_CODE/ACME/g"
#    ex: sed_inplace "/tmp/file" "/pattern_to_remove/d"
file/sed_inplace(){
  local sed=
  local sed_flags="-r -i"

  for sed in gsed /usr/local/bin/sed sed; do
    type $sed &>/dev/null && break
  done

  [ "$sed" = "sed" ] && [[ "$OSTYPE" =~ darwin|macos* ]] && sed_flags="-i '' -E"
  $sed $sed_flags "$2" $1
}

# file/interpolate - interpolates a match in a file, or appends if no match
#                    similar to ansible line_in_file
# usage: file/interpolate <file> <match> <content>
#    ex: file/interpolate  "default.vars" "^VARNAME=.*$" "VARNAME=value"
file/interpolate(){
  local delim=${4:-"|"}
  if is/in_file "$1" "$2"; then
    file/sed_inplace "$1" "s$delim$2$delim$3$delim"
  else
    echo "$3" >> "$1"
  fi
}
