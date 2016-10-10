#!/bin/bash

source $DIR_ADMIN/conf/script/const.sh

cApp="awstats"

cPkgName="$cApp"
gConfDir="/etc/$cApp"

gRoot="/usr/share/$cApp"
gExec="/usr/lib/cgi-bin/$cApp.pl"
