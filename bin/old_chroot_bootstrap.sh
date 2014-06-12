#!/bin/bash

export STAGE3_BALL=$1
export TARGET_ROOT=rootfs

[[ -e $TARGET_ROOT ]] && { 
    echo "ERROR: target $TARGET_ROOT already exists" >/dev/stderr; 
    exit 1; 
}

prep_rootfs_from_stage3() {
    mkdir $TARGET_ROOT
    tar -C $TARGET_ROOT -xjpf $STAGE3_BALL
    mkdir -p $TARGET_ROOT/dev/pts
    mkdir -p $TARGET_ROOT/usr/portage
    mkdir -p $TARGET_ROOT/var/tmp/packages
}

set_nameservers() {
    echo -e 'nameserver 8.8.8.8\nnameserver 8.8.4.4' > $TARGET_ROOT/etc/resolv.conf
}

prep_openrc_for_docker_boot() {
    # TODO: consider replacing this with a set of files for each deployment target:
    # vanilla lxc, docker, ec2, etc.
    # see https://github.com/gza/lxc-gentoo-template/blob/master/lxc-gentoo

    sed 's/^#rc_sys=""/rc_sys="lxc"/g' -i $TARGET_ROOT/etc/rc.conf
    sed 's/^#rc_provide="!net"/rc_provide="net"/g' -i $TARGET_ROOT/etc/rc.conf
    # disable agetty
    sed -e's/\(^c[1-6]\)/#\1/' -i $TARGET_ROOT/etc/inittab
    #echo "1:12345:respawn:/sbin/agetty -a root --noclear 115200 console linux"

    echo "# clean container shutdown on SIGPWR" >> $TARGET_ROOT/etc/inittab
    echo "pf:12345:powerwait:/sbin/halt" >> $TARGET_ROOT/etc/inittab

    rm -f $TARGET_ROOT/etc/runlevels/default/netmount
    touch $TARGET_ROOT/run/openrc/softlevel

    # fix https://github.com/dotcloud/docker/issues/2356
    ln -sf /proc/self/fd /dev/

    # blank out /etc/issue to prevent delays spawning login
    # caused by attempts to determine domainname on disconnected containers
    sed -i 's/[\][Oo]//g' $TARGET_ROOT/etc/issue
}

