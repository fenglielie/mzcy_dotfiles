# get root dir
$script_root_dir = Split-Path -Parent -Path (Resolve-Path $MyInvocation.MyCommand.Definition)

# get vscode setting dir
$vscode_root_dir = "$env:APPDATA/Code/User"

# vscode settings.json
New-Item -ItemType SymbolicLink -Path "$vscode_root_dir/settings.json" -Target "$script_root_dir/vscode/settings.json" -Force
Write-Host "vscode settings.json config finished."

# vscode keybindings.json
New-Item -ItemType SymbolicLink -Path "$vscode_root_dir/keybindings.json" -Target "$script_root_dir/vscode/keybindings.json" -Force
Write-Host "vscode keybindings.json config finished."
