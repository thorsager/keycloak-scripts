# Keycloak Token Testing
These are some scripts that I have found useful when testing interactions with
[keycloak](https://www.keycloak.org) servers.

It only uses `curl`, `jq` and `bash`, and is configured using ENV vars. The 
scripts will read a `.env` file located in the same dir as the scripts.

And well the scripts does not do much, except get tokens and do introspection
on the tokens, but the [get_token.sh](get_token.sh) script could be used as a
base for doing other scripting, using it in the same way 
[introspect_token.sh](introspect_token.sh_) does

`.env` file:
```
CLIENT_ID=<cliet-id>
CLIENT_SECRET=<client-secret>
USERNAME=<username>
PASSWORD=<password>
KC_HOST=https://your.keycloak.server
KC_REALM=<your-auth-realm>

## This is the client credentials used when doing "token introspection"
INTROSPECT_CLIENT_ID=<client-id>
INTROSPECT_CLIENT_SECRET=<client-id.>
```
