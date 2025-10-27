#!/usr/bin/bash

## Change to Your Wallpapers Directory.
wallpapers_dir=~/Pictures/wallpapers
cachefile=~/.cache/hypr/hyprland/scripts/wallpaper_picker

mode="none"
type="none"
wallpaper="none"

if [[ -f "$cachefile" ]]; then
    source $cachefile
else
    mode="light"
    type="scheme-tonal-spot"
fi

fzf_type_menu() {
    slt=$(echo -e "scheme-content\nscheme-expressive\nscheme-fidelity\nscheme-fruit-salad\nscheme-monochrome\nscheme-neutral\nscheme-rainbow\nscheme-tonal-spot" | fzf)
    [[ -z "$slt" ]] && fzf_menu && return
    type=$slt
    fzf_menu
}
fzf_mode_menu() {
    slm=$(echo -e "dark\nlight" | fzf)
    [[ -z "$slm" ]] && fzf_menu && return
    mode=$slm
    fzf_menu
}
fzf_menu() {
    sl=$( (
        echo -e "Change Mode\nChange Type"
        ls $wallpapers_dir
    ) | fzf --prompt="Select Wallpaper > ")
    [[ -z "$sl" ]] && return
    case "$sl" in
    "Change Mode")
        fzf_mode_menu
        ;;
    "Change Type")
        fzf_type_menu
        ;;
    *)
        wallpaper="$wallpapers_dir/$sl"
        fzf_menu
        ;;
    esac
}

fzf_menu

matugen -m $mode -t $type image $wallpaper

if [[ ! -f "$cachefile" ]]; then
    mkdir -p $(dirname $cachefile)
fi
echo "mode=$mode" >"$cachefile"
echo "type=$type" >>"$cachefile"
echo "wallpaper=$wallpaper" >>"$cachefile"

# A delay is needed for Matugen to compile and use Hooks. You may increase [or decrease] this delay if needed.
sleep 0.5
