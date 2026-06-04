
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
[ -f "${controlfolder}/modfiles/harbourmaster" ] && source "${controlfolder}/modfiles/harbourmaster"

get_controls

GAMEDIR="/roms/ports/rexuiz"
cd $GAMEDIR

# GLES2 Treiber-Zuweisung erzwingen (Wichtig für Mali-G31 GPU des R36S)
export SDL_VIDEO_GL_DRIVER="libGLESv2.so"
export SDL_VIDEO_EGL_DRIVER="libEGL.so"

# Ausführungsrechte zur Sicherheit nochmals setzen
$ESUDO chmod +x ./rexuiz-bin
>$GAMEDIR/log.txt

# Spiel starten mit Verweis auf unsere R36S-Konfiguration
./rexuiz-bin -basedir $GAMEDIR -game data +exec autoexec.cfg >$GAMEDIR/log.txt 2>&1

$EXARKILL
pgrep -f rexuiz-bin | xargs kill -9
systemctl restart oga_events &
printf "\033c" > /dev/tty1
