# Script PowerShell para descargar el modelo Phi3 en desarrollo local
# Ejecutar: .\setup-model-local.ps1

param(
    [string]$Model = "phi3"
)

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  Configuracion de Modelo LLM" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# Verificar que el contenedor de Ollama está corriendo
$container = docker ps --filter "name=basdonax-ollama-local" --format "{{.Names}}" 2>$null

if (-not $container) {
    Write-Host "[ERROR] El contenedor de Ollama no esta corriendo" -ForegroundColor Red
    Write-Host ""
    Write-Host "Por favor ejecuta primero:" -ForegroundColor Yellow
    Write-Host "  .\start-local.ps1" -ForegroundColor White
    exit 1
}

Write-Host "[OK] Contenedor de Ollama encontrado: $container" -ForegroundColor Green
Write-Host ""

# Verificar si el modelo ya está descargado
Write-Host "Verificando modelos instalados..." -ForegroundColor Yellow
$installedModels = docker exec basdonax-ollama-local ollama list 2>&1

if ($installedModels -match $Model) {
    Write-Host "[OK] El modelo $Model ya esta instalado" -ForegroundColor Green
    Write-Host ""
    Write-Host "Modelos disponibles:" -ForegroundColor Cyan
    docker exec basdonax-ollama-local ollama list
    Write-Host ""

    $reinstall = Read-Host "Deseas reinstalarlo de todas formas? (S/N)"
    if ($reinstall -ne "S") {
        Write-Host "[OK] Usando modelo existente" -ForegroundColor Green
        exit 0
    }
}

Write-Host ""
Write-Host "Descargando modelo: $Model" -ForegroundColor Yellow
Write-Host "Esto puede tardar 5-10 minutos (~2.5GB)" -ForegroundColor Yellow
Write-Host ""

# Descargar el modelo
docker exec basdonax-ollama-local ollama pull $Model

if ($LASTEXITCODE -eq 0) {
    Write-Host ""
    Write-Host "========================================" -ForegroundColor Cyan
    Write-Host "  Modelo instalado correctamente!" -ForegroundColor Green
    Write-Host "========================================" -ForegroundColor Cyan
    Write-Host ""
    Write-Host "Modelos disponibles:" -ForegroundColor Cyan
    docker exec basdonax-ollama-local ollama list
    Write-Host ""
    Write-Host "Todo listo! Accede a tu aplicacion en:" -ForegroundColor Green
    Write-Host "   http://localhost:8080" -ForegroundColor Cyan
    Write-Host ""
    Write-Host "Consejos:" -ForegroundColor Yellow
    Write-Host "   - Sube un documento PDF o TXT" -ForegroundColor White
    Write-Host "   - Haz preguntas sobre su contenido" -ForegroundColor White
    Write-Host "   - Los documentos se guardan en ChromaDB" -ForegroundColor White
    Write-Host ""
} else {
    Write-Host ""
    Write-Host "[ERROR] Error al descargar el modelo" -ForegroundColor Red
    Write-Host "Verifica tu conexion a internet e intenta de nuevo" -ForegroundColor Yellow
    exit 1
}