cleanup_unneeded_crap() {
    rm -rf $TARGET_ROOT/var/log/wtmp $TARGET_ROOT/var/log/emerge*log
    rm -rf $TARGET_ROOT/var/cache/eix/*
    # rm foreign man pages and unneeded docs
    rm -rf $TARGET_ROOT/usr/share/man/[^m]*
    rm -rf $TARGET_ROOT/usr/share/doc/*
}

prep_sshd() {
    [[ -e $TARGET_ROOT/etc/runlevels/default/sshd ]] || \
        ln -s /etc/init.d/sshd $TARGET_ROOT/etc/runlevels/default/
    mkdir -p $TARGET_ROOT/root/.ssh/
    cat /root/.ssh/id_rsa.pub > $TARGET_ROOT/root/.ssh/authorized_keys
}

prep_portage_config() {
    mv $TARGET_ROOT/etc/portage/make.conf $TARGET_ROOT/etc/portage/make.conf.dist
    cat > $TARGET_ROOT/etc/portage/make.conf <<"EOF"
CFLAGS="-O2 -pipe -march=x86-64"
#CFLAGS="-O2 -pipe -march=native"
CXXFLAGS="${CFLAGS}"
CHOST="x86_64-pc-linux-gnu"
PORTDIR="/usr/portage"
DISTDIR="${PORTDIR}/distfiles"
PKGDIR="${PORTDIR}/packages"
LINGUAS=en
MAKEOPTS="-j9"
EMERGE_DEFAULT_OPTS="--usepkg --buildpkg --quiet-build --jobs=8 --load-average=7.0"
FEATURES="clean-logs"
PKGDIR=/var/tmp/packages
USE="bindist mmx sse sse2 iproute2 bash-completion -cups -ipv6 -X -alsa"
USE_PYTHON="2.7"
PYTHON_TARGETS="python2_7"
EOF

    mkdir -p $TARGET_ROOT/etc/portage/sets
    cat > $TARGET_ROOT/etc/portage/sets/x_base <<"EOF"
app-admin/localepurge
app-portage/eix
app-portage/portage-utils
app-portage/gentoolkit
app-portage/flaggie
app-shells/gentoo-bashcomp

sys-apps/iproute2
sys-apps/ethtool
net-firewall/iptables
net-dns/bind-tools
net-misc/dhcpcd
net-misc/telnet-bsd
net-analyzer/netcat
net-misc/curl
sys-apps/pv
net-misc/openvpn
net-dns/dnsmasq
net-analyzer/iftop

sys-process/cronie

app-admin/syslog-ng
app-admin/sysstat
sys-process/lsof
sys-process/htop
dev-python/psutil
dev-util/strace

app-text/tree

dev-vcs/git
dev-vcs/mercurial
#dev-vcs/subversion

app-arch/pbzip2
app-arch/pixz
app-misc/jq

#app-crypt/gnupg
#dev-python/boto
#dev-python/libcloud

app-misc/screen

app-admin/salt
EOF
    #
    mkdir -p $TARGET_ROOT/etc/portage/package.license
    cat > $TARGET_ROOT/etc/portage/package.license/java <<EOF
>=dev-java/oracle-jdk-bin-1.7.0.25 Oracle-BCLA-JavaSE
EOF

    mkdir -p $TARGET_ROOT/etc/portage/package.keywords
    cat >> $TARGET_ROOT/etc/portage/package.keywords/pixz <<EOF
app-arch/pixz ~amd64
EOF
    cat >> $TARGET_ROOT/etc/portage/package.keywords/salt <<EOF
>=app-admin/salt-0.17.4-r1 ~amd64
>=dev-python/msgpack-0.4.0 ~amd64
>=dev-python/pycryptopp-0.6.0 ~amd64
>=dev-python/pyyaml-3.10-r1 ~amd64
EOF


    mkdir -p $TARGET_ROOT/etc/portage/package.use
    cat > $TARGET_ROOT/etc/portage/package.use/java <<"EOF"
dev-java/oracle-jdk-bin -X -fontconfig
EOF

}

set_locale_and_time() {
    cat > $TARGET_ROOT/etc/locale.gen <<EOF
en_US ISO-8859-1
en_US.UTF-8 UTF-8
EOF
    cp $TARGET_ROOT/usr/share/zoneinfo/UTC $TARGET_ROOT/etc/localtime
    echo "UTC" > $TARGET_ROOT/etc/timezone
    echo 'LANG="en_US.UTF-8"' > $TARGET_ROOT/etc/env.d/02locale
    echo 'LC_COLLATE="C"' >> $TARGET_ROOT/etc/env.d/02locale
}

#####

umount_host_sys_dirs() {
    umount -l $TARGET_ROOT/dev{/shm,/pts,}
    umount -l $TARGET_ROOT/proc
    umount -l $TARGET_ROOT/sys
    umount -l $TARGET_ROOT/usr/portage
    umount -l $TARGET_ROOT/var/tmp/packages
}

mount_host_sys_dirs() {
    set_nameservers
    trap "umount_host_sys_dirs" EXIT
    mount -t proc proc $TARGET_ROOT/proc
    mount --rbind /sys $TARGET_ROOT/sys
    mount --rbind /dev $TARGET_ROOT/dev
    mount --bind /usr/portage $TARGET_ROOT/usr/portage
    mount --bind /var/tmp/portage/docker_packages $TARGET_ROOT/var/tmp/packages
}

#####

do_emerge() {
    chroot_run emerge -u --quiet --quiet-build --usepkg --buildpkg $@
    #--binpkg-respect-use=y
}

chroot_run() {
    chroot $TARGET_ROOT "$@"
}

compile_kernel() {
    # optional
    do_emerge sys-kernel/gentoo-sources
    cp kernel_config $TARGET_ROOT/usr/src/linux/.config
    cat > $TARGET_ROOT/root/compile_kernel.sh <<EOF
set -e
cd /usr/src/linux
yes "" | make oldconfig
make -j8 
make modules_install
EOF
    chroot_run /root/compile_kernel.sh
}

base_files() {
    prep_rootfs_from_stage3
    touch $TARGET_ROOT/.prep-complete
    set_nameservers
    set_locale_and_time
    prep_portage_config
    prep_openrc_for_docker_boot
    prep_sshd
    echo "alias l='ls -alh --color=auto'" >> $TARGET_ROOT/etc/bash/bashrc
}

main() {
    date
    [[ -e $TARGET_ROOT/.prep-complete ]] || base_files
    mount_host_sys_dirs

    chroot_run emerge --config sys-libs/timezone-data
    chroot_run env-update
    do_emerge @system @world

    chroot_run python -c'import _multiprocessing; _multiprocessing.SemLock' || {
        chroot_run emerge '<dev-lang/python-2.8'
        chroot_run emerge python
    }
    umount_host_sys_dirs
    (
        cd $TARGET_ROOT
        tar -cf ../$TARGET_ROOT.pre.tar .
    )
    mount_host_sys_dirs

    do_emerge @x_base
    chroot_run rc-update add syslog-ng default
    chroot_run locale-gen
    cat >  $TARGET_ROOT/etc/locale.nopurge <<EOF
MANDELETE
#VERBOSE
en
en_US ISO-8859-1
en_US.UTF-8 UTF-8
EOF
    chroot_run localepurge >> /dev/null
    cleanup_unneeded_crap

    umount_host_sys_dirs
    (
        cd $TARGET_ROOT
        tar -cf ../$TARGET_ROOT.tar .
    )
    mount_host_sys_dirs

    echo `date` base done. Now Java
    do_emerge dev-java/oracle-jdk-bin
    chroot_run java-config --set-system-vm oracle-jdk-bin-1.7
    do_emerge --unmerge dev-java/icedtea-bin
    cleanup_unneeded_crap

    chroot_run glsa-check -l affected
    umount_host_sys_dirs
    (
        cd $TARGET_ROOT
        tar -cf ../$TARGET_ROOT.java.tar .
    )
    mount_host_sys_dirs
    date
}
main
