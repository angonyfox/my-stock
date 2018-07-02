login: {system "win\\login.bat"};
marketsummary: {.j.k raze system "win\\marketsummary.bat"};
fastquote: {.j.k raze system "win\\fastquote.bat ", string x};
fetchPortfolio: {raze system "win\\portfolio.bat ", string x};

parsePortfolio:  {[raw]
  l: {(count x[0])#' x} "|" vs' 5 _ "^" vs raw;
  {`x _ `sym`x`marketPrice`costAmount`marketValue`pnl`pnlPercent`realizedPnl`qty`qty2`qty3`avgCost! 12#"SSFFFFFFIIIFSSSSSSS"$x} each l};

fetchAndParsePortfolio: {parsePortfolio fetchPortfolio[]};