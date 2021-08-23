# ca.dcloud.ICAClient
Build and install the Citrix Workspace app (ICAClient) + HDX RealTime Media Engine for Skype as a Flatpak application for Linux.

## Disclaimer
This project and I are not affiliated with Citrix. This project does not contain any Citrix software. When the user builds the Flatpak application using this template, the required packages are obtained from Citrix's website, where Citrix has made the installers available for download.

## Requirements
flatpak, flatpak-builder, elfutils, pulseaudio  
You should be able to install all of these through your distro's package manager.

## Instructions
Perform the [flatpak setup](https://flatpak.org/setup/).  
Add the flathub remote, and install the Gnome SDK and runtime:  
*flatpak remote-add --user --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo  
flatpak install --user flathub org.gnome.Platform  
flatpak install --user flathub org.gnome.Sdk*

Clone/download this repo. Citrix seems to generate a unique download URL everytime you try to download the Workspace and HDX RTME pacakges, so you'll have to go to the site and get you own unique URL.  
[Workspace download](https://www.citrix.com/downloads/workspace-app/linux/workspace-app-for-linux-latest.html)

Under Tarball Packages, click on the Download File button for x86_64. When your browser prompts you to download, click cancel (if it's set to automatically download you can just delete/cancel the download in progress), you have to do this to make the actual download link available. Now right-click on the Download File button and copy the link. You'll have to paste the link into the ca.dcloud.ICAClient.yml file that you downloaded as part of this repo. Open that file with a text editor and find the code block that starts with "name: ICAClient", several lines down you'll see "url:", paste the link you copied there. Right beneath that is "sha256:". On the Citrix page, right under the Download File button is Checksums, copy the checksum starting after "SHA-256-" and paste it into the .yml file after "sha256:".

Repeat the same process for the HDX RTME, in the .yml file it is the code block that starts with "name: HDX-RTME".  
[HDX RTME download](https://www.citrix.com/downloads/workspace-app/additional-client-software/hdx-realtime-media-engine-29400.html)

Open a terminal in the folder where you downloaded this repo, and run the following:  
*flatpak-builder --user --install --force-clean icaclient ca.dcloud.ICAClient.yml*  
(If your distro uses musl libc rather than the tyipcal GNU libc, you may have to add the flag "--disable-rofiles-fuse" due to [this bug](https://github.com/flatpak/flatpak-builder/issues/329))  

It will take some time to download and build. Once it is finished, it should be automatially added to your application launcher, if not you can launch it via:  
*~/.local/share/flatpak/exports/share/applications/ca.dcloud.ICAClient.desktop*  
Or launch it via command line:  
*flatpak run ca.dcloud.ICAClient*  
The first time you start the flatpak it will run some install scripts before launching Workspace.  

## Notes
I have not tested this extensively by any means, not all features of Citrix Workspace may work, or work stably. So far I've basically only used it to connect to my workstation via Remote PC, and verified that Skype works when doing so. If you find a feature that doesn't work please raise a bug.
