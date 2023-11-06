#!/bin/bash

# get root dir
script_root_dir=$(dirname "$(realpath "$0")")

# tmux
ln -sf $(script_root_dir)/tmux/.tmux.conf ~/.tmux.conf
echo "tmux config finished."

# vim
ln -sf $(script_root_dir)/vim/.vimrc ~/.vimrc
echo "vim config finished."

# git
ln -sf $(script_root_dir)/git/.gitconfig ~/.gitconfig
echo "git config finished."
