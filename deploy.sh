#!/bin/bash
source ./lib.sh

##INIT VARS
writable_dirs=()
shared_dirs=()
copy_dirs=()
export SYMFONY_ENV=prod
keep_releases=3
timezone="UTC"
chmod_perm=770
##ENDVARS

export action=$1
shift

parse_args() {
    while [[ $# > 0 ]] ; do
      case "$1" in
        --project_tar)
          export project_tar=${2}
          shift
          ;;
        --project_dir)
          export project_dir=${2}
          shift
          ;;
        --writable_dirs)
          tmp=${2}
          export writable_dirs=(${tmp//,/ })
          ;;
        --shared_dirs)
          tmp=${2}
          export shared_dirs=(${tmp//,/ })
          ;;
        --shared_files)
          export shared_files=${2}
          ;;
        --copy_dirs)
          export copy_dirs=${2}
          ;;
        --keep_releases)
          export keep_releases=${2}
          ;;
      esac
      shift
    done
}

parse_args "$@"

#source init_variables
source ./lib.sh
source ./vars.sh
source ./common.sh

initVars

deploy(){
    msgTop "Prepare directory structure"
    prepareStructure

    untarProject

    createWritableDirs "permissionsChmod"

    ####export and print current releases
    exportReleases
    ##read current folder
    exportCurrentRelease

    msgTop "Project dirs"
    ####Copy dirs
    copyDirs "${copy_dirs[@]}"
    createSharedDirs
    createSharedFiles

    release
    cleanUp
}

case "$action" in

    deploy)
    deploy
    ;;

    rollback)
    exportReleases
    exportCurrentRelease
    rollback
    ;;

    clean-up)
    cleanUp
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

