dev-lang/python:
  portage_config.flags:
    - use:
      - sqlite

fix missing _multiprocessing.SemLock:
  cmd.run:
    - name: emerge --usepkg '<dev-lang/python-2.8' python
    - unless: python -c'import _multiprocessing; _multiprocessing.SemLock'

python-related:
  pkg.installed:
    - refesh: False
    - pkgs:
      - dev-python/pip
      - dev-python/ipython
