# prevent salt from updating portage before each pkg.installed run
/usr/lib/python2.7/site-packages/salt/states/pkg.py:
  file.sed:
    - limit: '^ *salt.utils.fopen\(rtag'
    - before: 'salt'
    - after: 'pass # salt'
