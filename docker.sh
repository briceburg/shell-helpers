# shell-helpers - docker the things
#   https://github.com/briceburg/shell-helpers

docker/deactivate-machine(){
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
  docker/deactivate-machine
  exec docker "$@"
)

# docker/local-compose - run docker-compose against the local engine
docker/local-compose()(
  docker/deactivate-machine
  exec docker-compose "$@"
)


# print Dockerfiles found in a path. filter by tag and/or extension.
#  follows symlinks to resolve extension validity. legal default examples;
#    /path/Dockerfile
#    /path/Dockerfile-1.2.0
#    /path/Dockerfile-1.3.0.j2
docker/find/dockerfiles(){
  local path="${1:-.}" ; shift || true
  local filter_tag="$1" ; shift || true
  local filter_extensions=( "${@:-j2 Dockerfile}" )

  (
    found=false
    cd $path 2>/dev/null

    for Dockerfile in Dockerfile* ; do
      [ -e "$Dockerfile" ] || continue

      filename="$Dockerfile"
      tag="$(docker/get/dockerfile-tag $Dockerfile)"

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

# docker/find/labels <name|sha> [type (container|image)]
#  outputs labels one per line as "<label name> <label value>"
docker/find/labels(){
  local lookup="$1"
  local type="$2"
  local format="${__format:-\$label \$value\n}"

  [ -n "$type" ] && type="--type $type"
  local label
  local value

  docker/local inspect $type -f '{{range $key, $value := .Config.Labels }}{{println $key $value }}{{ end }}' $lookup |
  while read label value ; do
    [ -z "$label" ] && continue
    eval "printf \"$format\""
  done
}

# docker/find/repotags <name|sha> [type (container|image)]
#  outputs names (repository tags) one per line
docker/find/repotags(){
  local lookup="$1"
  local type="$2"

  [ -n "$type" ] && type="--type $type"
  local name

  docker/local inspect $type -f '{{range $name := .RepoTags }}{{println $name }}{{ end }}' $lookup |
  while read name ; do
    [ -z "$name" ] && continue
    echo "$name"
  done
}


# print the tag of a passed Dockerfile path - this is used by buildchain,
# and related to docker/find/dockerfiles
#  /path/to/Dockerfile => latest
#  Dockerfile-1.2.0 => 1.2.0
docker/get/dockerfile-tag(){
  local Dockerfile="$(basename $1)"
  local filename=${Dockerfile%.*}
  local tag=${filename//Dockerfile-/}
  tag=${tag//Dockerfile/latest}
  echo "$tag"
}

# docker/get/name <name|sha> [type (container|image)]
docker/get/repotag(){
  docker/find/repotags "$@" | head -n1
}

# docker/get/id <name|repotag> [type (container|image)]
docker/get/id(){
  local lookup="$1"
  local type="$2"

  [ -n "$type" ] && type="--type $type"
  docker/local inspect $type -f '{{ .Id }}' $lookup
}


# docker/get/safe-name <strings> [append list...]
#   sanitize strings into a safe container or image name
docker/get/safe-name(){
  local name="$@"
  set -- "${name:0:1}" "${name:1}"
  printf "%s%s" "${1//[^a-zA-Z0-9]/0}" "${2//[^a-zA-Z0-9_.-]/_}"
}
