#!/bin/bash
node ./node_modules/db-migrate/bin/db-migrate up --config=config/database.json

supervisord -c /etc/supervisor/supervisor.conf
#supervisorctl stop all

node index.js 3000
