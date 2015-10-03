exportGitString(){
  ### Prepare git
  git_clone_options=""

  if [ ! -z "$branch" ]; then
    git_clone_options+=" -b $branch"
  fi

  if [ ! -z "$tag" ]; then
    git_clone_options+=" -b $tag"
  fi

  if [ ! $git_cache ]; then
    git_clone_options+=" --depth 1"
    # Add
  else
    export git_clone_options_simple=$git_clone_options" "$git_repository
    git_clone_options+=" --recursive -q --reference "$current_test" --dissociate "$git_repository
  fi

  export git_clone_options
}

gitClone(){
  echo "git clone "$git_clone_options" "$this_release_path_test
  git clone $git_clone_options $this_release_path_test
  #handle  if git fails, this will happen during first build
  ret=$?
  if [ ! $ret -eq 0 ]; then
      git clone $git_clone_options_simple $this_release_path_test
      ret=$?
      if [ ! $ret -eq 0 ]; then
        msg "Clone fails"
        exit 1
      fi
  fi
}

gitGetCommitSinceLastRelease(){
  cd $this_release_path_test
  msg "Commits since current:"
  git log --since=$(basename $current_test)
  cd $this_folder
}
