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

main_options() {
    echo "0. Change Mode"
    echo "00. Change Type"
    local i=1
    for item in $(ls $wallpapers_dir); do
        if [[ "$item" == "$(basename $wallpaper)" ]]; then
            echo "$i. $item *"
        else
            echo "$i. $item"
        fi
        ((i = i + 1))
    done
}
mode_options() {
    options=("dark" "light")
    local i=1
    for option in ${options[@]}; do
        if [[ "$option" == "$mode" ]]; then
            echo "$i. $option *"
        else
            echo "$i. $option"
        fi
        ((i = i + 1))
    done
}
type_options() {
    options=("scheme-content" "scheme-expressive" "scheme-fidelity" "scheme-fruit-salad" "scheme-monochrome" "scheme-neutral" "scheme-rainbow" "scheme-tonal-spot")
    local i=1
    for option in ${options[@]}; do
        if [[ "$option" == "$type" ]]; then
            echo "$i. $option *"
        else
            echo "$i. $option"
        fi
        ((i = i + 1))
    done
}
remove_mark() {
    local marked="$1"
    local unmarked=$(echo "$marked" | sed -e 's:^[0-9]*. ::' -e 's:[ -*]*$::')
    echo "$unmarked"
}
fzf_type_menu() {
    slt=$(type_options | fzf)
    [[ -z "$slt" ]] && fzf_main_menu && return
    slt=$(remove_mark "$slt")
    type=$slt
    fzf_main_menu
}
fzf_mode_menu() {
    slm=$(mode_options | fzf)
    [[ -z "$slm" ]] && fzf_main_menu && return
    slm=$(remove_mark "$slm")
    mode=$slm
    fzf_main_menu
}
fzf_main_menu() {
    sl=$(main_options | fzf --prompt="Select Wallpaper > ")
    [[ -z "$sl" ]] && return
    sl=$(remove_mark "$sl")
    case "$sl" in
    "Change Mode")
        fzf_mode_menu
        ;;
    "Change Type")
        fzf_type_menu
        ;;
    *)
        wallpaper="$wallpapers_dir/$sl"
        fzf_main_menu
        ;;
    esac
}

fzf_main_menu

matugen -m $mode -t $type image $wallpaper

if [[ ! -f "$cachefile" ]]; then
    mkdir -p $(dirname $cachefile)
fi
echo "mode=$mode" >"$cachefile"
echo "type=$type" >>"$cachefile"
echo "wallpaper=$wallpaper" >>"$cachefile"

# A delay is needed for Matugen to compile and use Hooks. You may increase [or decrease] this delay if needed.
sleep 0.5
