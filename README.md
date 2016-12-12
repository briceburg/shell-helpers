# shell-helpers
[![Build Status](https://travis-ci.org/briceburg/shell-helpers.svg?branch=master)](https://travis-ci.org/briceburg/shell-helpers)

shell-helpers - a utilitarian? bash shell library

![terminal](http://icons.iconarchive.com/icons/froyoshark/enkel/128/Terminal-icon.png)

## add shell-helpers to your project

> **caution** active development. start with the v2 branch -- api will stabilize
once an official release is made.

shell-helpers is periodically packaged as a monolithic library file and merged into a release branch (along with individual library files).

Releases are published to;
  * [get.iceburg.net](http://get.iceburg.net)
  * [github](https://github.com/briceburg/shell-helpers/releases)


### fetch the latest release (easiest)

```sh
cd /path/to/my-project/lib/helpers
# download v2 release
curl -L http://get.iceburg.net/shell-helpers/latest-v2/shell-helpers.sh > \
  shell-helpers.sh
```

### example usage in project

[dex](https://github.com/dockerland/dex) is a good example for using shell-helpers. It includes our [downstreamer](#updating-shell-helpers) for _keeping shell-helpers updated_. See the [lib.d/helpers](https://github.com/dockerland/dex/tree/master/lib.d/helpers) directory in dex.

### a-la-carte (developers)

If you prefer individual files or are a developer -- add shell-helpers
as a git subtree or simply _copy files into your project_. Using a subtree
is recommended for developers who may upstream changes back into our
repository.


##### as subtree
```sh
# attach v2 release as subtree under lib.d/helper
#   **change --prefix to your needs**
cd /path/to/my-project/
prefix="lib.d/helpers"
git subtree add --prefix="$prefix"s git@github.com:briceburg/shell-helpers.git v2
```

> to update once attached, use `git subtree pull`

## using helpers in your project

#### as a single library file

```sh
main(){
  readonly SCRIPT_CWD="$( cd $(dirname ${BASH_SOURCE[0]}) ; pwd -P )"

  . "$SCRIPT_CWD/lib/helpers/shell-helpers.sh" || {
    echo "shell-helpers.sh is required"
    exit 2
  }
}
```

#### a-la-carte example inclusion

If you cloned from git or are using a-la-carte (individual) helper files,
source them in your script with something like:

```sh
# my-project/script.sh
for helper in $(find lib/helpers/ -type f -name "*.sh"); do
  . $helper
done
```

### a couple of conventions

##### finds a list, gets a string

`find/` usually returns a list, `get/` usually returns a string. E.g.

```sh
render/templates(){
  local source_dir="$1"
  local cmd
  local dir
  local template
  
  # NOTE: get/ returns string
  cmd="$(get/cmd j2cli nunjucks)"
  
  # NOTE: find/ returns list
  for dir in $(find/dirs "$source_dir"); do
    template="$dir/template.j2"
    [ -e "$template" ] && {
      p/notice "rendering $template ..."
      $cmd "$template"
      p/success "rendered $template"
    }
  done
}
```

##### lookups on the left
patterns, searches, needles, lookups -- whatever you want to call them -- are typically "on-the-left" or the first argument passed to a function. e.g.

```
list=(
  apple
  orange
  starfruit
)

is/in_list "starfruit" "${list[@]}" && {
  echo "holy smokes! starfruit on on board captain!"
}
```


##### targets on the right

targets, destinations, lookup sources, -- whatever you want to call them -- are typically "on-the-right" or the last argument passed to a function. e.g.

```
file/interpolate "^127.0.0.1" "127.0.0.1 localhost dev" "/etc/hosts"
```


## updating shell-helpers

As shell-helpers evolves, you may want to fetch changes. A [downstreamer](bin/downstream-helpers) is provided to make this process more convenient.

Running the downstreamer searches through shell scripts for an update signature, and attempts to update all matching files.  It respect the original release branch -- so won't bump you to a newly released "major" version. See the [example in dex](https://github.com/dockerland/dex/tree/master/lib.d/helpers) .
