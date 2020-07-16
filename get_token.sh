#!/usr/bin/env bash
# 
# This script will request a token from the keycloak server 
#
# Author: Michael Thorsager <thorsager@gmail.com>
#
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
# shellcheck source=.env
. "${DIR}/.env"

USAGE="Usage: $(basename "$0") [-f] [-a] [-r]"

while getopts ":arf" opt; do
  case ${opt} in
    a)
      PRINT_AT=true
      ;;
    r)
      PRINT_RT=true
      ;;
    f)
      PRINT_FULL=true
      ;;
    \?) echo "$USAGE"
      ;;
  esac
done

if [ -z "$PRINT_AT" ] && [ -z "$PRINT_RT" ] && [ -z "$PRINT_FULL" ]; then
  echo "$USAGE"
  exit 1
fi

T=$(curl -s \
  -d "client_id=$CLIENT_ID" -d "client_secret=$CLIENT_SECRET" \
  -d "username=$USERNAME" -d "password=$PASSWORD" \
  -d "grant_type=password" \
  "$KC_HOST/auth/realms/$KC_REALM/protocol/openid-connect/token")


if [ -n "$PRINT_FULL" ]; then
  echo "$T"
fi

if [ -n "$PRINT_AT" ]; then
  echo "$T" | jq '.access_token' | sed -e 's/"//g'
fi

if [ -n "$PRINT_RT" ]; then
  echo "$T" | jq '.refresh_token' | sed -e 's/"//g'
fi
