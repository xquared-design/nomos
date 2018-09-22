# A rough guide on the program structure

`/app/` uses the stuff in `/vhs/`

`/vhs/` is the framework for all these enterprise patterns

`service` contracts/endpoints and domain

`schema` classes represent physical data structures, domain are the logical representation of schemas

`services` are business logic connecting domain objects

`contracts` are the versioned guarantee we make to service consumers

`endpoints` are the transport protocol specific implementation for services

`services` are registered in a discovery container namespaced by a string key

`/vhs/database` - abstraction of physical database implementations

`/vhs/domain` - domain & schema pattern implementation

`/vhs/email` - abstraction of email functionality (WIP)

`/vhs/loggers` - logging archetypes and basic/obvious implementations

`/vhs/migration` - db migration library, used by /tools/migrate.php

`/vhs/security` - User principal concept and authenticate interface expectations

`/vhs/services` - service implementation base, service registry, service discovery, endpoint archetype and standard endpoint types, contract expectations

`/vhs/web` - HTTP server, context & utils and module components, basic authenticate and service handling modules over HTTP NEW MESSAGES

`/vhs/SplClassLoader.php` - magic that maps namespaces to directory structure and class auto loading. this is not my code (should be standard in PHP but is debated)

`/vhs/vhs.php` convenient include to register and include the /vhs/ library

`/vhs/` in general is the framework that we are using, it's highly possible some of this shit is reinventing the wheel as its related to other available php frameworks, but at the end of the day there was so much garbage out there in php land that I felt it was easier (and ultimately more fun) for me to write my own framework. I will rename this library/framework as it technically has nothing to do with VHS and put it into it's own public OSS repo

`/app/` is an implementation of /vhs/ which we now call Nomos

`/web/` is the webUI for Nomos which is using angularJS, this should be it's own repo, it's a separate product

`/script/` is MMP legacy code, total utter garbage baked in the hot sun, hacked to make work, will be discarded ASAP

`/conf/` is our configs folder, this holds templates that are meant to be renamed and configured for your specific implementation

we really should be using docker or something to manage deploys a lot better

Vagrant has been added to help with developer setups but prod deploys are still skechy as hell

`/tests/` basically just test what's in /vhs/ the MMPModelTests.php was meant to start testing what's in Nomos but has not been maintained, was too much resistance at the time because services and contracts in Nomos are not stable

`/migrations/` is a managed list of iterative migration steps from our original db schema (MMP) until where we are at now. This will be collasped periodically and/or at least at the mark of the Epoch that is pruning legacy MMP

`/app/` - Nomos

`/app/app.php` - entry point. Ngnix is configured to point all HTTP web requests to this script