@echo off
@REM you need to add your details here
@REM tisco broker code is 002
set SET_BROKER_CODE=<from broker main page https://wen066.settrade.com/LoginRepOnRole.jsp (txtBrokerId)>
set SET_USERNAME=
set SET_PASSWORD=
set SET_ACCOUNT=<account id in portfolio page or https://wen46.settrade.com/daytradeflex/streamingSeos.jsp (txtAccountNo)>
set SET_PIN=
set SET_KEY=<run genkey.bat after login to get this (see README.md)>
set SET_SERVER="wen066.settrade.com"

echo "SET_BROKER_CODE=%SET_BROKER_CODE%"
echo "SET_USERNAME=%SET_USERNAME%"
echo "SET_ACCOUNT=%SET_ACCOUNT%"