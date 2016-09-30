## 0.3.2

The 0.3.1 release inadvertently omitted the `docker:release` task. This has been corrected.

## 0.3.1

* Adds `cogrb docker:release` task to build and push an updated Docker image in one step.
* Bugfix for `cogrb docker:push` task.

## 0.3.0 - Unreleased development version

**Note:** This version of `cog-rb` is not compatible with Cog versions lower than 0.14.

* Updates `cogrb templates:update` task to use bundle configuration version 4.
* Removes the subcommand support added in 0.2.0. We will revisit this in the future when subcommands are a first class feature in Cog. Attempting to support it at the command implementation level turned out to be unworkable.

## 0.2.0

* Adds support for subcommands
  * Adds a new parent class, `Cog::AggregateCommand`
  * Adds a new parent class, `Cog::SubCommand`

## 0.1.15

* Adds a `cogrb` binary that wraps some helper tasks in `lib/tasks/cog.rake`:
  * `cogrb template:update` - reads files in `templates/*` and updates bundle configuration file with contents
  * `cogrb docker:build` - builds docker image using image/tag defined in bundle configuration file
  * `cogrb docker:push` - pushes docker image using image/tag defined in bundle configuration file

## 0.1.14

* bugfix: options with scalar values were being ignored

## 0.1.13

* Add support for list options

## 0.1.9

* Fix service calls for SSL enabled Cog.

## 0.1.6

* `Cog::Response`: Fix log level validation to allow logging to more than `INFO`. [#1]
* `Cog::Command`: Add support for required environment variables. [#1]
