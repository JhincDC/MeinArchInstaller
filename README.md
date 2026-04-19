# MeinArchInstaller
So, just documentation on how this was made.

Based on another project, a [similar project](https://github.com/JhincDC/PersonalSetup) in fact, based, of course, on another project, [my personal installer from another account btw](https://github.com/Bisanota/MeinArchInstaller)

Just scripts that allows a more easy installation, with basics needs.

## Few Considerations
- Script prepare and make ready for my personal configuration on my computers. Why not NixOS? NixOS works different and doesn't feels like linux when I try to make changes directly but not in a config file (.nix file).

- Works with KDE Plasma, and tries to be *"boring"* in order to be a productive focused system.

- Technically another Distro? Maybe, but works under Arch Linux base, and just prepare and install everything. This doesn't come with so much changes.

- Some packages comes from AUR, through Chaotic-AUR repository, due missing time when is compiling.

# Content
Here are a list of files:
**Scripts:**
- main.sh : Script that detects if you meet some requeriments (and if you are in Live or not).

- preInstaller.sh : Install needed apps and let make partitions as the way anyone wants (partitions are manual part). Prepares and copies necessary files to system.

- installer.sh : Set up everything for being usable, and activates some things to just be usable when rebooting

- postInstaller.sh : Installs everything in modules, but KDE is the last thing installed. 

- tweaks.sh : Just put the appearence of KDE, installs and setups **zsh.sh** and **zRamSwap.sh**

- pkgInstaller.sh : Allows installation from txt's. Necessary for **installer** & **postInstaller**

**Folders:** 
- packagesList : Here is all packages, to improve modularity and make more easy deployment.

- pkgBase : Same as before one, but when system is being installed.

- coolFunctions : Just some functions, like loading functions. They do nothing actually


*Personal Use, but config it as you would like to use :)*
