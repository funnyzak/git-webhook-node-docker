#!/bin/ash

cd /app/code

echo "git pull code before event do" 
source /usr/bin/run_scripts_before_pull.sh
# Run any commands passed by env
eval "$BEFORE_PULL_COMMANDS"

echo "git pull code ..." 
git pull
echo "git pull code end."

echo "git pull code after event do" 
source /usr/bin/run_scripts_after_pull.sh
# Run any commands passed by env
eval "$AFTER_PULL_COMMANDS"

