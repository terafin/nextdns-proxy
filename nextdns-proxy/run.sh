#!/bin/bash

NEXTDNS_CONFIG_ID=$NEXTDNS_CONFIG
NEXTDNS_ARGUMENTS="-listen :8053 -report-client-info -log-queries"

/etc/init.d/dnsmasq restart

if [ -n "$NEXTDNS_CONFIG" ]; then
  NEXTDNS_ARGUMENTS+=" -config $NEXTDNS_CONFIG_ID"
fi

if [ -n "$NEXTDNS_FORWARDING_DOMAIN" ]; then
    if [ -n "$NEXTDNS_FORWARDING_DNSIP" ]; then
        NEXTDNS_ARGUMENTS+="  -forwarder $NEXTDNS_FORWARDING_DOMAIN=$NEXTDNS_FORWARDING_DNSIP"
    fi
fi

echo "Running nextdns with arguments: $NEXTDNS_ARGUMENTS"

/usr/bin/nextdns run $NEXTDNS_ARGUMENTS
