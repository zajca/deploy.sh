initVars(){
  export ssh_string=$user"@"$server":$port"$deploy_path_base$project_prod
  export deploy_path_test=$deploy_path_base_test$project_test
  export deploy_path_prod=$deploy_path_base$project_prod
  export timestamp=$(date +%s)
  export this_release_path_test_abolute=$deploy_path_test"/releases/"$timestamp
}

exportReleases(){
  ###read realeases
  export releases_test=( $(find $deploy_path_test"/releases/" -maxdepth 1 -type d | sort -n) )
  msg "Existing releases:"
  printf '%s\n' "${releases_test[@]}"

}

exportCurrentRelease(){
  if [ -d "$deploy_path_test/current" ];then
    export current_test=$(readlink $deploy_path_test"/current")
    echo "Current release path: "$current_test
  else
    echo "No current release"
  fi
}
