#!/bin/bash
#
# THIS IS DIST FILE SHOULD BE MODIFIED AND COPIED SOMEWHERE ELSE
#
set +e
source "${BASH_SOURCE%/*}/init.sh"
source "${BASH_SOURCE%/*}/symfony.sh"


deployAction(){
    cleanOPCacheFromUrl
}

rollbackAction(){
    echo ''
}

cleanUpAction(){
    echo ''
}

source "${BASH_SOURCE%/*}/commands.sh"
