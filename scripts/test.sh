#!/usr/bin/env bash
set -euo pipefail

# shellcheck source=test-utils.sh
source test-utils.sh

# global options
executeWithArguments launchpad --version
executeWithArguments launchpad --help
executeWithArguments launchpad -h
executeWithArguments launchpad
assertError "Missing command or option."

# list subcommand
executeWithArguments launchpad list
executeWithArguments launchpad list --help
executeWithArguments launchpad list -h
executeWithArguments launchpad list --verbose
executeWithArguments launchpad list -v

# explain subcommand
executeWithArguments launchpad explain
assertError "Missing application name or option."
executeWithArguments launchpad explain --help
executeWithArguments launchpad explain -h
executeWithArguments launchpad explain greeter
executeWithArguments launchpad explain broken

# start subcommand
executeWithArguments launchpad start
assertError "Missing application name or option."
executeWithArguments launchpad start --help
executeWithArguments launchpad start -h

#start greeter app
executeWithArguments launchpad start greeter
assertInfo "Obtaining configuration..."
assertError '"Name" parameter not provided. You must provide one.'

executeWithArguments launchpad start greeter --name=John
assertInfo "Obtaining configuration..."
assertWarning '"Title" parameter not provided. Using default.'
assertInfo "Name: John"
assertInfo "Title:"
assertInfo "Obtaining configuration... \[DONE\]"
assertStandardOutputIncludesText "Hi John!"

executeWithArguments launchpad start greeter --name=Jones --title=Mr.
assertInfo "Obtaining configuration..."
assertInfo "Name: Jones"
assertInfo "Title: Mr."
assertInfo "Obtaining configuration... \[DONE\]"
assertStandardOutputIncludesText "Hi Mr. Jones!"

executeWithArguments launchpad start --debug-mode greeter
assertStandardErrorIncludesText 'RequiredConfigurationNotFound: "Name" parameter not present.'

#start broken app
executeWithArguments launchpad start broken
assertInfo "Obtaining configuration..."
assertInfo "Obtaining configuration... \[DONE\]"

executeWithArguments launchpad start broken --raise-error
assertInfo "Obtaining configuration..."
assertInfo "Obtaining configuration... \[DONE\]"
assertError 'Unexpected startup error: "Doh!"'
assertStandardErrorIncludesText "The full stack"
