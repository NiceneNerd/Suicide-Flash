# Suicide Flash For Motorola Moto X (and others) #

Drawing from the impressive work of CrashXXL in rooting our phones, jahrule in simplifying the process, and Sabissimo in developing a tutorial to bake in apps for those of us with locked bootloaders and write protected systems, I have with great effort arrived at this glorious day. I present to thee: Suicide Flash.

What is Suicide Flash? It is a collection of Bash scripts and other files which streamline and automate the process of using the Qualcomm emergency download mode (Qualcomm HS-USB QDLoader) to write to the system partition on Moto phones using MSM8960 processors. It applies the method used to root these devices (see here, for example) to the task of arbitrary system modification. In other words: Suicide Flash makes it easy(ish) to modify system files for those of us who can't use traditional methods.

> DISCLAIMER: This is obviously a dangerous tool. I mean, it
> flashes your phone by bricking it first. Be smart. I shan't be held
> responsible if your phone melts, explodes, loses all of its data,
> or cheats on you with a hula dancer.

## Who Can Use It?
Suicide Flash is for sure compatible with most Moto X variants. The testing has been done primarily with an XT1049, the Republic Wireless model, but has also included the XT1060 (Verizon) and should work on most/all of them. However, in theory any phone, or at least any Moto phone, using the MSM8960 chip could be compatible, such as the Droid Turbo. So to simplify:
* XT1049 (Moto X Republic Wireless): Tested and working
* XT1060 (Moto X Verizon): Tested and working
* XT1058 (Moto X AT&T): Untested, highly likely to work
* XT10XX (Any other Moto X): Untested, likely to work
* Others: Untested, may work as long as they use MSM8960

## How Do I Use It?
Suicide Flash (SF) consists of three main scripts: a flashing script, a package creation script, and a pushing script. Details:
* suicideflash.sh: Flashes SF packages to the phone in bricked (QDLoader) mode
* pkgmaker.sh: For developers. Creates SF packages from system images.
* suicidepush.sh: Uses the SF system to "push" system files in an ADB-like way

To use these scripts, simply extract them to a place of your convenience. All scripts must be run from the root Suicide Flash folder. Do not run any of them from within the "scripts" folder. Also, while it may not strictly be necessary, it is best (if you are developer) to include any relevant system images in the root Suicide Flash folder, as well.

As an end user, you can download SF packages created by developers and flash them using the main Suicide Flash script. As a developer, you can pull system images and use them to create SF packages with the pkgmaker.sh script. Anyone can feel free to use the Suicide Push script to push files to their device. For more information, here are the help pages for each.

Suicide Flash:
```
Usage: suicideflash.sh PACKAGE
 Flashes PACKAGE to the system parition of a Moto phone using Qualcomm
 emergency download mode.

 Options:
   -h, --help      displays this help message
   -s, --skip      skips all prompts and runs without user interaction
```

Package Maker:
```
Usage: pkgmaker.sh [OPTION]... ORIGINALSYSTEM TARGETDEVICE REQUIREMENTS
   SYSTEMOFFSET OUTPUTFILE
 Creates a Suicide Flash package for writing to Moto phones via the emergency
 Qualcomm download mode.

 Arguments:
   ORIGINALSYSTEM     provides the original system image to be modded
   TARGETDEVICE       specifies the model of phone for the package to flash
   REQUIREMENTS       notes any important requirements for the phone state
                      prior to flashing
                      examples: "Stock", "Rooted", or "Rooted+Xposed"
   SYSTEMOFFSET       the address of the system partition on the target device
                      should be in hex format (i.e. 0x6420000 or 6420000)
                      can use value ADB to pull the offset over ABD
   OUTPUTFILE         the name of the Suicide Flash zip package to be created

 Options:
   -h, --help         returns this help message
   -m MODDEDSYSTEM    specifies an existing modded system image
                      if not given, will mount original for modification
```

Suicide Push:
```
Usage: suicidepush.sh LOCALFILE REMOTEFILE
 Uses Suicide Flash to push LOCALFILE to a phone system at REMOTEFILE.
 ```

## What Do I Need to Use It?
* A Linux installation
* ADB
* Fastboot
* Rhino
* Python
* A package called python-serial
* VirtualBox
* ADB Insecure (if developing or using Suicide Push)
If you don't have some of these (except, obviously, the first one and the last one), you can run the included script install-tools.sh. It will automatically install anything you're missing.

## Okay, Give Me Step-By-Step Instructions
For End Users:
1. Download the attached Suicide Flash zip
2. Extract the zip to a convenient folder and open a terminal window there
3. Go ahead and use sudo su
4. Run install-tools.sh
5. Download an SF package from a developer for your device
6. Flash the package with the command:
   `./suicideflash.sh DOWNLOADEDPACKAGE.zip`
7. Profit!

For Developers:
1. Download the attached Suicide Flash zip
2. Extract the zip to a convenient folder and open a terminal window there
3. Go ahead and use sudo su
4. Run install-tools.sh
5. Pull a system image from your phone
6. Run pkgmaker.sh to create an SF package
7. Upload the package for the benefit of others

For Anyone, to Use Suicide Push
1. Download the attached Suicide Flash zip
2. Extract the zip to a convenient folder and open a terminal window there
3. Go ahead and use sudo su
4. Run install-tools.sh
5. Push files to your phone's system partition with this command:
   `./suicidepush.sh LOCAL_SOURCE /system/PUSH_DESTINATION`

## So, What Can I Do with It Right Now?
If you're a developer, you can get to work creating SF packages for your device. If you're just a plain ol' user, a couple packages are already present at http://forum.xda-developers.com/moto-x/development/script-suicide-flash-moto-t3173766
