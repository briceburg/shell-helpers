# shell-helpers - look up. climb tree. look down. look around.
#   https://github.com/briceburg/shell-helpers

#
# get/ returns single-value string
# find/ returns multi-value lists
#

# get/cmd - return first usable command, preferring __cmd_prefix versions
# usage: get/cmd <command(s)...>
# example:
#  ansible=$(__cmd_prefix=badevops- get/cmd ansible dansible) =>
#   1. "badevops-ansible"
#   2. "badevops-dansible"
#   3. "ansible"
#   4. "dansible"
#   5. "" - returns 127
get/cmd(){
  local cmd=
  for cmd in "$@"; do
    type ${__cmd_prefix}${cmd} &>/dev/null && {
      echo "${__cmd_prefix}${cmd}"
      return 0
    }
  done

  for cmd in "$@"; do
    type $cmd &>/dev/null && {
      echo "$cmd"
      return 0
    }
  done

  return 127
}

# usage: get/gid_from_name <group name>
get/gid_from_name(){
  if is/cmd getent ; then
    getent group "$1" | cut -d: -f3
  elif is/cmd dscl ; then
    dscl . -read "/Groups/$1" PrimaryGroupID 2>/dev/null | awk '{ print $2 }'
  else
    python -c "import grp; print(grp.getgrnam(\"$1\").gr_gid)" 2>/dev/null
  fi
}

# usage: get/gid_from_file <path>
get/gid_from_path(){
  ls -ldn "$1" 2>/dev/null | awk '{print $4}'
}
