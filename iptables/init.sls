iptables:
    pkg:
        - installed

/etc/iptables.rules:
    file.managed:
        - source: salt://iptables/files/iptables.rules
        - template: jinja
        - require:
            - pkg: iptables
    cmd.wait:
        - name: iptables-restore < /etc/iptables.rules
        - watch:
            - file: /etc/iptables.rules
        - require:
            - pkg: iptables

/etc/network/if-pre-up.d/iptables:
    file.managed:
        - source: salt://iptables/files/iptables
        - mode: 755
        - require:
            - file: /etc/iptables.rules
