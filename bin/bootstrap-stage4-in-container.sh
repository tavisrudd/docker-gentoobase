#!/bin/bash
PORTAGE_SNAPSHOT_URL=http://192.168.2.113:9090/portage-latest.tar.xz
# http://gentoo.arcticnetwork.ca/snapshots/portage-latest.tar.xz

get_portage_snapshot() {
    [[ -e /usr/portage ]] || {
        LOCALPORTAGE=1
        wget -qO- $PORTAGE_SNAPSHOT_URL | tar xfJ - -C /usr 
    }
}

post_build_cleanup() {
    [[ -z $LOCALPORTAGE ]] || {
        mkdir /tmp/portage
        mv /usr/portage/{scripts,profiles,metadata} /tmp/portage
        rm -rf /usr/portage/
        mkdir -p /usr/portage/{packages,distfiles}
        mv /tmp/portage/* /usr/portage/
        rm -rf /tmp/portage
        rm -rf /usr/portage/metadata/md5-cache/
    }
}

install_essential() {
    emerge -u --quiet iproute2 iptables
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
    python -c'import _multiprocessing; _multiprocessing.SemLock' &>/dev/null || \
        emerge --usepkg '<dev-lang/python-2.8' python
}

configure_portage &&
get_portage_snapshot && 
ln -sf /proc/self/fd /dev/ &&
fix_python_multiprocessing &&
install_essential &&
emerge -vuD system world &&
emerge -u --usepkg --buildpkg --quiet --quiet-build salt &&
salt_local state.sls base.salt-patches &&
salt_local state.highstate &&
post_build_cleanup
