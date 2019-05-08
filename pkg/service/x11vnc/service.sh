#!/bin/bash

source ./const.sh
source $DIR_ADMIN/conf/script/service.sh


Init()
# ------------------------
{
  Log "$0->$FUNCNAME"
  #http://c-nergy.be/blog/?p=8984

  x11vnc -storepasswd /etc/x11vnc.pass

  cat > /lib/systemd/system/x11vnc.service << \
EOF
[Unit]
Description=Start x11vnc at startup.
After=multi-user.target

[Service]
Type=simple
ExecStart=/usr/bin/x11vnc -auth guess -forever -loop -noxdamage -repeat -rfbauth /etc/x11vnc.pass -rfbport 5900 -shared

[Install]
WantedBy=multi-user.target
EOF

  echo "Configure Services"
  systemctl enable x11vnc.service
  systemctl daemon-reload
  sleep 2
  service x11vnc status
}

# ------------------------
clear
case $1 in
    Exec|e)	Exec	$2 ;;
    Init)	$1	$2 ;;
    Install)	$1	$2 ;;
    *)		Test	;;
esac
