case "$action" in

    deploy)
    deployAction
    ;;

    rollback)
    rollbackAction
    ;;

    clean-up)
    cleanUpAction
    ;;

    *)
    echo "usage : $0 deploy|rollback|clean-up

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
"
    ;;
esac
