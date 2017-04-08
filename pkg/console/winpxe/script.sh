#!/bin/bash

source ./const.sh


clear
case $1 in
    Info)		$1	$2 $3 ;;
    Init)		$1	$2 $3 ;;
    Pkg)		$1	$2 $3 ;;
    Chroot)		$1 	$2 $3 ;;
esac
