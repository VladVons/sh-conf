#!/bin/bash
#--- VladVons@gmail.com, oster.com.ua


cPkgName="openjdk-8-jdk"
cDescr="Virtual Java"
cTag="system,console,lang"
cPpa="ppa:openjdk-r/ppa"

ScriptAfterInstall()
{
  update-alternatives --get-selections | grep ^java
  java -version
}
