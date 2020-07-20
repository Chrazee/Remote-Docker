#!/bin/bash

DATABASE_WAIT_TIMEOUT=120

env_create_file() {
  cp .env.example .env
  if [ $? -eq 0 ]; then
     echo "OK"
  else
     echo "Could not copy the .env file."
     exit $?
  fi
}
env_set_value() {
  echo "Set value for" $1
  awk -v pat="^$1=" -v value="$1=$2" '{ if ($0 ~ pat) print value; else print $0; }' .env > .env.tmp
  mv .env.tmp .env
  if [ $? -eq 0 ]; then
     echo "OK"
  else
     echo "Could not set value for" $1
     exit $?
  fi
}
env_add_value() {
  echo "Add value" $1
  echo $1 >> .env
  if [ $? -eq 0 ]; then
     echo "OK"
  else
     echo "Could not add value for" $1
     exit $?
  fi
}

env_set_values() {
  env_set_value "APP_NAME" $APP_NAME
  env_set_value "APP_DEBUG" $APP_DEBUG
  env_set_value "APP_URL" $APP_URL
  env_set_value "DB_HOST" $DB_HOST
  env_set_value "DB_PORT" $DB_HOST
  env_set_value "DB_DATABASE" $DB_DATABASE
  env_set_value "DB_USERNAME" $DB_USERNAME
  env_set_value "DB_PASSWORD" $DB_PASSWORD
}
env_add_values() {
  env_add_value ""
  env_add_value 'MODULE_DIRECTORY="modules"'
  env_add_value 'MODULE_VIEW="view"'
  env_add_value 'MODULE_VIEW_EXTENSION=".html"'
}

env_file_setup() {
    if [ -f .env ]; then
      echo ".env file exists. Nothing to do."
  else
    echo ">> Create the .env file"
    env_create_file

    echo ">> Change environment variables"
    env_set_values

    echo ">> Add environment variables"
    env_add_values

    echo ">> Generate the Application Key"
    artisan_key_generate
  fi
}

permission_storage_dir() {
  chmod 777 -R storage/
  if [ $? -eq 0 ]; then
    echo "OK"
  else
    echo "Could not change the permission for storage directory,"
    exit $?
  fi
}

composer_update() {
  composer update --optimize-autoloader --no-interaction --no-progress
  if [ $? -eq 0 ]; then
    echo "OK"
  else
    echo "Could not update dependencies."
    exit $?
  fi
}

git_repo_setup() {
  if [ ! -d .git ]; then
    git clone $GIT_REPOSITORY .
  else
      git pull
  fi
}

artisan_key_generate() {
  php artisan key:generate
}
artisan_db_migrate() {
  php artisan migrate
}
artisan_db_seed() {
  php artisan db:seed
}

database_setup() {
  echo "Waiting" $DATABASE_WAIT_TIMEOUT "seconds for Database (host: $DB_HOST, port:$DB_PORT)"

  START_TIME=$(date +%s)
  COUNTER=0
  while :
  do
      if [ $COUNTER -eq $DATABASE_WAIT_TIMEOUT ]; then
        echo "Could not connect to Database (timeout)."
        exit $?
      else
        nc -z $DB_HOST $DB_PORT

        if [[ $? -eq 0 ]]; then
            END_TIME=$(date +%s)
            echo "$DB_HOST:$DB_PORT is available after $((END_TIME - START_TIME)) seconds"
            break
        fi
      fi

      COUNTER=$((COUNTER+1))
      sleep 1
  done
}

echo ">> Setup Git repository"
git_repo_setup

echo ">> Run Composer"
composer_update

echo ">> Set the storage directory permission"
permission_storage_dir

echo ">> Setup the .env file"
env_file_setup

echo ">> Setup database"
database_setup

echo ">> Migrate database"
artisan_db_migrate

echo ">> Seed database"
artisan_db_seed

echo ">> Setup ended <<"