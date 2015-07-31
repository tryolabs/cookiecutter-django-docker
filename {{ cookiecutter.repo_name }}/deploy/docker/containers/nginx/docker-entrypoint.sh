#!/bin/bash -e
if [ -n "$NGINX_ON_DEVELOPMENT" ]
then
    # Put host's IP in /etc/hosts so nginx can use it as server_name.
    echo "$(ip route|awk '/default/ { print $3 }') {{ cookiecutter.local_hosts_name }}" >> /etc/hosts
fi

cd /templates
j2 nginx.conf.j2 > /etc/nginx/nginx.conf
cd /etc/

exec "$@"
