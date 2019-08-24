# VladVons@gmail.com

PkgCheck()
{
    aPackage="$1";

    ##dpkg -l | awk '{ print $2, $3 }' | sort | grep -w -m 1 "$aPackage"
    dpkg -l $aPackage 2>&1 | grep ii | awk '{ print $3 }'
    #cat $gFileDpkgFast | grep -w -m 1 "$aPackage"
}


PkgUpdate()
{
    Log "$FUNCNAME"

    apt-get update
    apt-get dist-upgrade
    #reboot
}


PkgClear()
{
    Log "$FUNCNAME"

    rm /var/cache/apt/archives/lock 2>/dev/null
    apt autoremove
    apt clean
}


FileListInstall_1()
# install packages listed in file
# ------------------------
{
    aFile="$1";

    if [ -r $aFile ]; then
        declare -a Files=$(cat $aFile | grep "^[^\#]")

        for File in ${Files[@]}; do
            Installed=$(_PkgCheck $File)
            if [ ! "$Installed" ]; then
                echo.
                echo $File
                apt-get install --yes --no-install-recommends $File
            fi
        done
    else
        Log "Error! Can't read file: $aFile"
    fi
}


FileListInstall_2()
{
    aFile="$1";
    Log "$FUNCNAME, $aFile"

    apt-get install --yes --no-install-recommends $(grep -vE "^\s*#" $aFile | tr "\n" " ")
}
