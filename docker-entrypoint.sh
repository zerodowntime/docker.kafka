#!/bin/bash

export KAFKA_PORT=9092
export HOST=`hostname -s`
export DOMAIN=`hostname -d`
export KAFKA_LOG_DIR="/var/log/kafka"

export ZOOKEEPER_CLIENT_SERVICE="10.102.83.241"
export ZOOKEEPER_CLIENT_PORT="2181"

# set ownership
chown -R kafka:root /opt/kafka/
chown -R kafka:root /var/log/kafka

# cut hostname from stateful set into name and ordinal
if [[ $HOST =~ (.*)-([0-9]+)$ ]]; then
    export NAME=${BASH_REMATCH[1]}
    export ORD=${BASH_REMATCH[2]}
else
    echo "Failed to parse name and ordinal of Pod"
    exit 1
fi

# get and set id
export MY_ID=$((ORD+1))

# confd
confd -onetime -log-level debug || exit 1
cat /opt/kafka/config/server.properties

# start kafka
exec su-exec kafka /opt/kafka/bin/kafka-server-start.sh /opt/kafka/config/server.properties

