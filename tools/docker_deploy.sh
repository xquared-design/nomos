#!/bin/bash

getpath() {
 cd `dirname $1` ; pwd
}

set -e

echo "################################"
echo "### Docker Deploy!"
echo "################################"

SCRIPTPATH=`getpath $0`
BASEDIR=`dirname "$SCRIPTPATH"`

DBDIR="$BASEDIR/data/mysql"
NGINXLOGDIR="$BASEDIR/data/logs/nginx"
NOMOSLOGDIR="$BASEDIR/data/logs/nomos"
WEBDIR="$BASEDIR/web"

ENVFILE="$BASEDIR/docker/nomos.env"

REBUILD=0
IGNORE_CHECK=0
TEST_FRONTEND=0

for argv in "$@" ; do
 case $argv in
  "-h")
   echo "Usage: docker_deploy.sh [-i] [-r] [-t]"
   echo ""
   echo "-i Ignore checks"
   echo "-r Rebuild"
   echo "-t Deploy test frontend"
   echo ""
   exit
  ;;
  "-i")
   IGNORE_CHECK=1
  ;;
  "-r")
   REBUILD=1
  ;;
  "-t")
   TEST_FRONTEND=1
  ;;
  *)
   echo ""
   echo "Invalid arguments"
   echo ""
   $0 -h
   exit 1
 esac
done

## Check if we have a valid nomos.env file
if [ ! -f "$ENVFILE" ] ; then
 echo "Missing nomos.env file!"
 exit
fi

## Check for updates
if [ $REBUILD -eq 0 ] ; then
 LATEST=`git log --format="%H" -n 1`

 git pull

 CURRENT=`git log --format="%H" -n 1`

 if [ $CURRENT = $LATEST ]; then
   echo "Already on latest version. Exiting."
   if [ $IGNORE_CHECK -eq 0 ] ; then
    exit
   fi
 else
  REBUILD=1
 fi
fi

if [ $REBUILD -eq 1 ] ; then
 echo "Rebuilding..."
 $BASEDIR/tools/docker_build.sh -a
fi

echo "Deploying nomos database..."

dbstatus=`docker ps -aq -f 'name=nomos-db' --format "{{.Status}}" | awk '{ print $1 }'`

if [ "$dbstatus" = "Up" ] ; then
 echo "Container is already running"
elif [ "$dbstatus" = "" ] ; then
 echo "Missing database. Creating new database container..."
 docker run -d --name nomos-db -v $DBDIR:/var/lib/mysql -e MYSQL_DATABASE=$NOMOS_DB_DATABASE -e MYSQL_USER=$NOMOS_DB_USER -e MYSQL_PASSWORD=$NOMOS_DB_PASS vanhack/nomos-db
elif [ "$dbstatus" = "Created" -o "$dbstatus" = "Exited" ] ; then
 echo "Starting up database"
 docker start nomos-db
 sleep 5
 dbstatus=`docker ps -q -f 'name=nomos-db' --format "{{.Status}}" | awk '{ print $1 }'`
 if [ "$dbstatus" != "Running" ] ; then
  echo "Fatal issue bringing database online:"
  echo ""
  echo "$dbstatus"
  echo ""
  exit
 fi
else
 echo "Unknown error for nomos-db container"
 echo ""
 echo "$dbstatus"
 echo ""
 exit
fi

echo "Deploying nomos-rabbitmq..."

docker stop nomos-rabbitmq || echo "Could not stop container..."
docker rm nomos-rabbitmq || echo "Could not remove container..."
docker run -d --name nomos-rabbitmq vanhack/nomos-rabbitmq

echo "Deploying nomos-static..."

docker stop nomos-static || echo "Could not stop container..."
docker rm nomos-static || echo "Could not remove container..."
docker run -d --name nomos-static vanhack/nomos-static

echo "Deploying nomos-worker..."

docker stop nomos-worker || echo "Could not stop container..."
docker rm nomos-worker || echo "Could not remove container..."
docker run -d --name nomos-worker --link nomos-db --link nomos-rabbitmq -v $NOMOSLOGDIR:/www/logs --env-file docker/nomos.env vanhack/nomos-worker

echo "Fix nomos webhooker api key"
NOMOS_WEBHOOKER_APIKEY=`egrep 'NOMOS_WEBHOOKER_APIKEY' docker/nomos.env | cut -f2 -d'='`

if [ "$NOMOS_WEBHOOKER_APIKEY" = "" ] ; then
 docker -it nomos-worker /www/tools/getwebhookerapikey.sh | awk '{ print "NOMOS_WEBHOOKER_APIKEY=" $1 }' >> docker/nomos.env
exit

echo "Deploying nomos-webhooker..."

docker stop nomos-webhooker || echo "Could not stop container..."
docker rm nomos-webhooker || echo "Could not remove container..."
docker run -d --name nomos-webhooker --link nomos-rabbitmq --link nomos-worker -v $NOMOSLOGDIR:/www/logs --env-file docker/nomos.env vanhack/nomos-webhooker

if [ $TEST_FRONTEND -eq 1 ] ; then
 echo "Deploying nomos-frontend..."

 docker stop nomos-frontend || echo "Could not stop container..."
 docker rm nomos-frontend || echo "Could not remove container..."
 docker run -d --name nomos-frontend --link nomos-static --link nomos-worker -v $NGINXLOGDIR:/var/log/nginx -p 80:80 vanhack/nomos-frontend
fi
