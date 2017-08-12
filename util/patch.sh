#!/bin/sh
set -eux

pool=`mount -pF /dev/null | sed -n 1s,/.\*,,p`
case $1 in
(host) prefix=$pool/0; set -- "$@" `cat /media/host/quirks` ;;
(jail) prefix=$pool/i ;;
(*) ! echo want host/jail >&2 ;;
esac
vol=$prefix/`freebsd-version | cut -d- -f1`
ver=`zfs list -HS creation -o name -rt snap "$vol" | sed -n '/@p/{p;q;}'`
tmp=${vol%/*}/new$$
dir=/media/tmp$$
old=${vol%/*}/old

zfs clone -o readonly=off "$ver" "$tmp"
mkdir -p "$dir"
mount -t zfs "$tmp" "$dir"

if env PAGER=cat freebsd-update -b "$dir" fetch install; then
	new=$tmp@`"$dir/bin/freebsd-version" | cut -d- -f3`
	zfs snap "$new"
fi

env DESTDIR="$dir" sh util/install.sh "$@"
zfs snap "$tmp@tip"
zfs inherit readonly "$tmp"
umount "$dir"
rmdir "$dir"

zfs list "$old" 2>/dev/null && zfs rename "$old" "$vol/p"
zfs rename "$vol" "$old"
zfs rename "$tmp" "$vol"
zfs promote "$vol"

case $prefix in
(*/0) zpool set bootfs="$vol" "$pool" ;;
esac