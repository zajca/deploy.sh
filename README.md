#Deployer.sh
Easy bash script for deploying on local and remote servers, inspired by deployer.php

*Now assuming that you have CI and test environment on same machine*

##Flow:
 * run script using CI
 * create test folders with timestamps
 * clone git and build
 * mv release to current
 * create prod folders with timestamps
 * rsync to remote server
 * clean test
 * clean prod

##TODO:
- [x] create structure
- [x] update code
- [x] build TODO: do more builds
- [x] make release
- [ ] create shared folders
- [ ] create shared files
- [ ] create writable folders
- [x] copy dirs between current and release
- [ ] git caching
- [x] clean
- [ ] handle errors
- [ ] remote create structure
- [ ] remote make release
- [ ] rsync
- [ ] refactoring
- [ ] code more optional, should be just invoking functions from imports
- [ ] task for using remote test server
