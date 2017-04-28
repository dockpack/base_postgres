#!/bin/bash -xe
# run as root to clone master database

cd /tmp
echo Stopping PostgreSQL
service postgresql-{{ base_postgres_m }} stop

echo Cleaning up old cluster directory
su - postgres -c "rm -rf /var/lib/pgsql/{{ base_postgres_m }}/data/*"

echo Starting base backup as replicator
su - postgres -c "pg_basebackup -w -h {{ base_postgres_mip }} -D /var/lib/pgsql/{{ base_postgres_m }}/data -X stream -U replicator -v -P"

echo Writing recovery.conf file
su - postgres -c "cat > /var/lib/pgsql/{{ base_postgres_m }}/data/recovery.conf <<- EOF
standby_mode = 'on'
primary_conninfo = 'host={{ base_postgres_mip }} port={{ base_postgres_port }} user=replicator password={{ base_postgres_pass }}'
trigger_file = '/tmp/postgresql.trigger'
EOF
"
chmod 600 /var/lib/pgsql/{{ base_postgres_m }}/data/recovery.conf

echo Starting PostgreSQL
service postgresql-{{ base_postgres_m }} start
