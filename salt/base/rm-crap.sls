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

clear git manuals:
  cmd.run:
    - name: rm -rf /usr/share/man/*/[Gg]it*
    - unless: '[[ ! -e /usr/share/man/man7/gitcli.7.bz2 ]]'

rm sgml / docbook crap:
  cmd.run:
    - name: emerge --quiet-unmerge-warn -q --unmerge opensp openjade docbook-xsl-stylesheets docbook-xml-dtd
    - unless: '[ ! -e /usr/share/sgml/docbook ]'

/var/cache/eix/previous.eix:
  file.absent

/var/log/wtmp:
  file.absent

/var/log/emerge.log:
  file.absent

/var/log/emerge-fetch.log:
  file.absent

/var/log/salt/minion.log:
  file.absent
