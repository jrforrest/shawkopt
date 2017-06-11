# Shawkopt

A shell option parser written in POSIX-compliant awk

## Why?

There should be a better way of parsing complex command-lines in shell scripts.
Awk provides a language that's good (enough) at the fairly complex text
wrangling needed for such parsing, and should be available everywhere POSIX
shell is.

## How?

An option spec will be given, along with the options to be handled.  The script
will print eval-able shell code on success.
