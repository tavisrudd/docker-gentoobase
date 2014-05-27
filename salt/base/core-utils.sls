include:
  - .python-multiproc-bug

dev-lang/python:
  portage_config.flags:
    - use:
      - sqlite

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

      # python 
      - dev-python/pip
      - dev-python/ipython

      # gentoo-utils:
      - app-admin/localepurge
      - app-portage/eix
      - app-portage/portage-utils
      - app-portage/gentoolkit
      - app-portage/flaggie
      - app-shells/gentoo-bashcomp

      # network-utils:
      - sys-apps/iproute2
      - sys-apps/ethtool
      - net-firewall/iptables
      - net-dns/bind-tools
      - net-misc/dhcpcd
      - net-misc/telnet-bsd
      - net-analyzer/netcat
      - net-misc/openvpn
      - net-dns/dnsmasq
      - net-analyzer/iftop
      - net-misc/curl
      - sys-apps/pv
      - www-servers/nginx
      - www-client/lynx

      # dev-utils:
      - dev-util/cmake
      - dev-lang/go

      # tty-utils:
      - app-misc/screen
      - app-text/tree

      # vcs-utils:
      - dev-vcs/git
      - dev-vcs/mercurial

      # archive-utils:
      - app-arch/pbzip2
      - app-arch/pixz
      - app-arch/dpkg
      - app-arch/alien

      # misc text utils
      - app-misc/jq
