#!/usr/bin/env bash
"""
Sync envrc to all target directories

I am primarily using this to activate
python virtual env. My virtualenv are in 
venv directory in evebry python last_opened_projec.

Ref https://github.com/direnv/direnv
"""
set -Eeuo pipefail

envrc="echo \"activating virtualenv\"\n
git rev-parse --show-toplevel | tee ~/.last_opened_project\n

if [[ -d ./venv ]] ; then\n
        source ./venv/bin/activate\n
        echo \"virtualenv activated\"\n
else\n
  echo \"Virtualenv not found\"\n
fi
"
dirs=$ENCRC_SYNC_TARGET_DIRS
# e.g /user/home/dev/comp/prefix-*,user/home/dev/dir/*

for target_dir in ${dirs//,/ }
do
  for d in $target_dir; do
      echo -e $envrc >  "$d/.envrc"
      direnv allow "$d"
      echo  "Synced to $d"
  done
done

echo "done!"

