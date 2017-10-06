#!/bin/bash

while ! nc -w 1 -z 127.0.0.1 8080; do sleep 1; done

curl 'http://127.0.0.1:8080/solr/admin/cores?action=CREATE&name=catalog&instanceDir=/home/solr/catalog&config=/home/solr/catalog/conf/solrconfig.xml&schema=/home/solr/catalog/conf/schema.xml&dataDir=home/solr/catalog'

