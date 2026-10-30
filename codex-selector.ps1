# Codex Provider Selector for Windows PowerShell
# Usage: .\codex-selector.ps1 [status|openai|alibaba] [--restart-desktop]

param(
    [Parameter(Position=0)]
    [ValidateSet("status", "openai", "alibaba")]
    [string]$Command = "status",
    
    [switch]$RestartDesktop
)

$ErrorActionPreference = "Stop"

# Configuration
$CODEX_HOME = if ($env:CODEX_HOME) { $env:CODEX_HOME } else { "$env:USERPROFILE\.codex" }
$CONFIG = "$CODEX_HOME\config.toml"
# TOML basic strings treat backslashes as escape characters. Always write
# model_catalog_json with forward slashes so Windows paths remain valid TOML.
$CATALOG = (Join-Path $CODEX_HOME "model-catalog-alibaba.json").Replace('\', '/')
$BACKUP_DIR = "$CODEX_HOME\backups\selector"

$OPENAI_MODEL = "gpt-5.6-terra"
$ALIBABA_MODEL = "qwen3.8-flash"
$ALIBABA_PROVIDER = "alibaba"
$ALIBABA_PROVIDER_TABLE = @'
[model_providers.alibaba]
name = "ALIBABA via LiteLLM ThinkStation"
base_url = "http://10.28.15.77:4000/v1"
env_key = "ALIBABA_KEY"
wire_api = "responses"
requires_openai_auth = false
stream_idle_timeout_ms = 7200000
stream_max_retries = 5
request_max_retries = 4
'@

function Backup-Config {
    if (-not (Test-Path $BACKUP_DIR)) {
        New-Item -ItemType Directory -Path $BACKUP_DIR -Force | Out-Null
    }
    
    $timestamp = Get-Date -Format "yyyyMMdd-HHmmss"
    $random = Get-Random -Minimum 0 -Maximum 999999999
    $backupFile = "$BACKUP_DIR\config-$timestamp-$random.toml"
    
    Copy-Item $CONFIG $backupFile
    return $backupFile
}

function Get-CurrentMode {
    if (-not (Test-Path $CONFIG)) {
        return "unknown"
    }
    
    $content = Get-Content $CONFIG -Raw
    if ($content -match 'model_provider\s*=\s*"([^"]+)"') {
        $provider = $matches[1]
        if ($provider -eq $ALIBABA_PROVIDER) {
            return "alibaba"
        }
    }
    return "openai"
}

function Get-DesktopStatus {
    $process = Get-Process -Name "ChatGPT" -ErrorAction SilentlyContinue
    if ($process) {
        return "running"
    }
    return "stopped"
}

function Switch-Mode {
    param(
        [string]$Mode,
        [bool]$RestartDesktop
    )
    
    if (-not (Test-Path $CONFIG)) {
        Write-Error "Config file not found: $CONFIG"
        exit 1
    }
    
    # Read current config
    $content = Get-Content $CONFIG -Raw
    $backup = Backup-Config
    
    # Determine values based on mode
    if ($Mode -eq "openai") {
        $modelValue = $OPENAI_MODEL
        $providerValue = "openai"
    } else {
        $modelValue = $ALIBABA_MODEL
        $providerValue = $ALIBABA_PROVIDER
    }
    
    # Update top-level settings
    $lines = $content -split "`n"
    $newLines = @()
    $inTable = $false
    $modelUpdated = $false
    $providerUpdated = $false
    $catalogUpdated = $false
    
    foreach ($line in $lines) {
        # Check if we're entering a table section
        if ($line -match '^\s*\[') {
            $inTable = $true
        }
        
        # Only modify top-level keys (before any table)
        if (-not $inTable) {
            if ($line -match '^\s*model\s*=') {
                $line = "model = `"$modelValue`""
                $modelUpdated = $true
            }
            elseif ($line -match '^\s*model_provider\s*=') {
                $line = "model_provider = `"$providerValue`""
                $providerUpdated = $true
            }
            elseif ($line -match '^\s*model_catalog_json\s*=') {
                if ($Mode -eq 'alibaba') {
                    $line = "model_catalog_json = `"$CATALOG`""
                    $catalogUpdated = $true
                }
                else {
                    # Remove this line for OpenAI mode
                    continue
                }
            }
        }
        
        $newLines += $line
    }
    
    # Add missing keys if needed
    if (-not $modelUpdated) {
        $newLines = @("model = `"$modelValue`"") + $newLines
    }
    if (-not $providerUpdated) {
        $newLines = @("model_provider = `"$providerValue`"") + $newLines
    }
    if ($Mode -eq 'alibaba' -and -not $catalogUpdated) {
        $newLines = @("model_catalog_json = `"$CATALOG`"") + $newLines
    }

    if ($Mode -eq 'alibaba' -and $content -notmatch '(?m)^\[model_providers\.alibaba\]\s*$') {
        $newLines += ""
        $newLines += ($ALIBABA_PROVIDER_TABLE -split "`r?`n")
    }
    
    # Write back
    $newContent = $newLines -join "`n"
    Set-Content $CONFIG $newContent -NoNewline
    
    Write-Output "mode=$Mode"
    Write-Output "backup=$backup"
    
    if ($RestartDesktop) {
        # Release both process names used by Windows desktop builds.
        Get-Process -Name "ChatGPT", "Codex" -ErrorAction SilentlyContinue | Stop-Process -Force
        Start-Sleep -Seconds 2
        
        # Launch ChatGPT / Codex Desktop. The Windows installer from
        # openai.com normally installs an MSIX package, so prefer the stable
        # AppsFolder application ID instead of a versioned WindowsApps path.
        $launched = $false
        $startApp = Get-StartApps | Where-Object { $_.AppID -like 'OpenAI.Codex_*!App' } | Select-Object -First 1
        if ($startApp) {
            try {
                Start-Process ("shell:AppsFolder\" + $startApp.AppID)
                $launched = $true
            }
            catch {
                # Fall back to non-Store installations.
            }
        }

        if (-not $launched) {
            $chatgptPaths = @(
                "$env:ProgramFiles\ChatGPT\ChatGPT.exe",
                "${env:ProgramFiles(x86)}\ChatGPT\ChatGPT.exe",
                "$env:LOCALAPPDATA\Programs\ChatGPT\ChatGPT.exe"
            )

            foreach ($path in $chatgptPaths) {
                if (Test-Path $path) {
                    Start-Process $path
                    $launched = $true
                    break
                }
            }
        }

        if ($launched) {
            Write-Output "desktop=restarted"
            return
        }

        Write-Error "ChatGPT/Codex Desktop executable was not found"
        exit 1
    }
}

# Main logic
switch ($Command) {
    "status" {
        $mode = Get-CurrentMode
        $desktop = Get-DesktopStatus
        Write-Output "mode=$mode"
        Write-Output "desktop=$desktop"
    }
    "openai" {
        Switch-Mode -Mode "openai" -RestartDesktop $RestartDesktop.IsPresent
    }
    "alibaba" {
        Switch-Mode -Mode "alibaba" -RestartDesktop $RestartDesktop.IsPresent
    }
}
