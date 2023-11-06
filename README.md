# README

这是个人使用的用于同步各个平台的各种配置文件的仓库。

主要作用是在相应位置自动建立软链接，指向当前仓库的配置文件，全平台统一相关配置文件。

通常将当前仓库下载到本地家目录下的`.mzcy_dotfiles/`，但是在脚本中并不做任何位置的假定。

## HOME(Linux/Win)

在HOME目录下的若干配置文件，包括：

* tmux: 配置文件.tmux.conf
* vim: 配置文件.vimrc
* git: 配置文件.gitconfig

使用`config_home.sh`或者`config_home.ps1`，建立相应的软链接。

## ProjectRoot(Linux/Win)

在项目根目录下的若干配置文件，包括：

* .editorconfig: 用于规范编码，回车以及tab的文本细节
* .clang-format: 用于格式化C++代码
* .clamg-tidy: 用于clangd静态代码分析

使用`config_projectroot.sh`或者`config_projectroot.ps1`，建立相应的软链接。

注意，对项目根目录有如下假设：

* Linux：默认为`~/projectroot/`
* Win: 默认为`D:/ProjectRoot/`

## Pwsh(Win)

一个自定义的powershell模块，以及powershell启动脚本，使用`config_pwsh.ps1`建立相应的软链接。


## VSCode(Win)

包括settings.json以及keybindings.json，使用`config_code.ps1`建立相应的软链接。

在`backup/`中还有额外的vscode配置导出备份。
