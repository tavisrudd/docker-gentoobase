rm sgml / docbook crap:
  cmd.run:
    - name: emerge --quiet-unmerge-warn -q --unmerge opensp openjade docbook-xsl-stylesheets docbook-xml-dtd gtk-doc-am
    - unless: '[ ! -e /usr/share/sgml/docbook ]'

clear /usr/share/doc/:
  cmd.run:
    - name: rm -rf /usr/share/doc/*
    - unless: '[[ "$(ls /usr/share/doc)" == "" ]]'

clear /usr/share/info/:
  cmd.run:
    - name: rm -rf /usr/share/info/*
    - unless: '[[ ! -e /usr/share/info/m4.info.bz2 ]]'

clear /usr/share/man/ non English:
  cmd.run:
    - name: rm -rf /usr/share/man/[^m]*
    - unless: '[[ ! -e /usr/share/man/es ]]'

/usr/share/man/man0p:
  file.absent

/usr/share/man/man1p:
  file.absent

/usr/share/man/man3:
  file.absent

/usr/share/man/man3p:
  file.absent

/usr/share/man/man6:
  file.absent

clear git manuals:
  cmd.run:
    - name: rm -rf /usr/share/man/*/[Gg]it*
    - unless: '[[ ! -e /usr/share/man/man7/gitcli.7.bz2 ]]'

/usr/share/man/man7:
  file.absent

rm /usr/share/gtk-doc:
  file.absent:
    - name: /usr/share/gtk-doc

rm python pyo files:
  cmd.run:
    - name: 'find /usr/lib64/python* -name "*pyo" -exec rm {} \;'
    - unless: '[[ ! -e /usr/lib64/python2.7/os.pyo ]]'

rm portage /var/db/pkg environment.bz2 files:
  cmd.run:
    - name: 'find /var/db/pkg -name environment.bz2 -exec rm {} \;'
    - unless: 'ls /var/db/pkg/sys-apps/less-* | grep environment.bz2 && false || true'

/var/cache/eix/previous.eix:
  file.absent

/var/log/wtmp:
  file.absent

/var/log/emerge.log:
  file.absent

/var/log/emerge-fetch.log:
  file.absent

/var/cache/salt/minion:
  file.absent

/var/log/salt/minion.log:
  file.absent
