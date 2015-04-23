#!/bin/bash
filebot \
-script /filebot/scripts/amc.groovy \
--log-file /input/amc.log \
--action move \
-non-strict \
/input/ \
--def \
"seriesFormat=/output/Serien/{n}/{'S'}{s.pad(2)}/{n} - {s00e00} - {t}" \
"movieFormat=/output/Filme/{n} [{vf}] [{rating}] ({y})/{n} [{vf}] [{rating}] ({y}){' CD'+pi}{'.'+lang}" \
--conflict auto \
--def subtitles=en,de \
--def artwork=y \
--def gmail=$gmailUsername:$gmailPassword \
--def mailto=$mailto \
--def pushover=$pushoverUserkey:$pushoverAppkey \
--def reportError=y \
--def clean=y \
--lang de
