---
name: code-design
description: Apply Odin's preferred coding style.
disable-model-invocation: true
---

Use these preferences when writing or modifying code:

* Code should do work and be direct. Avoid excessive indirection.
* Interfaces with a single implementation should be replaced by that implementation.
* Interfaces (or inheritance) with multiple implementations should be checked for whether they can be removed and replaced with simple if/else control flow. This is only a good change if it leads to two or fewer if/elses, if you need a lot of if/elses, keep the interface.
* Use strong type-checking wherever possible. Use validation libraries like zod at network/database boundaries. Be lenient in what you send out from the inside (reading from db, replying from web endpoints) and strict with what you take in (writing to db, ingesting from web endpoints)
* Validations of data being sent outside from the inside (db -> server or server -> frontend) should be backwards compatible where possible, maybe using auto-fixes or auto-fills for changed/new values. Make sure this never breaks logic or makes up data that is unreasonable - it's better to just fail validation in that case.

* DRY (Don't repeat yourself) is bad advice. 
  * Write everything twice, consolidate into an abstraction once the abstraction becomes necessary
  * Prefer multiple implementations over leaky abstractions
  * Prefer two implementations over a good abstraction, only at 3 can you consider abstracting

* For web services, a good architecture is
  * Router files for endpoints - define what data you want at what endpoint, validate input, validate permissions/auth, return responses
  * Service files for logic - called by routers, actually do logic and fetch data through repositories
  * Pure domain logic functions (can live in service file, or on their own) - called by Services, actually pure functions that just turn input into output
  * Repositories - fetch data from databases, APIs etc.
  * Don't be overly strict with boundaries. A simple web endpoint may just have 1-2 lines of logic in the router, no need for a service function (eg. health checks). A simple service endpoint may not need pure domain logic functions.
  * Avoid interfaces and indirections where possible - all modules/files should do work, not simply delegate
* Folder structure should follow function, no "type of thing". So eg. the "users" folder should contain user-endpoints, user-service-logic, user-database-code. It's all about vertical slices.

* Generating types from validation code (eg. zod schemas -> typescript types, or drizzle schemas -> typescript types) is great, use that!
* Generating any other code is probably bad. Whatever drizzle does is great (generating schemas from code), whatever any java library that generates code ever does is terrible and should be avoided at all cost (generating endpoints or interfaces or domain classes)! Generating code is bad because it makes it hard to track what your program will do when reading the code in your editor.

* Functions / modules should be deep - this means that the interface is slim and simple, and the implementation is deep and complex. This is what makes an abstraction useful - hiding a lot of complexity behind a simple interface

* Define errors out of existence - deleting something that isn't there? Cool, not an error (but should contain some info that the thing wasn't there already). 

