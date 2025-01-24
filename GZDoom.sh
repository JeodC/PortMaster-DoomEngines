#!/bin/bash

XDG_DATA_HOME=${XDG_DATA_HOME:-$HOME/.local/share}

if [ -d "/opt/system/Tools/PortMaster/" ]; then
  controlfolder="/opt/system/Tools/PortMaster"
elif [ -d "/opt/tools/PortMaster/" ]; then
  controlfolder="/opt/tools/PortMaster"
elif [ -d "$XDG_DATA_HOME/PortMaster/" ]; then
  controlfolder="$XDG_DATA_HOME/PortMaster"
else
  controlfolder="/roms/ports/PortMaster"
fi

source $controlfolder/control.txt
[ -f "${controlfolder}/mod_${CFW_NAME}.txt" ] && source "${controlfolder}/mod_${CFW_NAME}.txt"
get_controls

# Variables
GAMEDIR="/$directory/ports/gzdoom"
HEIGHT=$DISPLAY_HEIGHT
WIDTH=$DISPLAY_WIDTH
CONFIG="$GAMEDIR/cfg/gzdoom.ini"
ARGS="+gl_es 1 +vid_preferbackend 3 +cl_capfps 0 +vid_fps 0"

# CD and set permissions
cd $GAMEDIR
> "$GAMEDIR/log.txt" && exec > >(tee "$GAMEDIR/log.txt") 2>&1
$ESUDO chmod +x -R $GAMEDIR/*

# Create config dir
bind_directories ~/".config/gzdoom" "$GAMEDIR/cfg"

# Exports
export LD_LIBRARY_PATH="$GAMEDIR/libs:$LD_LIBRARY_PATH"
export SDL_GAMECONTROLLERCONFIG="$sdl_controllerconfig"

# Run launcher
chmod +xr ./love
$GPTOKEYB "love" &
./love launcher

# Read line from selected_game.txt
while IFS= read -r line; do
    if [ -z "$FOLDER" ]; then
        FOLDER="$line"  # First line is FOLDER
    fi
done < selected_game.txt

# Cleanup launcher
if [ -f selected_game.txt ]; then
    rm -rf selected_game.txt
    pm_finish
else
    exit
fi

# Modify resolution in config file
sed -i "s/^vid_defheight=[0-9]\+/vid_defheight=$HEIGHT/" "$CONFIG"
sed -i "s/^vid_defwidth=[0-9]\+/vid_defwidth=$WIDTH/" "$CONFIG"

# If Exit chosen from launcher, quit
if [[ $FOLDER == "Exit" ]]; then
    exit
fi

# Build args by reading the load.txt files in the folder chosen
if [ -n "$FOLDER" ]; then
    dos2unix "$FOLDER/.load.txt" >/dev/null 2>&1
    TMP=$IFS
    while IFS== read -r key value; do
        case "$key" in
            DATA)
                ARGS="$ARGS -iwad $value.WAD"
                ;;
            PK3|PK3_1|PK3_2|PK3_3|PK3_4)
                ARGS="$ARGS -file $value"
                ;;
            DIFF)
                ARGS="$ARGS +set skill $value"
                ;;
            MAP)
                ARGS="$ARGS +map $value"
                ;;
        esac
    done < "${FOLDER}/.load.txt"
    IFS=$TMP
fi

# Run game
echo "[LOG]: Running with args: ${ARGS}"
$GPTOKEYB "gzdoom" -c "gzdoom.gptk" & 
pm_platform_helper "$GAMEDIR/gzdoom"
./gzdoom $ARGS

# Cleanup
pm_finish
