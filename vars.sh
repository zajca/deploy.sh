initVars(){
  export timestamp=$(date +%s)
  export this_release_path=$project_dir"/releases/"$timestamp
}

exportReleases(){
  ###read realeases
  export previous_releases=( $(find $project_dir"/releases/" -maxdepth 1 -type d | sort -n) )
  msg "Existing releases:"
  printf '%s\n' "${previous_releases[@]}"
}

exportCurrentRelease(){
  if [ -d "$project_dir/current" ];then
    export current_dir=$(readlink $project_dir"/current")
    echo "Current release path: "$current_dir
  else
    echo "No current release"
  fi
}
