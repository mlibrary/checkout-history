26-Feb-2021

##Thoughts on what kind of alerts on the logs this needs.

For testing if Circ Load has run.


There should be two [Circ Load] and two [Patron Load] logs. Alert if not. 
* `count_over_time({filename="/development.log"} |= "[Circ Load]" |= " I "[24h])`
* `count_over_time({filename="/development.log"} |= "[Patron Load]" |= " I "[24h])`

Alert format?
`When count of query (A, 30m, now) is below 2.`
That is, check that there isn't a 30 minute interval where for the past 24 hours there haven't been at least two start/finishes of the Circ Load.

Alert on errors
* `{filename="/development.log"} |= "[Circ Load]" |= " E "`
* `{filename="/development.log"} |= "[Patron Load]" |= " E "`


