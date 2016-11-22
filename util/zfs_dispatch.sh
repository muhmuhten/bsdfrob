#!/bin/sh
set -eu

case $2 in
(host)
	export pool="$1/0" quirks="host `cat /media/host/quirks`"
	shift 2; exec sh util/zfs_rebuild.sh "$@"
	;;
(jail)
	export pool="$1/i" quirks="jail"
	shift 2; exec sh util/zfs_rebuild.sh "$@"
	;;
(patch)
	case $3 in
	(host) export pool="$1/0" ;;
	(jail) export pool="$1/i" ;;
	(*)
		echo "$0: not sure what to do about '$2 $3'" >&2
		exit 2
		;;
	esac
	shift 3; exec sh util/zfs_patch.sh "$@"
	;;
(*)
	echo "$0: not sure what to do about '$2'" >&2
	exit 2
	;;
esac
