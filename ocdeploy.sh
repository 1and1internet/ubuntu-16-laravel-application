#!/bin/bash

echo $1

if [ -z "$1" ]; then
	echo "No parameter"
	exit 1
fi

name=$1
oc new-project $1
oc new-app --file=openshift-template.yaml --param=APP_HOSTNAME_SUFFIX=.$1.da.10.2.2.2.xip.io

oc status

docker login -u admin -p $(oc whoami -t) hub.10.2.2.2.xip.io:80
docker tag laravelapp hub.10.2.2.2.xip.io:80/$1/ubuntu-16-laravel-application
docker push hub.10.2.2.2.xip.io:80/$1/ubuntu-16-laravel-application 

echo ""
oc get is

echo ""
oc status -v

echo ""
