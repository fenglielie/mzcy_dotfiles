#!/bin/bash

# 定义目录路径
DIRECTORY="$HOME/.mzcy_dotfiles"

# 检查目录是否存在
if [ ! -d "$DIRECTORY" ]; then
  # 目录不存在，创建目录
  mkdir "$DIRECTORY"
  echo ".mzcy_dotfiles created."
else
  # 目录已存在
  echo ".mzcy_dotfiles already exists."
fi

cp -rf ./* ~/.mzcy_dotfiles/
cp -r ./.[!.]* ~/.mzcy_dotfiles/

# tmux
ln -sf ~/.mzcy_dotfiles/tmux/.tmux.conf ~/.tmux.conf
echo "update tmux configuration"

# vim
ln -sf ~/.mzcy_dotfiles/vim/.vimrc ~/.vimrc
echo "update vim configuration"

# git
ln -sf ~/.mzcy_dotfiles/git/.gitconfig ~/.gitconfig
echo "update git configuration"


