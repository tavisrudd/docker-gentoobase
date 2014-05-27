include:
  - .salt-patches

dev-python/msgpack:
  portage_config.flags:
    - accept_keywords: 
      - ~amd64

dev-python/pyyaml:
  portage_config.flags:
    - accept_keywords: 
      - ~amd64
dev-python/pycryptopp:
  portage_config.flags:
    - accept_keywords: 
      - ~amd64

app-admin/salt:
  portage_config.flags:
    - accept_keywords: 
      - ~amd64
  pkg.installed:
    - refesh: False
