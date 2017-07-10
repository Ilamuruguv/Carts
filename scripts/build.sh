#!/usr/bin/env bash

set -ev

export BUILD_VERSION="0.0.2-SNAPSHOT"
export BUILD_DATE='date +%Y-%m-%dT%T%z'

pwd

mvnpath="/opt/app/maven/maven/bin"
$mvnpath/mvn clean compile
$mvnpath/mvn test
$mvnpath/mvn package
 sudo docker ps

