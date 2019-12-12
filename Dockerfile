##
## author: Adam Ćwiertnia
##

FROM zerodowntime/openjdk:1.8.0-centos7

ARG KAFKA_VERSION
ARG KAFKA_NAME

# Get kafka
RUN curl -L https://www.apache.org/dist/kafka/$KAFKA_VERSION/$KAFKA_NAME-$KAFKA_VERSION.tgz \
	-o /opt/$KAFKA_NAME-$KAFKA_VERSION.tgz \
	&& curl -L https://www.apache.org/dist/kafka/$KAFKA_VERSION/$KAFKA_NAME-$KAFKA_VERSION.sha512 \
	-o /opt/$KAFKA_NAME-$KAFKA_VERSION.tgz.sha512 \
	&& cd /opt \
	&& sha512sum $KAFKA_NAME-$KAFKA_VERSION.tgz \
	&& tar xzf $KAFKA_NAME-$KAFKA_VERSION.tgz \
	&& useradd kafka \
	&& chown -R kafka /opt/$KAFKA_NAME-$KAFKA_VERSION \
	&& ln -s /opt/$KAFKA_NAME-$KAFKA_VERSION /opt/kafka \
	&& chown -h kafka /opt/kafka

VOLUME ["/var/log/kafka"]

EXPOSE 9092

COPY confd/ /etc/confd
COPY docker-entrypoint.sh /

COPY post-start.sh /opt/
COPY pre-stop.sh /opt/
COPY liveness-probe.sh /opt/
COPY readiness-probe.sh /opt/

ENTRYPOINT ["/docker-entrypoint.sh"]
