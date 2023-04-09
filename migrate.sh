#!/bin/sh

echo "Performing migrations. This could take up to 1 minute."

docker-compose exec api tsx packages/backend/src/migrate

echo "Migrations complete."

