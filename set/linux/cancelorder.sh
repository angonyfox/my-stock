#!/bin/bash
#if [ "$#" -lt 3 ]; then
    #echo "USAGE: cancelorder.sh [sym] [orderid:1SW7EQJYAP] [extorderid:0151]"
if [ "$#" -lt 2 ]; then
    echo "USAGE: cancelorder.sh [sym] [orderid:1SW7EQJYAP]"
    exit 1
fi

SYM=$1
ORDERID=$2
#EXTORDERID=$3
#curl -b cookie.txt "https://${SET_SERVER}/daytradeflex/streamingSeos.jsp" -H "Origin: https://${SET_SERVER}" -H "Accept-Encoding: gzip, deflate, br" -H "Accept-Language: en-US,en;q=0.8" -H "User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/51.0.2704.103 Safari/537.36" -H "Content-Type: application/x-www-form-urlencoded; charset=UTF-8" -H "Accept: */*" -H "Referer: https://${SET_SERVER}/realtime/fastorder/fastorder.jsp?platform=mm" -H "X-Requested-With: XMLHttpRequest" -H "Connection: keep-alive" --data "Service=PlaceOrder&type=cancel&txtAccountNo=${SET_ACCOUNT}&txtPIN_new=${SET_PIN}&txtOrderNo=${ORDERID}&extOrderNo=${EXTORDERID}&txtCancelSymbol=${SYM}" --output -
curl -b cookie.txt "https://${SET_SERVER}/daytradeflex/streamingSeos.jsp" -H "Origin: https://${SET_SERVER}" -H "Accept-Encoding: gzip, deflate, br" -H "Accept-Language: en-US,en;q=0.8" -H "User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/51.0.2704.103 Safari/537.36" -H "Content-Type: application/x-www-form-urlencoded; charset=UTF-8" -H "Accept: */*" -H "Referer: https://${SET_SERVER}/realtime/fastorder/fastorder.jsp?platform=mm" -H "X-Requested-With: XMLHttpRequest" -H "Connection: keep-alive" --data "Service=PlaceOrder&type=cancel&txtAccountNo=${SET_ACCOUNT}&txtPIN_new=${SET_PIN}&txtOrderNo=${ORDERID}&extOrderNo=${ORDERID}&txtCancelSymbol=${SYM}" --output -
