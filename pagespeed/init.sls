include:
    - nginx

/etc/nginx/conf.d/pagespeed.conf:
    file.managed:
        - source: salt://pagespeed/files/pagespeed.conf
        - template: jinja
        - watch_in:
            - service: nginx
        - require:
            - pkg: nginx

/var/ngx_pagespeed_cache:
    file.directory:
        - user: www-data
        - group: www-data
        - require:
            - pkg: nginx
