# MSSQL Server on Linux for Docker Engine
This image adds the ability to:
- setup a user with his own database easily
- populate the database with a set of `.sql` files defined by user.

## For the other features
You can read the official documentation at "[microsoft/mssql-server-linux/](https://hub.docker.com/r/microsoft/mssql-server-linux/)"

## Setup a new user with his own database
You can add these environment variables to the execution:
```
  DB_NAME: "superdb"
  DB_USER: "greatuser"
  DB_PASSWORD: "1ComplexPassword!"
```

## To Populate the database
Once the database server started, it will execute files with `.sql` extension that are found in `/var/db/changes`.

In order to use your migration files with docker-compose you can configure `docker-compose.yml` in this manner:
```
version: '3'

services:
  mssql_database:
    image: alessiocoser/mssql-server-linux
    ports:
      - "1433:1433"
    environment:
      ACCEPT_EULA: "Y"
      SA_PASSWORD: "Your(!)SuperSecretPasssword"
    volumes:
       - ./your/local/path/db/changes:/var/db/changes

  [...]
```
Then by running `docker-compose up --build` it will start MSSQL server and run all the SQL migration inside `./your/local/path/db/changes`

# Complete example with docker-compose
```
version: '3'

services:
  mssql_database:
    image: alessiocoser/mssql-server-linux
    ports:
      - "1433:1433"
    environment:
      ACCEPT_EULA: "Y"
      SA_PASSWORD: "Your(!)SuperSecretPasssword"
      DB_NAME: "superdb"
      DB_USER: "greatuser"
      DB_PASSWORD: "1ComplexPassword!"
    volumes:
       - ./your/local/path/db/changes:/var/db/changes

  [...]
```