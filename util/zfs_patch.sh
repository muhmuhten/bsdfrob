#!/bin/sh
[ ${1+1} ] && exec env "$@" sh "$0"
set -eux

: pool="$pool"
: ver="${ver="`freebsd-version | sed 's/-.*-/@/; s/-.*/@p0/'`"}"
: vol="${vol="${ver%@*}"}"
: tmp="${tmp="new$$"}"
: dir="${dir=${2-/media/$$}}"
: old="${old="old"}"

zfs clone "$pool/$ver" "$pool/$tmp"
mkdir -p "$dir"
mount -t zfs "$pool/$tmp" "$dir"
mount -t devfs -o ruleset=4 devfs "$dir/dev"
mount -t tmpfs -o mode=0700 tmpfs "$dir/tmp"
mkdir -p "$dir/tmp/etc" "$dir/tmp/freebsd-update"
cp /etc/resolv.conf "$dir/tmp/etc"
mount -t unionfs -o below "$dir/tmp/etc" "$dir/etc"
mount -t nullfs "$dir/tmp/freebsd-update" "$dir/var/db/freebsd-update"
env PAGER=cat chroot "$dir" freebsd-update fetch install
new="`"$dir/bin/freebsd-version" | sed 's/-.*-/@/; s/-.*/@p0/'`"
umount "$dir/var/db/freebsd-update" "$dir/etc" "$dir/tmp" "$dir/dev" "$dir"
rmdir "$dir"
zfs snap "$pool/$tmp@${new##*@}"

zfs list -r "$pool/$old" 2>/dev/null && zfs rename "$pool/$old" "$pool/$vol/p"
zfs rename "$pool/$vol" "$pool/$old"
zfs rename "$pool/$tmp" "$pool/$vol"
zfs promote "$pool/$vol"
