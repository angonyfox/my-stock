
@echo off
if [%1]==[] goto usage
curl -s -b cookie.txt "https://%SET_SERVER%/webrealtime/data/fastquote.jsp" -H "Origin: https://%SET_SERVER%" -H "Accept-Encoding: gzip, deflate, br" -H "Accept-Language: en-US,en;q=0.8" -H "User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/51.0.2704.103 Safari/537.36" -H "Content-Type: application/x-www-form-urlencoded; charset=UTF-8" -H "Accept: */*" -H "Connection: keep-alive" -H "X-Requested-With: XMLHttpRequest" -H "Referer: https://%SET_SERVER%/realtime/fastorder/fastorder.jsp?platform=mm" --data "symbol=%1&key=%SET_KEY%"
goto :eof

:usage
@echo Usage: %0 ^<sym^>