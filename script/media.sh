#!/bin/bash
# Media.sh
#--- VladVons@gmail.com

source $DIR_ADMIN/conf/script/common.sh


DirProcess()
{
  aMode="$1"; aDirIn="$2"; aDirOut="$3"; aMask="$4"; aPar1="$5"; aPar2="$6"; 
  Log "$0->$FUNCNAME, $Mode, $aDirIn, $aDirOut, $aMask, $aPar1, $aPar2";  

  find "$aDirIn" -type f -iname "$aMask" | \
  sort | \
  while read i; do
    StripName=$(echo $i | sed -e "s|${aDirIn}||gI")
    FileOut=${aDirOut}${StripName}

    DirOut=$(dirname "$FileOut")
    if [ ! -d "$DirOut" ]; then 
      mkdir -p "$DirOut"
    fi

    echo "File: $FileOut ..."
    if [ -r "$FileOut" ]; then
      echo "skip"
    else
      case $aMode in
        mp3_Scale)
          lame --silent --scale $aPar1 "$i" "$FileOut" ;;
        mp3_Compress)
          lame --silent --resample $aPar1 --vbr-new -B $aPar2 "$i" "$FileOut" ;;
        wav_ToMp3)
          lame --silent --scale 3 --resample $aPar1 --vbr-new -B $aPar2 "$i" "${FileOut%.wav}.mp3" ;;
        jpg_Compress)
          jpegoptim --max=$aPar1 --dest="$DirOut" "$i";;
        video_Compress)
          ffmpeg -i "$i" -s $aPar1 -strict -2 "$FileOut";;
      esac
    fi;
  done
}


AudioScale()
{
  CheckParam "$0->$FUNCNAME(aDirIn='$1', aDirOut='$2', aScale='$3')" $# 2 3
  aDirIn="$1"; aDirOut="$2"; aScale=${3:-3};
  Log "$0->$FUNCNAME, $aDirIn, $aDirOut, $aScale"

  #DirProcess mp3_Scale "$aDir" "*.mp3" $aScale
  DirProcess mp3_Scale "$aDirIn" "$aDirOut" "*.wav" $aScale
}


AudioCompress()
{
  CheckParam "$0->$FUNCNAME(aDirIn='$1', aDirOut='$2', aBitRate='$3')" $# 2 3
  aDirIn="$1"; aDirOut="$2"; aBitRate=${3:-48};
  Log "$0->$FUNCNAME, $aDirIn, $aDirOut, $aBitRate"

  # Resample = 8, 11.025, 12, 16, 22.05, 24, 32, 44.1, 48
  # BitRate = 32, 40, 48, 56, 64, 80, 96, 112, 128, 160, 192, 224, 256, 320

  Resample=32
  DirProcess mp3_Compress "$aDirIn" "$aDirOut" "*.mp3" $Resample $aBitRate 
}


VideoCompress()
{
  CheckParam "$0->$FUNCNAME(aDirIn='$1', aDirOut='$2', aBitRate='$3')" $# 2 3
  aDirIn="$1"; aDirOut="$2"; aBitRate=${3:-320x240};
  Log "$0->$FUNCNAME, $aDirIn, $aDirOut, $aBitRate"

  DirProcess video_Compress "$aDirIn" "$aDirOut" "*.mp4" $aBitRate 
}


WavToMp3()
{
  CheckParam "$0->$FUNCNAME(aDirIn='$1', aDirOut="$2", aBitRate='$3')" $# 2 3
  aDirIn="$1"; aDirOut="$2"; aBitRate=${3:-48};
  Log "$0->$FUNCNAME, $aDirIn, $aDirOut, $aBitRate"

  Resample=32
  DirProcess wav_ToMp3 "$aDirIn" "$aDirOut" "*.wav" $Resample $aBitRate
}


JpgCompress()
{
  CheckParam "$0->$FUNCNAME(aDirIn='$1', aDirOut='$2', aQuality='$3')" $# 2 3
  aDirIn="$1"; aDirOut="$2"; aQuality=${3:-75};
  Log "$0->$FUNCNAME, $aDirIn, $aDirOut, $aQuality"

  DirProcess jpg_Compress "$aDirIn" "$aDirOut" "*.jpg" $aQuality
}


PngToJpg()
{
  CheckParam "$0->$FUNCNAME(aDirIn='$1', aDirOut='$2')" $# 2 2
  aDirIn="$1"; aDirOut="$2";
  Log "$0->$FUNCNAME, $aDirIn, $aDirOut"

  #sudo apt-get install imagemagick
  mogrify -format jpg "$aDirIn/*.png"
}


Install()
{
  Log "$0->$FUNCNAME"

  apt-get install lame jpegoptim
}



clear
case $1 in
    AudioScale)          "$1" "$2" "$3" ;;
    AudioCompress)       "$1" "$2" "$3" ;;
    JpgCompress)         "$1" "$2" "$3" ;;
    WavToMp3)            "$1" "$2" "$3" ;;
    PngToJpg)            "$1" "$2" "$3" ;;
    Install)             "$1" "$2" "$3" ;;
esac
