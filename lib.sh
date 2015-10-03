###
# Log
###

msg(){
  echo $1
}

msgTop(){
  msg "######"
  msg "# "$1
  msg "######"
}

getServerUser(){
  echo $(ps aux | grep -E '[a]pache|[h]ttpd|[_]www|[w]ww-data|[n]ginx' | grep -v root | head -1 | cut -d\  -f1)
}

###
# Files
###

##
# @param directory
# @param function string
##
isDirectoryExists() {
  if [ -d $deploy_path_test ]; then
      eval $1
  fi
}

##
# @param directory
# @param function string
##
isDirectoryNotExists() {
  if [ ! -d $1 ]; then
      eval $2
  fi
}

##
#@param array
#@param function string
##
iterateArr() {
  local_array=("${@}")
  for dir in "${local_array[@]}";do
    eval $2
  done
}

##
# @param file or dir
##
remove() {
  msg "removing: "$1
  rm -rf $1
}

##
# @param directory
##
createDir() {
  msg "creating dir "$1
  mkdir -p $1
}
##
# @param from
# @param to
##
copy() {
  msg "Copy from: "$1" to: "$2
  cp -r $1 $2
}

atomicMove(){
  msg "Move atomic from: "$1" to:"$2
  mv -T $1 $2
}

##
# @param from
# @param to
##
symlink() {
  msg "Symlink from: "$1" to: "$2
  ln -nfs $1 $2
}

###
# @param dir or file
###
permissionsChmod() {
  msg "changing perm on: "$1" to: "$chmod_perm
  chmod -R $chmod_perm $1
}

###
# @param dir or file
###
permissionsChmodA() {
  local $user $(getServerUser)
  chmod +a "$user allow delete,write,append,file_inherit,directory_inherit" $1
}

###
# @param dir or file
###
permissionsFacl() {
  local $user $(getServerUser)
  setfacl -R -m u:"$user":rwX -m u:`whoami`:rwX $1
  setfacl -dR -m u:"$user":rwX -m u:`whoami`:rwX $1
}
