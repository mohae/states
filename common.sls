include:
    - system
    - iptables
    - cron

common:
    pkg.installed:
        - pkgs:
            - build-essential
            - git-core
