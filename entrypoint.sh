#!/bin/env sh

/opt/mssql/bin/sqlservr &
SQLSERVER_PID=$!

sleep 30s

/opt/setup_db.sh

wait $SQLSERVER_PID