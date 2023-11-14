#!/usr/bin/env bash

readonly ANSI_BOLD="\\033[1m"
readonly ANSI_RED="\\033[31m"
readonly ANSI_GREEN="\\033[32m"
readonly ANSI_BLUE="\\033[34m"
readonly ANSI_RESET="\\033[0m"

function print_info() {
	if [ -t 1 ]; then
		printf "${ANSI_BOLD}${ANSI_BLUE}%s${ANSI_RESET}\\n" "$1"
	else
		echo "$1"
	fi
}

function print_success() {
	if [ -t 1 ]; then
		printf "${ANSI_BOLD}${ANSI_GREEN}%s${ANSI_RESET}\\n" "$1"
	else
		echo "$1"
	fi
}

function print_error() {
	if [ -t 1 ]; then
		printf "${ANSI_BOLD}${ANSI_RED}%s${ANSI_RESET}\\n" "$1" 1>&2
	else
		echo "$1" 1>&2
	fi
}

function executeWithArguments() {
	rm -rf logs out err
	LAST_ARGUMENTS=$*
	"$@" > out 2> err || true
}

function assertOutputIncludesMessage() {
	local message=$1
	local output=$2

	if [ "$(grep -c "$message" "$output")" -eq 0 ]; then
		print_error "Expected std$output to have: '$message' when invoked with $LAST_ARGUMENTS"
		print_info "Output contents"
		cat "$output"
		exit 1
	fi
}

set -e

print_info "Building base image"
docker buildx build --tag launchpad:sut docker/pharo

print_info "Building examples image"
docker buildx build \
  --tag launchpad-examples:sut \
  --file .docker/pharo/Dockerfile \
  .

print_info "Running basic test"
executeWithArguments docker run launchpad-examples:sut
assertOutputIncludesMessage '[INFO]' out
assertOutputIncludesMessage "Hi Mr. DJ!" out
print_success "OK"

print_info "Running basic test with structured logging"
executeWithArguments docker run -e LAUNCHPAD__LOG_FORMAT='json' launchpad-examples:sut
assertOutputIncludesMessage '"level":"INFO"' out
assertOutputIncludesMessage "Hi Mr. DJ!" out
print_success "OK"

print_info "Running --version test"
executeWithArguments docker run launchpad-examples:sut launchpad --version
assertOutputIncludesMessage "Launchpad" out
print_success "OK"

print_info "Running launchpad-list test"
executeWithArguments docker run launchpad-examples:sut launchpad-list
assertOutputIncludesMessage "broken greeter" out
print_success "OK"

print_info "Running launchpad-list --verbose test"
executeWithArguments docker run launchpad-examples:sut launchpad-list --verbose
assertOutputIncludesMessage "broken v0.0.1" out
assertOutputIncludesMessage "greeter v1.0.0" out
print_success "OK"

print_info "Running launchpad-explain test"
executeWithArguments docker run launchpad-examples:sut launchpad-explain broken
assertOutputIncludesMessage "broken \[v0.0.1\] - A broken application" out
executeWithArguments docker run launchpad-examples:sut launchpad-explain greeter
assertOutputIncludesMessage "greeter \[v1.0.0\] - A greetings application" out
executeWithArguments docker run launchpad-examples:sut launchpad-explain
assertOutputIncludesMessage "\[ERROR\] Missing application name or option." err
print_success "OK"

print_info "Running launchpad-start greeter test"
executeWithArguments docker run launchpad-examples:sut launchpad-start greeter --name=Juan
assertOutputIncludesMessage "Hi Juan!" out
print_success " Just name, OK"
executeWithArguments docker run launchpad-examples:sut launchpad-start greeter --name=Julia --title=Miss
assertOutputIncludesMessage "Hi Miss Julia!" out
print_success " Name and title, OK"
executeWithArguments docker run launchpad-examples:sut launchpad-start greeter --title=Miss
assertOutputIncludesMessage "\[ERROR\] \"Name\" parameter not provided. You must provide one." err
print_success " Missing name, OK"
executeWithArguments docker run launchpad-examples:sut launchpad-start greeter
assertOutputIncludesMessage "\[ERROR\] \"Name\" parameter not provided. You must provide one." err
print_success "OK"

print_info "Running launchpad-start broken test"
executeWithArguments docker run launchpad-examples:sut launchpad-start broken --raise-error
assertOutputIncludesMessage "\[INFO\] Obtaining configuration... \[DONE\]" out
assertOutputIncludesMessage "\[ERROR\] Unexpected startup error: \"Doh!\"" err
print_success "OK"

print_info "Running launchpad-start command server test"
# broken app keeps running when passed and invalid option
executeWithArguments docker run --rm --name=broken-running -d launchpad-examples:sut launchpad-start broken -wait
sleep 1
rm -f out
docker stop -t 30 broken-running > out
assertOutputIncludesMessage "broken-running" out
print_success "OK"
