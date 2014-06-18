# prevent salt from updating portage before each pkg.installed run
/usr/lib/python2.7/site-packages/salt/states/pkg.py:
  file.sed:
    - limit: '^ *salt.utils.fopen\(rtag'
    - before: 'salt'
    - after: 'pass # salt'

{% set portage_config_mod = "/usr/lib64/python2.7/site-packages/salt/modules/portage_config.py" %}

replace use of deprecated portage.dep.strip_empty 1/2:
  file.append:
    - name: {{ portage_config_mod }}
    - text: | 

        def strip_empty(myarr): 
            return [x for x in myarr if x]

replace use of deprecated portage.dep.strip_empty 2/2:
  file.replace:
    - name: {{ portage_config_mod }}
    - pattern: portage\.dep\.strip_empty
    - repl: strip_empty
