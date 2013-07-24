base:
    '*':
        - salt
        - common
    {% for minion, args in pillar.get('minions', {}).items() -%}
    '{{ minion }}':
        {%- for state in args %}
        - {{ state }}
        {%- endfor %}
    {%- endfor %}
