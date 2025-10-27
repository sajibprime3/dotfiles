#!/usr/bin/bash

# 󰐾 # 󰄳 # 󰴲 #  #  #  #

## Change to Your Wallpapers Directory.
wallpapers_dir=~/Pictures/wallpapers
cachefile=~/.cache/hypr/hyprland/scripts/wallpaper_picker

mode=""
type=""
wallpaper=""

staged_mode=""
staged_type=""
staged_wallpaper=""

if [[ -f "$cachefile" ]]; then
    source $cachefile
else
    mode="light"
    type="scheme-tonal-spot"
fi
change_wallpaper() {
    # You May edit this to set your wallpaper. I will use Matugen and swww(hooked via matugen).
    matugen -m "$mode" -t "$type" image "$wallpapers_dir/$wallpaper"
}
main_options() {
    echo " 0. Change Mode"
    echo " 00. Change Type"
    local i=1
    for item in $(ls $wallpapers_dir); do
        if [[ "$item" == "$wallpaper" ]]; then
            echo "󰄳 $i. $item"
        elif [[ "$item" == "$staged_wallpaper" ]]; then
            echo "󰐾 $i. $item"
        else
            echo " $i. $item"
        fi
        ((i = i + 1))
    done
}
mode_options() {
    options=("dark" "light")
    local i=1
    for option in ${options[@]}; do
        if [[ "$option" == "$mode" ]]; then
            echo "󰄳 $i. $option"
        elif [[ "$option" == "$staged_mode" ]]; then
            echo "󰐾 $i. $option"
        else
            echo "󰴲 $i. $option"
        fi
        ((i = i + 1))
    done
}
type_options() {
    options=("scheme-content" "scheme-expressive" "scheme-fidelity" "scheme-fruit-salad" "scheme-monochrome" "scheme-neutral" "scheme-rainbow" "scheme-tonal-spot")
    local i=1
    for option in ${options[@]}; do
        if [[ "$option" == "$type" ]]; then
            echo "󰄳 $i. $option"
        elif [[ "$option" == "$staged_type" ]]; then
            echo "󰐾 $i. $option"
        else
            echo "󰴲 $i. $option"
        fi
        ((i = i + 1))
    done
}
remove_mark() {
    local marked="$1"
    local unmarked=$(echo "$marked" | sed -e "s:^[󰐾󰄳󰴲]* ::" -e "s:^[0-9]*. ::")
    echo "$unmarked"
}
fzf_type_menu() {
    slt=$(type_options | fzf)
    [[ -z "$slt" ]] && fzf_main_menu && return
    slt=$(remove_mark "$slt")
    staged_type=$slt
    fzf_main_menu
}
fzf_mode_menu() {
    slm=$(mode_options | fzf)
    [[ -z "$slm" ]] && fzf_main_menu && return
    slm=$(remove_mark "$slm")
    staged_mode=$slm
    fzf_main_menu
}
save_and_exit() {
    [[ -n "$staged_mode" ]] && mode="$staged_mode"
    [[ -n "$staged_type" ]] && type="$staged_type"
    [[ -n "$staged_wallpaper" ]] && wallpaper="$staged_wallpaper"

    change_wallpaper

    [[ ! -f "$cachefile" ]] && mkdir -p $(dirname "$cachefile")
    echo "mode=$mode" >"$cachefile"
    echo "type=$type" >>"$cachefile"
    echo "wallpaper=$wallpaper" >>"$cachefile"
}
fzf_main_menu() {
    sl=$(main_options | fzf --prompt="Select Wallpaper > ")
    [[ -z "$sl" ]] && save_and_exit && return
    sl=$(remove_mark "$sl")
    case "$sl" in
    "Change Mode")
        fzf_mode_menu
        ;;
    "Change Type")
        fzf_type_menu
        ;;
    *)
        staged_wallpaper="$sl"
        fzf_main_menu
        ;;
    esac
}

fzf_main_menu

# A delay is needed for Matugen to compile and use Hooks. You may increase [or decrease] this delay if needed.
sleep 0.5
