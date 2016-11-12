#!/bin/sh
set -eu

if read quirks < /media/host/quirks; then
	set host $quirks
else
	set jail
fi

tar -cf - --numeric-owner --uid=0 --gid 0 1 | \
	tar -xvf - --strip-components 1 -C 0

for ea; do
	tar -cf - --numeric-owner --uid=0 --gid 0 -C "quirks/$ea" files @mtree | \
		tar -xvf - --strip-components 1 -C 0
done
