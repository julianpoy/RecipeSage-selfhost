#!/bin/sh

docker-compose exec api tsx packages/backend/src/activate $@

