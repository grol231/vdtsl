#!/bin/bash

npm install

node ./node_modules/db-migrate/bin/db-migrate up --config=config/database.json
supervisord -c /etc/supervisor/supervisor.conf

node index.js 3000
