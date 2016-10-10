#!/usr/bin/php

<?php
/*------------------------------------
Module:  GetDirWritable
created: 09/06/15
author:  Volodymyr Vons, VladVons@gmail.com
descr:   search writable dirs
------------------------------------*/

class TGetDirWritable
/////////////////////////////////////////////////////
{
  private $Counter, $ExclMask;


  protected function OnDirEvent($aFileName)
  {
    $Result = true;

    //if ($this->ExclMask == "" || !preg_match("/" . $this->ExclMask . "/i", $aFileName) ) {
      if (is_writable($aFileName)) {
        $this->Counter++;
        printf("%d Dir: %s<br>\n", $this->Counter, $aFileName);
      }else{
        //printf("Skip: %s<br>\n", $aFileName);
      }
    //}else{
	//$Result = false;
    //}

    return $Result;
}


  protected function OnFileEvent($aFileName)
  {

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
	      if ($this->OnDirEvent($FileName)) {
                $this->GetFilesRecurs($FileName, $aMaxDepth - 1);
	      }	
          } else {
            $this->OnFileEvent($FileName);
          }
        }
      }
      closedir($DirHandle);
    }  
  } 

 
  function Execute($aDirName, $aMaxDepth, $aExclMask)
  {
    $StartTimer = MicroTime(true);

    $this->Counter      = 0;
    $this->ExclMask     = $aExclMask;
    $this->GetFilesRecurs($aDirName, $aMaxDepth);

    printf("<br>Dirs: %s\n", $this->Counter);
    printf("Time: %s sec.<br>\n", Round(MicroTime(true) - $StartTimer, 1));
  }
}


//------------------------------------------------------------------------------
$DirName    = "/";
$MaxDepth   = 99;
$ExclMask   = "/sys/bus";

$GetDirWritable = new TGetDirWritable();
$GetDirWritable->Execute($DirName, $MaxDepth, $ExclMask);

?>
