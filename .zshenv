# Add a directory to PATH if it's not already in PATH
add_to_path_once() {
    local dir="$1"

    # Basic validation: ensure an argument is provided and it's a directory
    if [[ -z "$dir" ]]; then
        return
    fi
    if [[ ! -d "$dir" ]]; then
        return
    fi

    # Check if the directory is already in PATH (using colon delimiters to avoid partial matches)
    if [[ ":$PATH:" != *":$dir:"* ]]; then
        export PATH="$PATH:$dir"
    fi
}

add_to_path_once "$HOME/.local/bin"

# Local user-specific software directory
local_opt="$HOME/opt"

# Add executables from local_opt/* and any bin directories under them
if [ -d "$local_opt" ] && find "$local_opt" -mindepth 1 -maxdepth 1 -type d | grep -q .; then
    for app_dir in "$local_opt"/*; do
        [ -d "$app_dir" ] || continue

        if [[ -L "$app_dir/current" ]]; then
            resolved_path="$app_dir/current"
        else
            resolved_path="$app_dir"
        fi

        # Add resolved app root if it contains executables
        # if find "$resolved_path" -maxdepth 1 -type f -perm -u=x | grep -q .; then
        #     add_to_path_once "$resolved_path"
        # fi
        for file in "$resolved_path"/*; do
            if [[ -x "$file" ]]; then
                add_to_path_once "$resolved_path"
                break
            fi
        done

        # Add bin directory under the resolved_path directory
        if [[ -e "$resolved_path/bin" && -d "$resolved_path/bin" ]]; then
            add_to_path_once "$resolved_path/bin"
        fi
    done
fi

unset app_dir

unset local_opt

export PATH

# Automatically set JAVA_HOME for current JDK installed by SDKMAN if found.
if [ -d "$HOME/.sdkman/candidates/java" ]; then
    current_jdk="$HOME/.sdkman/candidates/java/current"
    if [ -x "$sdkman_current/bin/java" ]; then
        JAVA_HOME="$(realpath $current_jdk)"
    fi
    unset current_jdk
fi
export JAVA_HOME
unset -f add_to_path_once

export OLLAMA_HOST=0.0.0.0:11434
