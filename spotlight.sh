#! /bin/bash

directory="$HOME/.spotlight/"
item=$(wget -qO- "https://arc.msn.com/v3/Delivery/Cache?pid=279978&fmt=json&ua=WindowsShellClient&lc=fr,fr-FR&ctry=FR" | jq -r ".batchrsp.items | .[0].item" | sed 's/var adData =//' | sed -e '/;/q' |sed -e 's/;//')
if [ -z "$item" ]
then
	echo "Spotlight refresh failed : no internet connection" | systemd-cat -t spotlight
	exit 1
fi
landscapeUrl=$(echo $item | jq -r ".ad.image_fullscreen_001_landscape.u")
title=$(echo $item | jq -r ".ad.title_text.tx")
titleUrl=$(echo $item | jq -r ".ad.title_destination_url.u" | perl -pe 's/.*?(http.*)/\1/')

if [ ! -d $path ]
then
	mkdir -p $path
fi
slug=$(echo "$title" | iconv -t ascii//TRANSLIT | sed -r s/[^a-zA-Z0-9]+/-/g | sed -r s/^-+\|-+$//g | tr A-Z a-z)
fullpath="$directory$(date +"%Y%m%d%H%M")-$slug.jpg"
	
wget -qO "$fullpath" "$landscapeUrl"

ln -sf $fullpath "$directory/.screensaver.jpg"

notify-send "Screensaver changed" "$title ($titleUrl)" --icon=preferences-desktop-wallpaper
echo "Screensaver changed to $title ($titleUrl)" | systemd-cat -t spotlight
