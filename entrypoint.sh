#!/bin/sh -l

node --version
npm --version
tsc --version
python --version
time=$(date)
echo "time=$time" >> $GITHUB_OUTPUT
