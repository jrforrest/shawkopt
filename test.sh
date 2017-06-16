#!/bin/sh

set -e

limit_to=$1
test_number=0

success=true


succeed() {
  maybecolor 32 "[ OK     ] ${1}"
}

fail() {
  maybecolor 31 "[ FAILED ] ${1}"
}

maybecolor() {
  local color="\033[$1m"
  local str="$2"

  if [ -t 1 ]; then
    echo "$color$str\033[39m"
  else
    echo $str
  fi
}

with() {
  local args="$1"
  shift
  local input="$1"
  shift 2 #gobble "it"
  local spec="$1"
  local expected_output="$2"

  test_number=$(( test_number + 1 ))

  # Only run this test if it's the one requested
  if ! [ -z "$limit_to" ] && [ "$test_number" -ne "$limit_to" ]; then
    return 0
  fi

  export SHAWKOPT_ARGS="$args"

  local output="$( echo "$input" | ./shawkopt || true )"

  if [ "$output" = "$expected_output" ]; then
    succeed "$spec"
  else
    fail "$spec"
  fi
}

with "-v" "
  opt -v --verbose
    Sets verbose mode
    !set verbose=true" \
it "can handle short args" \
  "verbose=true"

with "" "
  opt -v --verbose
    !set verbose=true" \
it "doesn't set  opts that aren't given" \
  ""

with "--verbose" "
  opt -v --verbose
    !set verbose=true" \
it "handles long options" \
  "verbose=true"

with "--verbose -z" "
  opt -z
    !set some_random_var=true
  opt -v --verbose
    !set verbose=true" \
it "Can handle multiple args of mixed types" \
  "verbose=true
some_random_var=true"

[ "$success" = "true" ] || exit 1
