# shell-helpers
[![Build Status](https://travis-ci.org/briceburg/shell-helpers.svg?branch=master)](https://travis-ci.org/briceburg/shell-helpers)

shell-helpers - a utilitarian? bash shell library

![terminal](http://icons.iconarchive.com/icons/froyoshark/enkel/128/Terminal-icon.png)

*caution* active development. start with v2 as v1 is deprecated.

## add shell-helpers to your project

#### fetch the latest release (easiest)

shell-helpers is periodically packaged into a monolithic library and published
as a release on GitHub and get.iceburg.net.

```sh
cd /path/to/my-project/lib/helpers
# download v2 release
curl -L http://get.iceburg.net/shell-helpers/latest-v2/shell-helpers.sh > \
  shell-helpers.sh
```

An _optional_ [downstreamer](#updating-shell-helpers) is provided to speed up
fetching updates.

##### a-la-carte

You may also fetch individual helper files.

```sh
cd /path/to/my-project/lib/helpers
files=(
  cli.sh
  docker.sh
)
for file in "${files[@]}"; do
  curl -LO http://get.iceburg.net/shell-helpers/latest-v2/$file
done
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
