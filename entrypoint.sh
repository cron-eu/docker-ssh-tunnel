#!/usr/bin/env sh
set -e

USER_HOME=$(eval echo "~root")

# Import SSH user settings from env

if [ ! -z "${SSH_CONFIG}" ]; then
  echo "* Configuring .ssh/config"
  mkdir -p $USER_HOME/.ssh
  echo "${SSH_CONFIG}" > $USER_HOME/.ssh/config
  chmod 644 $USER_HOME/.ssh/config
fi
if [ ! -z "${SSH_KNOWN_HOSTS}" ]; then
  echo "* Configuring .ssh/known_hosts"
  mkdir -p $USER_HOME/.ssh
  echo "${SSH_KNOWN_HOSTS}" > $USER_HOME/.ssh/known_hosts
  chmod 644 $USER_HOME/.ssh/known_hosts
fi
if [ ! -z "${SSH_PRIVATE_KEY}" ]; then
  echo "* Configuring .ssh/id_rsa"
  mkdir -p $USER_HOME/.ssh
  echo "${SSH_PRIVATE_KEY}" > $USER_HOME/.ssh/id_rsa
  chmod 600 $USER_HOME/.ssh/id_rsa
fi

exec ssh -4 -g -i $USER_HOME/.ssh/id_rsa -Nn ${TUNNEL_HOST}
