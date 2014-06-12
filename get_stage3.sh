#!/bin/bash
set -e
latest="$(curl -s http://distfiles.gentoo.org/releases/amd64/autobuilds/latest-stage3-amd64.txt | tail -n1)"
tarball="$(basename "$latest")"
[[ -e "$tarball" ]] || {
    wget -O "$tarball" "http://distfiles.gentoo.org/releases/amd64/autobuilds/$latest"
    rm -f stage3.latest.tar.bz2
    ln -s "$tarball" stage3.latest.tar.bz2
}

