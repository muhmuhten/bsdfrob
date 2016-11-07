#!/bin/sh
set -eu

DESTDIR="$PWD/host/install"

# preimage from a first so we can build without 0/, but note that we need to
# rebuild before installing
sh util/preimage.sh a "$DESTDIR" b
[ -e 0/COPYRIGHT ] && sh util/preimage.sh 0 "$DESTDIR" b

# apply patches
diff -ru a b | patch -sp 1 -d "$DESTDIR"
find "$DESTDIR" -name '*.orig' -delete
