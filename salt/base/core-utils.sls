app-arch/pixz:
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
      - dev-python/psutil
      - dev-util/strace
      - sys-apps/pv

      # gentoo-utils:
      - app-admin/localepurge
      - app-portage/eix
      - app-portage/portage-utils
      - app-portage/gentoolkit
      - app-portage/flaggie
      - app-shells/gentoo-bashcomp

      # dev-utils:
      - sys-devel/make
      - app-editors/mg

      # network-utils:
      - sys-apps/iproute2
      - sys-apps/ethtool
      - net-firewall/iptables
      - net-dns/bind-tools
      - net-misc/dhcpcd
      - net-misc/telnet-bsd
      - net-analyzer/netcat
      - net-libs/libpcap
      - net-analyzer/tcpdump
      #- net-analyzer/iftop
      - net-misc/curl
      - www-servers/nginx

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
      - app-arch/lzop

      # misc text utils
      - app-misc/jq
