# VladVons@gmail.com
# apt install ffmpeg timelimit

Record()
{
    aDir=$1;

    Duration=1200
    TimeStamp="drawtext=fontfile=/usr/share/fonts/truetype/dejavu/DejaVuSerif.ttf: fontsize=14: fontcolor=white: fontsize=30: box=1: boxcolor=black: x=(W-tw)/2: y=H-th-10: text='%{localtime}'"
    Screen=$(xrandr -q --current | grep '*' | awk '{print$1}')

    Day=$(date +%Y-%m-%d)
    Dir=$aDir/$Day
    mkdir -p $Dir

    while true; do 
        Time=$(date +%H-%M-%S)
        File=$Dir/$Time.mp4
        echo "recording to $File ..."

        timelimit -t$Duration ffmpeg -f x11grab -s $Screen -i :0.0 -r 5 -vf "$TimeStamp" $File
    done
}

#Record /mnt/smb/temp/Users/screen/operator1
Record $1
