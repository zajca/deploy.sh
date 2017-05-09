#!/bin/bash
source ./init.sh
source ./symfony.sh

deployAction(){
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

    #symfony
    cleanCache
    migrateDB

    release
    cleanUp
}

rollbackAction(){
    exportReleases
    exportCurrentRelease
    rollback
}

cleanUpAction(){
    cleanUp
}

source ./commands.sh