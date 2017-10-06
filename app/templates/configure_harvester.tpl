#!/bin/bash

# configure production.ini
/usr/lib/ckan/bin/paster --plugin=ckan config-tool /etc/ckan/production.ini -e \
"db_user = ${db_user}" \
"db_pass = ${db_pass}" \
"db_server = ${db_server}" \
"db_database = ${db_database}" \
"solr_server = ${solr_server}" \

# install postgis

# initialize the dbs
#ckan db init
#ckan --plugin=ckanext-report report initdb
#/usr/lib/ckan/bin/ ./pycsw-ckan.py -c setup_db -f /etc/ckan/pycsw-all.cfg
