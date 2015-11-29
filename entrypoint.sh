#!/usr/bin/env bash

set -ex

SRC_ROOT='/var/www/html'
CONF_TEMPLATE="$SRC_ROOT/conf/config.inc.php.docker"
CONF_FILE="$SRC_ROOT/conf/config.inc.php"

# Overring config file with config template for docker image.
cp -f $CONF_TEMPLATE $CONF_FILE

# Reading parameters from environment.
LDAP_URL="${LDAP_URL:-}"
LDAP_BINDDN="${LDAP_BINDDN:-}"
LDAP_BINDPW="${LDAP_BINDPW:-}"
LDAP_BASE="${LDAP_BASE:-}"
LDAP_LOGIN_ATTRIBUTE="${LDAP_LOGIN_ATTRIBUTE:-uid}"
LDAP_FULLNAME_ATTRIBUTE="${LDAP_FULLNAME_ATTRIBUTE:-cn}"
LDAP_FILTER="${LDAP_FILTER:-(&(objectClass=person)(\$ldap_login_attribute={login}))}"

if [[ -z "$LDAP_URL" ]]; then
    echo "LDAP_URL is required."
    exit 1
fi

if [[ -z "$LDAP_BINDDN" ]]; then
    echo "LDAP_BINDDN is required."
    exit 1
fi

if [[ -z "$LDAP_BINDPW" ]]; then
    echo "LDAP_BINDPW is required."
    exit 1
fi

if [[ -z "$LDAP_BASE" ]]; then
    echo "LDAP_BASE is required."
    exit 1
fi

sed -e 's#{{LDAP_URL}}#'"${LDAP_URL}"'#g' \
    -e 's/{{LDAP_BINDDN}}/'"${LDAP_BINDDN}"'/g' \
    -e 's|{{LDAP_BINDPW}}|'"${LDAP_BINDPW}"'|g' \
    -e 's/{{LDAP_BASE}}/'"${LDAP_BASE}"'/g' \
    -e 's/{{LDAP_LOGIN_ATTRIBUTE}}/'"${LDAP_LOGIN_ATTRIBUTE}"'/g' \
    -e 's/{{LDAP_FULLNAME_ATTRIBUTE}}/'"${LDAP_FULLNAME_ATTRIBUTE}"'/g' \
    -e 's/{{LDAP_FILTER}}/'"${LDAP_FILTER}"'/g' \
    -i $CONF_FILE

exec "$@"
