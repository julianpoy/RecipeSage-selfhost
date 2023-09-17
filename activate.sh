#!/bin/sh

docker compose exec api npx ts-node --swc --project packages/backend/tsconfig.json packages/backend/src/activate $@

