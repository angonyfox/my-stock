@echo off

REM login1
echo logging in as %SET_USERNAME% with broker code %SET_BROKER_CODE%...

rm -f cookie.txt
curl -s -b cookie.txt -c cookie.txt "https://%SET_SERVER%/LoginRepOnRole.jsp" -H "Origin: http://www.tiscoetrade.com" -H "Accept-Encoding: gzip, deflate, br" -H "Accept-Language: en-US,en;q=0.8" -H "Upgrade-Insecure-Requests: 1" -H "User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/51.0.2704.103 Safari/537.36" -H "Content-Type: application/x-www-form-urlencoded" -H "Accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8" -H "Cache-Control: max-age=0" -H "Referer: http://www.tiscoetrade.com/tisco2/pre_logged_in/page/login.jsp" -H "Connection: keep-alive" --data "txtSecureKey=NONE&txtBrokerId=%SET_BROKER_CODE%&txtLanguage=English&txtLoginPage=tisco2"%%"2Fpre_logged_in"%%"2Fpage"%%"2Flogin.jsp&txtLogin=%SET_USERNAME%&fake_pass=&txtPassword=%SET_PASSWORD%&bnt_Submit=LOGIN" > output1.txt
type cookie.txt
curl -s -b cookie.txt -c cookie.txt "https://%SET_SERVER%/LoginBySystem.jsp" -H "Origin: https://%SET_SERVER%" -H "Accept-Encoding: gzip, deflate, br" -H "Accept-Language: en-US,en;q=0.8" -H "Upgrade-Insecure-Requests: 1" -H "User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/51.0.2704.103 Safari/537.36" -H "Content-Type: application/x-www-form-urlencoded" -H "Accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8" -H "Cache-Control: max-age=0" -H "Referer: https://%SET_SERVER%/LoginRepOnRole.jsp" -H "Connection: keep-alive" --data "txtLogin=%SET_USERNAME%&txtPassword=%SET_PASSWORD%&txtBrokerId=%SET_BROKER_CODE%&txtRole=&txtDefaultPage=&txtSecureKey=NONE&txtLanguage=English&txtUserClass=&txtLoginPage=tisco2"%%"2Fpre_logged_in"%%"2Fpage"%%"2Flogin.jsp&txtService=&txtSystem=&txtRealRole=INTERNET&txtLoginType=&txtSessionId=&txtJSSupport=&txtMaintenanceLogin=&txtSTTLogin=%SET_USERNAME%&txtDefaultCentralServer=wwwa1.settrade.com&txtAccountNo=&txtUserName=%SET_USERNAME%&txtLoginFailed=&txtUKey=%SET_USERNAME%_%SET_BROKER_CODE%" > output2.txt
type cookie.txt

REM If login is successful you should get cookie.txt that looks something like this
REM LoginRepOnRole.jsp
REM wen066.settrade.com     FALSE   /       TRUE    0       JSESSIONID      FE003F6DAD37DD657F9B0132461ACE64.ITPPN-TCE-A161
REM .settrade.com   TRUE    /       FALSE   0       __txtUTID       153050014471597aaddc6-5156-4189-9574-03ad4e747271
REM .settrade.com   TRUE    /       FALSE   0       __txtUKey       <account_brokercode>

REM LoginBySystem.jsp
REM wen066.settrade.com	FALSE	/	TRUE	0	JSESSIONID	FE003F6DAD37DD657F9B0132461ACE64.ITPPN-TCE-A161
REM .settrade.com	TRUE	/	FALSE	0	__txtUTID	153050014471597aaddc6-5156-4189-9574-03ad4e747271
REM .settrade.com	TRUE	/	FALSE	0	__txtUKey	<account_brokercode>
REM .settrade.com	TRUE	/	TRUE	1530500205	qtp	0
REM .settrade.com	TRUE	/	TRUE	0	if	"15vRZeOdmlNdGo245fweYShMvoH8gIPt1t5QfJD7UIU1arzgsmfRcOTTTREWtouX6qjMITTgIV4mNYdQIpqozlBP5XO7m4Na0ja6tLkzBPs="
REM .settrade.com	TRUE	/	TRUE	0	st	"ITP|10.33.1.161|1530500145000|/LoginBySystem.jsp"
REM .settrade.com	TRUE	/	TRUE	0	tm	""
REM .settrade.com	TRUE	/	TRUE	0	id	aazwKVIW303ymusbkKxinA0000000000
REM .settrade.com	TRUE	/	TRUE	0	rl	"qv6vTcHevm5iK+3b1plSGEQuo/nO5/+Rqao0Lg=="
REM .settrade.com	TRUE	/	TRUE	0	xid	D79BD146E39D9A535D1A8DB8