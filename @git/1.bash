#!/usr/bin/bash

GIT_REPO_URL=
GIT_BRANCH_NAME=
GIT_REPO_NAME=
GIT_BRANCH_SHA=

/usr/bin/git init /home/runner/work/${GIT_REPO_NAME}/${GIT_REPO_NAME}
/usr/bin/git remote add origin ${GIT_REPO_URL}
/usr/bin/git config --local gc.auto 0

/usr/bin/git config --local --name-only --get-regexp core\.sshCommand
/usr/bin/git submodule foreach --recursive git config --local --name-only --get-regexp 'core\.sshCommand' && git config --local --unset-all 'core.sshCommand' || :
/usr/bin/git config --local --name-only --get-regexp http\.https\:\/\/github\.com\/\.extraheader
/usr/bin/git submodule foreach --recursive git config --local --name-only --get-regexp 'http\.https\:\/\/github\.com\/\.extraheader' && git config --local --unset-all 'http.@.extraheader' || :
/usr/bin/git config --local http.@.extraheader AUTHORIZATION: basic ***

/usr/bin/git checkout --progress --force -B ${GIT_BRANCH_NAME} refs/remotes/origin/${GIT_BRANCH_NAME}

/usr/bin/git -c protocol.version=2 fetch --no-tags --prune --progress --no-recurse-submodules --depth=1 origin +${GIT_BRANCH_SHA}:refs/remotes/origin/${GIT_BRANCH_NAME}

/usr/bin/git log -1 --format='%H'

/usr/bin/git version
/usr/bin/git config --local --name-only --get-regexp core\.sshCommand
/usr/bin/git submodule foreach --recursive git config --local --name-only --get-regexp 'core\.sshCommand' && git config --local --unset-all 'core.sshCommand' || :
/usr/bin/git config --local --name-only --get-regexp http\.https\:\/\/github\.com\/\.extraheader


/usr/bin/git config --local --unset-all http.@.extraheader
/usr/bin/git submodule foreach --recursive git config --local --name-only --get-regexp 'http\.https\:\/\/github\.com\/\.extraheader' && git config --local --unset-all 'http.@.extraheader' || :

