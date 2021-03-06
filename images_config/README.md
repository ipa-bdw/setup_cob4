
# Automatic Installation for cob4 using Ubuntu Installer from USB/CD/DVD

## Contents

1. <a href="#Introduction">Introduction</a>
2. <a href="#Create Kickstart Configuration file">Create Kickstart Configuration file</a>
     1. <a href="#Install and Run Kickstart">Install and Run Kickstart</a>
     2. <a href="#Create Kickstart Configuration File">Create Kickstart Configuration File</a>
     2. <a href="#Additional Manual Steps">Additional Manual Steps</a>
3. <a href="#Create Preseed Configuration File">Create Preseed Configuration File</a>
4. <a href="#Create Custom ISO File">Create Custom ISO File</a>
5. <a href="#Create Bootable Media">Create Bootable Media</a>
6. <a href="#Cleanup">Cleanup</a>

### 1. Introduction <a id="Introduction"/>
This README documents how to achieve an automatic setup for the various PCs used in Care-O-bot 4.

Currently, Care-O-bot 4 will be set up with latest Ubuntu 16.04.3 Server - including desktop environments Gnome.

For this, a preconfiguration file for the Ubuntu Installer will be generated using the Kickstart Configurator tool.
This Kickstart configuration file will later be extended manually to fit the specific need of Care-O-bot 4's master/slave PCs.

In this document we are going to create Kickstart and Preseed configuration files, modify original Ubuntu ISO files and create an USB Startup Disk or CD from it.

See http://gyk.lt/ubuntu-16-04-desktop-unattended-installation/

### 2. Kickstart Configurator<a id="Create Kickstart Configuration file"/>
### a. Install and Run Kickstart <a id="Install and Run Kickstart"/>

Install Kickstart Configurator via:
```
sudo apt-get install system-config-kickstart
```
Start Kickstart Configurator via:
```
 sudo system-config-kickstart
```

### b. Create Kickstart Configuration File <a id="Create Kickstart Configuration File"/>
Go through the various settings in the GUI and adjust accordingly. See the screenshots in the `doc` folder to give you an idea.

See https://help.ubuntu.com/lts/installation-guide/s390x/ch04s03.html

This will result in a basic configuration file `ks-minimal.cfg` that needs further adjustments to meet the specific requirements for the Care-O-bot 4 master/slave PCs.

### c. Additional Manual Steps <a id="Additional Manual Steps"/>
Additional manual steps involve:
 - Disk partitioning
 - Installation of additional packages
 - Additional Pre-/Post-Installation scripts such as:
    - Setup OpenSSH-Server
    - Setup `root` and `robot` user
    - Install ROS
    - Setup `udev` rules
    - Setup `bash` environment
    - Setup NTP
    - Setup NFS
    - ...

The resulting files are stored as:
 - `ks-robot-master.cfg`
 - `ks-robot-slave.cfg`

### 3. Create Preseed Configuration File <a id="Create Preseed Configuration File"/>

In addition to the Kickstart Configuration File, a Preseed Configuration File is needed to allow Kickstart to run. The Preseed Configuration file also specifies the way the disk is partitioned.

See https://help.ubuntu.com/lts/installation-guide/s390x/apb.html

The resulting file is stored as:
 - `ubuntu-auto.seed`
 - `ubuntu-auto-cached.seed` (includes settings to use `cob-kitchen-server` as `apt-cacher`)

### 4. Create Custom ISO File <a id="Create Custom ISO File"/>
#### Ubuntu 14.04
Download latest Ubuntu Server 14.04.5 from Ubuntu website (https://www.ubuntu.com/download/server).

Make sure you have `setup_cob4` cloned into `~/git/setup_cob4`.

Then perform the following steps:
```
mkdir ~/ubuntu_iso
sudo  mount -r -o loop ~/Downloads/ubuntu-14.04.5-server-amd64.iso ~/ubuntu_iso
cp -r ~/ubuntu_iso ~/ubuntu_files
chmod +w -R ~/ubuntu_files
echo en >> ~/ubuntu_files/isolinux/lang
cp -r ~/git/setup_cob4/images_config/kickstart ~/ubuntu_files/
cp ~/git/setup_cob4/images_config/preseed ~/ubuntu_files/
cp ~/git/setup_cob4/images_config/isolinux/txt-14.04.cfg ~/ubuntu_files/isolinux/txt.cfg
cp ~/git/setup_cob4/images_config/initrd.gz ~/ubuntu_files/install/
mkisofs -D -r -V "Ubuntu-14.04-Care-O-bot" -cache-inodes -J -l -b isolinux/isolinux.bin -c isolinux/boot.cat -no-emul-boot -boot-load-size 4 -boot-info-table -o ~/ubuntu-14.04-care-o-bot.iso ~/ubuntu_files
```

#### Ubuntu 16.04
Download latest Ubuntu Server 16.04.3 from Ubuntu website (https://www.ubuntu.com/download/server).

Make sure you have `setup_cob4` cloned into `~/git/setup_cob4`.

Then perform the following steps:
```
mkdir ~/ubuntu_iso
sudo  mount -r -o loop ~/Downloads/ubuntu-16.04.3-server-amd64.iso ~/ubuntu_iso
cp -r ~/ubuntu_iso ~/ubuntu_files
chmod +w -R ~/ubuntu_files
echo en >> ~/ubuntu_files/isolinux/lang
cp -r ~/git/setup_cob4/images_config/kickstart ~/ubuntu_files/
cp ~/git/setup_cob4/images_config/preseed ~/ubuntu_files/
cp ~/git/setup_cob4/images_config/isolinux/txt-16.04.cfg ~/ubuntu_files/isolinux/txt.cfg
mkisofs -D -r -V "Ubuntu-16.04-Care-O-bot" -cache-inodes -J -l -b isolinux/isolinux.bin -c isolinux/boot.cat -no-emul-boot -boot-load-size 4 -boot-info-table -o ~/ubuntu-16.04-care-o-bot.iso ~/ubuntu_files
```

### 5. Create Bootable Media <a id="Create Bootable Media"/>
```
sudo apt-get install syslinux-utils
isohybrid ~/ubuntu-1X.04-care-o-bot.iso
```

Plugin USB Stick and create startup disk


### 6. Cleanup <a id="Cleanup"/>
To cleanup you local system run the following commands
```
sudo umount ~/ubuntu_iso
rm -rf ~/ubuntu_iso
rm -rf ~/ubuntu_files
```
