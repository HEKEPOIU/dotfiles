oh-my-posh init pwsh --config ~/.config/myposhtheme/powerlevel10k_rainbow.omp.json | Invoke-Expression
Import-Module -Name Terminal-Icons
Remove-PSReadLineKeyHandler -Chord *

Set-PSReadlineKeyHandler -Key Tab -Function Complete
Set-PSReadlineKeyHandler -Key Tab -Function MenuComplete
# 先清空預設綁定（避免衝突）

# 基本移動
Set-PSReadLineKeyHandler -Chord Ctrl+a -Function BeginningOfLine
Set-PSReadLineKeyHandler -Chord Ctrl+e -Function EndOfLine
Set-PSReadLineKeyHandler -Chord Ctrl+b -Function BackwardChar
Set-PSReadLineKeyHandler -Chord Ctrl+f -Function ForwardChar

# 單字移動
Set-PSReadLineKeyHandler -Chord Alt+b -Function BackwardWord
Set-PSReadLineKeyHandler -Chord Alt+f -Function ForwardWord

# 刪除
Set-PSReadLineKeyHandler -Chord Ctrl+d -Function DeleteChar
Set-PSReadLineKeyHandler -Chord Alt+d -Function KillWord
Set-PSReadLineKeyHandler -Chord Ctrl+h -Function BackwardDeleteChar

# 單字刪除
Set-PSReadLineKeyHandler -Chord Alt+Backspace -Function BackwardKillWord

# 剪切/貼上
Set-PSReadLineKeyHandler -Chord Ctrl+k -Function KillLine
Set-PSReadLineKeyHandler -Chord Ctrl+u -Function BackwardKillLine
Set-PSReadLineKeyHandler -Chord Ctrl+w -Function BackwardKillWord
Set-PSReadLineKeyHandler -Chord Ctrl+y -Function Yank

# 歷史
Set-PSReadLineKeyHandler -Chord Ctrl+p -Function PreviousHistory
Set-PSReadLineKeyHandler -Chord Ctrl+n -Function NextHistory
Set-PSReadLineKeyHandler -Chord Ctrl+r -Function ReverseSearchHistory

Set-PSReadLineOption -PredictionSource HistoryAndPlugin -PredictionViewStyle InlineView
$env:Path += ";C:\Program Files\LLVM\bin"

Invoke-Expression (& { (zoxide init --cmd cd powershell | Out-String) })

function vsdev {
    param(
        [string]$version = "2022",
        [string]$arch = "amd64"
    )

    $vsPath = "C:\Program Files\Microsoft Visual Studio\$version\Community\Common7\Tools\Launch-VsDevShell.ps1"

    if (-Not (Test-Path $vsPath)) {
        Write-Error "Can't find Visual Studio DevShell Version : $vsPath"
        return
    }
    & $vsPath -Arch $arch
}
