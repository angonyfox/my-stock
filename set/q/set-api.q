/login: {system "win\\login.bat"};
login: {
  system "./login_tisco.sh";
  system "./login_set.sh"};
/marketsummary: {.j.k raze system "win\\marketsummary.bat"};
marketsummary: {.j.k raze system "./marketsummary.sh"};
/fastquote: {.j.k raze system "win\\fastquote.bat ", string x};
fastquote: {.j.k raze system "./fastquote.sh ", string x};
/fetchPortfolio: {raze system "win\\portfolio.bat ", string x};
fetchPortfolio: {raze system "./portfolio.sh"}
fetchPortfolioDeriv: {raze system "./portfolio_deriv.sh"}

parsePortfolio:  {[raw]
  l: {(count x[0])#' x} "|" vs' 5 _ "^" vs raw;
  {`x _ `sym`x`marketPrice`costAmount`marketValue`pnl`pnlPercent`realizedPnl`qty`qty2`qty3`avgCost! 12#"SSFFFFFFIIIFSSSSSSS"$x} each l};
parsePortfolioDeriv:  {[raw]
  l: {(count x[0])#' x} "|" vs' 5 _ "^" vs raw;
  {`sym`side`qty1`qty2`qty3`avgCost`marketPrice`costAmount`marketValue`pnl`pnlPercent`realizedPnl!"SSFFFFFFFFFF"$12#x} each l};

fetchAndParsePortfolio: {parsePortfolio fetchPortfolio[]};
fetchAndParsePortfolioDeriv: {parsePortfolioDeriv fetchPortfolioDeriv[]};