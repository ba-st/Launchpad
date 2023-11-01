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

print_info "Creating network"
if docker network inspect launchpad-net > /dev/null 2>&1 ;then
  docker network rm launchpad-net
fi
docker network create --attachable launchpad-net

print_info "Starting stone"
docker run --rm --detach --name gs64-stone \
  -e TZ="America/Argentina/Buenos_Aires" \
  --cap-add=SYS_RESOURCE \
  --network=launchpad-net \
  --volume="$PWD":/opt/gemstone/projects/Launchpad:ro \
  --volume="$PWD"/.docker/gs64/gem.conf:/opt/gemstone/conf/gem.conf \
  --volume="$PWD"/.docker/gs64/gemstone.key:/opt/gemstone/product/sys/gemstone.key:ro \
  ghcr.io/ba-st/gs64-rowan:v3.7.0

sleep 1
print_info "Loading Launchpad in the stone"
docker exec -t -u gemstone gs64-stone ./load-rowan-project.sh Launchpad

print_info "Building base gem"
docker buildx build --tag launchpad-gs64:sut docker/gs64

 print_info "Building examples gem"
 docker buildx build \
   --tag launchpad-examples-gs64:sut \
   --file .docker/gs64/Dockerfile \
   .

function run_launchpad_gem(){
  executeWithArguments docker run \
  -e TZ="America/Argentina/Buenos_Aires" \
  -e GS64_STONE_HOSTNAME="gs64-stone" \
  --cap-add=SYS_RESOURCE \
  --network=launchpad-net \
  --volume="$PWD"/.docker/gs64/gem.conf:/opt/gemstone/conf/gem.conf \
  launchpad-examples-gs64:sut "$@"
}

print_info "Running basic test"
run_launchpad_gem
assertOutputIncludesMessage '[INFO]' out
assertOutputIncludesMessage "Hi Mr. DJ!" out
print_success "OK"

print_info "Running --version test"
run_launchpad_gem launchpad --version
assertOutputIncludesMessage "Launchpad" out
print_success "OK"

print_info "Running launchpad-list test"
run_launchpad_gem launchpad-list
assertOutputIncludesMessage "broken greeter" out
print_success "OK"

print_info "Running launchpad-list --verbose test"
run_launchpad_gem launchpad-list --verbose
assertOutputIncludesMessage "broken v0.0.1" out
assertOutputIncludesMessage "greeter v1.0.0" out
print_success "OK"

print_info "Running launchpad-explain test"
run_launchpad_gem launchpad-explain broken
assertOutputIncludesMessage "broken \[v0.0.1\] - A broken application" out
run_launchpad_gem launchpad-explain greeter
assertOutputIncludesMessage "greeter \[v1.0.0\] - A greetings application" out
run_launchpad_gem launchpad-explain
assertOutputIncludesMessage "\[ERROR\] Missing application name or option." err
print_success "OK"

print_info "Running launchpad-start greeter test"
run_launchpad_gem launchpad-start greeter --name=Juan
assertOutputIncludesMessage "Hi Juan!" out
print_success " Just name, OK"
run_launchpad_gem launchpad-start greeter --name=Julia --title=Miss
assertOutputIncludesMessage "Hi Miss Julia!" out
print_success " Name and title, OK"
run_launchpad_gem launchpad-start greeter --title=Miss
assertOutputIncludesMessage "\[ERROR\] \"Name\" parameter not provided. You must provide one." err
print_success " Missing name, OK"
run_launchpad_gem launchpad-start greeter
assertOutputIncludesMessage "\[ERROR\] \"Name\" parameter not provided. You must provide one." err
print_success "OK"

print_info "Running launchpad-start broken test"
run_launchpad_gem launchpad-start broken --raise-error
assertOutputIncludesMessage "\[INFO\] Obtaining configuration... \[DONE\]" out
assertOutputIncludesMessage "\[ERROR\] Unexpected startup error: \"Doh!\"" err
print_success "OK"

print_info "Stopping stone"
docker stop gs64-stone
print_info "Removing network"
docker network rm launchpad-net
