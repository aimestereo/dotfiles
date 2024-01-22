#!/usr/bin/env sh

#-------------------------------------------------
# render-user-nix
#-------------------------------------------------
# render user specific nix files for home-manager
# If the current environment is darwin, 
# we will also render configurations for nix-darwin (osx)

render_user_nix() {
  local file="$1"
  local dest="$2"
  if [ -f "$file" ];
  then
    local tmp="/tmp/$(basename $1)"
    # substitutes sh experssions
   (echo "cat <<EOF"; cat $file; echo EOF) | sh > $tmp
    cp $tmp $dest
  fi
}

CONFIG_DIR=${XDG_CONFIG_HOME:-$HOME/.config}

render_user_nix $CONFIG_DIR/home-manager/user.nix.tpl $CONFIG_DIR/home-manager/user.nix

case "$(uname -s)" in
  Darwin)
    render_user_nix $CONFIG_DIR/nix-darwin/user.nix.tpl $CONFIG_DIR/nix-darwin/user.nix
    ;;
esac

# no need to keep the function
unset render_user_nix
