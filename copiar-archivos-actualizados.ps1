# Script para copiar archivos actualizados al proyecto basdonax-ai-rag
# Elimina hardcodeo + implementa Opción B (prompt ultra-restrictivo)

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "COPIAR ARCHIVOS ACTUALIZADOS" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

$projectPath = "D:\Proyectos\basdonax-ai-rag"
$downloadsPath = "$env:USERPROFILE\Downloads"

# Verificar que existe el proyecto
if (-not (Test-Path $projectPath)) {
    Write-Host "❌ ERROR: No se encuentra el proyecto en $projectPath" -ForegroundColor Red
    exit 1
}

Write-Host "📁 Proyecto: $projectPath" -ForegroundColor Green
Write-Host "📥 Origen: $downloadsPath" -ForegroundColor Green
Write-Host ""

# Función para copiar archivo
function Copy-UpdatedFile {
    param(
        [string]$fileName,
        [string]$destination
    )
    
    $source = Join-Path $downloadsPath $fileName
    
    if (Test-Path $source) {
        Copy-Item $source $destination -Force
        Write-Host "✅ Copiado: $fileName → $destination" -ForegroundColor Green
    } else {
        Write-Host "⚠️  No encontrado: $fileName (descárgalo desde Claude)" -ForegroundColor Yellow
    }
}

Write-Host "Copiando archivos..." -ForegroundColor Cyan
Write-Host ""

# Copiar .env.example (raíz)
Copy-UpdatedFile ".env.example" "$projectPath\.env.example"

# Copiar archivos Python (app/common/)
Copy-UpdatedFile "langchain_module.py" "$projectPath\app\common\langchain_module.py"
Copy-UpdatedFile "ingest_file.py" "$projectPath\app\common\ingest_file.py"
Copy-UpdatedFile "assistant_prompt.py" "$projectPath\app\common\assistant_prompt.py"

# Copiar documentos de referencia (opcional)
Write-Host ""
Write-Host "📄 Documentos de referencia:" -ForegroundColor Cyan
Copy-UpdatedFile "RESUMEN-CAMBIOS-OPCION-B.md" "$projectPath\RESUMEN-CAMBIOS-OPCION-B.md"

Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "RESUMEN DE CAMBIOS" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "✅ Eliminado hardcodeo:" -ForegroundColor Green
Write-Host "   - max_tokens, temperature, ollama_host" -ForegroundColor Gray
Write-Host "   - chunk_size, chunk_overlap, collection_name" -ForegroundColor Gray
Write-Host "   - mmr_lambda_mult, mmr_fetch_k_multiplier" -ForegroundColor Gray
Write-Host ""
Write-Host "✅ Agregadas 10 variables nuevas en .env.example" -ForegroundColor Green
Write-Host ""
Write-Host "✅ Implementado prompt ultra-restrictivo (Opción B)" -ForegroundColor Green
Write-Host "   - Protocolo de 3 pasos obligatorio" -ForegroundColor Gray
Write-Host "   - Filtrado previo de contexto" -ForegroundColor Gray
Write-Host "   - Validación pre-respuesta" -ForegroundColor Gray
Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "PRÓXIMOS PASOS" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "1. Revisar los cambios (git diff)" -ForegroundColor White
Write-Host "2. Hacer commit:" -ForegroundColor White
Write-Host "   git add ." -ForegroundColor Gray
Write-Host '   git commit -m "feat: Eliminar hardcodeo + Opción B"' -ForegroundColor Gray
Write-Host "   git push origin master" -ForegroundColor Gray
Write-Host ""
Write-Host "3. Agregar variables en Easypanel:" -ForegroundColor White
Write-Host "   MAX_TOKENS=500" -ForegroundColor Gray
Write-Host "   TEMPERATURE=0" -ForegroundColor Gray
Write-Host "   SEARCH_TYPE=mmr" -ForegroundColor Gray
Write-Host "   MMR_FETCH_K_MULTIPLIER=4" -ForegroundColor Gray
Write-Host "   MMR_LAMBDA_MULT=0.5" -ForegroundColor Gray
Write-Host "   CHUNK_SIZE=1000" -ForegroundColor Gray
Write-Host "   CHUNK_OVERLAP=100" -ForegroundColor Gray
Write-Host "   COLLECTION_NAME=vectordb" -ForegroundColor Gray
Write-Host ""
Write-Host "4. Rebuild en Easypanel" -ForegroundColor White
Write-Host ""
Write-Host "5. Re-testear con TEST-VALIDACION-RAG.md" -ForegroundColor White
Write-Host ""
Write-Host "¡Listo para continuar! 🚀" -ForegroundColor Green
