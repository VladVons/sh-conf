#!/usr/bin/php

// This message does not have authentication information or fails to pass
// https://support.symantec.com/en_US/article.TECH246970.html


<?php

function SendMail($aFrom, $aTo)
{
  $Headers = array(
    "From: $aFrom",
    "Reply-To: $aFrom",
    "X-Mailer: PHP/" . PHP_VERSION
  );
  $Headers = implode("\r\n", $Headers);

  $Subject = "PHP Test mail 2";
  $Message = "This is a test email";
  $Res = mail($aTo, $Subject, $Message, $Headers);
  echo "send mail from: $aFrom, to: $aTo, status: $Res";
}


SendMail("root@oster.com.ua", "vladvons@gmail.com");
//SendMail("root@oster.com.ua", "vladvons@mail.ru");
?>
