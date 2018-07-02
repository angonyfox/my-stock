/need to manually copy json response to file and load

/1. go to https://www.jitta.com/explore?country%5B0%5D=TH
/2. open Network dev tool
/3. copy response from link that looks like https://instantsearch.jitta.com/1/indexes/*/queries?x-algolia-agent=Algolia%20for%20vanilla%20JavaScript%20(lite)%203.24.8%3Breact-instantsearch%204.1.3%3BJS%20Helper%202.23.2&x-algolia-application-id=L6HU33HKS0&x-algolia-api-key=8fa6652dfc7f2225015b6d6613466a82


readJsonResponse: {.j.k read1 `$(":jitta/", string x)}
extractHits: {((x`results) 0)`hits}

/rmCols: `objectID`role_jittstor
/meaningfulColumns: {{x where not (x = `graphs) or ((string x) like "0*") or ((string x) like "_*") or (x in rmCols)} cols x}

readAndParseJsonRes: {
  d: extractHits readJsonResponse x;
  t: select market, exchange, symbol, sector, industry, company_name, price, price_updated_at, jitta_score, updatedAt, price_diff, loss_chance, j_rank_score, last_complete_statement_enddate, last_complete_statement_key, updated_at from d;
  {"SSSSSSfZfZfffSSZ"$x} each t}

loadRes: {`r xcols update r: i + 1 from raze readAndParseJsonRes each x}

/t: loadRes `response.json`response2.json
