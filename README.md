# shell-helpers
[![Build Status](https://travis-ci.org/briceburg/shell-helpers.svg?branch=master)](https://travis-ci.org/briceburg/shell-helpers)

shell-helpers - a utilitarian? bash shell library

![terminal](http://icons.iconarchive.com/icons/froyoshark/enkel/128/Terminal-icon.png)

## add shell-helpers to your project

> **caution** active development. start with the v2 branch -- api will stabilize
once an official release is made.

shell-helpers is periodically packaged as a single-file monolithic library and merged into a release branch along with individual library files.

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

[dex](https://github.com/dockerland/dex) is a good example for using shell-helpers in a project, including the optional [downstreamer](#updating-shell-helpers) for _keeping shell-helpers updated_. See the [lib.d/helpers](https://github.com/dockerland/dex/tree/master/lib.d/helpers) directory in dex.

### a-la-carte (developers)

If you prefer individual files or are a developer -- add shell-helpers
as a git subtree or simply _copy files into your project_. Using a subtree
is recommended for developers who may upstream changes back into our
repository (to make it easier).


##### as subtree
```sh
# attach v2 release as subtree under lib.d/helper
#   **change --prefix to your needs**
cd /path/to/my-project/
prefix="lib.d/helpers"
git subtree add --prefix="$prefix"s git@github.com:briceburg/shell-helpers.git v2
```

to update once attached, use `git subtree pull`

```sh
# attach v2 release as subtree under lib.d/helper
#   **change --prefix to your needs**
cd /path/to/my-project/
prefix="lib.d/helpers"
git subtree pull --prefix="$prefix"s git@github.com:briceburg/shell-helpers.git v2
```


## using helpers in your project

If you cloned from git or are using a-la-carte (individual) helper files,
source them in your script with:

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
render/template(){
  local cmd
  local template="$1"

}


##### lookups on the left
patterns, searches, needles, lookups -- whatever you want to call them -- are typically "on-the-left" or the first argument passed to a function. e.g.

```


## updating shell-helpers

As shell-helpers evolves, you may want to fetch changes. You may do this manually or use convenient [downstreamer](bin/downstream-helpers).

The downstreamer respects the release defined in your original file (at bottom) -- so if you're using a pre-release, it will download the latest pre-release files.

Copy downstream-helpers into your project directory and run it. It will search for shell helpers files and attempt to update each on found.

```sh
# install downstreamer
cd /path/to/my-project/lib/helpers
curl -LO http://get.iceburg.net/shell-helpers/latest-v2/downstream-helpers && \
  chmod +x downstream-helpers


# run downstreamer
/path/to/my-project/lib/helpers/downstream-helpers
```
> alternatively pass a directory containing shell-helpers as the first argument.
