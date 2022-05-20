#!/bin/bash

git fetch origin
git reset --hard origin/master

make clean
make all -j 1 # don't use higher -j than 1, otherwise race condition
