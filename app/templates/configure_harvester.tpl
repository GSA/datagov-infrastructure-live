#!/bin/bash

# configure production.ini
/usr/lib/ckan/bin/paster --plugin=ckan config-tool /etc/ckan/production.ini -e \
"db_user = ${db_user}" \
"db_pass = ${db_pass}" \
"db_server = ${db_server}" \
"db_database = ${db_database}" \
"solr_server = ${solr_server}" \
