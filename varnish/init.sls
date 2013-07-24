varnish:
    pkgrepo.managed:
        - name: deb http://repo.varnish-cache.org/ubuntu/ {{ grains['oscodename'] }} varnish-3.0
        - key_url: http://repo.varnish-cache.org/debian/GPG-key.txt
        - require_in:
            - pkg: varnish
    pkg:
        - installed
    service.running:
        - enable: True
        - watch:
            - file: /etc/default/varnish
        - reload: True
        - require:
            - pkg: varnish

/etc/default/varnish:
    file.managed:
        - source: salt://varnish/files/varnish
        - template: jinja
        - require:
            - pkg: varnish
