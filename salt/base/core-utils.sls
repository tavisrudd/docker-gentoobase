app-arch/pixz:
  portage_config.flags:
    - accept_keywords: 
      - ~amd64

app-arch/pxz:
  portage_config.flags:
    - accept_keywords: 
      - ~amd64

core-utils:
  pkg.installed:
    - refesh: False
    - pkgs:
      - sys-process/htop
      - app-admin/sysstat
      - sys-process/lsof
      - sys-apps/dstat
      - dev-python/psutil
      - sys-apps/pv
      - sys-apps/collectl
      - sys-process/parallel
      - app-admin/sudo

      # init like
      #- sys-apps/s6

      # gentoo-utils:
      - app-admin/localepurge
      - app-portage/eix
      - app-portage/layman
      - app-portage/portage-utils
      - app-portage/gentoolkit
      - app-portage/flaggie
      - app-shells/gentoo-bashcomp

      # dev-utils:
      - sys-devel/make
      - dev-util/patchutils
      - app-editors/mg
      - app-text/sloccount
      - dev-util/ltrace
      - dev-util/strace

      # network-utils:
      - sys-apps/iproute2
      - sys-apps/ethtool
      - net-dns/bind-tools
      - net-dns/host
      - net-misc/iputils
      - net-firewall/iptables
      - net-firewall/ebtables
      - net-misc/bridge-utils
      - net-misc/dhcpcd
      - net-misc/ntp
      - net-misc/telnet-bsd
      - net-analyzer/netcat
      - net-misc/socat
      - net-libs/libpcap
      - net-analyzer/tcpdump
      #- net-analyzer/iftop
      - net-misc/curl
      - www-servers/nginx
      - net-proxy/haproxy

      # tty-utils:
      - app-misc/screen
      - app-text/tree

      # vcs-utils:
      - dev-vcs/git
      - dev-vcs/mercurial

      # archive-utils:
      - app-arch/zip
      - app-arch/pbzip2
      - app-arch/pixz
      - app-arch/pxz
      - app-arch/lzop

      # misc text utils
      - app-misc/jq
      - app-misc/color
