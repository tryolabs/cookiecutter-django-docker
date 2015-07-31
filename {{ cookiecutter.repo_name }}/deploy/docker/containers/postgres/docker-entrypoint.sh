#!/bin/bash

#
# Adapted from official script at https://github.com/docker-library/postgres
#
set -e

POSTGRESQL_DB=${POSTGRESQL_DB:-"{{ cookiecutter.postgresql_local_db_user }}"}
POSTGRESQL_USER=${POSTGRESQL_USER:-"{{ cookiecutter.postgresql_local_db_name }}"}
POSTGRESQL_PASS=${POSTGRESQL_PASS:-"{{ cookiecutter.postgresql_local_db_password }}"}
POSTGRESQL_SINGLE="gosu postgres postgres --single"

if [ "$1" = 'postgres' ]; then
    chown -R postgres "$PGDATA"

    if [ -z "$(ls -A "$PGDATA")" ]; then
        gosu postgres initdb

        sed -ri "s/^#(listen_addresses\s*=\s*)\S+/\1'*'/" "$PGDATA"/postgresql.conf

        # Optimize for speed, turn off fsync and full_page_writes
        sed -ri "s/^#(fsync\s*=\s*)\S+/\1off/" "$PGDATA"/postgresql.conf
        sed -ri "s/^#(full_page_writes\s*=\s*)\S+/\1off/" "$PGDATA"/postgresql.conf

        { echo; echo 'host all all 0.0.0.0/0 trust'; } >> "$PGDATA"/pg_hba.conf

        # Setup user and DB
        # CREATEDB permissions are so unit tests can create their DB
        $POSTGRESQL_SINGLE <<< "CREATE USER \"$POSTGRESQL_USER\";"
        $POSTGRESQL_SINGLE <<< "ALTER USER \"$POSTGRESQL_USER\" WITH PASSWORD \"$POSTGRESQL_PASS\";"
        $POSTGRESQL_SINGLE <<< "ALTER USER \"$POSTGRESQL_USER\" CREATEDB;"

        # Actual DB creation
        $POSTGRESQL_SINGLE <<< "CREATE DATABASE \"$POSTGRESQL_DB\" OWNER \"$POSTGRESQL_USER\" ENCODING 'UTF-8' LC_COLLATE 'en_US.utf8' LC_CTYPE 'en_US.utf8' TEMPLATE template0;"
    fi

    exec gosu postgres "$@"
fi

exec "$@"
