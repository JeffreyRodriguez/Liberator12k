#!/bin/sh

# When OpenSCAD saves the preset JSON files, it includes _RENDER which cannot be overriden later.
# This causes problems with exporting via CLI, exporting the same file no matter what -D _RENDER... says.

# This script deletes all the variables prefixed with "_" from the preset JSON files.

printusage() {
  echo "$0 <file>"
  exit 1
}

if [ -z "$1" ]; then
  echo "Not enough arguments."
  printusage
fi

if [ ! -f $1 ]; then
  echo "$1 is not a readable file"
  printusage
fi

JQ_FILTER='delpaths([paths | select(.[2]) | select(.[2] | startswith("_") )])'

jq --indent 4 "$JQ_FILTER" $1 | sponge $1