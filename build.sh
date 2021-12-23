#!/bin/bash


gen_bin_ver()
{
    __parse_git_branch() {
        type git >/dev/null 2>&1
        if [ "$?" -ne 0 ]; then
            return
        fi

        # Quit if this is not a Git repo.
        __branch=$(git symbolic-ref HEAD 2> /dev/null)
        if [ -z $__branch ] ; then
            # attempt to get short-sha-name
            __branch=":$(git rev-parse --short HEAD 2> /dev/null)"
        fi
        if [ "$?" -ne 0 ]; then
            # this must not be a git repo
            return
        fi

        # Clean off unnecessary information.
        __branch=${__branch#refs\/heads\/}

        echo "${__branch}"
    }

    __parse_git_stats(){
        type git >/dev/null 2>&1
        if [ "$?" -ne 0 ]; then
            return
        fi

        # check if git
        [[ -z $(git rev-parse --git-dir 2> /dev/null) ]] && return

        # return the number of modified but not staged items
        __modified=$(git ls-files --modified `git rev-parse --show-cdup` | wc -l)
        echo "$__modified" | tr -d '[:space:]'
    }

    if (type git >/dev/null 2>&1) && (git log >/dev/null 2>&1); then
        __commit="`git log --pretty=format:"%h" -1`[modified:`__parse_git_stats`]@`__parse_git_branch`"
    else
        __commit="nil"
    fi

    __bin_ver_str="commit=$__commit;buildpath=`pwd`;buildhost=`hostname`;buildtime=`date +%F_%T`"
    echo "$__bin_ver_str"
}

gcc main.c -DBIN_VER=\"`gen_bin_ver`\"

# test
BIN_VER_TYPE() {
    echo "BIN_VER_TYPE:$1"
}
strings ./a.out | grep BIN_VER > binver
source binver
echo commit:$commit
echo buildpath:$buildpath
echo buildhost:$buildhost
echo buildtime:$buildtime
