# Claude Code + Codex Windows Installation Script (PowerShell) - Custom Paths

$ErrorActionPreference = "Stop"

# === User Custom Paths ===
$UserClaudeDataDir = "C:\Users\lizhirui01\.claude"
$UserCodexDir = "C:\Users\lizhirui01\.codex"
# =========================

function Print-Message {
    param([string]$Message, [string]$Color="Green")
    Write-Host "[INFO] $Message" -ForegroundColor $Color
}

function Print-Error {
    param([string]$Message)
    Write-Host "[ERROR] $Message" -ForegroundColor Red
}

function Check-Command {
    param([string]$Name, [string]$Cmd)
    try {
        $null = Get-Command $Cmd -ErrorAction Stop
        Print-Message "$Name is installed (found in PATH)"
    } catch {
        # Handle Codex separately later
        if ($Name -ne "Codex") {
            Print-Error "$Name not found. Please install $Name first."
            exit 1
        } else {
            Print-Message "Codex not found in PATH, checking custom path..." "Yellow"
        }
    }
}

# 1. Check Environment
Print-Message "Checking system environment..." "Cyan"
Check-Command "Node.js" "node"
Check-Command "NPM" "npm"
Check-Command "Python" "python"
Check-Command "Pip" "pip"
# Codex check moved to later

# 2. Select Configuration
Write-Host "`nPlease select a configuration template:" -ForegroundColor Cyan
Write-Host "1) Simple (Recommended for beginners) - Basic Claude + Codex"
Write-Host "2) Standard (Recommended for daily use) - Full collaboration environment"
Write-Host "3) Advanced (Recommended for power users) - Enterprise environment"

$choice = Read-Host "`nEnter selection (1-3)"
$configLevel = "simple"
switch ($choice) {
    "1" { $configLevel = "simple" }
    "2" { $configLevel = "standard" }
    "3" { $configLevel = "advanced" }
    Default { $configLevel = "simple"; Print-Message "Defaulting to Simple configuration" "Yellow" }
}

# 3. Install Dependencies
Print-Message "Installing dependencies for $configLevel configuration..." "Cyan"

# Basic packages
$packages = @("@modelcontextprotocol/server-sequential-thinking")

if ($configLevel -eq "standard" -or $configLevel -eq "advanced") {
    $packages += "mcp-shrimp-task-manager"
    
    # Install uv (for code-index)
    Print-Message "Checking/Installing uv..."
    try {
        $null = Get-Command "uv" -ErrorAction SilentlyContinue
        if (-not $?) {
            pip install uv
        }
    } catch {
        Print-Message "Failed to install uv automatically. You may need to install it manually." "Yellow"
    }
}

if ($configLevel -eq "advanced") {
    $packages += "chrome-devtools-mcp@latest"
    $packages += "exa-mcp-server"
}

foreach ($pkg in $packages) {
    Print-Message "Installing NPM package: $pkg"
    cmd /c "npm install -g $pkg"
}

# === Locate Codex Executable ===
Print-Message "Locating Codex..." "Cyan"
$CodexExePath = "codex" # Default to PATH
if (Test-Path "$UserCodexDir\codex.exe") {
    $CodexExePath = "$UserCodexDir\codex.exe"
    Print-Message "Found Codex at: $CodexExePath"
} elseif (Test-Path "$UserCodexDir\bin\codex.exe") {
    $CodexExePath = "$UserCodexDir\bin\codex.exe"
    Print-Message "Found Codex at: $CodexExePath"
} else {
    Print-Message "codex.exe not found in $UserCodexDir. Will try using global 'codex' command." "Yellow"
}

# 4. Generate Config File
$claudeConfigDir = "$env:APPDATA\Claude"
if (-not (Test-Path $claudeConfigDir)) {
    New-Item -ItemType Directory -Path $claudeConfigDir | Out-Null
}

$configFile = "$claudeConfigDir\claude_desktop_config.json"
Print-Message "Generating config file: $configFile"

# Build config object
$mcpServers = @{}

# Sequential Thinking
$mcpServers["sequential-thinking"] = @{
    command = "npx.cmd"
    args = @("-y", "@modelcontextprotocol/server-sequential-thinking")
    env = @{ WORKING_DIR = $UserClaudeDataDir }
}

# Codex
$mcpServers["codex"] = @{
    command = $CodexExePath
    args = @("mcp-server")
    env = @{ WORKING_DIR = $UserClaudeDataDir }
}

# Shrimp Task Manager
if ($configLevel -ne "simple") {
    $mcpServers["shrimp-task-manager"] = @{
        command = "npx.cmd"
        args = @("-y", "mcp-shrimp-task-manager")
        env = @{
            DATA_DIR = "$UserClaudeDataDir/shrimp"
            TEMPLATES_USE = "zh"
            ENABLE_GUI = "false"
        }
    }
    
    # Code Index
    $mcpServers["code-index"] = @{
        command = "uvx" 
        args = @("code-index-mcp")
        env = @{ WORKING_DIR = $UserClaudeDataDir }
    }
}

# Advanced Tools
if ($configLevel -eq "advanced") {
    $mcpServers["chrome-devtools"] = @{
        command = "npx.cmd"
        args = @("chrome-devtools-mcp@latest")
        env = @{ WORKING_DIR = $UserClaudeDataDir }
    }
    
    $exaKey = Read-Host "Enter Exa API Key (Optional, press Enter to skip)"
    if (-not [string]::IsNullOrWhiteSpace($exaKey)) {
        $mcpServers["exa"] = @{
            command = "npx.cmd"
            args = @("-y", "exa-mcp-server")
            env = @{
                EXA_API_KEY = $exaKey
                WORKING_DIR = $UserClaudeDataDir
            }
        }
    }
}

$config = @{
    mcpServers = $mcpServers
}

$jsonContent = $config | ConvertTo-Json -Depth 10
$jsonContent | Out-File -FilePath $configFile -Encoding utf8

# 5. Create Directory Structure
Print-Message "Creating working directory structure ($UserClaudeDataDir)..." "Cyan"
# Ensure main dir exists
if (-not (Test-Path $UserClaudeDataDir)) {
    New-Item -ItemType Directory -Path $UserClaudeDataDir | Out-Null
}

$dirs = @("$UserClaudeDataDir\shrimp", "$UserClaudeDataDir\codex", "$UserClaudeDataDir\context", "$UserClaudeDataDir\logs", "$UserClaudeDataDir\cache")
foreach ($dir in $dirs) {
    if (-not (Test-Path $dir)) {
        New-Item -ItemType Directory -Path $dir | Out-Null
    }
}

Print-Message "✅ Installation Completed!" "Green"
Print-Message "Please restart Claude Desktop app to apply changes." "Green"
Print-Message "Type /available-tools in Claude to verify installation." "Green"
