#!/bin/bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SRC_MODS="${SCRIPT_DIR}/../modpack/minecraft/mods"
DEST_MODS="${SCRIPT_DIR}/data/mods"

BANLIST=(
  "AdvancementPlaques"
  "BadOptimizations"
  "BetterAdvancements"
  "CameraOverhaul"
  "Controlling"
  "Highlighter"
  "ImmediatelyFast"
  "ImmersiveUI"
  "Ixeris"
  "JustEnoughResources"
  "Kerria"
  "KeybindAtlas"
  "Mod Menu"
  "MouseTweaks"
  "Northstar-StellarView-Compatibility"
  "Prism-"
  "Searchables"
  "SimpleRPC"
  "Stellar.View"
  "aeronautics_windsound"
  "animatedmojanglogo"
  "better-clouds"
  "bettercombat-punchy-fix"
  "borderless"
  "chat_heads"
  "chatanimation"
  "chunksfadein"
  "coolrain"
  "create-dyn-light"
  "create_train_perspective"
  "createbetterfps"
  "defaultoptions"
  "dynamiccrosshair"
  "eatinganimation"
  "elytra_physics"
  "emf_compat_better_combat"
  "emf_compat_core"
  "emf_compat_create"
  "emf_compat_not_enough_animations"
  "enchdesc"
  "enhancedbossbars"
  "entity_model_features"
  "entity_sound_features"
  "entity_texture_features"
  "entityculling"
  "fallingleaves"
  "fape_compat"
  "immersivethunder"
  "iris-neoforge"
  "ismah-"
  "mace3d"
  "modelfix"
  "moreculling"
  "northstar-sable-iris-horizon-bridge"
  "notenoughanimations"
  "nowheel"
  "obscure_tooltips"
  "particle_effects"
  "particular-"
  "punchy-"
  "reeses-sodium-options"
  "satisfying_buttons"
  "shulkerboxtooltip"
  "sodium-neoforge"
  "sodiumdynamiclights"
  "sound-physics-remastered"
  "stellarview_mixin_renderer"
  "tidybinds"
  "visualhealth"
  "wakes-"
  "where_winds_blow"
  "windy-"
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
