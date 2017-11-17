#!/bin/sh
set -eux

case $1 in
(-s|--stop)
	restart=no
	shift ;;
esac

pool=`mount -pF /dev/null | sed -n 1s,/.\*,,p`
dst=$pool/j/$1
src=$pool/i/${2-$1}
old=$pool/z/${dst#*/}-old`date +%s`.$$

s6-svc -d -wD "/run/s6/jail:$1"
zfs rename -p "$dst" "$old"
zfs clone "$src@tip" "$dst"

case ${restart-yes} in
([Nn]|[Nn][Oo]) ;;
(*)
	s6-svc -u -wu "/run/s6/jail:$1"
esac
