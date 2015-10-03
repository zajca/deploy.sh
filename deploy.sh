#!/bin/bash
project_prod="www.project.com"
project_test="test-project.mycompany.com"
server="myhosting.com"
port="22"
user="mycompany"
id_rsa="~/.ssh/id_rsa"
deploy_path_base="/var/www/"
deploy_path_base_test="/var/www/"
writable_dirs=('app/cache' 'app/logs' 'web/media')
shared_dirs=('node_modules' 'web/media')
shared_files=('app/config/parameters.yml')
copy_dirs=('vendor')
assets=('web/assets', 'web/bundles')
#SYMFONY_ENV=prod
#SYMFONY_ENV=test
git_cache=true
composer_options="install  --verbose --prefer-dist --optimize-autoloader --no-progress --no-interaction"
keep_releases=3
copy_dirs_test=("vendor" "node_modules")
copy_dirs=("vendor")
timezone="UTC"
tag=""
branch="master"
git_repository="git@github.com:deployphp/deployer.git"
this_folder=$(pwd)
chmod_perm=770

#source init_variables
source ./lib.sh
source ./vars.sh
source ./git.sh
source ./common.sh

## Prepare project
initVars
msgTop "Local-prepare"
prepareStructure

###export and print current releases
# exportReleases ##there is bug now releases_test is not exported
export releases_test=( $(find $deploy_path_test"/releases/" -maxdepth 1 -type d | sort -n) )
msg "Existing releases:"
printf '%s\n' "${releases_test[@]}"
##read current folder
exportCurrentRelease
##create git clone string
msgTop "Git"
exportGitString
### Run git
gitClone
###show commits since last release
gitGetCommitSinceLastRelease

msgTop "Project-dirs"
###Copy dirs
copyDirs "${copy_dirs_test[@]}"
createSharedDirs
createSharedFiles
createWritableDirs "permissionsChmod"

#composer $composer_options
# npm i
# bower i
# npm run build

release

## Clean up
cleanUp
#rollback


## Remote
# ssh ssh_string << EOF
## put remote code here
# EOF

echo "done"
