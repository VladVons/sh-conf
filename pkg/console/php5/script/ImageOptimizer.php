#!/usr/bin/php

<?php
/*------------------------------------
Module:  ImageOptimizer
created: 01/01/15
author:  Volodymyr Vons, VladVons@gmail.com
descr:   reduce/optimize site images
------------------------------------*/

class TImageOptimizer
/////////////////////////////////////////////////////
{
  private $ArrLog, $TotalOldSize, $TotalNewSize; 
  private $optHistFile, $optExclMask, $optMaxPix, $optMaxSize, $optMaxDepth, $optQuality, $optBackUp;

  
  function __construct()
  {
    $this->Init();

    if ($this->optHistFile != "" && file_exists($this->optHistFile))
      $this->ArrLog = unserialize(file_get_contents($this->optHistFile));
    else
      $this->ArrLog = array();
  }


  function __destruct()
  {
    if ($this->optHistFile != "") 
      file_put_contents($this->optHistFile, serialize($this->ArrLog));
  }


  protected function Init()
  { 
    $this->optQuality   = 75;
    $this->optMaxDepth  = 100;
    $this->optExclMask  = "thumb|temp|tmp|cache";
    $this->optMaxPix    = 800;
    $this->optMaxSize   = 100; // KByte
    $this->optBackUp    = true;
    $this->optHistFile  = __FILE__ . ".dat";
  }


  protected function BackUpFile($aFileName)
  {
    if ($this->optBackUp) {
      $BakFileName = $aFileName . ".bak";
      Copy($aFileName, $BakFileName);  
    }  
  }


  protected function Optimize_jpg($aFileName, $aWidth, $aHeight, $aNewWidth, $aNewHeight)
  {
    $ImgSrc = ImageCreateFromJpeg($aFileName);
    $ImgNew = ImageCreateTrueColor($aNewWidth, $aNewHeight);
    ImageCopyResampled($ImgNew, $ImgSrc, 0, 0, 0, 0, $aNewWidth, $aNewHeight, $aWidth, $aHeight);
    ImageJpeg($ImgNew, $aFileName, $this->optQuality);
    ImageDestroy($ImgNew);
    
    return FileSize($aFileName);
  }


  protected function OnFileEvent($aFileName)
  {
    if ($this->optExclMask == "" || !preg_match("/" . $this->optExclMask . "/i", $aFileName) ) {
      $PathInfo = PathInfo($aFileName);
      $FileExt  = StrToLower($PathInfo["extension"]);
      $FileSize = FileSize($aFileName);
      if ($FileSize > $this->optMaxSize * 1000) {
        if ($FileExt == "jpg" || $FileExt == "jpeg") {
          if (!in_array($aFileName, $this->ArrLog)) {
            $this->ArrLog[] = $aFileName;

            list($Width, $Height) = GetImageSize($aFileName);
            $MaxPix = max($Width, $Height);
            if ($MaxPix > $this->optMaxPix) {
              $Scale = $this->optMaxPix / $MaxPix;
              $NewHeight = (int) abs($Height * $Scale);
              $NewWidth  = (int) abs($Width  * $Scale);
            }else{
              $NewHeight = $Height;
              $NewWidth  = $Width;
            }

            $NewFileSize = $FileSize;
            $this->BackUpFile($aFileName);
            if (exif_imagetype($aFileName) == IMAGETYPE_JPEG) 
                $NewFileSize = $this->Optimize_jpg($aFileName, $Width, $Height, $NewWidth, $NewHeight);

            $this->Counter++;
            $this->TotalOldSize += $FileSize;
            $this->TotalNewSize += $NewFileSize;
            $Ratio = (int) abs($NewFileSize / $FileSize * 100);
            printf("No: %s, Name: %s, Size: %sKb, Ratio: %s, Width: %s, Height: %s <br>\n", 
                   $this->Counter, $aFileName, Round($FileSize / 1000), $Ratio, $Width, $Height);
          }
        }
      }
    }
  }


  protected function GetFilesRecurs($aDirPath, $aMaxDepth)
  {
    $DirHandle = @opendir($aDirPath);
    if ($DirHandle) {
      while(false !== ($File = readdir($DirHandle))) {
        if ($File != "." && $File != "..") {
          $FileName = $aDirPath . ($aDirPath == "/" ? "" : "/") . $File;
          if (@is_dir($FileName)) {
            if ($aMaxDepth > 0)
              $this->GetFilesRecurs($FileName, $aMaxDepth - 1);
          } else {
            $this->OnFileEvent($FileName);
          }
        }
      }
      closedir($DirHandle);
    }  
  } 

 
  function Execute($aDirName, $aMaxDepth, $aMaxPix, $aMaxSize, $aExclMask, $aBackUp)
  {
    $StartTimer = MicroTime(true);

    $this->optExclMask = $aExclMask;
    $this->optMaxPix   = $aMaxPix;
    $this->optMaxSize  = $aMaxSize;
    $this->optBackUp   = $aBackUp;

    $this->Counter      = 0;
    $this->TotalOldSize = 0;
    $this->TotalNewSize = 0;    
    $this->GetFilesRecurs($aDirName, $aMaxDepth);

    printf("<br>Files: %s, Size old: %sKb, Size new: %sKb<br>\n",  
         $this->Counter, Round($this->TotalOldSize / 1000), Round($this->TotalNewSize / 1000));
    printf("Time: %s sec.<br>\n", Round(MicroTime(true) - $StartTimer, 1));
  }
}


//------------------------------------------------------------------------------
$DirName    = ".";
$MaxDepth   = 99;
$MaxPix     = 900;
$MaxSizeKb  = 100;
$ExclMask   = "Thumb|Temp|tmp|cache";
$BackUp     = false;

$ImageOptimizer = new TImageOptimizer();
$ImageOptimizer->Execute($DirName, $MaxDepth, $MaxPix, $MaxSizeKb, $ExclMask, $BackUp);

?>
