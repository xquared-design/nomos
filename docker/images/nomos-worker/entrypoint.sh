#!/bin/bash

## Import environment
{
 echo "<?php "
 env | grep "NOMOS_" | while read envline;
 do
  key=${envline%=*}
  value=`printenv $key`
  echo "define('$key', '$value');"
 done
} > /www/conf/env.php

## Run migration script
cd /www/tools
/usr/bin/php7.0 migrate.php

## Start php-fpm7.0
/usr/sbin/php-fpm7.0 -F --fpm-config /etc/php/7.0/fpm/php-fpm.conf
