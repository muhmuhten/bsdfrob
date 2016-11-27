#!/bin/sh
set -eu

: build="${build="BUILD"}"
: DESTDIR="${DESTDIR=/mnt}"

# require explicit no-quirks, to avoid brickings
case $1 in (""|none) shift ;; esac

tar -cf - --numeric-owner --uid=0 --gid 0 "$build" | \
	tar -xvf - --strip-components 1 -C "$DESTDIR"

for ea; do
	tar -cf - --numeric-owner --uid=0 --gid 0 -C "quirks/$ea" files @mtree | \
		tar -xvf - --strip-components 1 -C "$DESTDIR"
done
