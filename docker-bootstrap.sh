#!/bin/bash
get_portage() {
    [[ -e /usr/portage ]] || {
        wget -qO- http://gentoo.arcticnetwork.ca/snapshots/portage-latest.tar.xz | tar xfJ - -C /usr 
    }
}
salt_local() {
    salt-call -l warning --retcode-passthrough --local "$@"
}
get_portage && 
ln -sf /proc/self/fd /dev/ &&
mkdir -p /etc/portage/package.keywords/ &&
cat > /etc/portage/package.keywords/salt <<EOF
>=app-admin/salt-0.17.4-r1 ~amd64
>=dev-python/msgpack-0.4.0 ~amd64
>=dev-python/pycryptopp-0.6.0 ~amd64
>=dev-python/pyyaml-3.10-r1 ~amd64
EOF
emerge -u --usepkg --buildpkg --quiet --quiet-build salt &&
salt_local state.sls base.salt-patches &&
salt_local state.highstate
