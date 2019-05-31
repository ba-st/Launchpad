#!/usr/bin/env bash
set -euo pipefail

PHARO=${SMALLTALK_CI_VM:-./pharo}
IMAGE=${SMALLTALK_CI_IMAGE:-Pharo.image}
DUMP_FILE=logs/example-$(date --iso).fuel

function executeWithArguments() {
	rm -rf stdout stderr logs
	LAST_ARGUMENTS=$@
	"$PHARO" "$IMAGE" example $@ > out 2> err || true
	[ -f stdout ] && mv stdout out || touch out
	[ -f stderr ] && mv stderr err || touch err
}

function assertOutputIncludesMessage() {
	local output=$1
	local level=$2
	local message=$3

	if [ $(grep -c "^\[[0-9T.:+-]*\] \[$level\] $message" "$output") -eq 0 ]; then
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

function assertDumpFileIsPresent() {
	if [ ! -f "$DUMP_FILE" ]; then
		echo "The stack dump file $DUMP_FILE should be created when invoked with $LAST_ARGUMENTS"
		exit 1
	fi
}

function assertDumpFileIsAbsent() {
	if [ -f "$DUMP_FILE" ]; then
		echo "The stack dump file $DUMP_FILE should not exist when invoked with $LAST_ARGUMENTS"
		exit 1
	fi
}

executeWithArguments --addend=5
assertInfo "addend: 5"
assertInfo "seed: 0"
assertInfo "raise-error: false"
assertInfo "The sum of 0 and 5 is 5"
assertWarning "seed option not provided. Defaulting to 0"
assertDumpFileIsAbsent

executeWithArguments --addend=5 --seed=4
assertInfo "addend: 5"
assertInfo "seed: 4"
assertInfo "raise-error: false"
assertInfo "The sum of 4 and 5 is 9"
assertDumpFileIsAbsent

executeWithArguments --addend=5 --seed=4 --raise-error
assertInfo "addend: 5"
assertInfo "seed: 4"
assertInfo "raise-error: true"
assertError "Dumping Stack Due to Unexpected Error: This was a forced error, which should dump a stack file on runtime"
assertDumpFileIsPresent
