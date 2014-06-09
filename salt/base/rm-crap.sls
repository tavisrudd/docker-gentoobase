/var/log/wtmp:
  file.absent

/var/log/emerge*log:
  file.absent

/var/cache/eix/*:
  file.absent

/usr/share/man/[^m]*:
  file.absent

/usr/share/doc/*:
  file.absent

/usr/portage/distfiles/*:
  file.absent
