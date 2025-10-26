#!/usr/bin/bash

## Change to Your Wallpapers Directory.
wallpapers_dir=~/Pictures/wallpapers

selected_wallpaper_name=$(ls $wallpapers_dir | fzf --prompt="Select Wallpaper > ")
# If user cancelled
[[ -z "$selected_wallpaper_name" ]] && exit 0

wallpaper="$wallpapers_dir/$selected_wallpaper_name"

matugen -m light image $wallpaper

# A delay is needed for Matugen to compile and use Hooks. You need increase [or decrease] this delay if needed.
sleep 0.7

