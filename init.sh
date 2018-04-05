#!/bin/bash
source "${BASH_SOURCE%/*}/lib.sh"

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
        --project_remote)
          export project_remote=${2}
          shift
          ;;
        --env_file)
          export env_file=${2}
          shift
          ;;
        --clear_cache_url)
          export clear_cache_url=${2}
          shift
          ;;
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

tmp_copy=("${@}")
export ARGS="${tmp_copy[*]}"

parse_args $ARGS

#source init_variables
source "${BASH_SOURCE%/*}/lib.sh"
source "${BASH_SOURCE%/*}/vars.sh"
source "${BASH_SOURCE%/*}/common.sh"

initVars
