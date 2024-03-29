#!/bin/bash

#######################################################################
# Modified for dunst to only notify with text. No covers.
#######################################################################

# A simple notify script for now-playing songs on mpd. This script uses
# notify-send and mpc to get the current song information.

# Requirements (* = optional)
# - mpd
# - mpc
# - notify-send (libnotify)
# * ImageMagick (convert)

# Author : Wolfgang Mueller
# You can use, edit and redistribute this script in any way you like.
# (Just make sure not to hurt any kittens)

# Configuration-------------------------------------------------------

# The music directory that contains the music and cover files
MUSIC_DIR="/media/Obsidian/Music"

# The default cover to use (optional)
DEFAULT_ART=""

# The following track metadata delimiters can be changed.
# You can find all possible delimiters in the 'mpc' manpage.
# It's also possible to use pango markup like <u></u> and <i></i>

# How to format artist/album information
A_FORMAT="%artist%[ (%album%)]"

# How to format title information
T_FORMAT="%title%"

# Regex expression used for image search
IMG_REG="\.(jpg|jpeg|png|gif)"

# Regex expression used for image name
NAME_REG="(front|cover|art)"

# Title of the notification
NOTIFY_TITLE="Now Playing"

# Path of temporary resized cover
TEMP_PATH="/tmp/mpdnotify_cover.png"

# Resize cover to (optional, recommended)
COVER_RESIZE="125x125"

# Thumbnail background (transparent by default)
COVER_BACKGROUND="none"

# Logfile
LOGFILE="$HOME/.ncmpcpp/mpdnotify.log"

#--------------------------------------------------------------------

# determine file
file="$(mpc current -f %file%)"

# check if anything is playing at all
[[ -z $file ]] && exit 1

# Get title info
title="$(mpc current -f "$A_FORMAT")"

# Get song info
song="$(mpc current -f "$T_FORMAT")"

# Art directory
#art="$MUSIC_DIR/${file%/*}"

# find every file that matches both IMG_REG and NAME_REG and set the first matching
# file to be the cover.
#cover="$(find "$art/" -maxdepth 1 -type f | egrep -i "$IMG_REG" | egrep -i -m1 "$NAME_REG")"

# when no cover is found, use DEFAULT_ART as cover
#cover="${cover:=$DEFAULT_ART}"

# check if art is available
# --hint=int:transient:1 is needed, because gnome-shell will keep the notification in its bar.
# using 'hint' they'll be removed automatically (gnome-shell 3.01)
#if [[ -n $cover ]]; then
#
#	if [[ -n $COVER_RESIZE ]]; then
#		convert "$cover" -thumbnail $COVER_RESIZE -gravity center \
#			-background "$COVER_BACKGROUND" -extent $COVER_RESIZE "$TEMP_PATH" >> "$LOGFILE" 2>&1
#		cover="$TEMP_PATH"
#	fi
#
#	notify-send -t 5000 --hint=int:transient:1 "$NOTIFY_TITLE" "$title\n$song" -i "$cover" >> "$LOGFILE" 2>&1
#else
	notify-send -t 5000 --hint=int:transient:1 "$NOTIFY_TITLE" "$title\n$song" >> "$LOGFILE" 2>&1
#fi

