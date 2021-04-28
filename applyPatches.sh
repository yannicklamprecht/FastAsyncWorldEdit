#!/bin/bash

set -euo pipefail

allPatchesDir="patches"

function applyPatches() {
  projectDir=${1}
  patchesDir="${allPatchesDir}"
  rm -r "${projectDir}" || true
  FILES=$(ls -R "${patchesDir}/${projectDir}" | awk '/:$/&&f{s=$0;f=0}/:$/&&!f{sub(/:$/,"");s=$0;f=1;next}NF&&f{ print s"/"$0 }')

  cp -R "WorldEdit/${projectDir}" "${projectDir}" || true

  for f in $FILES
  do
    if [ -d "${f}" ]; then
        continue
    fi
    mkdir -p "$(dirname "${f#patches/}")"
    echo "appying patch ${f}"
    git apply --intent-to-add -3 "${f}"
  done
}

cd "$(dirname $0)" || true

applyPatches "worldedit-bukkit"
applyPatches "worldedit-cli"
applyPatches "worldedit-core"
applyPatches "worldedit-fabric"
applyPatches "worldedit-core"
applyPatches "worldedit-forge"
applyPatches "worldedit-libs"
applyPatches "worldedit-mod"
