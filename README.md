# nextdns-proxy

This is a simple DNS server that wraps up dnsmasq and the nextdns client into a single package

## Example usage

Here is an example docker-compose.yml file that will setup two docker services.

1. The autoheal service from willfarrell/autoheal that will kill the container if DNS services fail.
2. The DNS service itself

```
version: '2'

services:
  autoheal:
    container_name: autoheal
    image: willfarrell/autoheal
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
      NEXTDNS_FORWARDING_DOMAIN: <<Your Local DNS Name Here, eg: myfancyhome.net>>
      NEXTDNS_FORWARDING_DNSIP: <<Your Local Router's IP Here, eg: 10.0.1.1>>
    restart: always
```

To use the compose file, just make it in the directory of your choice, then simply run:

`docker-compose up -d`
