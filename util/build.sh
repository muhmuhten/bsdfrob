#!/bin/sh
set -eu

export DESTDIR="$PWD/1"

# copy overlay
cp -a common/ "$DESTDIR"

# build skaware
build_ska() {
	cd "skarnet/$1"; shift
	[ -f config.mak ] || ./configure "$@"
	gmake it install LDFLAGS=-s
}
(build_ska skalibs --disable-shared)
(build_ska execline \
	--with-sysdeps=../skalibs/sysdeps.cfg \
	--with-include="$DESTDIR/usr/include" \
	--with-lib="$DESTDIR/usr/lib/skalibs")
(build_ska s6 \
	--with-sysdeps=../skalibs/sysdeps.cfg \
	--with-include="$DESTDIR/usr/include" \
	--with-lib="$DESTDIR/usr/lib/skalibs" \
	--with-lib="$DESTDIR/usr/lib/execline")

build_prog() {
	cd "progs/$1"
	make "$1"
	cp -a "$1" "$DESTDIR/$2"
}
(build_prog jat sbin)
(build_prog jrm sbin)
(build_prog jset sbin)
(build_prog subreap bin)
