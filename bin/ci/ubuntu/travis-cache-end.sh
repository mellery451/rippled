#!/usr/bin/env bash
set -eux
pushd $(dirname ${CACHE_DIR:-$HOME/_cache})

if [ $(uname) = "Linux" ] ; then
    SUDO="sudo";
else
    SUDO="";
fi

if [[ -f cache_ignore.tar ]] ; then
    echo "restoring ignored cache files in $(pwd)"
    $SUDO tar xvf cache_ignore.tar;
fi

popd


