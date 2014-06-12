#!/bin/bash
set -e
latest="$(curl -s http://distfiles.gentoo.org/releases/amd64/autobuilds/latest-stage3-amd64.txt | tail -n1)"
latest_date="$(echo "$latest" | grep -oP '(?<=amd64-)[0-9]{8}')"
tarball="build/$(basename "$latest")"

get_latest() {
    [[ -e "$tarball" ]] || {
        wget -O "$tarball" "http://distfiles.gentoo.org/releases/amd64/autobuilds/$latest"
    }
    [[ -e "$tarball.DIGESTS.asc" ]] || {
        wget -O "$tarball.DIGESTS.asc" "http://distfiles.gentoo.org/releases/amd64/autobuilds/$latest.DIGESTS.asc"
    }
    ##
    [[ -e "$tarball" ]] && [[ -e "$tarball.DIGESTS.asc" ]] && 
    gpg --quiet --batch --verify "$tarball.DIGESTS.asc" &&
    rm -f build/stage3.latest.tar.bz2 &&
    ln -s "$(basename "$tarball")" build/stage3.latest.tar.bz2
}

import_latest() {
    local image_name="tavisrudd/stage3:$latest_date"
    if docker inspect "$image_name" >/dev/null; then
        echo "image $image_name already exists"
    else
        echo "importing stage3 as $image_name"
        pbunzip2 -c build/stage3.latest.tar.bz2 | docker import - "$image_name" &&
        echo "created image $image_name"
    fi
}

get_latest && import_latest
