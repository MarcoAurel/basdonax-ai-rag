# Script PowerShell para facilitar el despliegue a Easypanel
# Ejecutar: .\deploy-to-easypanel.ps1

param(
    [string]$ServerIP = "172.19.5.212",
    [string]$Message = "Update deployment"
)

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  Basdonax AI RAG - Deploy Script" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# Verificar si estamos en un repositorio git
if (-not (Test-Path ".git")) {
    Write-Host "Error: No estamos en un repositorio Git" -ForegroundColor Red
    exit 1
}

Write-Host "[1/5] Verificando estado del repositorio..." -ForegroundColor Yellow
git status

Write-Host ""
Write-Host "[2/5] Agregando archivos modificados..." -ForegroundColor Yellow
git add .

Write-Host ""
Write-Host "[3/5] Creando commit..." -ForegroundColor Yellow
git commit -m "$Message"

if ($LASTEXITCODE -ne 0) {
    Write-Host "Nota: No hay cambios para commitear o el commit falló" -ForegroundColor Yellow
}

Write-Host ""
Write-Host "[4/5] Enviando a GitHub..." -ForegroundColor Yellow
git push origin master

if ($LASTEXITCODE -eq 0) {
    Write-Host ""
    Write-Host "[5/5] Despliegue iniciado!" -ForegroundColor Green
    Write-Host ""
    Write-Host "Easypanel detectará los cambios automáticamente." -ForegroundColor Green
    Write-Host "Revisa el progreso en: http://$ServerIP" -ForegroundColor Cyan
    Write-Host "Tu aplicación estará en: http://$ServerIP:8080" -ForegroundColor Cyan
} else {
    Write-Host ""
    Write-Host "Error: No se pudo hacer push a GitHub" -ForegroundColor Red
    Write-Host "Verifica tu conexión y permisos" -ForegroundColor Red
    exit 1
}

Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  Despliegue completado!" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Cyan
