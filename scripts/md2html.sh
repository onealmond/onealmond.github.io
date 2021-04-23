#!/bin/bash

if [[ -z $1 ]] ;then echo "input file not given"; exit 0; fi
if [[ -z $2 ]] ;then echo "output file not given"; exit 0; fi
if [[ -z $3 ]] ;then 
  echo "title not given, using space instead"
  title=" "
else
  title="$3"
fi

pandoc --from=markdown --to=html \
  -o "$2" \
  --metadata title="$title" \
  --highlight-style breezedark \
  -H templates/writeup-head.html \
  -B templates/writeup-before-body.html \
  -A templates/writeup-after-body.html \
  "$1"
