#!/bin/bash

NEXTDNS_CONFIG_ID=$NEXTDNS_CONFIG
NEXTDNS_ARGUMENTS="-listen :8053 -report-client-info -log-queries"

/etc/init.d/dnsmasq restart

echo "Parsing configuration"

if [ -n "$NEXTDNS_CONFIG" ]; then
    NEXTDNS_ARGUMENTS+=" -config $NEXTDNS_CONFIG_ID"
    echo " => Found base NextDNS Config: $NEXTDNS_CONFIG_ID"
fi

while IFS='=' read -r -d '' n v; do
    if [[ "$n" = "NEXTDNS_CONFIG_"* ]]; then
        echo " => Found additional config: $n => $v"
        NEXTDNS_ARGUMENTS+=" -config $v"
    fi
done < <(env -0)

if [ -n "$NEXTDNS_FORWARDING_DOMAIN" ]; then
    if [ -n "$NEXTDNS_FORWARDING_DNSIP" ]; then
        NEXTDNS_ARGUMENTS+="  -forwarder $NEXTDNS_FORWARDING_DOMAIN=$NEXTDNS_FORWARDING_DNSIP"
    fi
fi

echo "Running nextdns with arguments: $NEXTDNS_ARGUMENTS"

/usr/bin/nextdns run $NEXTDNS_ARGUMENTS
