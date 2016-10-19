#!/bin/sh
set -eu

export DESTDIR="$PWD/1"

# copy overlay
cp -a overlay/ "$DESTDIR"

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

# preimage from a first so we can build without 0/, but note that we need to
# rebuild before installing
sh util/preimage.sh a "$DESTDIR" b
sh util/preimage.sh 0 "$DESTDIR" b

# apply patches
diff -ru a b | patch -sp 1 -d "$DESTDIR"
find "$DESTDIR" -name '*.orig' -delete
