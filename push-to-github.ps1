# push-to-github.ps1
# Einmalig laufen lassen, um den Projektordner mit dem GitHub-Repo zu verbinden.
# Voraussetzung: git ist installiert (git --version laeuft) und GitHub-Auth steht
# (Credential Manager oder Personal Access Token).
#
# Aufruf in PowerShell aus dem Projektordner:
#   .\push-to-github.ps1

$ErrorActionPreference = "Stop"

$repoUrl   = "https://github.com/TH-Koln-Bartnik/ki-zum-lernen.git"
$projDir   = $PSScriptRoot
$subClone  = Join-Path $projDir "ki-zum-lernen"

Write-Host "==> Projektordner: $projDir" -ForegroundColor Cyan

# 1) Verwaisten Sub-Klon entfernen, falls vorhanden
if (Test-Path $subClone) {
    Write-Host "==> Entferne verwaisten Sub-Klon ki-zum-lernen\ ..." -ForegroundColor Yellow
    Remove-Item -Recurse -Force $subClone
}

Set-Location $projDir

# 2) Git-Repo initialisieren (idempotent)
if (-not (Test-Path ".git")) {
    Write-Host "==> git init" -ForegroundColor Cyan
    git init | Out-Null
    git branch -M main
}

# 3) Remote setzen / aktualisieren
$existingRemote = (git remote 2>$null)
if ($existingRemote -match "origin") {
    git remote set-url origin $repoUrl
} else {
    git remote add origin $repoUrl
}
Write-Host "==> Remote origin = $repoUrl" -ForegroundColor Cyan

# 4) .nojekyll in docs/ sicherstellen
$nojekyll = Join-Path $projDir "docs\.nojekyll"
if (-not (Test-Path $nojekyll)) {
    New-Item -ItemType File -Path $nojekyll -Force | Out-Null
    Write-Host "==> docs\.nojekyll angelegt" -ForegroundColor Green
}

# 5) Erster Commit (oder Folgecommit)
git add -A
$status = git status --porcelain
if ($status) {
    $msg = Read-Host "Commit-Nachricht (Enter fuer Default)"
    if ([string]::IsNullOrWhiteSpace($msg)) {
        $msg = "Update Workshop-Seite"
    }
    git commit -m $msg
} else {
    Write-Host "==> Nichts zu committen." -ForegroundColor Yellow
}

# 6) Mit Remote zusammenfuehren (bei leerem Remote wirkungslos)
Write-Host "==> Pull (allow-unrelated-histories) ..." -ForegroundColor Cyan
try {
    git pull origin main --allow-unrelated-histories --no-edit
} catch {
    Write-Host "Pull konnte nicht automatisch mergen. Bitte manuelle Konfliktloesung." -ForegroundColor Red
    throw
}

# 7) Push
Write-Host "==> Push ..." -ForegroundColor Cyan
git push -u origin main

Write-Host ""
Write-Host "Fertig. Auf GitHub unter Settings -> Pages pruefen:" -ForegroundColor Green
Write-Host "  Source: Deploy from a branch" -ForegroundColor Green
Write-Host "  Branch: main, Folder: /docs" -ForegroundColor Green
Write-Host ""
Write-Host "Pages-URL nach 1 - 2 Minuten:" -ForegroundColor Green
Write-Host "  https://th-koln-bartnik.github.io/ki-zum-lernen/" -ForegroundColor Green
