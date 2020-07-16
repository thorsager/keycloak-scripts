#!/usr/bin/env bash
#
# This script will do introspection on an "access-toke".
# If no access-token is passed to it, it will request a new token 
# using the get-token.sh and perform introspection on it.
#
# Author: Michael Thorsager <thorsager@gmail.com>
#
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
# shellcheck source=.env
. "${DIR}/.env"

USAGE="Usage: $(basename "$0") [-a <access-token>]"

while getopts ":a:" opt; do
  case ${opt} in
    a)
      ACCESS_TOKEN=$OPTARG
      ;;
    \?) 
		echo "$USAGE"
		exit 1;
      ;;
  esac
done

if [[ -z "$ACCESS_TOKEN" ]] ; then
	echo "* Creating accesstoken to introspect" 2>&1
	ACCESS_TOKEN=$("$DIR"/get_token.sh -a)
fi
curl -sq -X POST \
	--user "$INTROSPECT_CLIENT_ID:$INTROSPECT_CLIENT_SECRET" \
    -H "Content-Type: application/x-www-form-urlencoded" \
    -d "token_type_hint=requesting_party_token&token=${ACCESS_TOKEN}" \
    "${KC_HOST}/auth/realms/${KC_REALM}/protocol/openid-connect/token/introspect" | jq
