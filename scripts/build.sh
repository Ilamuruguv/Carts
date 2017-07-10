#!/usr/bin/env bash

set -ev

export BUILD_VERSION="0.0.2-SNAPSHOT"
export BUILD_DATE='date +%Y-%m-%dT%T%z'

export SCRIPT_DIR=/opt/app/scriptDir

export CODE_DIR=/opt/app/codeDir
echo $CODE_DIR
echo $SCRIPT_DIR

mvn -DskipTests -Dmaven.test.skip=true -s clean compile
mvn -s test
mvn -DskipTests -Dmaven.test.skip=true -s package
docker ps

