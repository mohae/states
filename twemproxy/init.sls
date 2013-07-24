include:
    - redis

twemproxy:
    file.managed:
        - name: /opt/nutcracker-0.2.4.tar.gz
        - source: https://twemproxy.googlecode.com/files/nutcracker-0.2.4.tar.gz
        - source_hash: sha1=be93eafee257f82f0083bba44fc502b19406ea4a
        - require:
            - pkg: redis-server
    cmd.wait:
        - cwd: /opt
        - name: tar xvfz nutcracker-0.2.4.tar.gz
        - watch:
            - file: twemproxy
    service.running:
        - name: nutcracker
        - enable: True
        - watch:
            - file: /etc/nutcracker/nutcracker.yml
        - reload: True
        - require:
            - file: /etc/init.d/nutcracker

twemproxy-make:
    cmd.wait:
        - cwd: /opt/nutcracker-0.2.4
        - names:
            - ./configure --enable-debug=log
            - make
            - make install
        - watch:
            - cmd: twemproxy

/etc/nutcracker:
    file.directory:
        - makedirs: True
        - require:
            - cmd: twemproxy-make

/etc/nutcracker/nutcracker.yml:
    file.managed:
        - source: salt://twemproxy/files/nutcracker.yml
        - template: jinja
        - require:
            - cmd: twemproxy-make
            - file: /etc/nutcracker

/etc/init.d/nutcracker:
    file.managed:
        - source: salt://twemproxy/files/nutcracker
        - template: jinja
        - mode: 755
        - require:
            - cmd: twemproxy-make
    cmd.wait:
        - name: update-rc.d nutcracker defaults
        - watch:
            - file: /etc/init.d/nutcracker
