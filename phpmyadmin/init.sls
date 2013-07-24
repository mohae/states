include:
    - mysql
    - nginx
    - php

phpmyadmin:
    pkg:
        - installed
    require:
        - pkg: mysql
        - pkg: php
