fix missing _multiprocessing.SemLock:
  cmd.run:
    - name: emerge --usepkg '<dev-lang/python-2.8' python
    - unless: python -c'import _multiprocessing; _multiprocessing.SemLock'
