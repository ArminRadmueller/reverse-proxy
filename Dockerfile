FROM debian:12.4-slim

LABEL org.opencontainers.image.authors='Armin Radmüller'

ENV TZ='Europe/Rome' \
    LANG=C.UTF-8

RUN export DEBIAN_FRONTEND=noninteractive && \
    apt-get update && apt-get upgrade && \
    apt-get install -yq cron locales netcat-traditional procps supervisor \
                        apache2 apache2-utils certbot python3-certbot-apache openssl && \
    apt-get autoremove -y && apt-get clean && rm -Rf /var/lib/apt/lists/* && \
    rm /var/log/alternatives.log /var/log/dpkg.log && rm -R /var/log/apt && \
    # cleanup demo environment
    rm -Rf /etc/apache2/* \
    rm -f /var/www/html/index.html \
    # purge unnecessary data (Cleanup)
    rm -R /var/log/* && \
    rm -R /etc/logrotate.d/* && \
    mkdir -p /var/log/supervisor && \
    # prepare docker enviroment
    echo "net.ipv4.tcp_timestamps = 0" >> /etc/sysctl.conf && \
    echo $TZ > /etc/timezone

ADD ./assets /

RUN chmod +x /usr/local/bin/entrypoint.sh && \
    chmod +x /usr/local/bin/setup.sh && \
    chmod +x /usr/local/bin/start_apache2.sh && \
    chmod +x /usr/local/bin/start_cron.sh

HEALTHCHECK --interval=15s --timeout=5s --start-period=30s CMD /usr/local/bin/healthcheck.sh

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
