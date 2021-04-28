#!/bin/bash

set -euo pipefail

allPatchesDir="patches"

function makePatches() {
  projectDir=${1}
  patchesDir="${allPatchesDir}"
  rm -r "${patchesDir}/${projectDir}" || true
  FILES=$(ls -R "${projectDir}" | awk '/:$/&&f{s=$0;f=0}/:$/&&!f{sub(/:$/,"");s=$0;f=1;next}NF&&f{ print s"/"$0 }')

  commitId=$(git ls-files -s WorldEdit | awk '{print $2}')
  for f in $FILES
  do
    if [ -d "${f}" ] || [[ "${f}" = ${projectDir}/build/* ]]; then
        continue
    fi

    diffedContent=$(git diff --full-index --minimal "${commitId}"..head -- "${f}")
    if [[ ! -z "${diffedContent//}" ]]; then
      echo "creating patch for ${f}"
      mkdir -p "${patchesDir}/$(dirname "$f")"
      echo "${diffedContent}" > "${patchesDir}/${f}.patch"
    fi
  done
}

cd "$0" || true

makePatches "worldedit-bukkit"
makePatches "worldedit-cli"
makePatches "worldedit-core"
makePatches "worldedit-fabric"
makePatches "worldedit-sponge"
makePatches "worldedit-forge"
makePatches "worldedit-libs"
makePatches "worldedit-mod"
