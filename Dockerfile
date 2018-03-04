FROM ubuntu
MAINTAINER sameer@damagehead.com

ENV SQUID_CACHE_DIR=/var/spool/squid \
    SQUID_LOG_DIR=/var/log/squid \
    SQUID_USER=proxy

RUN apt-get update && apt-get install -y squid 

RUN sed -i "s|\#acl\ localnet\ src\ 10\.0\.0\.0\/8|acl\ localnet\ src\ `hostname -i|awk '{print $1}'`\/32|g" /etc/squid/squid.conf
RUN sed -i 's|\#http_access\ allow\ localnet|http_access\ allow\ localnet|g' /etc/squid/squid.conf

COPY entrypoint.sh /sbin/entrypoint.sh
RUN chmod 755 /sbin/entrypoint.sh

EXPOSE 3128/tcp
VOLUME ["${SQUID_CACHE_DIR}"]
ENTRYPOINT ["/sbin/entrypoint.sh"]
