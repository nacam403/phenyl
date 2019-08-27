#!/bin/bash
# This script should not be run in CircleCI. Instead, it utilizes a docker image for mongodb.
if [ "$CI" == "" ];then
  mkdir -p test/tmp/mongodb
  mongod --dbpath test/tmp/mongodb --replSet phenyl-mongodb-replset --fork --syslog --smallfiles --port 27017
  mongo --port 27017 --eval "rs.initiate({_id: 'phenyl-mongodb-replset', members: [{_id: 0, host: 'localhost:27017'}]})"
  mongo --port 27017 --eval "while(true) {if (rs.isMaster().ismaster) break;sleep(1000)};"
else
  echo "In CI envinroment, this script does nothing because mongodb is already launched at an external image."
fi