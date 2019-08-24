#!/bin/bash
# VladVons@gmail.com

FindDir="upload\/"
ReplaceDir="public_html\/"
ZipFile="dblogmodulecompiledoc2.3.0.2.v3.1.4.ocmod.zip"

Delete()
{
    unzip -Z1 $ZipFile |\
    sed "s/$FindDir/$ReplaceDir/g" |\
    while read i; do
        if [ -r "$i" ]; then
            echo "$i"
            rm "$i"
        fi
    done
}

Delete

