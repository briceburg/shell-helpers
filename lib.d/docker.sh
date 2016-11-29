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
