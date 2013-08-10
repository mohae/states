# states

A basic set of Salt Stack states for setting up a server with nginx, PageSpeed,
Varnish and much more.

## Getting started

* Make sure you have Salt Stack [installed](http://salt.readthedocs.org/en/latest/topics/installation/index.html).
* [Download](https://github.com/kevva/states/archive/master.tar.gz) or clone the
git repo — `git clone https://github.com/kevva/states.git` — into your
`states/` folder.
* Configure the Pillar data and run: `salt \* state.highstate`

## Usage

All states are controlled with [Pillar](http://salt.readthedocs.org/en/latest/topics/pillar/index.html) which makes them very easy to customize.

### cron

Sets up a cron job.

* `user` — The name of the user who's crontab needs to be modified. Default is `root`.
* `minute` — The information to be set into the minute section. Default is `*`.
* `hour` — The information to be set in the hour section. Default is `*`.
* `daymonth` — The information to be set in the day of month section. Default is `*`.
* `month` — The information to be set in the month section. Default is `*`.
* `dayweek` — The information to be set in the day of week section. Default is `*`.

Example usage:

```yaml
cron:
    date > /tmp/date:
        user: root
        minute: random
        hour: 2
```

### iptables

A list of ports to open for connections. Example usage:

```yaml
port_allow:
    - 22
    - 443
    - 80
```

A list of ports to open from specific sources. Example usage:

```yaml
port_allow_from:
    8080:
        - 10.0.0.1
        - 10.0.0.2
    3306:
        - 10.0.0.3
```

A list of ports to rate-limit (max 3 hits within 30 seconds). Example usage:

```yaml
port_limit:
    - 22
```

### minions

A list of salt minions and their configured states. Example usage:

```yaml
minions:
    foo:
        - salt.master
        - web
        - dev
    bar:
        - db
```

### nginx

Configures nginx.

* `worker_processes` — How many worker threads to run. Default is `auto`.
* `worker_rlimit_nofile` — Maximum open file descriptors per process. Default is `768`.
* `worker_connections` — Maximum connections per process. Default is `640`.
* `keepalive` — How long to allow each connection to stay idle. Default is `20`.
* `gzip` — Enable or disable gzip compression. Default is `'on'`.
* `gzip_comp_level` — Gzip compression level. Default is `5`.
* `ssl_certificate` — Path to SSL certificate.
* `ssl_certificate_key` — Path to SSL certificate key.
* `mail` — Enable or disable mail configuration. Default is `False`.

Example usage:

```yaml
nginx:
    worker_processes: auto
    worker_rlimit_nofile: 8192
    worker_connections: 8000
    keepalive: 15
    gzip_comp_level: 6
    mail: True
```

### npm

A list of npm packages to install. Example usage:

```yaml
npm:
    - bower
    - grunt-cli
    - yo
```

### pagespeed

A list of [filters](https://developers.google.com/speed/pagespeed/module/filters)
to enable in PageSpeed. Example usage:

```yaml
pagespeed:
    - combine_javascript
    - inline_preview_images
    - lazyload_images
    - prioritize_critical_css
    - sprite_images
```

### php

Configures php.

* `max_execution_time` — The maximum time in seconds a script is allowed to run before it is terminated by the parser. Default is `25`.
* `max_file_uploads` — The maximum number of files allowed to be uploaded simultaneously. Default is `20`.
* `memory_limit` — The maximum amount of memory in bytes that a script is allowed to allocate. Default is `256M`.
* `post_max_size` — The maximum size of post data allowed. Default is `50M`.
* `upload_max_filesize` — The maximum size of an uploaded file. Default is `50M`.

Example usage:

```yaml
php:
    max_execution_time: 15
    max_file_uploads: 50
    memory_limit: 512M
```

### php-fpm

Configures php-fpm.

* `max_children` — The maximum number of child processes to be created. Default is `50`.
* `start_servers` — The number of child processes created on startup. Default is `10`.
* `min_spare_servers` — The desired minimum number of idle server processes. Default is `5`.
* `max_spare_servers` — The desired maximum number of idle server processes. Default is `20`.
* `max_requests` — The number of requests each child process should execute before respawning. Default is `500`.

Example usage:

```yaml
php-fpm:
    max_children: 75
    start_servers: 25
    min_spare_servers: 10
    max_spare_servers: 30
    max_requests: 750
```

### redis

Configures the redis server.

* `unix` — Whether or not to use Unix sockets. Default is `False`.
* `timeout` — How long to allow each connection to stay idle. Default is `30`.
* `keepalive` — Default is `20`.
* `databases` — The amount of databases per server. Default is `1`.
* `maxclients` — Maximum clients allowed. Default is `10000`.
* `maxmemory` — Maximum memory to be used per instance. Default is `2mb`.
* `maxmemory-policy` — Default is `volatile-lru`.
* `maxmemory-samples` — Default is `3`.
* `servers` — A list of redis instances to create.

Example usage:

```yaml
redis:
    unix: True
    timeout: 60
    keepalive: 30
    servers:
        - 6380
        - 6381
        - 6382
        - 6383
```

### salt

Configure salt.

* `master` — The address to the salt master server. Default is `salt`.
* `interface` — The address of the interface to bind to. Default is `0.0.0.0`.
* `state_verbose` — Default is `False`.
* `file_roots` — Default is `/srv/salt/states`.
* `pillar_roots` — Default is `/srv/salt/pillars`.

Example usage:

```yaml
salt:
    master: foobar.com
    state_verbose: True
```

### sites

A list of sites to enable.

* `default` — Make a site the default one. Default is `False`.
* `enable` — Whether to enable a site or not. Default is `False`.
* `aliases` — A list of site aliases.
* `php` — Whether to enable php or not. Default is `False`.
* `magento` — Whether to include settings for Magento or not. Default is `False`.
* `wordpress` — Whether to include settings for Wordpress or not. Default is `False`.

Example usage:

```yaml
sites:
    foo.com:
        default: True
        enable: True
        aliases:
            - www.foo.com
            - dev.foo.com
        php: True
        wordpress: True
    bar.com
        enable: True
        aliases:
            - www.bar.com
            - foo.bar.com
```

### system

Configures the system.

* `timezone` — Sets the timezone. Default is `Europe/Stockholm`.
* `locale` — Sets the locale. Default is `sv_SE.UTF-8`.

Example usage:

```yaml
system:
    timezone: Europe/Oslo
    locale: en_US.UTF-8
```

### twemproxy

Configures [twemproxy](https://github.com/twitter/twemproxy), also known as nutcracker. It will automatically add the redis servers for you.

* `listen` — Which adress to listen to. Could also be a Unix socket. Default is `127.0.0.1`.
* `port` — Which port to listen to. Default is `22121`.
* `hash` — Default is `fnv1a_64`.
* `hash_tag` — Default is `{}`.
* `distribution` — Default is `ketama`.
* `redis` — Whether to listen to redis or memcached. Default is `'false'`.
* `timeout` — The timeout value in msec that we wait for to establish a connection to the server or receive a response from a server. Default is `20000`.
* `auto_eject_hosts` — A boolean value that controls if server should be ejected temporarily when it fails consecutively server_failure_limit times. Default is `'false'`.
* `server_retry_timeout` — Default is `30000`.
* `server_failure_limit` — Default is `2`.

Example usage:

```yaml
twemproxy:
    listen: /tmp/twemproxy.sock
    redis: 'true'
    timeout: 100
    server_failure_limit: 1
```

### users

Adds and configures users.

* `home` — The path to the home directory. Default is `/home/[username]`.
* `shell` — The configured shell. Default is `/bin/bash`.
* `fullname` — Sets the users full name.
* `groups` — A list of groups assigned to the user.
* `ssh_auth` — A list of SSH keys assigned to the user.

Example usage:

```yaml
users:
    johndoe:
        fullname: John Doe
        shell: /bin/zsh
        groups:
            - admin
        ssh_auth:
            - ssh-rsa 123KJom945+
```

### varnish

Configures Varnish.

* `config` — The path to the config file. Default is `/etc/varnish/default.vcl`.
* `listen` — Which address Varnish listens to.
* `port` — Which port Varnish listens to. Default is `80`.
* `min_threads` — The minimum number of worker threads to start. Default is `1`.
* `max_threads` — The maximum number of worker threads to start. Default is `1000`.
* `thread_timeout` — Idle timeout for worker threads. Default is `120`.
* `storage_size` — Cache file size. Default is `1G`.

Example usage:

```yaml
varnish:
    config: /etc/varnish/foo.vcl
    max_threads: 500
    storage_size: 500mb
```

## License

[MIT License](http://en.wikipedia.org/wiki/MIT_License) (c) [Kevin Mårtensson](http://kevinmartensson.com)
