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

function executeWithArguments() {
	rm -rf stdout stderr logs
	LAST_ARGUMENTS=$*
	"$SMALLTALK_CI_VM" "$SMALLTALK_CI_IMAGE" "$@" > out 2> err || true
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
