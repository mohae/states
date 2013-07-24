{% set system = pillar.get('system', {}) %}

{{ system.get('timezone', 'Europe/Stockholm') }}:
    timezone.system:
        - utc: True

{{ system.get('locale', 'sv_SE.UTF-8') }}:
    locale:
        - system
