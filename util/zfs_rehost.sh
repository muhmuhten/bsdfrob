#!/bin/sh
set -eux

[ ${1+1} ] && exec env "$@" sh "$0"

: ${ver="`freebsd-version | sed s/-RELEASE-/@/`"}
: ${vol="${ver%@*}"}
: ${tmp="new$$"}
: ${dir=${2-/media/$$}}
: ${old="p"}

zfs clone "$pool/$ver" "$pool/$tmp"
mkdir -p "$dir"
mount -t zfs "$pool/$tmp" "$dir"
make DESTDIR="$dir" install
zfs snap "$pool/$tmp@tip"
zpool set bootfs="$pool/$tmp" "${pool%%/*}"

zfs list "$pool/$old" 2>/dev/null && zfs rename "$pool/$old" "$pool/$vol/$old"
zfs rename "$pool/$vol" "$pool/$old"
zfs rename "$pool/$tmp" "$pool/$vol"
zfs promote "$pool/$vol"
