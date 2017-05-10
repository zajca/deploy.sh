#!/usr/bin/env bash

cleanCache(){
    eval $this_release_path"/bin/console cache:clear --env=prod"
}

warmupCache(){
    eval $this_release_path"/bin/console cache:warmup --env=prod"
}

migrateDB(){
    eval $this_release_path"/bin/console doctrine:migrations:migrate --env=prod"
}

#for this command cachetool needs to be registered by composer
#https://github.com/gordalina/CacheToolBundle
clearOpCache(){
    eval $this_release_path"/bin/console cachetool:opcache:reset --env=prod"
}