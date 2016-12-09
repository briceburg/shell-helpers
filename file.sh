# shell-helpers - file/fs manipulation
#   https://github.com/briceburg/shell-helpers


# file/sed_inplace - cross-platform sed "in place"
# usage: file/sed_inplace "sed script" "file"
#    ex: file/sed_inplace "s/CLIENT_CODE/ACME/g" "/tmp/file"
#    ex: file/sed_inplace "/pattern_to_remove/d" "/tmp/file"
file/sed_inplace(){
  local script="$1"
  local file="$2"
  local sed_flags="-r -i"
  local sed

  for sed in gsed /usr/local/bin/sed sed; do
    type $sed &>/dev/null && break
  done

  [ "$sed" = "sed" ] && [[ "$OSTYPE" =~ darwin|macos* ]] && sed_flags="-i '' -E"
  $sed $sed_flags "$script" "$file"
}

# file/interpolate - interpolates a match in a file, or appends if no match
#                    similar to ansible line_in_file
# usage: file/interpolate <pattern> <replace> <file>
#    ex: file/interpolate "^VARNAME=.*$" "VARNAME=value" "default.vars"
file/interpolate(){
  local pattern="$1"
  local replace="$2"
  local file="$3"
  local delim=${4:-"|"}

  if is/in_file "$pattern" "$file"; then
    file/sed_inplace "s${delim}$pattern${delim}$replace${delim}" "$file"
  else
    echo "$replace" >> "$file"
  fi
}
