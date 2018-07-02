@echo off

if [%1]==[] goto usage
if [%2]==[] goto usage
if [%3]==[] goto usage
if [%4]==[] goto usage

curl -s -b cookie.txt "https://%SET_SERVER%/daytradeflex/streamingSeos.jsp" -H "Origin: https://%SET_SERVER%" -H "Accept-Encoding: gzip, deflate, br" -H "Accept-Language: en-US,en;q=0.8" -H "User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/51.0.2704.103 Safari/537.36" -H "Content-Type: application/x-www-form-urlencoded; charset=UTF-8" -H "Accept: */*" -H "Referer: https://%SET_SERVER%/realtime/fastorder/fastorder.jsp?platform=mm" -H "X-Requested-With: XMLHttpRequest" -H "Connection: keep-alive" --data "Service=PlaceOrder&type=place&txtTerminalType=jsp&txtQty=%3&txtPIN_new=%SET_PIN%&txtPrice=%4&txtAccountNo=%SET_ACCOUNT%&txtClientType=I&txtBorS=%1&txtPublishVol=&txtSymbol=%2&txtCondition=DAY&txtPriceType=limit&confirmedWarn=Y" --output -
goto :eof

:usage
@echo Usage: %0 ^<BorS^> ^<sym^> ^<qty^> ^<price^>