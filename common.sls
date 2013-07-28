include:
    - system
    - iptables
    - cron
    - users

common:
    pkg.installed:
        - pkgs:
            - build-essential
            - git-core
