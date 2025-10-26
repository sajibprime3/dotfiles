#!/usr/bin/bash

## Change to Your Wallpapers Directory.
wallpapers_dir=~/Pictures/wallpapers

mode="none"
type="none"
wallpaper="none"
menu="fzf"

fzf_type_menu() {
    slt=$(echo -e "scheme-content\nscheme-expressive\nscheme-fidelity\nscheme-fruit-salad\nscheme-monochrome\nscheme-neutral\nscheme-rainbow\nscheme-tonal-spot" | fzf)
    [[ -z "$slt" ]] && menu="fzf" && return
    type=$slt
    menu="fzf"
}
fzf_mode_menu() {
    slm=$(echo -e "dark\nlight" | fzf)
    [[ -z "$slm" ]] && menu="fzf" && return
    mode=$slm
    menu="fzf"
}
fzf_menu() {
    sl=$( (
        echo -e "Change Mode\nChange Type"
        ls $wallpapers_dir
    ) | fzf --prompt="Select Wallpaper > ")
    [[ -z "$sl" ]] && menu="none" && return
    case "$sl" in
    "Change Mode")
        menu="mode"
        ;;
    "Change Type")
        menu="type"
        ;;
    *)
        wallpaper="$wallpapers_dir/$sl"
        ;;
    esac
}
while true; do
    case "$menu" in
    "fzf")
        fzf_menu
        ;;
    "mode")
        fzf_mode_menu
        ;;
    "type")
        fzf_type_menu
        ;;
    "none")
        break
        ;;
    *)
        echo "Something went wrong!"
        ;;
    esac
done

# FIX: crash if didn't select all three every instance.
matugen -m $mode -t $type image $wallpaper
# A delay is needed for Matugen to compile and use Hooks. You need increase [or decrease] this delay if needed.
sleep 0.7
