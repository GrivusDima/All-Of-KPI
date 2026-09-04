#!/bin/bash
set -e
cd "$(dirname "$0")"
./sync-mods.sh
docker compose up -d
