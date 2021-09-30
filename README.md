# ca.dcloud.ICAClient
Build and install the Citrix Workspace app (ICAClient) + HDX RealTime Media Engine for Skype as a Flatpak application for Linux.

## Disclaimer
This project and I are not affiliated with Citrix. This project does not contain or distribute any Citrix software. When the flatpak is built, it iniates downloads from Citrix's site of packages that they have made freely available.

## Requirements
flatpak, flatpak-builder, elfutils, pulseaudio  
You should be able to install all of these through your distro's package manager.

## Instructions
Perform the [flatpak setup](https://flatpak.org/setup/).  
Add the flathub remote, and install the Gnome SDK and runtime:  
*flatpak remote-add --user --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo  
flatpak install --user flathub org.gnome.Platform  
flatpak install --user flathub org.gnome.Sdk*

Clone/download this repo. Open a terminal in the folder where you downloaded this repo, and run the following:  
*flatpak-builder --user --install --force-clean icaclient ca.dcloud.ICAClient.yml*  
(If your distro uses musl libc rather than the tyipcal GNU libc, you may have to add the flag "--disable-rofiles-fuse" due to [this bug](https://github.com/flatpak/flatpak-builder/issues/329))  

It will take some time to download and build. Once it is finished, launch the application by running<sup>1</sup>:  
*flatpak run ca.dcloud.ICAClient && flatpak kill ca.dcloud.ICAClient*  
The first time you start the flatpak it will run some install scripts in the backgroud, before launching Workspace.  

## Notes
I have not tested this extensively by any means, not all features of Citrix Workspace may work, or work stably. So far I've basically only used it to connect to my workstation via Remote PC, and verified that Skype works when doing so. If you find a feature that doesn't work please raise a bug.

---  

1 The reason for the "&& flatpak kill [...]" part is [this bug](https://github.com/dcloud-ca/ca.dcloud.ICAClient/issues/1)
