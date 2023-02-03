# ca.dcloud.ICAClient
Build and install the Citrix Workspace app (ICAClient) + HDX RealTime Media Engine for Skype as a Flatpak application for Linux.

# 🚨 Project not receiving maintenance

Shortly after creating this project, I stopped requiring the use of Citrix Workspace for my job. I stopped maintaining this shortly after (~Jan 2022). I  may eventually archive this repo. But if anyone is interested please feel free to fork and continue work on it.

## Disclaimer
This project and I are not affiliated with Citrix. This repository does not contain any Citrix software. When the user builds the Flatpak application using this template, the required packages are obtained from Citrix's website, where Citrix has made the installers available for download.

## Requirements
flatpak, flatpak-builder, elfutils, pulseaudio  
You should be able to install all of these through your distro's package manager.

## Instructions
Perform the [flatpak setup](https://flatpak.org/setup/).  
Add the flathub remote, and install the Gnome SDK and runtime:  
*flatpak remote-add --user --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo  
flatpak install --user flathub org.gnome.Platform//41  
flatpak install --user flathub org.gnome.Sdk//41*

Clone/download this repo. Open a terminal in the folder where you downloaded this repo, and run the following:  
*flatpak-builder --user --install --force-clean icaclient ca.dcloud.ICAClient.yml*  
(If your distro uses musl libc rather than the tyipcal GNU libc, you may have to add the flag "--disable-rofiles-fuse" due to [this bug](https://github.com/flatpak/flatpak-builder/issues/329))  

It will take some time to download sources and build. Once it is finished, it should be automatially added to your application launcher (may need to log out and back in for it to show up), if not you can launch it via:  
*~/.local/share/flatpak/exports/share/applications/ca.dcloud.ICAClient.desktop*  
Or launch it via command line:  
*flatpak run ca.dcloud.ICAClient*  

## Updating
When you build the app, it will automatically grab the most recent versions of Workspace and HDX RTME. Therefore, if Citrix has published new verions you can update your flatpak app by simply re-running the *flatpak-builder* command listed above. However, you may need to empty the .flatpack-builder folder (located in the folder where you previously built the app), as Flatpak may see the build manifest hasn't changed and therefore use the cached files from the previous build, rather than re-downloading and grabbing the latest installers.

## Notes
I have not tested this extensively by any means, not all features of Citrix Workspace may work, or work stably. So far I've basically only used it to connect to my workstation via Remote PC, and verified that Skype works when doing so.
