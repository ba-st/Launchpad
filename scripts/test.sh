#!/usr/bin/env bash
set -euo pipefail

echo "::group::Running Pharo CI"
/opt/pharo/pharo-ci "$@"
echo "::endgroup::"

echo "::group::Declaring Shell Functions"

function executeWithArguments() {
	rm -rf logs
	LAST_ARGUMENTS=$*
	/opt/pharo/pharo-vm /opt/pharo/Pharo.image "$@" > out 2> err || true
}
 
function assertOutputIncludesMessage() {
	local output=$1
	local level=$2
	local message=$3

	if [ "$(grep -c "\[$level\] $message" "$output")" -eq 0 ]; then
		echo "Expected std$1 to have: [$level] '$message' when invoked with $LAST_ARGUMENTS"
		exit 1
	fi
}

function assertInfo() {
	assertOutputIncludesMessage out INFO "$1"
}
function assertWarning() {
	assertOutputIncludesMessage err WARNING "$1"
}
function assertError() {
	assertOutputIncludesMessage err ERROR "$1"
}

function assertOutputIncludesText() {
  local text=$1
  local output=$2

  if [ "$(grep -c "$text" "$output")" -eq 0 ]; then
    echo "Expected '$text' when invoked with $LAST_ARGUMENTS"
    exit 1
  fi 
}

function assertStandardOutputIncludesText() {
  assertOutputIncludesText "$1" out
}

function assertStandardErrorIncludesText() {
  assertOutputIncludesText "$1" err
}
echo "::endgroup::"

echo "Running Shell Tests"

echo "::group::Global Options"
# global options
executeWithArguments launchpad --version
executeWithArguments launchpad --help
executeWithArguments launchpad -h
executeWithArguments launchpad
assertError "Missing command or option."
echo "::endgroup::"

echo "::group::List subcommand"
# list subcommand
executeWithArguments launchpad list
executeWithArguments launchpad list --help
executeWithArguments launchpad list -h
executeWithArguments launchpad list --verbose
executeWithArguments launchpad list -v
echo "::endgroup::"

echo "::group::Explain subcommand"
# explain subcommand
executeWithArguments launchpad explain
assertError "Missing application name or option."
executeWithArguments launchpad explain --help
executeWithArguments launchpad explain -h
executeWithArguments launchpad explain greeter
executeWithArguments launchpad explain broken
echo "::endgroup::"

echo "::group::Start subcommand"
# start subcommand
executeWithArguments launchpad start
assertError "Missing application name or option."
executeWithArguments launchpad start --help
executeWithArguments launchpad start -h
echo "::endgroup::"

echo "::group::Start greeter app"
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
echo "::endgroup::"

echo "::group::Start broken app"
#start broken app
executeWithArguments launchpad start broken
assertInfo "Obtaining configuration..."
assertInfo "Obtaining configuration... \[DONE\]"

executeWithArguments launchpad start broken --raise-error
assertInfo "Obtaining configuration..."
assertInfo "Obtaining configuration... \[DONE\]"
assertError 'Unexpected startup error: "Doh!"'
assertStandardErrorIncludesText "The full stack"
echo "::endgroup::"
