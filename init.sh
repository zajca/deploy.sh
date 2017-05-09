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