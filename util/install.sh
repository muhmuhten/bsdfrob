#!/bin/sh
set -eu
: ${DESTDIR=0}

if read quirks < /media/host/quirks; then
	set host $quirks
else
	set jail
fi

tar -cf - --numeric-owner --uid=0 --gid 0 1 | \
	tar -xvf - --strip-components 1 -C "$DESTDIR"

for ea; do
	tar -cf - --numeric-owner --uid=0 --gid 0 -C "quirks/$ea" files @mtree | \
		tar -xvf - --strip-components 1 -C "$DESTDIR"
done
