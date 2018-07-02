#!/bin/bash
if [ "$#" -lt 4 ]; then
    echo "USAGE: placeorder.sh [B/S] [sym] [qty] [price]"
    exit 1
fi

BorS=$1
SYM=$2
QTY=$3
PRICE=$4
echo "$BorS $SYM $QTY@$PRICE"

curl -b cookie.txt "https://${SET_SERVER}/daytradeflex/streamingSeos.jsp" -H "Origin: https://${SET_SERVER}" -H "Accept-Encoding: gzip, deflate, br" -H "Accept-Language: en-US,en;q=0.8" -H "User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/51.0.2704.103 Safari/537.36" -H "Content-Type: application/x-www-form-urlencoded; charset=UTF-8" -H "Accept: */*" -H "Referer: https://${SET_SERVER}/realtime/fastorder/fastorder.jsp?platform=mm" -H "X-Requested-With: XMLHttpRequest" -H "Connection: keep-alive" --data "Service=PlaceOrder&type=place&txtTerminalType=jsp&txtQty=${QTY}&txtPIN_new=${SET_PIN}&txtPrice=${PRICE}&txtAccountNo=${SET_ACCOUNT}&txtClientType=I&txtBorS=${BorS}&txtPublishVol=&txtSymbol=${SYM}&txtCondition=DAY&txtPriceType=limit&confirmedWarn=Y" --output -
