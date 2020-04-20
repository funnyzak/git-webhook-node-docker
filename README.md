# Git Webhook Node Docker

Pull your nodejs project git code into a data volume and trigger node event via Webhook.

[![Docker Stars](https://img.shields.io/docker/stars/funnyzak/git-webhook-node.svg?style=flat-square)](https://hub.docker.com/r/funnyzak/git-webhook-node/)
[![Docker Pulls](https://img.shields.io/docker/pulls/funnyzak/git-webhook-node.svg?style=flat-square)](https://hub.docker.com/r/funnyzak/git-webhook-node/)

This image is based on Alpine Linux image, which is a 166MB image.

Download size of this image is:

[![](https://images.microbadger.com/badges/image/funnyzak/git-webhook-node.svg)](http://microbadger.com/images/funnyzak/git-webhook-node)

[Docker hub image: funnyzak/git-webhook-node](https://hub.docker.com/r/funnyzak/git-webhook-node)

Docker Pull Command: `docker pull funnyzak/git-webhook-node`

Webhook Url: [http://hostname:9000/hooks/git-webhook?token=HOOK_TOKEN](#)

---

## Environment

* go
* nodejs
* npm
* yarn
* openssh
* zip
* tar
* wget
* rsync
* git
* curl
* bash

---
  
## Available Parameters

The following flags are a list of all the currently supported options that can be changed by passing in the variables to docker with the -e flag.

* **USE_HOOK** : The web hook is enabled as long as this is present.
* **HOOK_TOKEN** : Custom hook security tokens, strings.
* **GIT_REPO** : url to the repository containing your source code.
* **GIT_BRANCH** : Select a branch for clone and auto hook match.
* **GIT_EMAIL** : Set your email for git (required for git to work)
* **GIT_NAME** : Set your name for git (required for git to work)
* **STARTUP_COMMANDS** : Optional. Add any commands that will be run at the end of the start.sh script. left blank, will not execute.
* **AFTER_PULL_COMMANDS** : Optional. Add any commands that will be run after pull. left blank, will not execute.
* **BEFORE_PULL_COMMANDS** : Optional. Add any commands that will be run before pull. left blank, will not execute.
---

## Volume

* **/app/code** : git source code dir. docker work dir.
* **/root/.ssh** :  If it is a private repository, please set ssh key
* **/custom_scripts/on_startup** :  which the scripts are executed at startup, traversing all the scripts and executing them sequentially
* **/custom_scripts/before_pull** :  which the scripts are executed at before pull
* **/custom_scripts/after_pull** :  which the scripts are executed at after pull

### ssh-keygen

`ssh-keygen -t rsa -b 4096 -C "youremail@gmail.com" -N "" -f ./id_rsa`

---

## Docker-Compose

 ```docker
version: '3'
services:
  hookserver:
    image: funnyzak/git-webhook-node
    privileged: true
    container_name: git-hook
    working_dir: /app/code
    logging:
      driver: 'json-file'
      options:
        max-size: '1g'
    tty: true
    environment:
      - TZ=Asia/Shanghai
      - LANG=C.UTF-8
      - USE_HOOK=1
      - HOOK_TOKEN=hello
      - GIT_REPO=https://github.com/vuejs/vuepress.git
      - GIT_BRANCH=master
      - GIT_EMAIL=youremail
      - GIT_NAME=yourname
      - STARTUP_COMMANDS=echo "STARTUP_COMMANDS helllo"
      - AFTER_PULL_COMMANDS=echo "AFTER_PULL_COMMANDS hello"
      - BEFORE_PULL_COMMANDS=echo "AFTER_PULL_COMMANDS hello"
    restart: on-failure
    ports:
      - 1001:9000
    volumes:
      - ./custom_scripts:/custom_scripts
      - ./code:/app/code
      - ./ssh:/root/.ssh

 ```
