#!/bin/bash

#PORTAGE_SNAPSHOT_URL=http://192.168.2.114:9090/portage-latest-min.tar.xz
PORTAGE_SNAPSHOT_URL=http://gentoo.arcticnetwork.ca/snapshots/portage-latest.tar.xz

is_portage_bind_mounted() {
    grep '/usr/portage ' /proc/mounts >/dev/null
}

get_portage_snapshot() {
    is_portage_bind_mounted || {
        wget -qO- $PORTAGE_SNAPSHOT_URL | tar xfJ - -C /usr 
    }
}

post_build_cleanup() {
    is_portage_bind_mounted || {
        mkdir /tmp/portage
        mv /usr/portage/{scripts,profiles,metadata} /tmp/portage/
        rm -rf /usr/portage/
        mkdir -p /usr/portage/{packages,distfiles}
        mv /tmp/portage/* /usr/portage/
        rm -rf /tmp/portage
        rm -rf /usr/portage/metadata/md5-cache/
    }
}

install_essential() {
    emerge -uD --usepkg --buildpkg --quiet system world iproute2 iptables salt
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

fix_python_multiprocessing() {
    python -c'import _multiprocessing; _multiprocessing.SemLock' &>/dev/null || {
        echo "fixing bug in Python build of _multiprocessing.SemLock"
        emerge --quiet --usepkg '<dev-lang/python-2.8' python
    }
}

main() {
    configure_portage &&
    get_portage_snapshot && 
    ln -sf /proc/self/fd /dev/ &&
    fix_python_multiprocessing &&
    install_essential &&
    salt_local state.sls base.salt-patches &&
    salt_local state.highstate &&
    post_build_cleanup
}

##
[[ "$BASH_SOURCE" == "$0" ]] && main
