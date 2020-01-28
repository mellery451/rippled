#!/usr/bin/env bash
set -exu
if [[ -z ${COMSPEC:-} ]]; then
    if [[ "$(uname)" == "Darwin" ]] ; then
        system_profiler SPHardwareDataType
    else
        lscpu
        lscpu | egrep 'Model name|Socket|Thread|NUMA|CPU\(s\)'
    fi
else
    WMIC CPU Get DeviceID,NumberOfCores,NumberOfLogicalProcessors
    WMIC CPU Get /Format:List
fi

