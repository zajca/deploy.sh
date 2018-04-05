# Deploy.sh

Simple bash php application deployment framework.
Mainly used for deploy symfony 4 app now.

## Structure

### lib.sh

Simple function which wraps bash commands

### vars.sh

Variables export for project

### common.sh

Common deployment tasks

### init.sh

Inits framework variables and reads arguments

### commands.sh

Commands run and help menu

### symfony.sh

Symfony related functions

## Usage & Customization

Best use would be place repository on your server and write your own deploy.sh command.

My example of use is in `deploy.sh.dist` file.

Basic configuration uses 3 commands `deploy`, `rollback` and`clean-up`

You can add your own commands writing your own `commands.sh` file.

 
### simple use (symfony)

```
./deploy.sh deploy \
    --project_dir /var/www/app \
    --project_tar /tmp/release.tgz \
    --copy-dirs '' \
    --writable_dirs 'var/cache,var/logs,var/sessions' \
    --shared_dirs 'public/uploads' \
    --keep_releases 3
```

#### usage with gitlab ci artifacts
```
./deploy.sh deploy \
    --project_dir /var/www/project \ 
    --project_remote http://<gitlab_url>/-/jobs/artifacts/$CI_COMMIT_REF_NAME/download?job=build \
    --copy-dirs '' \
    --writable_dirs 'var/cache,var/logs,var/sessions,public/media,public/uploads' \
    --shared_dirs 'public/uploads' \
    --keep_releases 3 \
    --env_file /<my_dot_env_file>/.env \ 
    --ci_token <my_private_token> \
    --clear_cache_url "<clear_cache_url_on_web>"
```

### HELP

```
Actions:
    deploy     Deploy app from tar
    rollback   Rollback to previous release
    clean-up   Clean up old releases

  Options:
    --project_remote   (optional)  url for project tar
    --env_file         (optional)  path to .env file
    --project_tar      (optional)  absolute path to project *.tgz dile
    --project_dir      (required)  absolute path to project dir
    --writable_dirs    (optional)  array of relative dirs to make writable 'var/log,var/cache'
    --shared_dirs      (optional)  array of relative dirs to make shared 'var/log,var/cache'
    --shared_files     (optional)  array of relative files to symlink 'var/log,var/cache'
    --copy_dirs        (optional)  array of relative dirs to copy
    --keep_releases    (optional)  number of release folders to keep
```

## Workflow

in `project_dir` is created structure

```
releases - timestamped project releases
shared - directories shared accross deployments
```

- Project archive is extracted to new release folder
-  `release` symlink which point to current release folder is created
-  deploy tasks like copy directories set shared directories or setting permissions is done, this is place where you most probably want to add your own logic.
-  `release` folder is atomically changed for `current` folder (`mv -T` is used)

## TODO

* [ ] Clean opcache (now delegate to `gordalina/CacheToolBundle` or own url)



