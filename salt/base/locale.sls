app-admin/localepurge:
  pkg.installed:
    - refesh: False

/etc/locale.gen:
  file.managed:
    - source: salt://base/etc/locale.gen

/etc/locale.nopurge:
  file.managed:
    - source: salt://base/etc/locale.nopurge

/etc/env.d/02locale:
  file.managed:
    - source: salt://base/etc/env.d/02locale

locale-gen/purge after etc/locale{.nopurge,.gen} changes:
  cmd.wait:
    - name: locale-gen && localepurge
    - watch: 
      - file: /etc/locale.gen
      - file: /etc/locale.nopurge

env-update after /etc/env.d/ changes:
  cmd.wait:
    - name: env-update
    - watch: 
      - file: /etc/env.d/*
