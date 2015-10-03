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


ssh_string=$user"@"$server":$port"$deploy_path_base$project_prod
deploy_path_test=$deploy_path_base_test$project_test
deploy_path_prod=$deploy_path_base$project_prod

## Prepare project
timestamp=$(date +%s)
###create project path
if [ ! -d $deploy_path_test ]; then
  echo "test:creating project dir"
  mkdir -p $deploy_path_test
fi
###create releases dir
if [ ! -d $deploy_path_test"/releases" ]; then
  echo "test:creating releases dir"
  mkdir -p $deploy_path_test"/releases"
fi

###read realeases
releases_test=( $(find $deploy_path_test"/releases/" -maxdepth 1 -type d | sort -n) )
# echo ${releases_test[0]}
# echo ${releases_test[1]}
echo "test:existing releases:"
printf '%s\n' "${releases_test[@]}"

###read current folder
if [ -d "$deploy_path_test/current" ];then
  current_test=$(readlink $deploy_path_test"/current")
  echo "test:current release path: "$current_test
else
  echo "test:no current release"
fi


###create new release folder
this_release_path_test_abolute=$deploy_path_test"/releases/"$timestamp
if [ ! -d $this_release_path_test_abolute ]; then
  echo "test:creating release folder: "$this_release_path_test_abolute
  mkdir -p $this_release_path_test_abolute
fi
this_release_path_test=$deploy_path_test"/release"

if [ -d $this_release_path_test ]; then
  echo "test:removing failed release: "$(readlink $this_release_path_test)
  rm -rf $(readlink $this_release_path_test)
  echo "test:removing failed release symlink: "$this_release_path_test
  rm $this_release_path_test
fi
ln -s $this_release_path_test_abolute $this_release_path_test
echo "Test:this release path "$this_release_path_test

### Prepare git
git_clone_options=$git_repository

if [ ! $git_cache ]; then
  git_clone_options+=" --depth 1"
fi

if [ ! -z "$branch" ]; then
  git_clone_options+=" -b $branch"
fi

if [ ! -z "$tag" ]; then
  git_clone_options+=" -b $tag"
fi
### Run git
echo "git clone "$git_clone_options" "$this_release_path_test
git clone $git_clone_options $this_release_path_test

cd $this_release_path_test
echo "Commits since current:"
git log --since=$(basename $current_test)
cd $this_folder

## Install vendor
echo "test:copy cached dirs"
for dir in "${copy_dirs_test[@]}";do
  cp -r "$current_test/${dir}" "$this_release_path_test"
done
echo "test:build"
#composer $composer_options
# npm i
# bower i
# bower i

echo "test:release: mv -T "$this_release_path_test" "$deploy_path_test"/current"
mv -T $this_release_path_test $deploy_path_test"/current"
echo "test:new release path is: "$(readlink $deploy_path_test"/current")

## Clean up
echo "test:cleaning up"
for (( idx=${#releases_test[@]}-1 ; idx>=1 ; idx-- ));do
  release=${releases_test[idx]}
  if [ $idx -lt $((${#releases_test[@]}-$keep_releases+1)) ];then
    echo "test:remove: "$release
    rm -rf $release
  fi
done

echo "test:rollback"
for (( idx=${#releases_test[@]}-1 ; idx>=1 ; idx-- ));do
  release=${releases_test[idx]}
  if [ $current_test != $release ];then
    echo "test:rollback to: "$release
    ln -s $release $deploy_path_test"/rollback"
    mv -T $deploy_path_test"/rollback" $deploy_path_test"/current"
    break;
  fi
done

## Remote
# ssh ssh_string << EOF
## put remote code here
# EOF

echo "done"
