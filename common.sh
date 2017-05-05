untarProject(){
  msg "Extracting project"
  tar zxf $project_tar -C $this_release_path
}

prepareStructure(){
  ###create project dir
  isDirectoryNotExists $project_dir "createDir "$project_dir
  ###create releases dir
  isDirectoryNotExists $project_dir"/releases" "createDir "$project_dir"/releases"

  ###create new release folder
  isDirectoryNotExists $this_release_path "createDir "$this_release_path
  export this_release_path_temp=$project_dir"/release"
  if [ -d $this_release_path_temp ]; then
    remove $(readlink $this_release_path_temp)
    remove $this_release_path_temp
  fi
  symlink $this_release_path $this_release_path_temp

  ### create shared dir
  isDirectoryNotExists $project_dir"/shared" "createDir "$project_dir"/shared"
}

copyDirs(){
  if [ -d "$project_dir/current" ];then
        local_array=("${@}")
        for dir in "${local_array[@]}";do
            copy $current_dir"/"$dir $this_release_path_temp
        done
  fi
}

createSharedDirs(){
  msg "Create shared dirs"
  for dir in "${shared_dirs[@]}";do
    local full_dir=$project_dir"/shared/"$dir
    local release_full_dir=$this_release_path"/"$dir
    isDirectoryExists $release_full_dir "remove $release_full_dir"
    isDirectoryNotExists $full_dir "createDir $full_dir"
    symlink $full_dir $release_full_dir
  done
}

createSharedFiles(){
  msg "Create shared files"
  for file in "${shared_files[@]}";do
    local full_dir=$(dirname $project_dir"/shared/"$file)
    local release_full_file=$this_release_path_temp"/"$file
    if [ -f $release_full_file ]; then
      remove $release_full_file
    fi

    isDirectoryNotExists $full_dir "createDir $full_dir"
    symlink $project_dir"/shared/"$file $release_full_file
  done
}

createWritableDirs(){
  ## Create writable dirs
  msg "Create writable dirs"
  for dir in "${writable_dirs[@]}";do
    isDirectoryNotExists $this_release_path_temp"/"$dir "createDir $this_release_path_temp/$dir"
    eval $1 $this_release_path_temp"/"$dir
  done
}

release() {
  msgTop "Release"
  atomicMove $this_release_path_temp "$project_dir/current"
  msg "New release path is: "$(readlink "$project_dir/current")
}

cleanUp(){
  msgTop "Clean Up"
  for (( idx=${#previous_releases[@]}-1 ; idx>=1 ; idx-- ));do
    local release=${previous_releases[idx]}
    if [ $idx -lt $((${#previous_releases[@]}-$keep_releases+1)) ];then
      remove $release
    fi
  done
}

rollback() {
  msgTop "Rollback"
  for (( idx=${#previous_releases[@]}-1 ; idx>=1 ; idx-- ));do
    release=${previous_releases[idx]}
    if [ $current_dir != $release ];then
      msg "Rollback to: "$release
      symlink $release $project_dir"/rollback"
      atomicMove $project_dir"/rollback" $current_dir
      break;
    fi
  done
}
