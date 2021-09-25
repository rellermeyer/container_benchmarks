#!/bin/bash

for PLATFORM in ./*/; do
    cd $PLATFORM 
    ./run.sh
    cd ..
done
