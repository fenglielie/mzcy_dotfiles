#!/bin/bash

# get root dir
script_root_dir=$(dirname "$(realpath "$0")")

# tmux
ln -sf $script_root_dir/tmux/.tmux.conf $HOME/.tmux.conf
echo "tmux config finished."

# vim
ln -sf $script_root_dir/vim/.vimrc $HOME/.vimrc
echo "vim config finished."

# git
ln -sf $script_root_dir/git/.gitconfig $HOME/.gitconfig
echo "git config finished."

# fish
ln -sf $script_root_dir/fish $HOME/.config/fish
echo "fish config finished."
