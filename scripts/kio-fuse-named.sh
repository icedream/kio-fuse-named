#!/bin/sh

#
# kio-fuse-named
#
# Main symlink management script.
#
# Author: Carl Kittelberger <icedream@icedream.pw>
#

set -e
set -u
set -o pipefail

action="$1"
shift 1

if [ "$#" -lt 1 ]
then
	echo "ERROR: You need to specify at least a mount ID that you want to mount or unmount." >&2
	exit 1
fi
	
MOUNT_ID="$1"
MOUNT_BASE_PATH="${XDG_RUNTIME_DIR:-/run/user/$UID}/kio-fuse-named"
MOUNT_PATH="${MOUNT_BASE_PATH}/${MOUNT_ID}"

case "$action" in
mount)
	MOUNT_URL=""
	MOUNT_CONF_PATH="${XDG_CONFIG_DIR:-$HOME/.config}/kio-fuse-named/$MOUNT_ID"
	if [ "$#" -gt 1 ]
	then
		MOUNT_URL="$2"
	elif [ -f "${MOUNT_CONF_PATH}" ]
	then
		. "${MOUNT_CONF_PATH}"
	fi
	if [ -z "$MOUNT_URL" ]
	then
		echo "ERROR: You need to specify a mount URL, either via a file $MOUNT_CONF_PATH or via a second command line argument." >&2
		exit 1
	fi

	# ask kio-fuse to mount this for us
	realmountpath=$(dbus-send --session --print-reply=literal --type=method_call \
		--dest=org.kde.KIOFuse /org/kde/KIOFuse org.kde.KIOFuse.VFS.mountUrl \
		string:"$MOUNT_URL" | awk '{print $1}')
	if [ -z "$realmountpath" ]
	then
		echo "ERROR: Something went wrong during kio-fuse mount attempt." >&2
		exit 1
	fi

	# remove any existing old symlink and/or file (if that's a real folder, fail)
	if [ -e "${MOUNT_PATH}" ]
	then
		rm "${MOUNT_PATH}"
	fi

	# create a symlink that points to kio-fuse's mount path
	mkdir -p "${MOUNT_BASE_PATH}"
	ln -s "${realmountpath}" "${MOUNT_PATH}"
	;;
unmount)
	if [ -L "${MOUNT_PATH}" ]
	then
		# just remove our symlink, leave the rest to kio-fuse
		rm "${MOUNT_PATH}"
	fi
	;;
*)
	echo "usage: $0 {mount|unmount} <mountID> <mountURL>" >&2
	;;
esac
