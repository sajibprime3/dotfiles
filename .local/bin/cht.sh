#!/usr/bin/env bash
selected=$(cat ~/.cht/cht-languages ~/.cht/cht-command | fzf)
if [[ -z $selected ]]; then
    exit 0
fi

read -p "Enter Query: " query

if grep -qs "$selected" ~/.tmux-cht-languages; then
    query=$(echo $query | tr ' ' '+')
    tmux neww bash -c "echo \"curl cht.sh/$selected/$query/\" & curl cht.sh/$selected/$query & while [ : ]; do sleep 1; done"
else
    tmux neww bash -c "curl -s cht.sh/$selected~$query | less"
fi

get_list_of_sections() 2 usages
1 {
2 ▎ curl -s "${CHTSH_URL}"/:list | grep -v '/.*/' | grep '/$' | xargs
3 }
