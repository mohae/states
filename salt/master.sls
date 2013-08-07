salt-master:
    pkg:
        - installed
    service.running:
        - enable: True
        - watch:
            - file: /etc/salt/master.d/*.conf
        - require:
            - pkg: salt-master

/etc/salt/master.d/master.conf:
    file.managed:
        - source: salt://salt/files/master.conf
        - template: jinja
        - require:
            - pkg: salt-master
