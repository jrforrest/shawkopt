#!/bin/sh

set -e

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
  echo "$1"
}

it() {
  local spec="$1"
  local expected_output="$2"
  local input="$(cat)"
  local output=$( echo "$input" | ./shawkopt || true)

  if [ "$output" = "$expected_output" ]; then
    succeed "$spec"
  else
    fail "$spec"
  fi
}

with "-v
  opt -v --verbose
    Sets verbose mode
    !set verbose=true" |
it "Sets the verbose arg to true" \
  "verbose=true"

with "
  opt -v --verbose
  !set verbose=true" |
it "Does not set the verbose arg to true" \
  ""

[ "$success" = "true" ] || exit 1
