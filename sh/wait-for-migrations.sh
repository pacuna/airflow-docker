#!/bin/bash
# wait-for-postgres.sh

set -e

host="$1"
shift
cmd="$@"

until PGPASSWORD=airflow psql -h "$host" -U "airflow" -c '\d job'; do
  >&2 echo "Migrations not ready yet!"
  sleep 1
done

>&2 echo "Migrations ready - executing command"
exec $cmd



