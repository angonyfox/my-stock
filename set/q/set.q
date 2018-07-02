/runs this in command line before starting Q
/set\win\setenv.bat
/set\win\login.bat

/.set.setenv: {system "set\\win\\setenv.bat"};
/.set.login: {system "set\\win\\login.bat"};
/.set.genkey: {system "set\\win\\genkey.bat"};

//>>>>>>>market
.set.marketsummary: {.j.k raze system "set\\win\\marketsummary.bat"}
/res: .j.k "{\"agriculturalstatus\":\"Close\",\"ccstatus\":\"Close\",\"volumel\":[],\"enstatus\":\"Close\",\"loserp\":[],\"volumep\":[],\"tfDeal\":\"853\",\"ststatus\":\"Close\",\"gainerp\":[],\"brokerid\":\"002\",\"futures\":[\"0\",\"0\",\"370,017\",\"6,062\",\"779\",\"55,168\",\"168\",\"53\",\"3,842\",\"0\",\"0\",\"21,537\",\"0\",\"0\",\"0\",\"0\",\"0\",\"2,401,860\",\"0\",\"0\",\"123\",\"212\",\"21\",\"1,232\",\"6,442\",\"853\",\"2,853,779\"],\"gainerl\":[],\"mtstatus\":\"Close\",\"options\":[\"0\",\"0\",\"0\",\"N/A\",\"0\",\"0\",\"0\",\"44,402\",\"68,023\",\"23,621\",\"0.53\"],\"loserl\":[],\"index\":[\"0\",\"0.000\",\"0\",\"0\",\"0\",\"1,618.66\",\"0.00\",\"0.00\",\"0.00\",\"0.00\",\"1,060.58\",\"0.00\",\"0.00\",\"0.00\",\"0.00\",\"2,349.63\",\"0.00\",\"0.00\",\"0.00\",\"0.00\",\"865.67\",\"0.00\",\"0.00\",\"0.00\",\"0.00\",\"1,213.75\",\"0.00\",\"0.00\",\"0.00\",\"0.00\",\"433.05\",\"0.00\",\"0.00\",\"0.00\",\"0.00\"],\"physicalstatus\":\"Close\",\"oidate\":\"27/06/18\",\"irstatus\":\"Close\",\"valuel\":[],\"pcRatio\":\"N/A\",\"valuep\":[],\"cindex\":{\"ssetIndex\":865.67,\"set50Index\":1060.58,\"maiIndex\":433.05,\"setIndex\":1618.66,\"set100Index\":2349.63,\"setHDIndex\":1213.75},\"dstatus\":\"Close\",\"estatus\":\"Closed\"}"
.set.index: {(.set.marketsummary[])`cindex}
/.set.index[]
/.set.marketsummary[]

//>>>>>>quote
.set.int.fastquote: {raze system "set\\win\\fastquote.bat ", string x}
.set.fastquote: {.j.k .set.int.fastquote x}
.set.fq: .set.fastquote /shortcut
/res: .set.int.fastquote `SYMC
/res: .j.k "{\"sector\":\"ICT\",\"sellVolumnList\":[],\"symbolbarNonSide\":0,\"last\":0,\"nonSideNumberOfExeList\":[],\"type\":\"stock\",\"d5\":\"5.20 / 4.90\",\"close\":4.98,\"bo\":[\"4.92\",\"5.05\",4.9,5.1,4.88,5.15,4.86,5.2,4.8,5.25],\"open\":0,\"ticker\":[],\"mktstatus\":\"Open1\",\"totalList\":[],\"marketbarSell\":47.675995675791405,\"avg\":0,\"settleDecimal\":2,\"sellNumberOfExeList\":[],\"nonSideTotalVolumn\":0,\"symbol\":\"SYMC\",\"mkt\":\"equity\",\"buyNumberOfExeList\":[],\"open2\":0,\"chg\":0,\"pbuy\":\"\",\"pe\":\"0.00\",\"eps\":\"0.03\",\"pchg\":0,\"priceDecimal\":2,\"pbv\":\"0.95\",\"floor\":3.5,\"bsp\":[],\"percentSellVolumn\":\"\",\"openopendata\":0,\"language\":\"english\",\"low\":0,\"avgbuy\":\"\",\"industryname\":\"Technology\",\"val\":0,\"buyVolumnList\":[],\"percentNonSideVolumn\":\"\",\"dy\":\"0.00\",\"ceil\":6.45,\"buyTotalVolumn\":0,\"nonSideVolumnList\":[],\"bsv\":[],\"sectorbarNonSide\":13.32810768477226,\"marketbarNonSide\":13.016474610703709,\"par\":\"1.00\",\"sellTotalVolumn\":0,\"vol\":0,\"sectorbarBuy\":32.509824115647085,\"sectorbarSell\":54.16206819958066,\"name\":\"SYMPHONY COMMUNICATION PUBLIC COMPANY\",\"marketbarBuy\":39.307529713504884,\"psell\":\"\",\"symbolbarSell\":0,\"pnonside\":\"\",\"avgsell\":\"\",\"symbolbarBuy\":0,\"openopen\":\"Open 1\",\"mktlabel\":\"SET\",\"priceList\":[],\"sStatus\":\"\",\"sectorname\":\"Information & Communication Technology\",\"percentBuyVolumn\":\"\",\"totalPercentList\":[],\"bov\":[7600,3000,1000,500,1400,1200,1500,1000,1200,3000],\"cur\":\"(Baht)\",\"high\":0,\"spread\":0.01,\"totalVolumnAllSide\":0}"
/.set.fastquote `SYMC
.set.int.parseTicker: {`tradeTime xasc flip `tradeTime`side`qty`price!flip {"TSff" {x$y}' x} each 4 cut x[`ticker]};
/wrong first 2 bo's can be ATO, ATC
.set.int.normalizeBO: {{{$[0 < type x; "F"$x; x]} each x} each x};
.set.int.parseBov: {flip `lvl`bid`bidQty`ask`askQty!(enlist`L1`L2`L3`L4`L5),flip raze each 2 cut (,'/) .set.int.normalizeBO x[`bo`bov]};

/.set.int.parseTicker res
/.set.int.parseBov res
.set.ticker: {.set.int.parseTicker .set.fastquote x}
.set.bov: {.set.int.parseBov .set.fastquote x}
.set.last: {(.set.fastquote x)`last}
.set.close: {(.set.fastquote x)`close}
/.set.ticker `SYMC
/.set.bov `SYMC
/.set.fq `PTT
/.set.last `PTT
/.set.close `PTT


//>>>>>portfolio
.set.int.portfolio: {0N!raze system "set\\win\\portfolio.bat"}
/res: "StreamingResponse~1~Streaming^Portfolio^T^23^02626^BANPU| |19.60|234839.0200|262640.00|27078.7463|11.53|0.00|13400|13400|13400|17.5253||null|0.00|0.00|0.002570|0.070000|^BAY| |39.00|300656.4600|269100.00|-32296.4581|-10.74|0.00|6900|6900|6900|43.5734||null|0.00|0.00|0.002570|0.070000|^BCP| |32.00|509533.8300|547200.00|36161.4247|7.10|0.00|17100|17100|17100|29.7973||null|0.00|0.00|0.002570|0.070000|^"
/.set.int.parsePortfolio res
/sym   marketPrice costAmount marketValue pnl       pnlPercent realizedPnl qty   qty2  qty3  avgCost
/---------------------------------------------------------------------------------------------------
/BANPU 19.6        234839     262640      27078.75  11.53      0           13400 13400 13400 17.5253
/BAY   39          300656.5   269100      -32296.46 -10.74     0           6900  6900  6900  43.5734
/BCP   32          509533.8   547200      36161.42  7.1        0           17100 17100 17100 29.7973
.set.int.parsePortfolio:  {[raw]
  l: {(count x[0])#' x} "|" vs' 5 _ "^" vs raw;
  {`x _ `sym`x`marketPrice`costAmount`marketValue`pnl`pnlPercent`realizedPnl`qty`qty2`qty3`avgCost! 12#"SSFFFFFFIIIFSSSSSSS"$x} each l}
.set.portfolio: {.set.int.parsePortfolio .set.int.portfolio[]}
/.set.portfolio[]

//>>>>orderStatus
.set.int.orderStatus: {0N!raze system "set\\win\\orderstatus.bat"}
/res: .set.int.orderStatus[]
/res: "StreamingResponse~1~Streaming^OrderStatus^T^9^01160^1SWFZVZ6JT| |BANPU|09:35:09|B|15.00|100|0|100|0|Queuing(SX)||Y|Y|2018-06-28|0|null|null|1SWFZVZ6JT||Day|Y|1|null|null|null|^1SWFY50AIX| |BANPU|09:34:03|B|15.00|100|0|0|100|Cancelled(CX)||N|N|2018-06-28|0|null|null|1SWFY50AIX||Day|N|3|null|null|null|^1SWFY3J5PT| |BANPU|09:34:00|B|15.00|100|0|0|100|Cancelled(CX)||N|N|2018-06-28|0|null|null|1SWFY3J5PT||Day|N|3|null|null|null|^1SWFOA4MWX| |BANPU|09:30:18|B|15.00|100|0|0|100|Cancelled(CX)||N|N|2018-06-28|0|null|null|1SWFOA4MWX||Day|N|4|null|null|null|^1SWFJI1HG9| |BANPU|09:30:18|B|15.00|100|0|0|100|Cancelled(CX)||N|N|2018-06-28|0|null|null|1SWFJI1HG9||Day|N|4|null|null|null|^1SWC07EO35| |BANPU|08:48:21|B|15.00|100|0|0|100|Cancelled(CS)||N|N|2018-06-28|0|null|null|1SWC07EO35||Day|N|1|null|null|null|^1SWC0153PT| |BANPU|08:48:10|B|15.00|100|0|0|100|Cancelled(CS)||N|N|2018-06-28|0|null|null|1SWC0153PT||Day|N|1|null|null|null|^1SWBWZ630X| |BANPU|08:46:25|B|15.00|100|0|0|100|Cancelled(CS)||N|N|2018-06-28|0|null|null|1SWBWZ630X||Day|N|1|null|null|null|^1SW7EQJYAP| |CK|07:48:15|S|30.00|100|0|0|100|Cancelled(CS)||N|N|2018-06-28|0|null|null|1SW7EQJYAP||Day|N|1|null|null|null|\000"
.set.int.parseOrderStatus: {update status: {{`$(x?"(") # x} string x} each statusx from {`orderid`sym`time`side`price`qty`fillQty`liveQty`cancelQty`statusx`date!"SSTSFJFFJSD"$("|" vs x) 0 2 3 4 5 6 7 8 9 10 14} each 5 _ "^" vs x}
/.set.int.parseOrderStatus res
/orderid    sym   time         side price qty unknown1 unknown2 leaveqty status        date      
/------------------------------------------------------------------------------------------------
/1SWC07EO35 BANPU 08:48:21.000 B    15    100 0        0        100      Cancelled(CS) 2018.06.28
/1SWC0153PT BANPU 08:48:10.000 B    15    100 0        0        100      Cancelled(CS) 2018.06.28
/1SWBWZ630X BANPU 08:46:25.000 B    15    100 0        0        100      Cancelled(CS) 2018.06.28
/1SW7EQJYAP CK    07:48:15.000 S    30    100 0        0        100      Cancelled(CS) 2018.06.28
.set.orderStatus: {.set.int.parseOrderStatus .set.int.orderStatus[]}
/s: .set.orderStatus[]
/orderStatus: s

//>>>>>orderDetail
.set.int.orderDetail: {raze system "set\\win\\orderDetail.bat ", string x}
/res: .set.int.orderDetail `1SWP5G5LUX
/orderDetailRes: res
/load `:orderDetailRes /html

/res: .set.int.orderDetail each 
/ids: exec orderid from s where status=`Matched
/orderDetails: ids!res
/save `:orderDetails



//>>>>cancelOrder
.set.int.cancelOrder: {[sym; orderid] 0N!raze system "set\\win\\cancelorder.bat ", (string sym), " ", (string orderid)}
.set.int.parseCancelResponse: {("^" vs x) 5}
/test
/res: "StreamingResponse~1~Streaming^PlaceOrder^T^1^00055^Cancel Order Submitted^0~StreamingResponse~1~\000"
/.set.int.parseCancelResponse[res] ~ "Cancel Order Submitted"
.set.cancelOrder: {[sym; orderid] .set.int.parseCancelResponse .set.int.cancelOrder[sym; orderid]}
/.set.cancelOrder[`BANPU; `1SWBWZ630X]

//>>>>placeOrder
.set.int.placeOrder: {[side; sym; qty; price] 0N!raze system "set\\win\\placeorder.bat ", (string side), " ", (string sym), " ", (string qty), " ", (string price)}
.set.int.parsePlaceOrderResponse: {`$first "~" vs ("^" vs x) 6}
/after market open - returns `orderId
/res: "StreamingResponse~1~Streaming^PlaceOrder^T^1^00059^Request Submitted^1SWFJI1HG9~StreamingResponse~1~\000"
/(.set.int.parsePlaceOrderResponse res) ~ `1SWFJI1HG9

/before market open - returns `0
/res: "StreamingResponse~1~Streaming^PlaceOrder^T^1^00055^place Order Submitted^0~StreamingResponse~1~\000"
/.set.int.parsePlaceOrderResponse[res] ~ `0
.set.placeOrder: {[side; sym; qty; price] .set.int.parsePlaceOrderResponse .set.int.placeOrder[side; sym; qty; price]}

.set.placeBulkOrder: {x, (enlist `result)!enlist .set.placeOrder[x`side; x`sym; x`qty; x`price]}'
/mock placeOrder
/.set.placeOrder: {[side; sym; qty; price] "order placed ", (string side), " ", (string sym), " ", (string qty), " ", (string price)}
/.set.placeOrder[`B; `BANPU; 100; 15]
/.set.placeBulkOrder ([]side: `B`S; sym: `BANPU`SYMC; qty: (10; 20); price: (100f; 120f))

.set.cancelAllStatus: {[orderstatus; cancelstatus]{x,(enlist `result)!enlist .set.cancelOrder[x`sym; x`orderid]} each select from orderstatus where status=cancelstatus}
/s: .set.orderStatus[]
/mock
/.set.cancelOrder: {[sym; orderid] (string sym), " ", (string orderid), " canceled"
/.set.cancelAllStatus[s; `Queuing]
/.set.cancelAllStatus[.set.orderStatus[]; `Queuing]

/
/.set.setenv[]
/.set.login[]
/.set.genkey[]
.set.marketsummary[]
.set.orderstatus[]
.set.fastquote `SYMC
.set.portfolio[]
system "which curl"
system "curl --version"
system "echo"
\l set/q/set.q
.set