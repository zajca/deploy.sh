#!/usr/bin/env bash

cleanCache(){
    $this_release_path"/bin/console cache:clear --env=prod"
}

warmupCache(){
    $this_release_path"/bin/console cache:warmup --env=prod"
}

migrateDB(){
    $this_release_path"/bin/console doctrine:migrations:migrate --env=prod"
}