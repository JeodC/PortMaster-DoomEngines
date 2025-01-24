# GZ Doom -- A PortMaster implementation of GZDoom to play Doom WADs

## Installation
This port comes with the free Doom shareware and Freedoom1 and Freedoom2 WAD files. GZDoom supports many WAD files. See the [wiki page](https://zdoom.org/wiki/IWAD) for details.

To use them, place your WAD files in `ports/gzdoom/data`.

## Play
To use addon mods, place `.pk3` files in `ports/gzdoom/mods` and list the `.pk3` files to load in `.load.txt` for the relevant game.

## Mod
The launcher lists folders as games and looks for `.load.txt` files inside them. It uses their information to construct arguments passed to gzdoom, and will not display menu options for any games that are missing data. To create a `.load.txt` file, open a text editor and add the following:

- `PATH` - This is always `./data`
- `DATA` - File name of the WAD to use
- `PK3_#` - Any `.pk3` files to load after the data, can use up to four

Follow this example `Doom/.load.txt` which launches vanilla Doom:

```
PATH=./data
DATA=DOOM
```

This example `Legend of Doom/.load.txt` launches the mod The Legend of Doom:

```
PATH=./data
DATA=FREEDOOM2
PK3_1=./mods/LegendOfDoom-1.1.0.pk3
PK3_2=./mods/LoDMusicLoops.pk3
```

Since we gave the mod its own subfolder and `.load.txt` file, it appears in the launcher as its own option despite using shared data files.

## The Master Levels
Doom II comes with an addon called The Master Levels, but they're packaged as one WAD per level. You can use a WAD editor to merge them into one WAD (example, `MASTER.WAD`) and load that as a mod to `DOOM2`. If you manage to do this, you will want to also load the [Master Levels Menu Interface](https://www.doomworld.com/idgames/utils/frontends/zdmlmenu) mod so you can actually select the addon.

## Building
There is no need to build, as [GZDoom](https://github.com/ZDoom/gzdoom) offers `.deb` releases.

## Thanks
id Software -- Original game  
GZDoom Team -- GZDoom, see license file for individual contributions
Andrew Hushult -- The [music](https://www.youtube.com/watch?v=Yctbs7A4KHk) used for the launcher  
Slayer366 -- Original GZDoom push and port assistance  
PortMaster Discord -- Testers
