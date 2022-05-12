FROM debian:11

EXPOSE 53
EXPOSE 53/udp

RUN apt-get update && apt-get install -y locales && localedef -i en_US -c -f UTF-8 -A /usr/share/locale/locale.alias en_US.UTF-8
ENV LANG en_US.utf8
RUN apt-get install -fy apt-transport-https gnupg gpgv wget
RUN wget -qO - https://nextdns.io/repo.gpg | apt-key add -
RUN echo "deb https://nextdns.io/repo/deb stable main" | tee /etc/apt/sources.list.d/nextdns.list

RUN apt-get update ; apt-get install -fy nextdns dnsutils ; rm -rf /var/lib/apt/lists/*

RUN mkdir -p /var/nextdns
COPY run.sh /var/nextdns/run.sh

HEALTHCHECK --interval=60s --timeout=10s --start-period=5s --retries=1 \
    CMD dig +time=20 @127.0.0.1 -p 53 probe-test.dns.nextdns.io && dig +time=20 @127.0.0.1 -p 53 probe-test.dns.nextdns.io

CMD ["/var/nextdns/run.sh"]
