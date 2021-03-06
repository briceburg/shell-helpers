
# shell/detect - detect user's shell and sets
#  __shell (user's shell, e.g. 'fish', 'bash', 'zsh')
#  __shell_file (shell configuration file, e.g. '~/.bashrc')
# usage: shell/detect [shell (skips autodetect)]
shell/detect(){
  # https://github.com/rbenv/rbenv/wiki/Unix-shell-initialization
  __shell=${1:-$(basename $SHELL | awk '{print tolower($0)}')}
  __shell_file=

  local search
  local path
  case $__shell in
    bash|sh   ) search=".bashrc .bash_profile" ;;
    cmd       ) search=".profile" ;;
    ash|dash  ) search=".profile" ;;
    fish      ) search=".config/fish/config.fish" ;;
    ksh       ) search=".kshrc" ;;
    powershell) search=".profile" ;;
    tcsh      ) search=".tcshrc .cshrc .login" ;;
    zsh       ) search=".zshenv .zprofile .zshrc" ;;
    *         ) die/exception "unrecognized shell \"$__shell\"" ;;
  esac

  for path in $search; do
    [ -e ~/$path ] && {
      __shell_file=~/$path
      return 0
    }
  done

  __shell_file=~/.profile
  p/warn "failed detecting $__shell shell config file, falling back to $__shell_file"
  return 1
}

# shell/evaluable_export - print evaluable commands to export a variable
#   requires __shell to be set (via shell/detect)
# usage: shell/evaluable_export <variable> <value> [append_flag] [append_delim]
shell/evaluable_export(){
  local append=${3:-false}
  local append_delim="$4"
  [[ "$1" = "PATH" && -z "$append_delim" ]] && append_delim=':'

  if $append; then
    case $__shell in
      cmd       ) echo "SET $1=%${1}%${append_delim}${2}" ;;
      fish      ) echo "set -gx $1 \$${1} ${2};" ;;
      tcsh      ) echo "setenv $1 = \$${1}${append_delim}${2}" ;;
      powershell) echo "\$Env:$1 = \"\$${1}${append_delim}${2}\";" ;;
      *         ) echo "export $1=\"\$${1}${append_delim}${2}\"" ;;
    esac
  else
    case $__shell in
      cmd       ) echo "SET $1=$2" ;;
      fish      ) echo "set -gx $1 \"$2\";" ;;
      tcsh      ) echo "setenv $1 \"$2\"" ;;
      powershell) echo "\$Env:$1 = \"$2\";" ;;
      *         ) echo "export $1=\"$2\"" ;;
    esac
  fi
}

shell/evaluable_entrypoint(){
  local pre
  local post

  # don't print anything if we're in a pipe
  [ -t 0 ] || return

  case $__shell in
    cmd       ) pre="@FOR /f "tokens=*" %i IN ('" post="') DO @%i'" ;;
    fish      ) pre="eval (" post=")" ;;
    tcsh      ) pre="eval \`" post="\`" ;;
    powershell) pre="&" post=" | Invoke-Expression" ;;
    *         ) pre="eval \$(" ; post=")" ;;
  esac

  p/comment \
    "To configure your shell, run:" \
    "  ${pre}${SCRIPT_ENTRYPOINT}${post}"

  [ -z "$__shell_file" ] || p/comment \
    "To remember your configuration in subsequent shells, run:" \
    "  ${SCRIPT_ENTRYPOINT} >> $__shell_file"
}


# shell/execfn <function name> [args...]
shell/execfn(){
  is/fn "$1" || die/exception "$1 is not a target function"

  "$@"
  exit $?
}

# shell/is/in_path <path|pattern>
shell/is/in_path(){
  # trim trailing slash from path|pattern
  local pattern="$(echo "$1" | sed 's|/$||')"
  local IFS=":"

  is/in "$pattern" $PATH
}
