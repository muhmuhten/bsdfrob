#!/bin/sh
set -eu

export DESTDIR="$PWD/1"

# copy overlay
cp -a overlay/ "$DESTDIR"

# apply patches
sh util/preimage.sh 0 "$DESTDIR" b
diff -ru a b | patch -sp 1 -d "$DESTDIR"
find "$DESTDIR" -name '*.orig' -delete

# build skaware
build_ska() {
	cd "skarnet/$1"; shift
	./configure "$@"
	gmake it strip install
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
