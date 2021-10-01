#!/bin/bash

#Set the default install directory in the Workspace install script
sed -ie 's/DefaultInstallDir=.*$/DefaultInstallDir=\/app\/ICAClient\/linuxx64/' /tmp/icaclient/linuxx64/hinst
#The installation options selected below answer yes to using the gstreamer pluging from ICAClient. The "app protection component" and USB support
#require the installer to be run as root, so they cannot be installed in this case.
echo -e "1\n\ny\ny\n3\n" | /tmp/icaclient/setupwfc
cd /app/ICAClient/linuxx64
ln -s /usr/share/ca-certificates/mozilla/* keystore/cacerts/
util/ctx_rehash keystore/cacerts/

#HDX RTME requires some directories for storing settings, log, and version info. These directories aren't persistant
#so they get recreated everytime the Flatpak is run. I haven't observed any negative effects from settings being wiped every time the app closes.
mkdir -p /var/lib/RTMediaEngineSRV
chmod a+rw -v /var/lib/RTMediaEngineSRV
mkdir -p /var/log/RTMediaEngineSRV
chmod a+rw -v /var/log/RTMediaEngineSRV
mkdir -p /var/lib/Citrix/HDXRMEP
chmod a+rw -v /var/lib/Citrix/HDXRMEP

#Install HDX RTME.
cd /app/ICAClient/linuxx64
mkdir rtme
cp /tmp/icaclient/x86_64/usr/local/bin/HDXRTME.so .
chmod +x HDXRTME.so
cp /tmp/icaclient/x86_64/usr/local/bin/* rtme
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

exit