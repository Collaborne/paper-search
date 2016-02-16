#!/bin/sh
# Version 1.0.3
#
# Modified to work with Travis CI automated builds
# Original license follows
#
# @license
# Copyright (c) 2014 The Polymer Project Authors. All rights reserved.
# This code may only be used under the BSD style license found at http://polymer.github.io/LICENSE.txt
# The complete set of authors may be found at http://polymer.github.io/AUTHORS.txt
# The complete set of contributors may be found at http://polymer.github.io/CONTRIBUTORS.txt
# Code distributed by Google as part of the polymer project is also
# subject to an additional IP rights grant found at http://polymer.github.io/PATENTS.txt
#

# This script pushes a demo-friendly version of your element and its
# dependencies to gh-pages.

# usage gp Polymer core-item [branch]
# Run in a clean directory passing in a GitHub org and repo name
if [ -z "${TRAVIS_REPO_SLUG}" ]; then
	echo "TRAVIS_REPO_SLUG environment is not set" >&2
	exit 1
fi

org=`echo ${TRAVIS_REPO_SLUG} | cut -f 1 -d /`
repo=`echo ${TRAVIS_REPO_SLUG} | cut -f 2 -d /`

name=$1
email=$2
branch=${3:-"master"} # default to master when branch isn't specified

# make folder (same as input, no checking!)
if [ -n "${GH_TOKEN}" ]; then
	repo_url=https://${GH_TOKEN}@github.com/${TRAVIS_REPO_SLUG}.git
else
	repo_url=git://github.com/${TRAVIS_REPO_SLUG}.git
fi

filter_gh_token() {
	if [ -n "${GH_TOKEN}" ]; then
		sed -e "s,${GH_TOKEN},*****,g" >&2
	else
		cat
	fi
}

log() {
	echo "$1" | filter_gh_token >&2
}

workdir=${repo}.$$
trap "rm -rf ${workdir}" EXIT
git clone ${repo_url} --no-checkout --single-branch ${workdir}
if [ $? -ne 0 ]; then
	log "Cannot checkout gh-pages branch from ${repo_url}"
	exit 1
fi

create_gh_pages() {
	# switch to gh-pages branch
	git checkout --orphan gh-pages

	# remove all content
	git rm -rf -q .

	# use bower to install runtime deployment
	bower cache clean ${repo} # ensure we're getting the latest from the desired branch.
	git show ${branch}:bower.json > bower.json
	echo "{
	  \"directory\": \"components\"
	}" > .bowerrc
	bower install
	bower install ${org}/${repo}#${branch}
	git checkout ${branch} -- demo
	rm -rf components/${repo}/demo
	mv demo components/${repo}/

	# redirect by default to the component folder
	echo "<META http-equiv='refresh' content='0;URL=components/${repo}/'>" >index.html

	git config user.name ${name}
	git config user.email ${email}

	# send it all to github
	git add -A .
	git commit -am 'Deploy to GitHub Pages'
	git push --force --quiet -u ${repo_url} gh-pages > /dev/null 2>&1
	if [ $? -ne 0 ]; then
		log "Cannot push new gh-pages branch to ${repo_url}"
		exit 1
	fi
}

(cd ${workdir} >/dev/null && create_gh_pages)


