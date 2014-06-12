#!/bin/bash

get_portage_snapshot() {
    [[ -e /usr/portage ]] || {
        wget -qO- http://gentoo.arcticnetwork.ca/snapshots/portage-latest.tar.xz | tar xfJ - -C /usr 
    }
}
salt_local() {
    salt-call -l warning --retcode-passthrough --local "$@"
}

configure_portage() {
    mkdir -p /etc/portage/package.keywords/
    cp /srv/salt/base/etc/portage/make.conf /etc/portage/make.conf
    cat > /etc/portage/package.keywords/salt <<-EOF
	>=app-admin/salt-0.17.4-r1 ~amd64
	>=dev-python/msgpack-0.4.0 ~amd64
	>=dev-python/pycryptopp-0.6.0 ~amd64
	>=dev-python/pyyaml-3.10-r1 ~amd64
	EOF
}

configure_portage &&
get_portage_snapshot && 
ln -sf /proc/self/fd /dev/ &&
emerge -vuD system world &&
emerge -u --usepkg --buildpkg --quiet --quiet-build salt &&
salt_local state.sls base.salt-patches &&
salt_local state.highstate
