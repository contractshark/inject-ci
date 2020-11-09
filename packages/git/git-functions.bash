#!/usr/bin/env bash
# SPDX-License-Identifier: ISC

pname git/git

ORG=contractshark

# uses svn to download a single folder from github
gitfolder() {
    svn export https://github.com/"$1".git/trunk/"$2"
}

# get a list of all the public repos of a user
ghrepos() {
    GHUSER="${1:-${ORG}}"
    curl -s "https://api.github.com/users/$GHUSER/repos?per_page=100" | grep -E -o 'git@[^"]*' | grep -o ':.*' | grep -E -o '[^:]*'
}

ghbackup() {
    if [ -n "$2" ] && [ "$2" -eq "$2" ]; then
        GITDEPTH="$2"
    fi
    for repo in $(ghrepos "${1:-${ORG}}"); do
        REPONAME=$(grep -o '/.*\.' <<<"$repo")
        if [ -d "$REPONAME" ]; then
            cd "$REPONAME" || exit
            git pull
            cd ..
        else
            if [ -n "$GITDEPTH" ]; then
                git clone --depth="$GITDEPTH" "https://github.com/$repo"
            else
                git clone "https://github.com/$repo"
            fi
        fi
    done
}

# clone one of my repos. just here for backwards compatibility
papergit() {
    git clone --depth 1 "https://github.com/${ORG}/$1"
}

# clone repo, default to github, default to my username
gitclone() {
    zerocheck "$1"
    if grep -q '://' <<<"$1"; then
        git clone --depth=1 "$1"
    else
        if grep -q '/' <<<"$1"; then
            git clone --depth=1 "https://github.com/$1.git"
        else
            git clone --depth 1 "https://github.com/${ORG}/$1.git"
        fi
    fi
}

# get only the addition lines of a .diff file
diffadditions() {
    grep '^+' <"$1" | grep -o '[^+].*'
}

ghcommit() {
    if [[ "$1" =~ '/' ]]; then
        git ls-remote git://github.com/"$1".git | grep 'refs/heads/master' | grep -Eo '^[a-zA-Z0-9]*'
    else
    # keep double quotes on $1
        git ls-remote "git://github.com/${ORG}/""$1"".git" | grep 'refs/heads/master' | grep -Eo '^[a-zA-Z0-9]*'
    fi

}
