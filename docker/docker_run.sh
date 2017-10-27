#!/bin/bash

# Import environment
docker_env_config.sh > /www/conf/env.php

# Run migration script
cd /www
/usr/bin/php7.0 tools/migrate.php

/usr/sbin/php-fpm7.0 -F --fpm-config /etc/php/7.0/fpm/php-fpm.conf
