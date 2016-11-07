#!/bin/sh
set -eu

if [ ${1+1} ]; then
	ty=$1
elif [ -x 0/boot/kernel/kernel ]; then
	ty=host
elif [ "`sysctl -n security.jail.jailed`" = 1 ]; then
	ty=jail
fi

tar -cf - --numeric-owner --uid=0 --gid 0 1 -C "$ty" install @mtree | \
	tar -xvf - --strip-components 1 -C 0
