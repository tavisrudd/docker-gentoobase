/sbin/salt-init:
  file.managed:
    - mode: 0755
    - contents: |
        #!/bin/bash
        : ${SALTMASTER:="$1"}
        [[ -n SALTMASTER ]] && sed -i "s/^#master: salt/master: $SALTMASTER/" /etc/salt/minion
        sed -i "s/^#acceptance_wait_time: 10/acceptance_wait_time: 4/" /etc/salt/minion
        [[ -n SSHD ]] && rc-update add sshd default
        rc-update add salt-minion default
        exec /sbin/init

/sbin/ssh-init:
  file.managed:
    - mode: 0755
    - contents: |
        #!/bin/bash
        rc-update add sshd default
        exec /sbin/init
