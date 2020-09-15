#!/bin/bash
docker volume create docker_dbdata
docker run --rm -v docker_dbdata:/var/lib/postgresql/data -v $(pwd)/backups:/backups ubuntu bash -c "cd / && tar xvf /backups/dbdata1-backup.tar"

docker volume create docker_esdata
docker run --rm -v docker_esdata:/usr/share/elasticsearch/data -v $(pwd)/backups:/backups ubuntu bash -c "cd / && tar xvf /backups/esdata1-backup.tar"

docker volume create docker_ontologymanager-app
docker run --rm -v docker_ontologymanager-app:/var/lib/app/data -v $(pwd)/backups:/backups ubuntu bash -c "cd / && tar xvf /backups/ontology-app-backup.tar"