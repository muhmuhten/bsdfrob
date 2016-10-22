#!/bin/sh
set -eu

mkdir -p "$2"
tar -cf - --format=mtree -C "$3" . | tar -cf - -C "$1" @- | tar -xf - -C "$2"
