# mzcy_dotfiles

这是个人使用的用于同步各个平台的各种配置文件的仓库，同时附带简要的配置解释和命令速查笔记。

脚本的主要工作是在相应位置自动建立软链接，指向当前仓库的配置文件，便于在全平台统一相关配置文件。

通常将当前仓库下载到本地家目录下的`.mzcy_dotfiles/`，但是在脚本中并不做任何位置的假定，仓库可以存放在任何位置，脚本也可以在任何位置执行。

## HOME(Linux & Windows)

在HOME目录下的若干配置文件，包括：

* tmux: 配置文件.tmux.conf [tmux-note](./tmux/tmux-note.md)
* vim: 配置文件.vimrc
* git: 配置文件.gitconfig [git-note-1](./git/git-note-1.md)  [git-note-2](./git/git-note-2.md)
* fish: 配置文件目录~/.config/fish/

使用`config_home.sh`或者`config_home.ps1`，建立相应的软链接。

注意：

* `$HOME`是用户主目录，对于Windows通常为`C:\Users\Bob\`，对于Linux通常为`/home/Bob/`；
* `ln -sf a b`创建软链接b指向a，如果b是一个已经存在的文件，会被`-f`选项覆盖；如果b是一个已经存在的文件夹，则会在b/创建一个指向a的名称仍然为b的软链接，这在fish配置整个文件夹时要注意。



## ProjectRoot(Linux & Windows)

在项目根目录下的若干配置文件，包括：

* .editorconfig: 用于规范编码，回车以及tab的文本细节
* .clang-format: 用于格式化C++代码
* .clamg-tidy: 用于clangd静态代码分析

使用`config_projectroot.sh`或者`config_projectroot.ps1`，建立相应的软链接。

注意：对项目根目录有假设：Linux默认为`~/projectroot/`，Windows默认为`D:/ProjectRoot/`。

## Pwsh(Windows)

一个自定义的pwsh模块，以及pwsh启动脚本，使用`config_pwsh.ps1`建立相应的软链接。
