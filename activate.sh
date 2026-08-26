#!/bin/sh

docker compose exec api node dist/apps/cli/main.cjs activateBonusFeatures --email "$@"

