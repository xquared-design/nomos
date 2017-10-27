#!/bin/bash

IMAGES=""

CKRP=`whereis realpath`

if [ "$CKRP" == "" ] ; then
 realpath() {
    [[ $1 = /* ]] && echo "$1" || echo "$PWD/${1#./}"
 }
fi

set -e

echo Docker Build!

SCRIPTPATH=`realpath $0`
SCRIPTDIR=`dirname "$SCRIPTPATH"`
BASEDIR=`realpath "$SCRIPTDIR/../."`

ENVFILE="$BASEDIR/docker/nomos.env"
WEBDIR="$BASEDIR/web"

cd "$BASEDIR"

## Check if we have a valid nomos.env file
if [ ! -f "$ENVFILE" ] ; then
 echo "Missing nomos.env file!"
 exit
fi

## Check which images to build
BUILD_ALL=0
BUILD_DB=0
BUILD_FRONTEND=0
BUILD_STATIC=0
BUILD_WORKER=0

for argv in "$@" ; do
 case $argv in
  "-a")
   BUILD_ALL=1
  ;;
  "-d")
   BUILD_DB=1
  ;;
  "-f")
   BUILD_FRONTEND=1
  ;;
  "-s")
   BUILD_STATIC=1
  ;;
  "-w")
   BUILD_WORKER=1
  ;;
 esac
done

if [ $BUILD_ALL -eq 1 -o $BUILD_DB -eq 1 ] ; then
 IMAGES=`echo "$IMAGES nomos-db"`
fi

if [ $BUILD_ALL -eq 1 -o $BUILD_FRONTEND -eq 1 ] ; then
 IMAGES=`echo "$IMAGES nomos-frontend"`
fi

if [ $BUILD_ALL -eq 1 -o $BUILD_STATIC -eq 1 ] ; then
 IMAGES=`echo "$IMAGES nomos-static"`
fi

if [ $BUILD_ALL -eq 1 -o $BUILD_WORKER -eq 1 ] ; then
 IMAGES=`echo "$IMAGES nomos-worker"`
fi

if [ "$IMAGES" = "" ] ; then
 echo "No images selected. Aborting..."
 exit
fi

echo "Building $IMAGES"

for img in $IMAGES ; do

 echo "[$img] Building..."

 BOOTSTRAP=`echo "$BASEDIR/docker/images/$img/bootstrap.sh"`

 if [ -f "$BOOTSTRAP" ] ; then
  echo "[$img] Bootstrapping..."
  sh "$BOOTSTRAP" | while read line ; do echo "[$img] $line" ; done
 else
  echo "[$img] Skipping bootstrap..."
 fi

 echo "[$img] Building Docker image..."
 echo "================================"
 RES=""
 echo docker build -t "vanhack/$img" -f docker/images/$img/Dockerfile .
 docker build -t "vanhack/$img" -f docker/images/$img/Dockerfile .
 RES=$?
 echo "RES: $RES"
 echo "================================"

 if [ $RES -ge 1 ] ; then
  echo "[$img] An error occurred during build"
  exit
 fi

done
