# VladVons@gmail.com

PostInstall()
{
    apt install unzip

    File="eXtplorer_2.1.13.zip"
    wget https://extplorer.net/attachments/download/82/$File 

    Dir="/var/www/app/eXtplorer"
    unzip -o $File -d $Dir
    rm $File
    chown -R www-data $Dir
}
