#!/bin/bash
docker-compose -f app.yml pull
docker-compose -f app.yml up -d
