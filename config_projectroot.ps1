# get root dir
$script_root_dir = Split-Path -Parent -Path (Resolve-Path $MyInvocation.MyCommand.Definition)

# get projectroot dir
$project_root_dir = "D:/ProjectRoot"

# .editorconfig
New-Item -ItemType SymbolicLink -Path "$project_root_dir/.editorconfig" -Target "$script_root_dir/editorconfig/.editorconfig" -Force
Write-Host ".editorconfig config finished."

# .clang-format
New-Item -ItemType SymbolicLink -Path "$project_root_dir/.clang-format" -Target "$script_root_dir/clang/.clang-format" -Force
Write-Host ".clang-format config finished."

# .clang-tidy
New-Item -ItemType SymbolicLink -Path "$project_root_dir/.clang-tidy" -Target "$script_root_dir/clang/.clang-tidy" -Force
Write-Host ".clang-tidy config finished."
