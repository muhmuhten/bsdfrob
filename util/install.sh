#!/bin/sh
set -eu

tar -cf - --numeric-owner --uid=0 --gid=0 1 "@mtree.${1-host}" | \
	tar -xvf - --strip-components 1 -C 0
