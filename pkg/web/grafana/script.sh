#!/bin/bash
#--- VladVons@gmail.com

source ./const.sh
source $DIR_ADMIN/conf/script/system.sh


ResetAdminPassw()
{
  Log "$0->$FUNCNAME"

  grafana-cli admin reset-admin-password --homepath "/usr/share/grafana" "NewPassw"
}


