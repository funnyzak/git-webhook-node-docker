# Git Webhook Node Docker

Pull your nodejs project git code into a data volume and trigger node event via Webhook.

[![Docker Stars](https://img.shields.io/docker/stars/funnyzak/git-webhook-node.svg?style=flat-square)](https://hub.docker.com/r/funnyzak/git-webhook-node/)
[![Docker Pulls](https://img.shields.io/docker/pulls/funnyzak/git-webhook-node.svg?style=flat-square)](https://hub.docker.com/r/funnyzak/git-webhook-node/)

This image is based on Alpine Linux image, which is a 163MB image.

Download size of this image is:

[![](https://images.microbadger.com/badges/image/funnyzak/git-webhook-node.svg)](http://microbadger.com/images/funnyzak/git-webhook-node)

[Docker hub image: funnyzak/git-webhook-node](https://hub.docker.com/r/funnyzak/git-webhook-node)

Docker Pull Command: `docker pull funnyzak/git-webhook-node`

Webhook Url: http://hostname:9000/hooks/git-webhook-node

---

## Available Configuration Parameters

The following flags are a list of all the currently supported options that can be changed by passing in the variables to docker with the -e flag.

- **GIT_REPO** : URL to the repository containing your source code
- **GIT_BRANCH** : Select a specific branch (optional)
- **GIT_EMAIL** : Set your email for code pushing (required for git to work)
- **GIT_NAME** : Set your name for code pushing (required for git to work)
- **STARTUP_COMMANDS** : Add any commands that will be run at the end of the start.sh script
- **AFTER_PULL_COMMANDS** : Add any commands that will be run after pull
- **BEFORE_PULL_COMMANDS** : Add any commands that will be run before pull

## Volume Configuration

 - **/app/code** : vuepress output dir.
 - **/root/.ssh** :  If it is a private repository, please set ssh key

#### ssh-keygen

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
      - GIT_REPO=https://github.com/vuejs/vuepress.git
      - GIT_BRANCH=master
      - GIT_EMAIL=youremail
      - GIT_NAME=yourname
      - STARTUP_COMMANDS=echo \"STARTUP_COMMANDS helllo\"
      - AFTER_PULL_COMMANDS=echo \"AFTER_PULL_COMMANDS hello\"
      - BEFORE_PULL_COMMANDS=echo \"AFTER_PULL_COMMANDS hello\"
    restart: on-failure
    ports:
      - 1001:9000
    volumes:
      - ./custom_scripts:/custom_scripts
      - ./code:/app/code # source code dir. Will automatically pull the code.
      - ./ssh:/root/.ssh # If it is a private repository, please set ssh key

 ```
