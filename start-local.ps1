# Script PowerShell para iniciar el proyecto en desarrollo local
# Ejecutar: .\start-local.ps1

param(
    [switch]$Build,
    [switch]$Stop,
    [switch]$Clean,
    [switch]$Logs
)

$ErrorActionPreference = "Stop"

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  Basdonax AI RAG - Local Development" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# Verificar que Docker Desktop está corriendo
$dockerRunning = docker info 2>&1
if ($LASTEXITCODE -ne 0) {
    Write-Host "[ERROR] Docker Desktop no esta corriendo" -ForegroundColor Red
    Write-Host "Por favor inicia Docker Desktop y vuelve a intentar" -ForegroundColor Yellow
    exit 1
}

Write-Host "[OK] Docker Desktop esta corriendo" -ForegroundColor Green
Write-Host ""

# Comando para detener
if ($Stop) {
    Write-Host "[STOP] Deteniendo contenedores..." -ForegroundColor Yellow
    docker-compose -f docker-compose.local.yml down
    Write-Host "[OK] Contenedores detenidos" -ForegroundColor Green
    exit 0
}

# Comando para limpiar todo (incluyendo volúmenes)
if ($Clean) {
    Write-Host "[CLEAN] Limpiando contenedores y volumenes..." -ForegroundColor Yellow
    Write-Host "[WARN] Esto eliminara los modelos descargados y datos de ChromaDB" -ForegroundColor Red
    $confirmation = Read-Host "Estas seguro? (escribe SI para confirmar)"
    if ($confirmation -eq "SI") {
        docker-compose -f docker-compose.local.yml down -v
        Write-Host "[OK] Todo limpio" -ForegroundColor Green
    } else {
        Write-Host "[CANCEL] Operacion cancelada" -ForegroundColor Yellow
    }
    exit 0
}

# Comando para ver logs
if ($Logs) {
    Write-Host "[LOGS] Mostrando logs (Ctrl+C para salir)..." -ForegroundColor Yellow
    docker-compose -f docker-compose.local.yml logs -f
    exit 0
}

# Iniciar servicios
if ($Build) {
    Write-Host "[BUILD] Construyendo e iniciando servicios..." -ForegroundColor Yellow
    docker-compose -f docker-compose.local.yml up --build -d
} else {
    Write-Host "[START] Iniciando servicios..." -ForegroundColor Yellow
    docker-compose -f docker-compose.local.yml up -d
}

if ($LASTEXITCODE -eq 0) {
    Write-Host ""
    Write-Host "[OK] Servicios iniciados correctamente" -ForegroundColor Green
    Write-Host ""
    Write-Host "Estado de los contenedores:" -ForegroundColor Cyan
    docker-compose -f docker-compose.local.yml ps
    Write-Host ""
    Write-Host "Esperando a que los servicios esten listos..." -ForegroundColor Yellow
    Start-Sleep -Seconds 10

    Write-Host ""
    Write-Host "========================================" -ForegroundColor Cyan
    Write-Host "  Siguiente paso: Descargar modelo" -ForegroundColor Yellow
    Write-Host "========================================" -ForegroundColor Cyan
    Write-Host ""
    Write-Host "Ejecuta el siguiente comando para descargar el modelo Phi3:" -ForegroundColor White
    Write-Host "  docker exec basdonax-ollama-local ollama pull phi3" -ForegroundColor Green
    Write-Host ""
    Write-Host "O ejecuta el script:" -ForegroundColor White
    Write-Host "  .\setup-model-local.ps1" -ForegroundColor Green
    Write-Host ""
    Write-Host "Luego accede a: http://localhost:8080" -ForegroundColor Cyan
    Write-Host ""
    Write-Host "Comandos utiles:" -ForegroundColor Yellow
    Write-Host "  Ver logs:     .\start-local.ps1 -Logs" -ForegroundColor White
    Write-Host "  Detener:      .\start-local.ps1 -Stop" -ForegroundColor White
    Write-Host "  Rebuild:      .\start-local.ps1 -Build" -ForegroundColor White
    Write-Host "  Limpiar todo: .\start-local.ps1 -Clean" -ForegroundColor White
    Write-Host ""
} else {
    Write-Host ""
    Write-Host "[ERROR] Error al iniciar los servicios" -ForegroundColor Red
    Write-Host "Ejecuta este comando para ver los errores:" -ForegroundColor Yellow
    Write-Host "  docker-compose -f docker-compose.local.yml logs" -ForegroundColor White
    exit 1
}
