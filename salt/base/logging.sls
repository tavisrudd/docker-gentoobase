app-admin/syslog-ng:
  portage_config.flags:
    - accept_keywords: 
      - ~amd64
    - use:
      - json
  pkg.installed:
    - refesh: False

syslog-ng:
  service.running:
    - enable: True
    - provider: service
