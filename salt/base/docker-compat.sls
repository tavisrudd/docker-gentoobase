/etc/rc.conf:
  file.sed:
    - before: '^#rc_sys=""'
    - after: 'rc_sys="lxc"'
  file.sed:
    - before: '^#rc_provide="!net"'
    - after: 'rc_provide="net"'

/etc/inittab:
  file.sed:
    - before: '\(^c[1-6]\)'
    - after: '#\1'
  file.append:
    text: |
    # clean container shutdown on SIGPWR
    pf:12345:powerwait:/sbin/halt

/etc/issue:
  file.sed:
    - before: '[\][Oo]'
    - after: ''

/etc/runlevels/default/netmount:
  file.absent

/run/openrc/softlevel:
  file.touch

# fix https://github.com/dotcloud/docker/issues/2356
/dev/fd:
  file.symlink
    - target: /proc/self/fd
