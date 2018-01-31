#!/bin/sh

set -e

DATABASE_NAME=${DB_NAME:=master}
DATABASE_USER=${DB_USER:=guest}
DATABASE_PASSWORD=${DB_PASSWORD:=secret}

create_db_and_user() {
  echo "CREATE DATABASE ${DATABASE_NAME};" >> /var/db/setup.sql
  echo "GO" >> /var/db/setup.sql

  echo "CREATE LOGIN ${DATABASE_USER} WITH PASSWORD=\"${DATABASE_PASSWORD}\";" >> /var/db/setup.sql
  echo "ALTER LOGIN ${DATABASE_USER} WITH default_database=${DATABASE_NAME};"  >> /var/db/setup.sql
  echo "GO" >> /var/db/setup.sql

  echo "USE ${DATABASE_NAME};" >> /var/db/setup.sql
  echo "CREATE USER ${DATABASE_USER} FOR LOGIN ${DATABASE_USER};" >> /var/db/setup.sql
  echo "GRANT CONTROL TO ${DATABASE_USER};" >> /var/db/setup.sql
  echo "GO" >> /var/db/setup.sql

  /opt/mssql-tools/bin/sqlcmd -S localhost -U sa -P ${SA_PASSWORD} -d master -i /var/db/setup.sql

  rm /var/db/setup.sql
}

run_all_migration_as_user() {
  for f in /var/db/changes/*.sql; do
    echo "Applying changes from $f ...";
    /opt/mssql-tools/bin/sqlcmd -S localhost -U ${DATABASE_USER} -P ${DATABASE_PASSWORD} -d ${DATABASE_NAME} -i $f
  done
}

create_db_and_user

run_all_migration_as_user