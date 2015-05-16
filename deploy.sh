#!/bin/bash
#
# This syncs from your git master branch to a specified svn branch/directory i.e. trunk or tag/1.4
# You can call the script anywhere as long as the $BASEDIR is specified
#
# Setup: specify your BASEDIR
# 
# @usage: ./deploy.sh

# args
MSG=${1-'Deploy from git'}
BRANCH=${2-'trunk'} #svn branch
TAG=${3-''}

#BASEDIR=$(cd `dirname "${BASH_SOURCE[0]}"` && pwd)
BASEDIR=/home/pogidude/projects/justme/plugins/email-reminder/email-reminder

SLUG=$(basename $BASEDIR)
SRC_DIR=${BASEDIR}/git
DEST_DIR=${BASEDIR}/svn/$BRANCH

# These are needed because this itself is a Git repo
export GIT_WORK_TREE=${BASEDIR}/git
export GIT_DIR=${BASEDIR}/git/.git

# make sure we're deploying from the right dir
if [ ! -d "$SRC_DIR/.git" ]; then
	echo "$SRC_DIR doesn't seem to be a git repository"
	exit
fi

# make sure the SVN repo exists
if [ ! -d "${BASEDIR}/svn" ]; then
	echo "Coudn't find the SVN repo at ${BASEDIR}/svn. Trying to create one..."
	svn co http://plugins.svn.wordpress.org/$SLUG/ ${BASEDIR}/svn
	exit
fi

# make sure the destination dir exists
mkdir -p $DEST_DIR
svn add $DEST_DIR 2> /dev/null

# delete everything except .svn dirs
for file in $(find $DEST_DIR/* -type f -and -not -path "*.svn*")
do
	rm $file
done

git checkout -f master

# copy everything over from git
rsync --recursive --exclude='*.git*' $SRC_DIR/* $DEST_DIR

# check .svnignore
for file in $(cat "$SRC_DIR/.svnignore" 2> /dev/null)
do
	rm -rf $DEST_DIR/$file
done

cd $DEST_DIR

# Transform the readme
if [ -f readme.md ]; then
	mv readme.md readme.txt
	sed -i '' -e 's/^# \(.*\)$/=== \1 ===/' -e 's/ #* ===$/ ===/' -e 's/^## \(.*\)$/== \1 ==/' -e 's/ #* ==$/ ==/' -e 's/^### \(.*\)$/= \1 =/' -e 's/ #* =$/ =/' readme.txt
fi

# svn addremove
svn stat | awk '/^\?/ {print $2}' | xargs svn add > /dev/null 2>&1
svn stat | awk '/^\!/ {print $2}' | xargs svn rm --force

svn stat

echo committing...
svn ci -m "$MSG"

