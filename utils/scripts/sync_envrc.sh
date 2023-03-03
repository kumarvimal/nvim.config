#!/usr/bin/env bash

set -Eeuo pipefail

current_dir=$(pwd -P)

envrc="${current_dir}/envrc"

target_dir=$ENVRC_SYNC_TARGET_DIR


for d in $target_dir; do
   # [ -e "$file" ] || continue
    cp "$envrc" "$d/.envrc"
    direnv allow "$d"
    echo  "Synced to $d"
done

echo "done!"

