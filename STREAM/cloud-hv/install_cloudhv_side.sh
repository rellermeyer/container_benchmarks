#!/bin/bash
sudo swupd bundle-add c-basic make
gcc /stream.c -o /stream_c.exe
for i in {1..10}; do /stream_c.exe >> /result; done