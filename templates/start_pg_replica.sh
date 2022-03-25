#!/bin/bash -xe
# run as root to clone master database

cd /tmp
echo Stopping PostgreSQL
systemctl stop {{ base_postgres_service }}

echo Cleaning up old cluster directory
su - postgres -c "rm -rf {{ base_postgres_pgdata }}/*"

echo Starting base backup as replicator
su - postgres -c "pg_basebackup -w -h {{ base_postgres_mip }} -D {{ base_postgres_pgdata }} -X stream -U replicator -v -P"

echo Writing recovery.conf file
su - postgres -c "cat > {{ base_postgres_pgdata }}/recovery.conf <<- EOF
standby_mode = 'on'
primary_conninfo = 'host={{ base_postgres_mip }} port={{ base_postgres_port }} user=replicator password={{ base_postgres_pass }}'
trigger_file = '/tmp/postgresql.trigger'
EOF
"
chmod 600 {{ base_postgres_pgdata }}/recovery.conf

echo Starting PostgreSQL
systemctl start {{ base_postgres_service }}
