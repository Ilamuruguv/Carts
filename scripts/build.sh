#!/usr/bin/env bash

set -ev

export BUILD_VERSION="0.0.2-SNAPSHOT"
export BUILD_DATE='date +%Y-%m-%dT%T%z'

export SCRIPT_DIR=/opt/app/scriptDir

export CODE_DIR=/opt/app/codeDir
echo $CODE_DIR
sudo docker run --rm -v /home/ec2-user/.m2:/root/.m2 -v $CODE_DIR:/usr/src/mymaven -w /usr/src/mymaven maven:3.3.9 mvn -q -DskipTests package

sudo cp $CODE_DIR/target/*.jar $CODE_DIR/docker/carts

for m in ./docker/*/; do
   
    sudo docker build \
      --build-arg BUILD_VERSION=$BUILD_VERSION \
      --build-arg BUILD_DATE=$BUILD_DATE \
      --build-arg COMMIT=$COMMIT \
      -t $CODE_DIR/$m;
done;
