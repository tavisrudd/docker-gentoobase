/usr/lib/python2.7/site-packages/salt/states/pkg.py:
  file.sed:
    - limit: '^ *salt.utils.fopen\(rtag'
    - before: 'salt'
    - after: 'pass # salt'

/usr/lib/python2.7/site-packages/salt/utils/__init__.py:
  file.sed:
    - limit: '^ *if host.find'
    - before: '== 4'
    - after: '>= 3'
