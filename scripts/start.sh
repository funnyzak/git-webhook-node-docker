  
#!/bin/ash

mkdir -p -m 0700 /root/.ssh
mkdir -p -m 0700 /app/code

# Disable Strict Host checking for non interactive git clones
rm -f /root/.ssh/config
echo -e "Host *\n\tStrictHostKeyChecking no\n" >> /root/.ssh/config

# SSH key
chmod 600 /root/.ssh/id_rsa

# Setup git variables
if [ ! -z "$GIT_EMAIL" ]; then
 git config --global user.email "$GIT_EMAIL"
fi
if [ ! -z "$GIT_NAME" ]; then
 git config --global user.name "$GIT_NAME"
 git config --global push.default simple
fi

# Dont pull code down if the .git folder exists
if [ ! -d "/app/code/.git" ];then
  # Pull down code form git for our site!
  if [ ! -z "$GIT_REPO" ]; then
    rm /app/code/*
    if [ ! -z "$GIT_BRANCH" ]; then
      git clone  --recursive -b $GIT_BRANCH $GIT_REPO /app/code/
      cd /app/code && git checkout $GIT_BRANCH
      git reset --hard origin/$GIT_BRANCH
    else
      git clone --recursive $GIT_REPO /app/code/
    fi
    chown -Rf root:root /app/code/*
  else
    # if git repo not defined, pull from default repo:
    git clone  --recursive -b production git@github.com:vuejs/vuepress.git /app/code/
    # remove git files
    rm -rf /app/code/.git
  fi
fi

chmod +x -R /custom_scripts

# Run any commands passed by env
eval "$STARTUP_COMMANDS"

# Custom scripts
source /usr/bin/run_scripts_on_startup.sh

if [ -n "$USE_HOOK" ]; then
    echo "start hook..."
    /go/bin/webhook -hooks /app/hook/hooks.json -verbose
else
    sh /app/hook/hook.sh
    while sleep 23h; do sh /app/hook/hook.sh; done
fi