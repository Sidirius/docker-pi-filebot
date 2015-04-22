#!/bin/sh
java -Dunixfs=false -DuseExtendedFileAttributes=false -Dfile.encoding=UTF-8 -Dsun.net.client.defaultConnectTimeout=10000 -Dsun.net.client.defaultReadTimeout=60000 -Dapplication.deployment=ipkg -Dapplication.analytics=true -Duser.home=/usr/share/filebot/data -Dapplication.dir=/usr/share/filebot/data -Djava.io.tmpdir=/usr/share/filebot/data/temp -Djna.library.path=/usr/share/filebot -Djava.library.path=/usr/share/filebot -Dnet.sourceforge.filebot.AcoustID.fpcalc=fpcalc -jar -Xmx400M /usr/share/filebot/FileBot.jar "$@"