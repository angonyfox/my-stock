# Collection of Scripts for SETTRADE

## Setup
First, you need to setup your username and account info in `setenv.bat` (leave `SET_KEY` variable blank for now), then run
```
setenv.bat
login.bat
genkey.bat
```
You should get output like this
```
var aj = "<your key>";
```
Copy `<your key>` and paste it to `SET_KEY` variable in `setenv.bat`. You only need this once.

## Usage
```
setenv.bat
login.bat
orderstatus.bat
marketsummary.bat
portfolio.bat

fastquote.bat SYMC

cancelorder.bat CK 123456 435567
placeorder.bat B SYMC 100 8
```

## Debug
### host changes
wen46.settrade.com to wen066.settrade.com
### how to get broker code?
turn on dev tool net work, check preserve log, login to broker main page, check request form data of https://wen066.settrade.com/LoginRepOnRole.jsp (txtBrokerId)
### how to get account id?
open place order from broker menu, open dev tool, check form data of https://wen46.settrade.com/daytradeflex/streamingSeos.jsp (txtAccountNo)

## Usage in q
Before starting q session, you need to run `setenv.bat` and `login.bat`. Then, you should get `cookie.txt` which can be used in further commands
```
set\win\setenv.bat
set\win\login.bat
q -p 6666
```
You can then runs q functions in repl
```q
\l set/q/set.q

pf: .set.portfolio[]
st: .set.orderStatus[]

.set.ticker `BANPU
.set.bov `BANPU
.set.last `BANPU
.set.close `BANPU

.set.index[]

/id: .set.placeOrder[`B; `BANPU; 100; 15]
/.set.cancelOrder[`BANPU; `$id]
/.set.placeBulkOrder ([]side: `B`S; sym: `BANPU`SYMC; qty: (10; 20); price: (100f; 120f))
/.set.cancelAllStatus[.set.orderStatus[]; `Queuing]
```