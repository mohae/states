salt-minion:
    pkg:
        - installed
    service.running:
        - enabled: True
        - watch:
            - file: /etc/salt/minion.d/*.conf
        - require:
            - pkg: salt-minion

/etc/salt/minion.d/minion.conf:
    file.managed:
        - source: salt://salt/files/minion.conf
        - template: jinja
        - require:
            - pkg: salt-minion
