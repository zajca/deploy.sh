#Deploy.sh
Easy bash script for deploying on local and remote servers, inspired by deployer.php

**Project not complete**
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
- [x] create shared folders
- [x] create shared files
- [x] create writable folders
- [x] copy dirs between current and release
- [x] git show last commits since current
- [x] git caching
- [x] clean
- [x] rollback
- [-] handle errors
- [ ] remote create structure
- [ ] remote make release
- [ ] rsync
- [-] refactoring
- [ ] write more comments
- [ ] code more optional, should be just invoking functions from imports
- [ ] task for using remote test server
