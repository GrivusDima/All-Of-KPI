#!/bin/bash
set -euo pipefail

SRC_MODS="/repo-mods"
DEST_MODS="/data/mods"

#TODO: find all client-side mods and include them here
BANLIST=(
  "mod1"
  "mod2"
  "mod3"
)

if [ ! -d "$SRC_MODS" ]; then
  echo "ERROR: source mods dir not found at ${SRC_MODS}"
  exit 1
fi

mkdir -p "$DEST_MODS"

echo "Syncing mods from ${SRC_MODS} to ${DEST_MODS}..."
rsync -a --delete "${SRC_MODS}/" "${DEST_MODS}/"

echo "Applying banlist..."
removed=0
for modfile in "${DEST_MODS}"/*.jar; do
  [ -e "$modfile" ] || continue
  fname="$(basename "$modfile")"

  for banned in "${BANLIST[@]}"; do
    if grep -qi -- "$banned" <<<"$fname"; then
      echo "  removing (matched '${banned}'): ${fname}"
      rm -f "$modfile"
      removed=$((removed + 1))
      break
    fi
  done
done

total=$(find "$DEST_MODS" -maxdepth 1 -name '*.jar' | wc -l)
echo "Done. Removed ${removed} banned mod(s). ${total} mod(s) remain."
