
export PATH="$HOME/bin:$HOME/.local/bin:$PATH"

# Add a directory to PATH if it's not already in PATH
add_to_path_once() {
  case ":$PATH:" in
    *":$1:"*) ;; # already present
    *) PATH="$1:$PATH" ;;
  esac
}

# Local user-specific software directory
local_opt="$HOME/opt"

# Add executables from local_opt/* and any bin directories under them
if [ -d "$local_opt" ] && find "$local_opt" -mindepth 1 -maxdepth 1 -type d | grep -q .; then
  for app_dir in "$local_opt"/*; do
    [ -d "$app_dir" ] || continue

    # Add app root if it contains executables
    if find "$app_dir" -maxdepth 1 -type f -perm -u=x | grep -q .; then
      add_to_path_once "$app_dir"
    fi

    # Add all bin/ directories under the app directory
    while IFS= read -r -d '' bin_dir; do
      add_to_path_once "$bin_dir"
    done < <(find "$app_dir" -type d -name bin -print0)
  done
fi

export PATH
