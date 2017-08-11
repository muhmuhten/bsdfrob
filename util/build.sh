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
	cd ../..
}
build_ska skalibs --disable-shared
build_ska execline \
	--with-sysdeps=../skalibs/sysdeps.cfg \
	--with-include="$build/usr/include" \
	--with-lib="$build/usr/lib/skalibs"
build_ska s6 \
	--with-sysdeps=../skalibs/sysdeps.cfg \
	--with-include="$build/usr/include" \
	--with-lib="$build/usr/lib/skalibs" \
	--with-lib="$build/usr/lib/execline"

make -C progs/jset jset jat jrm
make -C progs/setlogin setlogin
make -C progs/subreap subreap
cp -a \
	progs/jset/jset progs/jset/jat progs/jset/jrm \
	progs/setlogin/setlogin \
	progs/subreap/subreap \
	"$build/sbin"
