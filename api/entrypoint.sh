#!/bin/bash

mix deps.get
command -v pg_isready

if [ -z ".env" ]; then
    exit 1
fi

echo "$PGUSER $PGHOST:$PGPORT for $PGDATABASE ---- VERYF"

while ! pg_isready -q -h $PGHOST -p $PGPORT --username=$PGUSER
do
  echo "$(date) - waiting database to start"
  sleep 2
done

if [[ -z `psql -Atqc "\\list $PGDATABASE"` ]]; then
  echo "Database $PGDATABASE does not exist. Creating..."
  createdb -E UTF8 $PGDATABASE -l en_US.UTF-8 -T template0
  mix setup
  echo "Database $PGDATABASE created."
else
  echo "Database $PGDATABASE loaded."
  source .env
  mix setup
fi

echo "RUNNING API SERVER PHOENIX"
exec mix phx.server
