# get root dir
$script_root_dir = Split-Path -Parent -Path (Resolve-Path $MyInvocation.MyCommand.Definition)

# tmux
New-Item -ItemType SymbolicLink -Path "$HOME/.tmux.conf" -Target "$script_root_dir/tmux/.tmux.conf" -Force
Write-Host "tmux config finished."

# vim
New-Item -ItemType SymbolicLink -Path "$HOME/.vimrc" -Target "$script_root_dir/vim/.vimrc" -Force
Write-Host "vim config finished."

# git
New-Item -ItemType SymbolicLink -Path "$HOME/.gitconfig" -Target "$script_root_dir/git/.gitconfig" -Force
Write-Host "git config finished."
