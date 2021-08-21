#!/bin/bash
if [[ ! -d $HOME/ICAClient/linuxx64 ]]; then
    echo -e "1\n\ny\ny\n3\n" | /app/icaclient/setupwfc
    cd $HOME/ICAClient/linuxx64
    ln -s /usr/share/ca-certificates/mozilla/* keystore/cacerts/
    util/ctx_rehash keystore/cacerts/
fi

mkdir -p /var/lib/RTMediaEngineSRV
chmod a+rw -v /var/lib/RTMediaEngineSRV

mkdir -p /var/log/RTMediaEngineSRV
chmod a+rw -v /var/log/RTMediaEngineSRV

mkdir -p /var/lib/Citrix/HDXRMEP
chmod a+rw -v /var/lib/Citrix/HDXRMEP

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

$HOME/ICAClient/linuxx64/selfservice

exit