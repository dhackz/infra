#!/bin/bash

set -euf -o pipefail

while sudo apt-get update; [ $? != 0 ]
do sleep 2
done
sudo apt-get install -y \
    python3
