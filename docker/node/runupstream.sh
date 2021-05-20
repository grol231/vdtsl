#!/bin/bash

npm install


until node ./node_modules/db-migrate/bin/db-migrate up --config=config/database.json; do
  >&2 echo "Postgres is unavailable - sleeping"
  sleep 1
done

>&2 echo "Postgres is up - executing command"


node ./node_modules/db-migrate/bin/db-migrate up --config=config/database.json
supervisord -c /etc/supervisor/supervisor.conf

node index.js 3000
