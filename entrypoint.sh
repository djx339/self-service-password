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
LDAP_FILTER="${LDAP_FILTER:-\(\&\(objectClass=person\)\(\$ldap_login_attribute=\{login\}\)\)}"

AD_MODE="${AD_MODE:-false}"
AD_FORCE_UNLOCK="${AD_FORCE_UNLOCK:-false}"
AD_FORCE_PWD_CHANGE="${AD_FORCE_PWD_CHANGE:-false}"
SAMBA_MODE="${SAMBA_MODE:-false}"

PWD_HASH="${PWD_HASH:-clear}"
PWD_MIN_LENGTH="${PWD_MIN_LENGTH:-8}"
PWD_MAX_LENGTH="${PWD_MAX_LENGTH:-32}"
PWD_MIN_LOWER="${PWD_MIN_LOWER:-0}"
PWD_MIN_UPPER="${PWD_MIN_UPPER:-0}"
PWD_MIN_DIGIT="${PWD_MIN_DIGIT:-0}"
PWD_MIN_SPECIAL="${PWD_MIN_SPECIAL:-0}"
PWD_NO_REUSE="${PWD_NO_REUSE:-true}"
PWD_COMPLEXITY="${PWD_COMPLEXITY:-0}"
PWD_SHOW_POLICY="${PWD_SHOW_POLICY:-never}"

SMTP_HOST="${SMTP_HOST:-}"
SMTP_PORT="${SMTP_PORT:-25}"
SMTP_AUTH="${SMTP_AUTH:-false}"
SMTP_USERNAME="${SMTP_USERNAME:-x}"
SMTP_PASSWORD="${SMTP_PASSWORD:-x}"


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
    -e 's/{{AD_MODE}}/'"${AD_MODE}"'/g' \
    -e 's/{{AD_FORCE_UNLOCK}}/'"${AD_FORCE_UNLOCK}"'/g' \
    -e 's/{{AD_FORCE_PWD_CHANGE}}/'"${AD_FORCE_PWD_CHANGE}"'/g' \
    -e 's/{{SAMBA_MODE}}/'"${SAMBA_MODE}"'/g' \
    -e 's/{{PWD_HASH}}/'"${PWD_HASH}"'/g' \
    -e 's/{{PWD_MIN_LENGTH}}/'"${PWD_MIN_LENGTH}"'/g' \
    -e 's/{{PWD_MAX_LENGTH}}/'"${PWD_MAX_LENGTH}"'/g' \
    -e 's/{{PWD_MIN_LOWER}}/'"${PWD_MIN_LOWER}"'/g' \
    -e 's/{{PWD_MIN_UPPER}}/'"${PWD_MIN_UPPER}"'/g' \
    -e 's/{{PWD_MIN_DIGIT}}/'"${PWD_MIN_DIGIT}"'/g' \
    -e 's/{{PWD_MIN_SPECIAL}}/'"${PWD_MIN_SPECIAL}"'/g' \
    -e 's/{{PWD_NO_REUSE}}/'"${PWD_NO_REUSE}"'/g' \
    -e 's/{{PWD_COMPLEXITY}}/'"${PWD_COMPLEXITY}"'/g' \
    -e 's/{{PWD_SHOW_POLICY}}/'"${PWD_SHOW_POLICY}"'/g' \
    -e 's/{{SMTP_HOST}}/'"${SMTP_HOST}"'/g' \
    -e 's/{{SMTP_PORT}}/'"${SMTP_PORT}"'/g' \
    -e 's/{{SMTP_AUTH}}/'"${SMTP_AUTH}"'/g' \
    -e 's/{{SMTP_USERNAME}}/'"${SMTP_USERNAME}"'/g' \
    -e 's/{{SMTP_PASSWORD}}/'"${SMTP_PASSWORD}"'/g' \
    -i $CONF_FILE

exec "$@"
