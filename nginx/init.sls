nginx:
    pkgrepo.managed:
        - ppa: sandyd/nginx-current-pagespeed
        - require_in:
            - pkg: nginx
    pkg:
        - installed
    service.running:
        - enable: True
        - watch:
            - file: /etc/nginx/mime.types
            - file: /etc/nginx/nginx.conf
            - file: /etc/nginx/custom.d/*.conf
        - reload: True
        - require:
            - pkg: nginx

/etc/nginx/nginx.conf:
    file.managed:
        - source: salt://nginx/files/nginx.conf
        - template: jinja
        - require:
            - pkg: nginx

/etc/nginx/mime.types:
    file.managed:
        - source: salt://nginx/files/mime.types
        - require:
            - pkg: nginx

/etc/nginx/custom.d:
    file.directory:
        - makedirs: True
        - require:
            - pkg: nginx

/etc/nginx/custom.d/optimize.conf:
    file.managed:
        - source: salt://nginx/files/optimize.conf
        - require:
            - pkg: nginx
            - file: /etc/nginx/custom.d

{% if pillar.get('nginx', {}).get('mail', {}) == True %}
/etc/nginx/custom.d/mail.conf:
    file.managed:
        - source: salt://nginx/files/mail.conf
        - require:
            - pkg: nginx
            - file: /etc/nginx/custom.d
{% else %}
/etc/nginx/custom.d/mail.conf:
    file.absent:
        - require:
            - pkg: nginx
{% endif %}

{% for site, args in pillar.get('sites', {}).items() %}
/etc/nginx/sites-available/{{ site }}:
    file.managed:
        - source: salt://nginx/files/site.conf
        - template: jinja
        - context:
            site: {{ site }}
            args: {{ args }}
        - watch_in:
            - service: nginx
        - require:
            - pkg: nginx

{% if 'enable' in args and args.enable == True %}
/etc/nginx/sites-enabled/{{ site }}:
    file.symlink:
        - target: /etc/nginx/sites-available/{{ site }}
        - require:
            - pkg: nginx
{% else %}
/etc/nginx/sites-enabled/{{ site }}:
    file.absent:
        - require:
            - pkg: nginx
{% endif %}

/var/www/{{ site }}:
    file.directory:
        - user: www-data
        - group: www-data
        - makedirs: True
        - require:
            - pkg: nginx
{% endfor %}

/var/cache/nginx:
    file.directory:
        - user: www-data
        - group: www-data
        - makedirs: True
        - require:
            - pkg: nginx
