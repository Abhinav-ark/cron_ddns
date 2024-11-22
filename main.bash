#!/usr/bin/env bash

ipv6_address=$(ip -6 addr show dev eth0 scope global | grep -oP 'inet6 \K[0-9a-f:]+(?=/)')
echo "IPv6 Address: $ipv6_address"
