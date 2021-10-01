#!/bin/bash

#HDX RTME requires some directories for storing settings, log, and version info. These directories aren't persistant
#so they get recreated everytime the Flatpak is run. I haven't observed any negative effects from settings being wiped every time the app closes.
mkdir -p /var/lib/RTMediaEngineSRV
chmod a+rw -v /var/lib/RTMediaEngineSRV
mkdir -p /var/log/RTMediaEngineSRV
chmod a+rw -v /var/log/RTMediaEngineSRV
mkdir -p /var/lib/Citrix/HDXRMEP
chmod a+rw -v /var/lib/Citrix/HDXRMEP

#If Workspace doesn't close cleanly it can hang the next time you try to run it, clearing out the temp directory prevents hanging in this scenario.
if [[ -d $HOME/.ICAClient/.tmp ]]; then
    rm -r $HOME/.ICAClient/.tmp
fi

#Start the Citrix logging service
/app/ICAClient/linuxx64/util/ctxlogd
#Start the Workspace self-service dashboard
/app/ICAClient/linuxx64/selfservice

#This services seems to (sometimes) get started when launching Workspace. It's stubborn and requires SIGKILL to stop.
if [[ ! -z $(ps -e | grep UtilDaemon) ]]; then
    pkill --signal 9 UtilDaemon
fi

#Kill the rest of the services that were started, so the Flatpak container itself stops running once you close Workspace.
for process in AuthManagerDaem ServiceRecord ctxlogd icasessionmgr; do
    pkill $process
done

exit