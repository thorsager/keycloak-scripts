#!/usr/bin/env bash
#
# This script will request an "access-token" using a current "refresh-
# token".
# If no "refresh-token" is passed to it, it will try to create a new
# using the get-token.sh script.
#
# Author: Michael Thorsager <thorsager@gmail.com>
#
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
# shellcheck source=./../../.env
. "${DIR}/.env"

USAGE="Usage: $(basename "$0") [-f] [-a] [-r] [-c <refresh-token>]"

while getopts ":arfc:" opt; do
	case ${opt} in
	c)
		REFRESH_TOKEN=$OPTARG
		;;
	a)
		PRINT_AT=true
		;;
	r)
		PRINT_RT=true
		;;
	f)
		PRINT_FULL=true
		;;
	\?) 
		echo "$USAGE"
		exit 1;
		;;
	esac
done

if [ -z "$PRINT_AT" ] && [ -z "$PRINT_RT" ] && [ -z "$PRINT_FULL" ]; then
  echo "$USAGE"
  exit 1
fi

if [[ -z "$REFRESH_TOKEN" ]]; then 
	echo "* Creating refreshtoken"
	REFRESH_TOKEN=$("$DIR"/get_token.sh -r)
fi

T=$(curl -qs --user "$CLIENT_ID:$CLIENT_SECRET" \
	-d "grant_type=refresh_token&refresh_token=$REFRESH_TOKEN" \
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
