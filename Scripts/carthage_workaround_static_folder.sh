#!/bin/bash
# Author: François Lamboley
# Version: 1.0
# Description: Link (ln) static Frameworks generated by Carthage
#    in the “Static” folder to the root Carthage folder
# Usage: carthage_workaround_static_folder.sh static_folder_name

### FL Script Header V1 ##################
set -e
[ "${0:0:1}" != "/" ] && _prefix="$(pwd)/"
scpt_dir="$_prefix$(dirname "$0")"
lib_dir="$scpt_dir/zz_lib"
source "$lib_dir/common.sh" || exit 255
cd "$(dirname "$0")"/../ || exit 42
##########################################

if [ $# -ne 1 ]; then
	echo_error "Syntax error" >/dev/stderr
	echo "usage: carthage_workaround_static_folder.sh static_folder_name" >/dev/stderr
	exit 1
fi

static_folder_name="$1"
if [ -z "$static_folder_name" ]; then exit 0; fi

cd "Carthage/Build"
for os in *; do
	if [ ! -d "$os" ]; then continue; fi

	echo "Applying workaround in folder $os..."
	pushd "$os" >/dev/null
	for f in "$static_folder_name"/*; do
		if [ ! -e "$f" ]; then continue; fi
		b="$(basename "$f")"
		rm -fr "$b"
		ln -sv "$f" .
	done
	popd >/dev/null
done
