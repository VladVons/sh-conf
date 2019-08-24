#!/bin/bash
# VladVons@gmail.com

Ver="Package installer 1.01, VladVons@gmail.com"
echo $Ver
echo

RootDir=$(pwd)


CopyFiles()
{
    Log "$FUNCNAME"

    cp -r Files/* / 2>/dev/null
}


ParseDir()
{
    for File in $(ls Inc/*.{conf,sh} 2>/dev/null | sort); do
        echo "Include $File ..."
        source $File
    done

    for File in $(ls Script/*.sh 2>/dev/null | sort); do
        echo
        echo "PreInstall $File ..."
        source $RootDir/Install/Inc/ClearVar.sh
        source $File
        PreInstall
    done

    echo
    for File in $(ls Pkg/*.lst 2>/dev/null | sort); do
        echo "Install $File ..."
        FileListInstall_2 $File
    done

    for File in $(ls Script/*.sh 2>/dev/null | sort); do
        echo
        echo "PostInstall $File ..."
        source $RootDir/Install/Inc/ClearVar.sh
        source $File
        PostInstall
    done

    CopyFiles
}


Run()
{
    aFile="$1";

    cd Install
    ParseDir
    cd $RootDir

    if [ -d lst/$aFile ]; then
        cd lst/$aFile
        ParseDir
    else
        PkgUpdate
        FileListInstall_2 lst/${aFile}.lst
    fi

    PkgClear
}


#Run xubuntu
#Run proxmox
#Run raspberry
Run vpn
#Run nas
