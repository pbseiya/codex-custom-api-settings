$ErrorActionPreference = 'Stop'

$desktop = [Environment]::GetFolderPath('Desktop')
$launcher = Join-Path $env:USERPROFILE 'codex-selector.bat'
if (-not (Test-Path $launcher)) {
    throw "Launcher not found: $launcher"
}

$icon = $null
$package = Get-AppxPackage OpenAI.Codex -ErrorAction SilentlyContinue
if ($package) {
    $candidate = Join-Path $package.InstallLocation 'app\ChatGPT.exe'
    if (Test-Path $candidate) {
        $icon = "$candidate,0"
    }
}

$wshShell = New-Object -ComObject WScript.Shell
$shortcuts = @(
    @{ Name = 'Codex - OpenAI.lnk'; Arguments = 'openai -RestartDesktop' },
    @{ Name = 'Codex - ALIBABA.lnk'; Arguments = 'alibaba -RestartDesktop' }
)

foreach ($item in $shortcuts) {
    $shortcutPath = Join-Path $desktop $item.Name
    $shortcut = $wshShell.CreateShortcut($shortcutPath)
    $shortcut.TargetPath = $launcher
    $shortcut.Arguments = $item.Arguments
    $shortcut.WorkingDirectory = $env:USERPROFILE
    $shortcut.Description = "Switch Codex provider and restart Desktop: $($item.Arguments)"
    if ($icon) {
        $shortcut.IconLocation = $icon
    }
    $shortcut.Save()
}

Write-Output "desktop=$desktop"
Write-Output 'shortcuts=created'
