#!/usr/bin/php
<?php

function SendMail($aTo)
{
  $Subject = "PHP Test mail";
  $Message = "This is a test email";
  $From    = "vladvons@gmail.com";
  $Headers = "From: $From";
  $Res = mail($aTo, $Subject, $Message, $Headers);
  echo "Mail status: $Res";
}

SendMail("VladVons@mail.ru");
?>
