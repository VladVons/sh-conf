#!/bin/bash
#--- VladVons@gmail.com, oster.com.ua


cPkgName="broadwayd"
cPkgDepends="gtk-doc-tools libgirepository1.0-dev gobject-introspection libatk-bridge2.0"
cDescr="HTML5 backend"
cTag="system,gtk"
cApt="ppa:malizor/gtk-broadway"


ScriptBeforeInstall()
{
  # search: gtk html5
  # https://blogs.gnome.org/alexl/2011/03/15/gtk-html-backend-update/
  # http://www.linuxfromscratch.org/blfs/view/svn/x/gtk3.html

  apt-get install $cPkgDepends

  # ubintu 15 has already broadway support. so skip 
  apt-cache search libgtk-3-*
  apt-get source libgtk-3-0

  cd gtk+3.0-3.10.8
  ./autogen.sh
  ./configure --prefix=/usr --sysconfdir=/etc --enable-broadway-backend --enable-x11-backend --disable-wayland-backend

  #make clean
  make

  #make check
  #make install
  #apt-get install checkinstall
  checkinstall

  #GDK_BACKEND=broadway gnome-calculator
  GDK_BACKEND=broadway BROADWAY_DISPLAY=:0 gnome-calculator
}
