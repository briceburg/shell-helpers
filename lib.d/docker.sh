# shell-helpers - docker the things
#   https://github.com/briceburg/shell-helpers

docker/deactivate_machine(){
  # @TODO support boot2docker / concept of "default" machine
  is/cmd docker-machine && {
    eval $(docker-machine env --unset --shell bash)
    return
  }
  # lets be safe and unset if missing docker-machine
  unset DOCKER_HOST DOCKER_TLS_VERIFY DOCKER_CERT_PATH DOCKER_MACHINE_NAME
}

# docker/local - run docker against the local engine
docker/local()(
  docker/deactivate_machine
  exec docker "$@"
)

# docker/local-compose - run docker-compose against the local engine
docker/local-compose()(
  docker/deactivate_machine
  exec docker-compose "$@"
)

# docker/safe_name - sanitize a string for use as a container or image name
docker/safe_name(){
  local name="$@"
  set -- "${name:0:1}" "${name:1}"
  printf "%s%s" "${1//[^a-zA-Z0-9]/0}" "${2//[^a-zA-Z0-9_.-]/_}"
}



# print Dockerfiles found in a path. filter by tag and/or extension.
#  follows symlinks to resolve extension validity. legal default examples;
#    /path/Dockerfile
#    /path/Dockerfile-1.2.0
#    /path/Dockerfile-1.3.0.j2
find/dockerfiles(){
  local path="${1:-.}" ; shift
  local filter_tag="$1" ; shift
  local filter_extensions=( "${@:-j2 Dockerfile}" )

  (
    found=false
    cd $path 2>/dev/null

    for Dockerfile in Dockerfile* ; do
      [ -e "$Dockerfile" ] || continue

      filename="$Dockerfile"
      tag="$(find/dockerfile-tag $Dockerfile)"

      # skip tags not matching our filter
      [[ -n "$filter_tag" && "$tag" != "$filter_tag" ]] && continue

      # resolve extension
      extension="${filename##*.}"
      while [ -L "$path/$filename" ]; do
        filename=$(readlink $path/$filename)
        extension=${filename##*.}
      done

      # skip files not matching our extension filter
      [ -n "$extension" ] && is/in_list "$extension" "${filter_extensions[@]}" && continue

      echo "$path/$Dockerfile"
      found=true
    done

    $found
  )

}

# print the tag of a passed Dockerfile path
#  /path/to/Dockerfile => latest
#  Dockerfile-1.2.0 => 1.2.0
find/dockerfile-tag(){
  local Dockerfile="$(basename $1)"
  local filename=${Dockerfile%.*}
  local tag=${filename//Dockerfile-/}
  tag=${tag//Dockerfile/latest}
  echo "$tag"
}
