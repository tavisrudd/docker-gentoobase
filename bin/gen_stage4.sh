#!/bin/bash
CONTAINER_NAME="${1-stage4}-$(date '+%Y%m%d-%H-%M-%S')"
IMAGE_NAME="${1-stage4}:$(date '+%Y%m%d-%H-%M-%S')"
BASEIMAGE="${BASEIMAGE-tavisrudd/stage3}"
PORTAGE_VOLS_CONTAINER="${PORTAGE_VOLS_CONTAINER-gentoo-vols}"
CWD="$(pwd)"

main() {
    time docker run -it --name "$CONTAINER_NAME" \
                --volumes-from "$PORTAGE_VOLS_CONTAINER" \
                -v "$CWD":/mnt -v "$CWD/salt/":/srv/salt \
                "$BASEIMAGE" /mnt/bin/bootstrap-stage4-in-container.sh &&
    docker export "$CONTAINER_NAME" > "build/$CONTAINER_NAME.tar" &&
    docker import - "tavisrudd/$IMAGE_NAME" < "build/$CONTAINER_NAME.tar" &&
    docker rm "$CONTAINER_NAME" &&
    pixz "build/$CONTAINER_NAME.tar"
}

main
