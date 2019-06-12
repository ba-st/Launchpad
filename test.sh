#!/usr/bin/env bash
set -euo pipefail

source test-utils.sh

executeWithArguments --add=5
assertInfo "add: 5"
assertInfo "seed: 0"
assertInfo "raise-error: false"
assertInfo "The sum of 0 and 5 is 5"
assertWarning "seed option not provided. Defaulting to 0"
assertDumpFileIsAbsent

executeWithArguments --seed=5
assertError "add option not provided. You must provide one."
assertDumpFileIsAbsent

executeWithArguments --add=5 --seed=4
assertInfo "add: 5"
assertInfo "seed: 4"
assertInfo "raise-error: false"
assertInfo "The sum of 4 and 5 is 9"
assertDumpFileIsAbsent

executeWithArguments --add=5 --seed=4 --raise-error
assertInfo "add: 5"
assertInfo "seed: 4"
assertInfo "raise-error: true"
assertError "Dumping Stack Due to Unexpected Error: This was a forced error, which should dump a stack file on runtime"
assertDumpFileIsPresent
