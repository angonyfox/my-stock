@echo off

curl -b cookie.txt -c cookie.txt "https://%SET_SERVER%/webrealtime/script/genKey.jsp?type=fastquote" -H "Origin: https://%SET_SERVER%" -H "Accept-Encoding: gzip, deflate, sdch, br" -H "Accept-Language: en-US,en;q=0.8" -H "User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/51.0.2704.103 Safari/537.36" -H "Accept: */*" -H "Referer: https://%SET_SERVER%/realtime/fastorder/fastorder.jsp?platform=mm" -H "Connection: keep-alive" -H "Cache-Control: max-age=0"
