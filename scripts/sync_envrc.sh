#!/usr/bin/env bash
"""
Sync envrc to all target directories

I am primarily using this to activate
python virtual env. My virtualenv are in 
venv directory in evebry python last_opened_projec.

Ref https://github.com/direnv/direnv
"""
set -Eeuo pipefail

current_dir=$(pwd -P)

envrc="${current_dir}/envrc"

target_dir=$ENVRC_SYNC_TARGET_DIR


envrc="echo \"activating virtualenv\"\n
git rev-parse --show-toplevel | tee ~/.last_opened_project\n

if [[ -d ./venv ]] ; then\n
        source ./venv/bin/activate\n
        echo \"virtualenv activated\"\n
else\n
  echo \"Virtualenv not found\"\n
fi
"

for d in $target_dir; do
    echo -e $envrc >  "$d/.envrc"
    direnv allow "$d"
    echo  "Synced to $d"
done

echo "done!"

