# VladVons@gmail.com

Log()
{
  aMsg="$1"; aShow=${2:-1};

  Msg="$(date +%Y-%m-%d-%a), $(date +%H:%M:%S), $(id -u -n), $aMsg"
  echo "$Msg" >> Install.log

  if [ $aShow = 1 ]; then
    echo "$Msg"
  fi
}
