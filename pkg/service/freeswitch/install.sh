ppa()
{
  wget -O - https://files.freeswitch.org/repo/deb/freeswitch-1.8/fsstretch-archive-keyring.asc | apt-key add -
  echo "deb http://files.freeswitch.org/repo/deb/freeswitch-1.8/ stretch main" > /etc/apt/sources.list.d/freeswitch.list

  apt-get update
  apt-cache search freeswitch > cache.txt
}


pkg()
{
  cPkgDepends="freeswitch freeswitch-systemd \
    freeswitch-mod-sofia freeswitch-mod-dptools freeswitch-mod-event-socket \
    freeswitch-mod-shout freeswitch-meta-codecs freeswitch-mod-sndfile freeswitch-mod-local-stream \
        freeswitch-mod-tone-stream \
    freeswitch-mod-console freeswitch-mod-logfile \
    freeswitch-mod-db freeswitch-mod-cdr-sqlite \
    freeswitch-mod-lua freeswitch-mod-python \
    freeswitch-mod-xml-rpc freeswitch-mod-loopback freeswitch-mod-commands freeswitch-mod-expr \
        freeswitch-mod-cidlookup freeswitch-mod-fail2ban freeswitch-mod-conference \
        freeswitch-mod-fifo freeswitch-mod-hash freeswitch-mod-voicemail \
    freeswitch-mod-dialplan-xml freeswitch-mod-native-file \
    freeswitch-conf-minimal freeswitch-conf-vanilla"
    #freeswitch-mod-say-ru freeswitch-lang-ru freeswitch-music-default

  apt-get install $cPkgDepends 

  #systemctl daemon-reload
  #systemctl enable freeswitch.service
  #freeswitch
}

python()
{
  apt-get install python-pip --no-install-recommends
  pip install Flask
}

records()
{
  aDir="$1";
  #aDir=/mnt/share/temp/record

  #chmod -R u+r,g+r,o+r "$aDir"

  find "$aDir" -type f -print0 | xargs -0 chmod 644
  find "$aDir" -type d -print0 | xargs -0 chmod 755
}

sound()
{
  #http://files.freeswitch.org/releases/sounds/
  DirDst="/usr/share/freeswitch/sounds/"

  wget http://files.freeswitch.org/releases/sounds/freeswitch-sounds-ru-RU-elena-16000-1.0.51.tar.gz -O archive.tar.gz
  mkdir -p $DirDst
  tar -xf ./archive.tar.gz -C $DirDst
}

run()
{
  #freeswitch -help 
  /usr/bin/freeswitch -u freeswitch -g freeswitch -ncwait -conf /etc/freeswitch -log /var/log/freeswitch -db /var/lib/freeswitch/db
}

sys()
{
  # liphone - linux SIP client
  # phonerlite - windows SIP client
  apt install mc rsync htop zip unzip wget net-tools git-core locate sqlite sudo lame fail2ban ca-certificates ssmtp
}

pb()
{
  #https://habr.com/company/big/blog/330360/
  sudo -u freeswitch sqlite3 /var/lib/freeswitch/db/phonebook.db < init.sql
}

mp3()
{
  # to low mono 
  #lame --decode innput.mp3  - | lame -m m -V2 -B 48 - output.mp3

  # to mono 8Khz
  lame --decode Wonder.mp3 - | lame -m m -V2 --resample 8 - output.mp3
}

reload()
{
    fs_cli -x 'reloadxml'
    fs_cli -x 'reload mod_dialplan_xml'
    fs_cli -x 'reload mod_sofia'
}

status()
{
  clear

  ls -1 /usr/lib/freeswitch/mod | sort
  echo
  fs_cli -x 'eval ${sounds_dir}'
  echo
  fs_cli -x 'sofia status'
  echo
  fs_cli -x 'show registrations'
  echo
  fs_cli -x 'show calls'
  echo
  fs_cli -x 'show codec'
  echo
  #fs_cli -x 'show modules'
  echo
  fs_cli -x 'sofia status profile lan' | grep WS-BIND-URL
}


sys
ppa
pkg
#run
#reload
#status
#pb
#sound
#python

