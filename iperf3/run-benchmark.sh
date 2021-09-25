#!/bin/bash

for PLATFORM in ./*/; do
    cd $PLATFORM 
    ./run.sh
    cd ..
done

for PLATFORM in ./*; do
    echo $PLATFORM 
    head -n1 $PLATFORM/results/*
done