#! /bin/bash

set -e

directory="$HOME/.spotlight"

cd $directory

# Get image info
item=$(curl --silent "https://arc.msn.com/v3/Delivery/Placement?pid=209567&fmt=json&ua=WindowsShellClient&lc=fr,fr-FR&ctry=FR&cdm=1" | jq -r ".batchrsp.items | .[0].item" | sed 's/var adData =//' | sed -e '/;/q' |sed -e 's/;//')
if [ -z "$item" ]
then
	echo "Spotlight refresh failed : no internet connection" | systemd-cat -t spotlight
	exit 1
fi
landscapeUrl=$(echo $item | jq -r ".ad.image_fullscreen_001_landscape.u")
title=$(echo $item | jq -r ".ad.title_text.tx")
titleUrl=$(echo $item | jq -r ".ad.title_destination_url.u" | perl -pe 's/.*?(http.*)/\1/')

if [ ! -d $directory ]
then
	mkdir -p $directory
fi

# file infos
filename="$(date +"%Y%m%d%H%M")-$(echo "$title" | iconv -t ascii//TRANSLIT | sed -r s/[^a-zA-Z0-9]+/-/g | sed -r s/^-+\|-+$//g | tr A-Z a-z).jpg"
fullpath="$directory/$filename"

# Download image
curl --silent --output "$fullpath" "$landscapeUrl"

# Update background link with old screensaver image
oldPicture=`readlink -f "$directory/.screensaver.jpg"`
ln -sf $oldPicture "$directory/.background.jpg"

# Update screensaver image
ln -sf $fullpath "$directory/.screensaver.jpg"

# Clean duplicates
if [ ! -f "$directory/.md5sum" ]; then
	touch "$directory/.md5sum"
fi
md5=$(md5sum $filename | awk '{print $1}')
awk "/$md5/{print $2}" "$directory/.md5sum" | xargs /bin/rm -f
sed -i "/$md5/d" "$directory/.md5sum"

echo "$md5 $filename" >> "$directory/.md5sum"

notify-send "Screensaver changed" "$title ($titleUrl)" --icon=preferences-desktop-wallpaper
echo "Screensaver changed to $title ($titleUrl)" | systemd-cat -t spotlight

