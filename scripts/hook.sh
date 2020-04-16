#!/bin/ash

cd /app/code

echo "git pull code before command do..." 
eval "$BEFORE_PULL_COMMANDS"

echo "git pull code before shell do..." 
source /usr/bin/run_scripts_before_pull.sh

echo "git pull code ..." 
git pull
echo "git pull code end."

echo "git pull code after command do..." 
eval "$AFTER_PULL_COMMANDS"

echo "git pull code after shell do..." 
source /usr/bin/run_scripts_after_pull.sh

