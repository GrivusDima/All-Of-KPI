#!/bin/bash
set -e
cd "$(dirname "$0")"
./00-rsync-mods.sh
docker compose up -d
