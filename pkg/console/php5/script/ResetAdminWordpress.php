#!/usr/bin/php

<?php
/*------------------------------------
Module:  ResetAdminWordpress
created: 27/01/16
author:  Volodymyr Vons, VladVons@gmail.com
descr:   Reset admin password for wordpress
------------------------------------*/


function Query($aConnect, $aSQL)
{
  $Result = mysql_query($aSQL, $aConnect) or Die ("Query in $aSQL");
  $Arr = mysql_fetch_assoc($Result);
  @mysql_free_result($Result);

  return $Arr;
}


function ResetAdmin($aHost, $aDB, $aUser, $aPassw)
{
  $Connect = mysql_pconnect($aHost, $aUser, $aPassw ) or Die("Cant connect to server $aHost");
  mysql_select_db($aDB, $Connect) or Die("Cant open database: $aDB");

  $Arr=Query($Connect, "SHOW TABLES LIKE '%users'");
  if (Count($Arr) > 0) {
    list($Label, $Table) = Each($Arr);

    $Arr=Query($Connect, "SELECT ID, user_login, user_pass FROM $Table");
    print("Current settings:<br>");
    print_r($Arr);

    Query($Connect, "UPDATE $Table SET user_login='admin', user_pass=MD5('admin') WHERE ID = 1");

    $Arr=Query($Connect, "SELECT ID, user_login, user_pass FROM $Table");
    print("New settings:<br>");
    print_r($Arr);
  }else{
    print ("Table users not found");
  }
}


ResetAdmin("wda.mysql.ukraine.com.ua", "wda_revival", "wda_revival", "rev2011");
?>
