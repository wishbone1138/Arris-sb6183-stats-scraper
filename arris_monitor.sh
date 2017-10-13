#!/bin/bash

CURL_OUT=`curl -m 10 -s "http://192.168.100.1" | awk -f ./parse_arris.awk`
echo "curl output: $CURL_OUT"

curl -s -i -m 5 -XPOST 'http://localhost:8086/write?db=telegraf' --data-binary "$CURL_OUT"
