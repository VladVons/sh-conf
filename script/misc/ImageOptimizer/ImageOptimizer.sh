#!/bin/bash

Dir1="catalog"
Dir2="catalog2"
Dir3="catalog3"
FileList="Image.txt"


Sync()
# ------------------------
{
  # png -> jpg
  #mogrify -format jpg *.png

  rsync --files-from=$FileList $Dir1 $Dir2
  #find $Dir2 | xargs jpegoptim --max=75 --dest=$Dir3
  ls $Dir2  | xargs -I {} -t convert -quality 75 -resize "1024x768>" $Dir2/{} $Dir3/{}
}


mkdir -p $Dir2 $Dir3
Sync
