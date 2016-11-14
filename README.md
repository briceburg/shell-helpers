# shell-helpers
[![Build Status](https://travis-ci.org/briceburg/shell-helpers.svg?branch=master)](https://travis-ci.org/briceburg/shell-helpers)

a library of shell helper functions -- utility and consistency for your bashfu

![terminal](http://icons.iconarchive.com/icons/froyoshark/enkel/128/Terminal-icon.png)


## how to add shell-helpers to your project

#### fetch the latest release (preferred)

shell-helpers is packaged as a GitHub release -- meaning the scripts in lib.d/
are combined into a single file and published as a download.

two branches are provided -- `release` and `prerelease`, and we _try_ to follow semantic versioning(http://semver.org/) with both.

```
cd /path/to/my-project
REF=release curl ... > lib/helpers.sh
```

#### manually

Sure, copy the lib.d/ folder and then source all its contents in your script.
This looks something like:

```sh
cp -a /path/to/shell-helpers/lib.d/* /path/to/my-project/lib/helpers/
```

```sh
# my-project/script.sh
for helper in $(find lib/helpers/ -type f -name "*.sh"); do
  . $helper
done
```

#### as a git subtree (preferred for development)

If you prefer the individual library files, or plan on upstreaming changes,
attach shell-helpers using [git subtree](http://git.kernel.org/cgit/git/git.git/plain/contrib/subtree/git-subtree.txt).

To attach (first time)
```sh
cd /path/to/my-project
REF=release
git subtree add --prefix=lib/helpers git@github.com:briceburg/shell-helpers.git $REF
```

To update (once you've attached)
```sh
cd /path/to/my-project
REF=release
git subtree pull git@github.com:briceburg/shell-helpers.git $REF
```
> Pass --squash if you prefer to keep your project's history clean.

Once added as a subtree, follow the same approach as manually for sourcing
helpers in your script.
