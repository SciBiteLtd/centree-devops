#!/bin/bash
docker run --rm --volumes-from docker_ontologymanager-postgresql_1 -v $(pwd):/backup ubuntu tar cvf /backup/dbdata1-backup.tar /var/lib/postgresql/data/
docker run --rm --volumes-from docker_ontologymanager-elasticsearch_1 -v $(pwd):/backup ubuntu tar cvf /backup/esdata1-backup.tar /usr/share/elasticsearch/data
docker run --rm --volumes-from docker_ontologymanager-app_1 -v $(pwd):/backup ubuntu tar cvf /backup/ontology-app-backup.tar /var/lib/app/data/