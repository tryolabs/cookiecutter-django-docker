#!/bin/bash -e
DOCKER_HOST_IP=$(ip route|awk '/default/ { print $3 }')

if [ -n "$WAIT_FOR_PG" ]
then
    echo "Waiting for PG to be up..."
    while ! nc -w 1 postgres $POSTGRES_PORT_5432_TCP_PORT 2>/dev/null
    do
        echo -n .
        sleep 1
    done
fi

cd /django
exec "$@"
