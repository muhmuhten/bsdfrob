#!/bin/sh
[ ${1+1} ] && exec env "$@" sh "$0"
set -eux

: pool="$pool"
: ver="${ver=`freebsd-version | sed 's/-.*-/@/; s/-.*/@p0/'`}"
: vol="${vol=${ver%@*}}"
: tmp="${tmp=new$$}"
: dir="${dir=${2-/media/$$}}"
: old="${old=old}"
: quirks="$quirks"
: bootfs="${bootfs=0}"

zfs clone "$pool/$ver" "$pool/$tmp"
mkdir -p "$dir"
mount -t zfs "$pool/$tmp" "$dir"
env DESTDIR="$dir" sh util/install.sh $quirks
umount "$dir"
rmdir "$dir"
zfs snap "$pool/$tmp@tip"

zfs list -r "$pool/$old" 2>/dev/null && zfs rename "$pool/$old" "$pool/$vol/p"
zfs rename "$pool/$vol" "$pool/$old"
zfs rename "$pool/$tmp" "$pool/$vol"
zfs promote "$pool/$vol"
[ "$bootfs" = 0 ] || zpool set bootfs="$pool/$vol" "${pool%%/*}"
