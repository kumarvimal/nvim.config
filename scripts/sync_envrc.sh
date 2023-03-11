#!/usr/bin/env bash
# Ref https://github.com/direnv/direnv
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
dirs=$ENCRC_SYNC_TARGET_DIRS # csv of directory patterns, e.g a/*,b/c/pre*

for target_dir in ${dirs//,/ }
do
  for d in $target_dir; do
      venv="$d/venv"
      if [ -d "$venv" ]; then 
        if [ ! -L "$venv" ]; then
          # sync if directory is not a symlink 
          # and a 'venv' directory exist 
          echo "* syncing:  $d"
          echo -e $envrc >  "$d/.envrc"
          direnv allow "$d"
        fi
      fi
        done
done

echo "done!"

