#!/bin/bash

for RUN in $(seq 5); do
    sysbench memory --memory-access-mode=rnd --time=15 run
    sleep 3
done