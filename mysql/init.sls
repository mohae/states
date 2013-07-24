mysql:
    pkgrepo.managed:
        - name: deb http://repo.percona.com/apt {{ grains['oscodename'] }} main
        - keyid: 1C4CBDCDCD2EFD2A
        - keyserver: keys.gnupg.net
        - require_in:
            - pkg: mysql
    pkg.installed:
        - pkgs:
            - percona-server-server-5.5
            - percona-server-client-5.5
    service.running:
        - enable: True
        - require:
            - pkg: mysql
