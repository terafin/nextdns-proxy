# nextdns-proxy

This is a simple DNS server that wraps up dnsmasq and the nextdns client into a single package

## Example usage

Here is an example docker-compose.yml file that will setup three docker services.

1. The autoheal service from willfarrell/autoheal that will kill the container if DNS services fail.
2. The DNS service itself
3. Will auto update nextdns-proxy

```
version: '2'

services:
  watchtower:
    container_name: watchtower
    restart: always
    image: v2tec/watchtower
    environment:
      WATCHTOWER_CLEANUP: "true"
    volumes:
      - /var/run/docker.sock:/var/run/docker.sock
  autoheal:
    container_name: autoheal
    image: jstrader/autoheal
    volumes:
      - /var/run/docker.sock:/var/run/docker.sock
    restart: always
  nextdns-proxy:
    image: "terafin/nextdns-proxy:latest"
    container_name: nextdns-proxy
    hostname: nextdns-proxy
    labels:
      autoheal: "true"
    ports:
     - "53:53/udp"
    environment: # Note, these are ALL optional
      NEXTDNS_CONFIG: <<Your NextDNS Config/Endpoint ID here, this can be found on the NextDNS Setup page>
      NEXTDNS_CONFIG_CUSTOM1: <<Your conditional routing pattern here. Documentation here: https://github.com/nextdns/nextdns/wiki/Conditional-Configuration>
      NEXTDNS_CONFIG_CUSTOM2: <<Your conditional routing pattern here. Documentation here: https://github.com/nextdns/nextdns/wiki/Conditional-Configuration>
      NEXTDNS_CONFIG_YOUR_CUSTOM_SUFFIX: <<Your conditional routing pattern here. Documentation here: https://github.com/nextdns/nextdns/wiki/Conditional-Configuration>
      NEXTDNS_FORWARDING_DOMAIN: <<Your Local DNS Name Here, eg: myfancyhome.net>>
      NEXTDNS_FORWARDING_DNSIP: <<Your Local Router's IP Here, eg: 10.0.1.1>>
      NEXTDNS_MAX_TTL: <<Maximum TTL in seconds for hostnames from NextDNS - defaults to 15>>
      NEXTDNS_CACHE_SIZE: <<Cache size for NextDNS - defaults to 10MB>>
    restart: always
```

To use the compose file, just make it in the directory of your choice, then simply run:

`docker-compose up -d`

Note, for Raspberry Pi deployment, change the line:
`image: jstrader/autoheal`
to be:
`image: jstrader/autoheal:latest-arm`
