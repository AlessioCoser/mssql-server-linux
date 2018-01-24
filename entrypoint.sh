#!/bin/env sh

/opt/mssql/bin/sqlservr &
SQLSERVER_PID=$!

sleep 30s

for f in /var/db/changes/*.sql; do
  echo "Applying changes from $f ...";
  /opt/mssql-tools/bin/sqlcmd -S localhost -U sa -P ${SA_PASSWORD} -d master -i $f
done

wait $SQLSERVER_PID