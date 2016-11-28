# v2 (prerelease)

* reorganized helpers into groups with namespace prefix (<group>/<fn>)
* improved io helpers
  * add io/comment io/notice io/success io/shout io/header io/blockquote
  * fun unicode prefixes


### migration map
v1 name | v2 name
--- | ---
__local_docker | docker/local
__local_docker_compose | docker/local-compose
__deactivate_machine | docker/deactivate_machine
clone_or_pull | git/clone_or_pull (?)
docker_safe_name | docker/safe_name
error | die
error_noent | die/noent
error_perms | die/perms
error_exception | die/exception
fetch-url | network/fetch
get_cmd | find/cmd
get_group_id | find/gid_from_name
is_dirty | is/dirty
line_in_file | file/interpolate
log | io/log
normalize_flags | args/normalize
normalize_flags_first | args/normalize_flags_first
prompt_confirm | io/prompt_confirm
prompt_echo | io/prompt
runfunc | shell/execfn
set_cmd | _deprecated_
sed_inplace | file/sed_inplace
shell_detect | shell/detect
shell_eval_export | shell/evaluable_export
shell_eval_message | shell/evaluable_entrypoint
unrecognized_flag | args/unknown "flag"
unrecognized_arg | args/unknown _or_ args/unknown "command"
warn | io/warn

# v1 (release)

* add downstreamer https://github.com/briceburg/shell-helpers/blob/master/bin/downstream-helpers
* introduce is/ helpers
