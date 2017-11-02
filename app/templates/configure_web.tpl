#!/bin/bash

# configure production.ini
/usr/lib/ckan/bin/paster --plugin=ckan config-tool /etc/ckan/production.ini -e \
"db_user = ${db_user}" \
"db_pass = ${db_pass}" \
"db_server = ${db_server}" \
"db_database = ${db_database}" \
"solr_server = ${solr_server}" \

# export some psql env vars
export PGHOST=${db_server}
export PGDATABASE=${db_database}
export PGUSER=${db_user}
export PGPASSWORD=${db_pass}

# install postgis
psql -c "create extension postgis;"
psql -c "create extension fuzzystrmatch;"
psql -c "create extension postgis_tiger_geocoder;"
psql -c "create extension postgis_topology;"
psql -c "alter schema tiger owner to rds_superuser;"
psql -c "alter schema tiger_data owner to rds_superuser;"
psql -c "alter schema topology owner to rds_superuser;"
psql -P pager=off -c 'CREATE FUNCTION exec(text) returns text language plpgsql volatile AS $f$ BEGIN EXECUTE $1; RETURN $1; END; $f$;'
psql -P pager=off -c "SELECT exec('ALTER TABLE ' || quote_ident(s.nspname) || '.' || quote_ident(s.relname) || ' OWNER TO rds_superuser;') \
  FROM ( \
    SELECT nspname, relname \
    FROM pg_class c JOIN pg_namespace n ON (c.relnamespace = n.oid) \
    WHERE nspname in ('tiger','topology') AND \
    relkind IN ('r','S','v') ORDER BY relkind = 'S') \
s;"

# initialize ckan dbs
ckan db init
ckan --plugin=ckanext-report report initdb
#chdir=/usr/lib/ckan/bin/ ./pycsw-ckan.py -c setup_db -f /etc/ckan/pycsw-all.cfg

# fix this aws ec2 weird issue: https://forums.aws.amazon.com/message.jspa?messageID=495274
echo "127.0.0.1 $(hostname)" >> /etc/hosts
service apache2 restart
