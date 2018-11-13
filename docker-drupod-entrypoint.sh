#!/bin/sh
set -e

if ($ENABLE_XDEBUG); then
  docker-php-ext-enable xdebug
  { \
    echo '[xdebug]'; \
    echo 'xdebug.remote_enable = 1'; \
    echo 'xdebug.remote_autostart = 1'; \
    echo 'xdebug.remote_connect_back = 1'; \
    echo 'xdebug.remote_port = 9090'; \
    echo 'xdebug.remote_log = /tmp/xdebug.log'; \
  } | tee /usr/local/etc/php/conf.d/xdebug.ini
fi

exec docker-php-entrypoint "$@"
