#!/bin/bash

####################################################################################################
# VARIABLES
####################################################################################################
CONTAINER_NAME=$1
DOMAIN=$2

# check for container name
if [ -z "${CONTAINER_NAME}" ]; then
  echo "missing container name"
  echo "Usage: ./cronjob.sh container_name domain_name"
  echo "Eg: ./cronjob.sh napi_proxy notionalapi.net"
  exit
fi

# check for domain name
if [ -z "${DOMAIN}" ]; then
  echo "missing domain name"
  echo "Usage: ./cronjob.sh container_name domain_name"
  echo "Eg: ./cronjob.sh napi_proxy notionalapi.net"
  exit
fi

# Install cronnie on archlinux
pacman -Syyu --noconfirm
pacman -Sy cronie --noconfirm

# Enable cronnie on archlinux
systemctl enable cronie
systemctl start cronie

# Add new cronjob
rm -rf $HOME/cron/*
mkdir -p $HOME/cron
cp -f ./certbot-renew.sh $HOME/cron/certbot-renew

# Your task here
echo "Task is running at $(date)"

# Calculate the next run date (30 days from now)
NEXT_RUN_DATE=$(date -d "30 days" "+%Y-%m-%d %H:%M:%S")

# Convert next run date to cron format
NEXT_RUN_CRON=$(date -d "$NEXT_RUN_DATE" "+%M %H %d %m *")

# Schedule the next run
(crontab -l ; echo "$NEXT_RUN_CRON /bin/sh $HOME/cron/certbot-renew.sh $CONTAINER_NAME $DOMAIN") | crontab -

echo "Next run scheduled for $NEXT_RUN_DATE"
