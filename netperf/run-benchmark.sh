#!/bin/bash

for PLATFORM in ./*/; do
    cd $PLATFORM 
    ./run.sh
    sleep 3
    cd ..
done

for PLATFORM in ./*/; do
    head -n 1 $PLATFORM/results/*
done

