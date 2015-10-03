prepareStructure(){
  ###create project dir
  isDirectoryNotExists $deploy_path_test "createDir "$deploy_path_test
  ###create releases dir
  isDirectoryNotExists $deploy_path_test"/releases" "createDir "$deploy_path_test"/releases"

  ###create new release folder
  isDirectoryNotExists $this_release_path_test_abolute "createDir "$this_release_path_test_abolute
  export this_release_path_test=$deploy_path_test"/release"
  if [ -d $this_release_path_test ]; then
    remove $(readlink $this_release_path_test)
    remove $this_release_path_test
  fi
  symlink $this_release_path_test_abolute $this_release_path_test
  msg "This release path "$this_release_path_test

  ### create shared dir
  isDirectoryNotExists $deploy_path_test"/shared" "createDir "$deploy_path_test"/shared"
}

copyDirs(){
  local_array=("${@}")
  for dir in "${local_array[@]}";do
    copy $current_test"/"$dir $this_release_path_test
  done
}

createSharedDirs(){
  msg "Create shared dirs"
  for dir in "${shared_dirs[@]}";do
    local full_dir=$deploy_path_test"/shared/"$dir
    local release_full_dir=$deploy_path_test"/shared/"$dir
    isDirectoryExists $release_full_dir "remove $release_full_dir"
    isDirectoryNotExists $full_dir "createDir $full_dir"
    symlink $full_dir $release_full_dir
  done
}

createSharedFiles(){
  msg "Create shared files"
  for file in "${shared_files[@]}";do
    local full_dir=$(dirname $deploy_path_test"/shared/"$file)
    local release_full_file=$this_release_path_test"/"$file
    if [ -f $release_full_file ]; then
      remove $release_full_file
    fi

    isDirectoryNotExists $full_dir "createDir $full_dir"
    symlink $deploy_path_test"/shared/"$file $release_full_file
  done
}

createWritableDirs(){
  ## Create writable dirs
  msg "Create writable dirs"
  for dir in "${writable_dirs[@]}";do
    isDirectoryNotExists $this_release_path_test"/"$dir "createDir $this_release_path_test/$dir"
    eval $1 $this_release_path_test"/"$dir
  done
}

release() {
  msgTop "Release"
  atomicMove $this_release_path_test $deploy_path_test"/current"
  msg "New release path is: "$(readlink $deploy_path_test"/current")
}

cleanUp(){
  msgTop "Clean Up"
  for (( idx=${#releases_test[@]}-1 ; idx>=1 ; idx-- ));do
    local release=${releases_test[idx]}
    if [ $idx -lt $((${#releases_test[@]}-$keep_releases+1)) ];then
      remove $release
    fi
  done
}

rollback() {
  msgTop "Rollback"
  for (( idx=${#releases_test[@]}-1 ; idx>=1 ; idx-- ));do
    release=${releases_test[idx]}
    if [ $current_test != $release ];then
      msg "Rollback to: "$release
      symlink $release $deploy_path_test"/rollback"
      atomicMove $deploy_path_test"/rollback" $deploy_path_test"/current"
      break;
    fi
  done
}
