#!/bin/sh
set -eux

pool=`mount -pF /dev/null | sed -n 1s,/.\*,,p`
case $1 in
(host) boot=yes ;;
(test) shift ;;
 esac
case $1 in
(host) prefix=$pool/0; set -- "$@" `cat /media/host/quirks` ;;
(jail) prefix=$pool/i ;;
(*) ! echo want host/jail >&2 ;;
esac
vol=$prefix/`uname -r | cut -d- -f1`
ver=`zfs list -HS creation -o name -rt snap "$vol" | sed -n '/@p/{p;q;}'`
dir=/media/tmp$$
tmp=$pool/z/${vol#*/}-new`date +%s`.$$
old=$pool/z/${vol#*/}-old`date +%s`.$$

zfs clone -p "$ver" "$tmp"
mkdir -p "$dir"
mount -t zfs "$tmp" "$dir"

if env PAGER=cat freebsd-update -b "$dir" fetch install; then
	new=$tmp@`"$dir/bin/freebsd-version" | cut -d- -f3`
	zfs snap "$new"
fi

env DESTDIR="$dir" sh util/install.sh "$@"
zfs snap "$tmp@tip"
umount "$dir"
rmdir "$dir"

zfs rename -p "$vol" "$old"
zfs rename "$tmp" "$vol"
zfs promote "$vol"

case ${boot-no} in
([Nn][Oo]) ;;
(*) zpool set bootfs="$vol" "$pool" ;;
esac