* Generally pay attention to performance
  * In the frontend: Ensure that renders only trigger necessary components to rerender, virtualize large lists/tables etc (such that they're still scrollable fast without blurring!), paginate large lists/tables, show skeletons that get filled later for slow queries and don't block pageload on that, prefetch & cache things (auto-refresh cache, don't n+1 your queries), optimize images on build or ingestion
  * Backend: Paginate large data entries, for large objects don't include full details in list-queries, but only on details-queries, be async on DB requests/API requests/LLM queries and don't block while not doing work

## Heuristics for bad code
* Files that have more than 800 lines are almost certainly doing too much and should be split into cohesive sub-modules
* Overly abstract code is bad and needs to be made more direct. Overly abstract heuristics:
  * if you have to go from the entry point (eg. http endpoint, main function..) to more than 2 other files to get to the meat of the logic, it's too abstract (Good: endpoint -> service with logic. Also good: endpoint -> service with logic -> domain function. Bad: endpoint -> ServiceInterface -> ServiceManager -> Service -> LogicInterface -> LogicAdapter -> domain function)
  * if you can't get to the logic by just cmd+clicking through functions, it's too abstract (Bad: you use magic code generation that you can't see in your editor, you use decorators to inject functionality that is non obvious eg. @authorized to make a function check for login credentials, )

* A strong heuristic for good code is code you can easily click through by jumping from function to function, or through call hierarchies with no ambiguity to read what the code actually does (interface with multiple impls, decorators, code-gen, framework-magic all make this harder and are thus heuristics for bad code). On top of that, you can easily browse things with strong cohesion (eg. all web endpoints that affect the "user" domain object in one file, with a file that's still small enough to comfortably scroll through)

* Make the app easy to use and test for devs and AIs
  * One command to spin up the app completely (including FE, BE, DB, other services etc), that can also fetch configs like env vars from a secret vault (eg. AWS secrets manager) if you're logged in and there's missing configs, and that can auto-migrate your database on run
  * Add a way to LLMs to easily authenticate on localhost, like a local-login button that circumvents your regular auth provider and logs into a test account
  * Make sure all app logs (FE, BE and more if necessary) are easily accessible for your dev/LLM, write them locally for local runs
  * Everything you do through your web ui should be accessible through a documented API (through an API key) or even a stateless MCP

## Logging, Tracing and error responses
* Logs should follow the OpenTelemetry format
* Logs should be pretty and readable on the command line and in local logs files
  * Use colors for log-levels (red errors etc)
  * pretty-format dates and make them human-readable
  * pretty-format stack traces (indented new line for each part of the trace, core error message clearly readable on top)

* As a positive example, pino with pino pretty is good
  * Raw pino logs follow OpenTelemetry, eg. `{"level":30,"time":1522431328992,"msg":"hello world","pid":42,"hostname":"foo","v":1}`
  * Pino-pretty logs show that as `[17:35:28.992] INFO (42): hello world`

* Also ofc don't roll your own logging system, but pick a library that does these things well / configure your current library to do so

## System Architecture
* Database: If there is no specific need for something else, choose Postres for all storage and S3 (or compatible) blob storage for files
* Servers: Anything that auto-scales, runs a docker image and doesn't require big configs is great (eg. ECS fargate), ideally behind an API gateway that does auth for you & a load balancer. Serverless functions (eg. Lambda) are a great alternative for quick & simple logic that is easily encapsulated (eg. simple auth logic, quick processing of small data, data cleanup scripts that need to be scheduled)

## Testing
* Unit tests should check the essentials for most code, and be exhaustive and check edge cases etc. only for logic-heavy modules 
* Most code is "accept and validate data and write it" or "accept and validate a query and return a response" - this logic should only have the most essential "does this explode immediately when it runs?" tests and validations should do the rest
* Some code has serious logic behind it; this logic should be encapsulated into a pure module/function with excessive unit testing
* It's imperative that tests run fast and are not flaky.
  * Write few tests -> less runtime, less opportunity to flake
  * Write deep tests, never test "is this header in the UI exactly 'ABC'?", but write deep logic tests that don't break the moment you make tiny changes
  * Never under any circumstances should you write snapshot tests (they break on every change, but frequent change is exactly what we want!)
* The most effective test is to manually open the page and click through things, and this is the type of test you should do whenever you implement anything
  * This includes vaidating that the UI works, the backend works, the db works, any APIs involved work
  * Doing this type of testing also includes intentionally trying to break things, going through more complex flows than just the most essential one
* The second most effective type of tests is automated e2e tests that hit a real database, a real API endpoint etc.
  * Only write these for critical and important code, not for every endpoint
  * Only write these for API-using endpoints if the APIs that can be expected to be extremely high availability (otherwise you add flaking, which is really bad)
* The third most effective type of tests is automated e2e tests that mock out anything that's unreliable (DBs, anything requiring network access etc.)
* When writing tests, make sure to focus on performance and reliability. Always use mock time where possible and necessary, never use sleep. Don't block other test runs while waiting for network responses in e2e tests. Give tests clean setups, but make those setups extremely fast to create. Reuse or mock logins if logging in is slow.

Ultimately, unit tests are great for testing logic-heavy, pure modules. Manual tests are great for validating that things work. Automated e2e tests are a tradeoff because we can't always manually e2e test everything, but they're not great because they tend to be slow and flakey - don't write too many of these, focus these tests on the most important core functionality. Integration tests are useless and just "e2e tests but worse".

The worst thing a test suite can do is block you. Don't write tests that will eat more time in maintenance than they save in catching bugs. You achieve this by keeping tests focused, slim and few, doing lots of manual testing when implementing new features, focusing expensive e2e tests only on the most important features. You also do this by avoiding tests that are high-maintenance (asserting on things that are likely to change often like text in UIs or other overly specific values) and low-likelihood-of-catching-real-bugs (anything that doesn't test complex logic or is the one single test that asserts "this API endpoint / DB call / file read works as intended and doesn't catch fire the second you touch it")


## General key words of things that are good
* Vertical slices
* [Locality of behavior](https://htmx.org/essays/locality-of-behaviour/)
* Type-safety
* Validation
* Deep functions / deep modules

## General software developers who's styles are good and worth emulating
* John Ousterhout
* T3 Theo
* Matt Pocock

## Libraries with good designs to use or emulate
* Anything from tanstack (most importantly tanstack query)
* Drizzle ORM
