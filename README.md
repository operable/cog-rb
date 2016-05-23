# cog-rb

Simple, opinionated library for building Cog commands in Ruby.

## Usage

First, create a file named `cog-command` at the top level of your project directory. This file should look something like the following, with `format` replaced with the name of your bundle:

```ruby
#!/usr/bin/env ruby

# Make sure we're in the top-level directory for the command
# since so many paths are relative.
Dir.chdir(File.dirname(__FILE__))

require 'bundler/setup'
require 'cog'

Cog.bundle('format')
```

This file will be the target `executable` for every command in your bundle. The library handles routing commands to the correct class based on the command name. Note: The permissions on this file must allow it to be run by your Relay.

The class that implements your command should be named the same as your command and should be declared in a namespace named after your bundle within the `CogCmd` toplevel namespace. For instance, if you had a bundle named **test** and a command named **dump**, the class that implements the **dump** command would be called `CogCmd::Test::Dump`. The implementation for the command would live in `lib/cog_cmd/test/dump.rb` relative to the location of your `cog-command` script.

## Examples

See the [cog-bundles/format](https://github.com/cog-bundles/format) repository for an example of this library in action.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'cog-rb'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install cog-rb

