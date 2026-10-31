<#
  Activates the .venv environment next to this script.

  Usage (note the leading dot and space):
      . .\activate-venv.ps1

  This file intentionally uses ASCII text for Windows PowerShell 5.1
  compatibility. PowerShell 5.1 can misread UTF-8 scripts without a BOM.
#>

# Dot-sourcing is required to retain the prompt and deactivate function.
if ($MyInvocation.InvocationName -ne ".") {
    Write-Warning "Dot-source this script to activate the current PowerShell session:"
    Write-Host "  . `"$PSCommandPath`"" -ForegroundColor Cyan
    return
}

$venvPath = Join-Path -Path $PSScriptRoot -ChildPath ".venv"
$activateScript = Join-Path $venvPath "Scripts\Activate.ps1"

if (-not (Test-Path -LiteralPath $venvPath -PathType Container)) {
    Write-Error "Virtual environment not found: $venvPath`nCreate it with: python -m venv `"$venvPath`""
    return
}

if (-not (Test-Path -LiteralPath $activateScript -PathType Leaf)) {
    Write-Error "The virtual environment is incomplete; activation script not found: $activateScript"
    return
}

try {
    . $activateScript
} catch {
    Write-Error "Failed to activate the virtual environment: $($_.Exception.Message)"
    Write-Host "If script execution is blocked, run this once:" -ForegroundColor Yellow
    Write-Host "  Set-ExecutionPolicy -Scope CurrentUser RemoteSigned" -ForegroundColor Cyan
    return
}

if (-not $env:VIRTUAL_ENV) {
    Write-Error "The activation script ran, but VIRTUAL_ENV was not set."
    return
}

$pythonCommand = Get-Command python -ErrorAction SilentlyContinue
Write-Host "Virtual environment activated: $env:VIRTUAL_ENV" -ForegroundColor Green
Write-Host "Python: $($pythonCommand.Source)"