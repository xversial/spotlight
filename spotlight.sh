#! /bin/bash

path="$HOME/.spotlight/"
item=$(wget -qO- "https://arc.msn.com/v3/Delivery/Cache?pid=279978&fmt=json&ua=WindowsShellClient&lc=fr,fr-FR&ctry=FR" | jq -r ".batchrsp.items | .[0].item" | sed 's/var adData =//' | sed -e '/;/q' |sed -e 's/;//')
if [ -z "$item" ]
then
	echo "Spotlight refresh failed : no internet connection" | systemd-cat -t spotlight
	exit 1
fi
landscapeUrl=$(echo $item | jq -r ".ad.image_fullscreen_001_landscape.u")
if [ ! -d $path ]
then
	mkdir -p $path
fi
path="$path$(date +"%Y%m%d%H%M").jpg"
	
wget -qO "$path" "$landscapeUrl"

gsettings set org.gnome.desktop.screensaver picture-options "zoom"
gsettings set org.gnome.desktop.screensaver picture-uri "file://$path"

notify-send "Screensaver changed" "$title ($titleUrl)" --icon=preferences-desktop-wallpaper
echo "Screensaver changed to $title ($titleUrl)" | systemd-cat -t spotlight
