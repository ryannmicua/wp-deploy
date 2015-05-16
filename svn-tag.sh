#!/bin/bash
# Copies
 
if [ $# -lt 1 ]; then
	echo 'usage: svn-tag.sh 1.2.3'
	exit
fi

# args
TAG_NAME=$1

cd `dirname "${BASH_SOURCE[0]}"`

./deploy.sh "Tagging version $TAG_NAME" tags/$TAG_NAME

