#Deploy.sh

Project for prepare structure for zero downtime deploy of php applications.

simple use (symfony)
```
$sh deploy.sh deploy \
    --project_dir /var/www/app \
    --project_tar /tmp/release.tgz \
    --copy-dirs '' \
    --writable_dirs 'var/cache,var/logs,var/sessions' \
    --shared_dirs 'web/uploads' \
    --keep_releases 3
```

```
Actions:
    deploy     Deploy app from tar
    rollback   Rollback to previous release
    clean-up   Clean up old releases

  Options:
    --project_tar   (required)  absolute path to project *.tgz dile
    --project_dir   (required)  absolute path to project dir
    --writable_dirs (optional)  array of relative dirs to make writable 'var/log,var/cache'
    --shared_dirs   (optional)  array of relative dirs to make shared 'var/log,var/cache'
    --shared_files  (optional)  array of relative files to symlink 'var/log,var/cache'
    --copy_dirs     (optional)  array of relative dirs to copy
    --keep_releases (optional)  number of release folders to keep
```