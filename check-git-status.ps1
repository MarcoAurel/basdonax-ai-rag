# Script temporal para verificar cambios en Git
Set-Location "D:\Proyectos\basdonax-ai-rag"

Write-Host "=== GIT STATUS ===" -ForegroundColor Cyan
git status

Write-Host "`n=== ARCHIVOS MODIFICADOS ===" -ForegroundColor Cyan
git diff --name-only

Write-Host "`n=== CAMBIOS DETALLADOS ===" -ForegroundColor Cyan
git diff
