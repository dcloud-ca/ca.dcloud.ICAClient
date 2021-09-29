#!/bin/bash

#Checks if Workspace has already been installed (by looking for the installation folder), if not runs the setup.
#The installation options selected below answer yes to using the gstreamer pluging from ICAClient. The "app protection component" and USB support
#require the installer to be run as root, so they cannot be installed in this case.
if [[ ! -d $HOME/ICAClient/linuxx64 ]]; then
    echo -e "1\n\ny\ny\n3\n" | /app/icaclient/setupwfc
    cd $HOME/ICAClient/linuxx64
    ln -s /usr/share/ca-certificates/mozilla/* keystore/cacerts/
    util/ctx_rehash keystore/cacerts/
fi

#HDX RTME requires some directories for storing settings, log, and version info. These directories aren't persistant
#so they get recreated everytime the Flatpak is run. I haven't observed any negative effects from settings being wiped every time the app closes.
mkdir -p /var/lib/RTMediaEngineSRV
chmod a+rw -v /var/lib/RTMediaEngineSRV
mkdir -p /var/log/RTMediaEngineSRV
chmod a+rw -v /var/log/RTMediaEngineSRV
mkdir -p /var/lib/Citrix/HDXRMEP
chmod a+rw -v /var/lib/Citrix/HDXRMEP

#Checks if HDX RTME has already been installed (by looking for the installation folder), if not runs the setup.
if [[ ! -d $HOME/ICAClient/linuxx64/rtme ]]; then
    cd $HOME/ICAClient/linuxx64
    mkdir rtme
    cp /app/icaclient/x86_64/usr/local/bin/HDXRTME.so .
    chmod +x HDXRTME.so
    cp /app/icaclient/x86_64/usr/local/bin/* rtme
    MODULE_INI=config/module.ini
    if [ -L "$MODULE_INI" ] ; then
        MODULE_INI=$(readlink -f "$MODULE_INI")
    fi
    cp $MODULE_INI .
    chmod a+rw -v module.ini
    rtme/RTMEconfig -install -ignoremm
    if [ -s "./new_module.ini" ] ; then
        rm -rf "$MODULE_INI"
        cp ./new_module.ini "$MODULE_INI"
        chmod a+rw -v "$MODULE_INI"
    fi
    rm -rf ./module.ini
    rm -rf ./new_module.ini
fi

#If Workspace doesn't close cleanly it can hang the next time you try to run it, clearing out the temp directory prevents hanging in this scenario.
if [[ -d $HOME/.ICAClient/.tmp ]]; then
    rm -r $HOME/.ICAClient/.tmp
fi

#Start the Citrix logging service
$HOME/ICAClient/linuxx64/util/ctxlogd
#Start the Workspace self-service dashboard
$HOME/ICAClient/linuxx64/selfservice

#This services seems to (sometimes) get started when launching Workspace. It's stubborn and requires SIGKILL to stop.
if [[ ! -z $(ps -e | grep UtilDaemon) ]]; then
    pkill --signal 9 UtilDaemon
fi

#Kill the rest of the services that were started, so the Flatpak container itself stops running once you close Workspace.
for process in AuthManagerDaem ServiceRecord ctxlogd; do
    pkill $process
done

exit
