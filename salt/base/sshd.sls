sshd:
  service.running:
    - enable: True
    - provider: service

# what do about keeping the host key out of the base image?
