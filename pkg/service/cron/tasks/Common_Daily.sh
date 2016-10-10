#!/bin/bash
# Slave file called by /etc/cron.daily/TaskDaily
# 'rsync' utility update it


source $DIR_ADMIN/conf/pkg/service/cron/tasks/Common.sh
#. $(dirname $0)/Common.sh


TaskMonthly()
{
  Day=$(date "+%d")
  if [ $Day = 1 ]; then
  source $DIR_ADMIN/conf/pkg/service/cron/tasks/Common_Monthly.sh
  fi
}

# ------------------------
#Test "Hello Common_Daily"
#
#MySQLBackupHosting
#MySQLBackupArchive
#DiskClearTemp
#DiskClearBackup

#TaskMonthly
