#!/bin/bash
echo "First login to your docker hub that hass access to 'sconecuratedimages'"
docker login

echo "If you did that correctly, now ready to run scone images."
#Just using the crosscompilers base image is good enough (sconecuratedimages/crosscompilers).
echo "Take care when running that you don't forget to add the --device=/dev/isgx flag to actually use the SGX hardware (if available)"