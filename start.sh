#!/bin/bash
set -eu
cd /app/code

if [[ ! -f /app/data/env ]]; then
    echo "=> First time use"

    cp /app/code/.env.sample /app/data/env
    chown -R cloudron:cloudron /app/data

    echo "=> Generate app keys (only once)"
    crudini --set /app/data/env "" SECRET_KEY "$(openssl rand -hex 32)"
    crudini --set /app/data/env "" UTILS_SECRET "$(openssl rand -hex 32)"

    echo "=> Disable forced https; cloudron takes care of ssl termination"
    crudini --set /app/data/env "" FORCE_HTTPS "false"

    echo "=> Disable auto-update check; does not work in readonly filesystem"
    crudini --set /app/data/env "" ENABLE_UPDATES "false"

    echo "=> Remove dummy Slack Values"
    crudini --set /app/data/env "" SLACK_KEY ""
    crudini --set /app/data/env "" SLACK_SECRET ""
fi

echo "Setting up database"
crudini --set /app/data/env "" DATABASE_URL "postgres://${CLOUDRON_POSTGRESQL_USERNAME}:${CLOUDRON_POSTGRESQL_PASSWORD}@${CLOUDRON_POSTGRESQL_HOST}:${CLOUDRON_POSTGRESQL_PORT}/${CLOUDRON_POSTGRESQL_DATABASE}"
crudini --set /app/data/env "" PGSSLMODE "disable"
crudini --set /app/data/env "" REDIS_URL "${CLOUDRON_REDIS_URL}"

echo "Setting up app location"
crudini --set /app/data/env "" URL "${CLOUDRON_APP_ORIGIN}"
crudini --set /app/data/env "" PORT "3000"

if [[ -n "${CLOUDRON_MAIL_SMTP_SERVER:-}" ]]; then
  echo "Setting up SMTP credentials"
  crudini --set /app/data/env "" SMTP_HOST "${CLOUDRON_MAIL_SMTP_SERVER}"
  crudini --set /app/data/env "" SMTP_PORT "${CLOUDRON_MAIL_SMTP_PORT}"
  crudini --set /app/data/env "" SMTP_USERNAME "${CLOUDRON_MAIL_SMTP_USERNAME}"
  crudini --set /app/data/env "" SMTP_PASSWORD "${CLOUDRON_MAIL_SMTP_PASSWORD}"
  crudini --set /app/data/env "" SMTP_FROM_EMAIL "${CLOUDRON_MAIL_FROM}"
  crudini --set /app/data/env "" SMTP_REPLY_EMAIL "${CLOUDRON_MAIL_FROM}"
  crudini --set /app/data/env "" SMTP_SECURE "false"
fi

mkdir -p /run/.yarn /run/.cache
chown -R cloudron:cloudron /app/data /run/.yarn /run/.cache

echo "Run migrations"
gosu cloudron:cloudron yarn db:migrate --env=production-ssl-disabled

echo "==> starting server"
exec /usr/local/bin/gosu cloudron:cloudron yarn start
