
##################################################################
# conda initialize (rewrite)
# 这里和conda init自动生成的脚本不一样，并没有自动激活base环境
If (Test-Path "D:\LangProgram\miniconda3\Scripts\conda.exe") {
    (& "D:\LangProgram\miniconda3\Scripts\conda.exe" "shell.powershell" "hook")
        | ForEach-Object {
            if ($_ -notlike "conda*") {
                $_
            }
        } | Out-String | ?{$_} | Invoke-Expression
}


##################################################################
# oh-my-posh scheme
oh-my-posh init pwsh --config "E:\lishu\Documents\PowerShell\Modules\mzcy_pwsh_utils\mzcy_simple.omp.json" | Invoke-Expression


##################################################################
# mzcy_pwsh_utils
Import-Module mzcy_pwsh_utils
Set-Alias -Name cd -Value Set-MzcyCd -Force -Option "AllScope"
