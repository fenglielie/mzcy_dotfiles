#!/bin/bash

# get root dir
script_root_dir=$(dirname "$(realpath "$0")")

# fish
ln -sf $script_root_dir/fish $HOME/.config/fish
echo "fish config finished."
