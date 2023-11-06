#!/bin/bash

# get root dir
script_root_dir=$(dirname "$(realpath "$0")")

# get projectroot dir
project_root_dir="~/projectroot"

# .editorconfig
ln -sf "$script_root_dir/editorconfig/.editorconfig" "$project_root_dir/.editorconfig"
echo ".editorconfig config finished."

# .clang-format
ln -sf "$script_root_dir/clang/.clang-format" "$project_root_dir/.clang-format"
echo ".clang-format config finished."

# .clang-tidy
ln -sf "$script_root_dir/clang/.clang-tidy" "$project_root_dir/.clang-tidy"
echo ".clang-tidy config finished."
