# 检查是否以管理员权限运行
if (-NOT ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator"))
{
    Write-Host "Please run this script as an Administrator." -ForegroundColor Red
    exit
}

# 定义目录路径
$DIRECTORY = Join-Path $HOME ".mzcy_dotfiles"

# 检查目录是否存在
if (-Not (Test-Path $DIRECTORY)) {
    # 目录不存在，创建目录
    New-Item -Path $DIRECTORY -ItemType Directory
    Write-Host ".mzcy_dotfiles created."
} else {
    # 目录已存在
    Write-Host ".mzcy_dotfiles already exists."
}

# 复制当前目录下的非隐藏文件
Get-ChildItem -Path ".\" -File | Where-Object { $_.Name -notmatch '^\.' } | Copy-Item -Destination $DIRECTORY -Force

# 复制当前目录下的非隐藏文件夹，包括其中的所有内容
Get-ChildItem -Path ".\" -Directory | Where-Object { $_.Name -notmatch '^\.' } | ForEach-Object {
    Copy-Item -Path $_.FullName -Destination (Join-Path $DIRECTORY $_.Name) -Recurse -Force
}

# .proxy 文件

# tmux 配置 (windows不支持)

# vim 配置 (不使用_vimrc而是linux风格的.vimrc)
# 软链接到C盘，注意需要管理员权限
$vimConfig = Join-Path $HOME ".vimrc"
New-Item -ItemType SymbolicLink -Path $vimConfig -Target "$DIRECTORY\vim\.vimrc"
Write-Host "vim configuration updated."

# git 配置
# 软链接到C盘，注意需要管理员权限
$gitConfig = Join-Path $HOME ".gitconfig"
New-Item -ItemType SymbolicLink -Path $gitConfig -Target "$DIRECTORY\git\.gitconfig"
Write-Host "git configuration updated."
