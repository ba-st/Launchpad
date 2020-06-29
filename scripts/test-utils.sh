#!/usr/bin/env bash
set -euo pipefail

if [ -z "${SMALLTALK_CI_VM}" ] ; then
	echo "Missing SMALLTALK_CI_VM, defaulting to ./pharo"
	SMALLTALK_CI_VM=./pharo
fi
if [ -z "${SMALLTALK_CI_IMAGE}" ] ; then
	echo "Missing SMALLTALK_CI_IMAGE, defaulting to Pharo.image"
	SMALLTALK_CI_IMAGE=Pharo.image
fi

DUMP_FILE=logs/example-$(date --iso).fuel

function executeWithArguments() {
	rm -rf stdout stderr logs
	LAST_ARGUMENTS=$*
	"$SMALLTALK_CI_VM" "$SMALLTALK_CI_IMAGE" example "$@" --quit > out 2> err || true
	[ -f stdout ] && mv stdout out || touch out
	[ -f stderr ] && mv stderr err || touch err
}

function assertOutputIncludesMessage() {
	local output=$1
	local level=$2
	local message=$3

	if [ "$(grep -c "^\[[0-9T.:+-]*\] \[$level\] $message" "$output")" -eq 0 ]; then
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
