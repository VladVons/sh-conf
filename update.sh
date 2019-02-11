#!/bin/bash

source ./script/utils.sh

cd $DIR_ADMIN/conf/pkg/service/rsync
./script.sh conf

if YesNo "Update packages" 60 0; then
    PkgUpdate
fi;
