# ElasticSwift

## Project Status

This project is very early in developement, more information will be made available as project progresses.

If you'd like to contribute contact me via <prafull@pksprojects.org>

High level implementation Plan:

* Initial version of Transport Layer (Connections & Connection pool).

* Initial version of elasticsearch Request, Response & Exception Objects.

* Adding support for elasticsearch API's not necessarily in oder:
  * cat
  * cluster
  * indices
  * ingest
  * nodes
  * snapshot
  * task

* Stabilizing package and API's

* Platform support for macOS, iOS & linux.

* Query DSL builders and helpers similar to elasticsearch Java client.

## Project Goal

Our goal is to make a very Swifty and high-performant elasticsearch client.

High-performant means providing end user's response under 100ms not including the time elasticsearch took to process the request.