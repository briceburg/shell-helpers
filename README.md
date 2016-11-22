# shell-helpers
[![Build Status](https://travis-ci.org/briceburg/shell-helpers.svg?branch=master)](https://travis-ci.org/briceburg/shell-helpers)

a library of shell helper functions -- utility and consistency for your bashfu

![terminal](http://icons.iconarchive.com/icons/froyoshark/enkel/128/Terminal-icon.png)


## how to add shell-helpers to your project

#### fetch the latest release (preferred)

shell-helpers is packaged as a GitHub release -- meaning the scripts in lib.d/
are combined into a monolithic library and published. Releases are mirrored
at get.iceburg.net.

```sh
curl -L http://get.iceburg.net/shell-helpers/latest-release/shell-helpers.sh > \
  /path/to/my-project/lib/shell-helpers.sh
```

##### a-la-carte

You may also fetch individual helper files.

```sh
for file in cli.sh docker.sh; do
  curl -L http://get.iceburg.net/shell-helpers/latest-release/$file > \
    /path/to/my-project/lib/$file
done
```

#### using git

Two branches are provided, `release` and `prerelease` -- and we _try_ to follow [semantic versioning](http://semver.org/) with both.

```sh
HELPERS_VERSION=release
HELPERS_DESTINATION=/path/to/my-project/lib/helpers

git clone git@github.com:briceburg/shell-helpers.git shell-helpers
GIT_WORK_TREE="HELPERS_DESTINATION" git checkout -f $RELEASE_VERSION
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

### updating shell-helpers

You may fetch another release from our page or use our convenient [downstreamer](bin/downstream-helpers).

#### downstreamer

Use [downstream-helpers](bin/downstream-helpers) in [bin/](bin/) to quickly fetch the latest version helper file(s). It is **awesome**, and respects the release -- so if you're using a pre-release, it will download the latest pre-release files.


Copy [downstream-helpers](bin/downstream-helpers) into your project directory containing shell-helpers and run it.

> Alternatively pass a directory containing shell-helpers to update as the first argument.
