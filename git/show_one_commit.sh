#!/bin/bash

if [ $# -eq 1 ]; then
    git difftool $1^ $1
else
    echo "Usage: $(basename $0) <commit>"
    exit 1
fi