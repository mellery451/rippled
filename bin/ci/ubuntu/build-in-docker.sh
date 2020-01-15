#!/usr/bin/env bash
# run our build script in a docker container
# using travis-ci/github hosts
set -eux

function join_by { local IFS="$1"; shift; echo "$*"; }

set +x
echo "VERBOSE_BUILD=true" > /tmp/co.env
matchers=(
   'TRAVIS.*' 'GITHUB.*' 'CI' 'CC' 'CXX'
   'BUILD_TYPE' 'TARGET' 'MAX_TIME'
   'CODECOV.+' 'CMAKE.*' '.+_TESTS'
   '.+_OPTIONS' 'NINJA.*' 'NUM_.+'
   'NIH_.+' 'BOOST.*' '.*CCACHE.*')

matchstring=$(join_by '|' "${matchers[@]}")
echo "MATCHSTRING IS:: $matchstring"
env | grep -E "^(${matchstring})=" >> /tmp/co.env
set -x
# Don't want to pass these to container:
cat /tmp/co.env | grep -v -E "(TRAVIS_CMD|BOOST_ROOT)" > /tmp/co.env.2
mv /tmp/co.env.2 /tmp/co.env
cat /tmp/co.env

if [[ ${TRAVIS:-false} == "true" ]]; then
    export WORKSPACE=${TRAVIS_BUILD_DIR}
elif [[ ${GITHUB_ACTIONS:-false} == "true" ]]; then
    export WORKSPACE=${GITHUB_WORKSPACE} 
else
    export WORKSPACE=${HOME}
fi
mkdir -p -m 0777 ${WORKSPACE}/cores
echo "${WORKSPACE}/cores/%e.%p" | sudo tee /proc/sys/kernel/core_pattern
docker run \
    -t --env-file /tmp/co.env \
    -v ${HOME}:${HOME} \
    -v ${WORKSPACE}:${WORKSPACE} \
    -w ${WORKSPACE} \
    --cap-add SYS_PTRACE \
    --ulimit "core=-1" \
    $DOCKER_IMAGE \
    /bin/bash -c 'if [[ $CC =~ ([[:alpha:]]+)-([[:digit:].]+) ]] ; then sudo update-alternatives --set ${BASH_REMATCH[1]} /usr/bin/$CC; fi; bin/ci/ubuntu/build-and-test.sh'


