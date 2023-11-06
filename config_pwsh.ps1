# get root dir
$script_root_dir = Split-Path -Parent -Path (Resolve-Path $MyInvocation.MyCommand.Definition)

# get pwsh module dir
$pwsh_module_dir = ($env:PSModulePath -split ';')[0]

# pwsh module
New-Item -ItemType SymbolicLink -Path "$pwsh_module_dir/mzcy_pwsh_utils" -Target "$script_root_dir/pwsh/mzcy_pwsh_utils" -Force
Write-Host "pwsh module config finished."

# pwsh profile
New-Item -ItemType SymbolicLink -Path "$pwsh_module_dir/../Microsoft.PowerShell_profile.ps1" -Target "$script_root_dir/pwsh/Microsoft.PowerShell_profile.ps1" -Force
Write-Host "pwsh profile config finished."
