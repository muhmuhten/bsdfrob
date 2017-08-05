#!/bin/sh
set -eu

: build="${build="$PWD/BUILD"}"

# copy overlay
cp -a common/ "$build"

# build skaware
build_ska() {
	cd "skarnet/$1"; shift
	[ -f config.mak ] || ./configure "$@"
	gmake it install LDFLAGS=-s DESTDIR="$build"
}
(build_ska skalibs --disable-shared)
(build_ska execline \
	--with-sysdeps=../skalibs/sysdeps.cfg \
	--with-include="$build/usr/include" \
	--with-lib="$build/usr/lib/skalibs")
(build_ska s6 \
	--with-sysdeps=../skalibs/sysdeps.cfg \
	--with-include="$build/usr/include" \
	--with-lib="$build/usr/lib/skalibs" \
	--with-lib="$build/usr/lib/execline")

build_prog() {
	cd "progs/$1"
	make "$1"
	cp -a "$1" "$build/$2"
}
(build_prog jset sbin)
(build_prog jat sbin)
(build_prog jrm sbin)
(build_prog setlogin sbin)
(build_prog subreap bin)
