#!/usr/bin/env bash

cleanCache(){
    msg "Cleaning cache"
    run_eval $this_release_path"/bin/console cache:clear --no-debug --no-warmup";
}

cleanOPCacheFromUrl(){
    msg "Clearing OP cache"
    curl -sS $clear_cache_url;
}

warmupCache(){
    msg "Cache warmup"
    run_eval $this_release_path"/bin/console cache:warmup";
}

migrateDB(){
    msg "Migrate DB"
    run_eval $this_release_path"/bin/console doctrine:migrations:migrate";
}

copyParameters(){
    if [ -f $env_file ]; then
      msg "Set .env file"
      copy $env_file $this_release_path"/.env"
    fi
}


#for this command cachetool needs to be registered by composer
#https://github.com/gordalina/CacheToolBundle
clearOpCache(){
    msg "Clear opcache"
    run_eval $this_release_path"/bin/console cachetool:opcache:reset --env=prod";
}
