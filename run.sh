#!/bin/bash
docker run -it --name filebot_test -v /data/media/downloads:/input -v /data/media:/output -e gmailUsername="$1" -e gmailPassword="$2" -e mailto="$3" -e pushoverUserkey="$4" -e pushoverAppkey="$5" sidirius/docker-pi-filebot
