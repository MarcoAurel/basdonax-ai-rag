# Script para hacer commit final
Set-Location "D:\Proyectos\basdonax-ai-rag"

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "COMMIT FINAL: Hardcodeo eliminado + Prompt original" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# Estado
Write-Host "Estado del repositorio:" -ForegroundColor Yellow
git status

Write-Host ""
Write-Host "Archivos modificados:" -ForegroundColor Yellow
Write-Host "  ✅ .env.example (8 variables nuevas)" -ForegroundColor Green
Write-Host "  ✅ app/common/langchain_module.py (sin hardcodeo)" -ForegroundColor Green  
Write-Host "  ✅ app/common/ingest_file.py (sin hardcodeo)" -ForegroundColor Green
Write-Host "  ⏮️  app/common/assistant_prompt.py (revertido a original 73%)" -ForegroundColor Yellow
Write-Host ""

# Agregar archivos
git add .env.example
git add app/common/langchain_module.py
git add app/common/ingest_file.py
git add app/common/assistant_prompt.py
git add CONFIGURACION-FINAL.md
git add VALIDACION-RAPIDA-POST-DESPLIEGUE.md
git add TEST-VALIDACION-RAG.md

# Commit
Write-Host "Haciendo commit..." -ForegroundColor Cyan
git commit -m "feat: Eliminar hardcodeo + mantener prompt original (73%)

✅ CAMBIOS PRINCIPALES:

1. Eliminación de hardcodeo en .env.example
   - Agregadas 8 variables de entorno configurables
   - MAX_TOKENS, TEMPERATURE, SEARCH_TYPE
   - MMR_FETCH_K_MULTIPLIER, MMR_LAMBDA_MULT
   - CHUNK_SIZE, CHUNK_OVERLAP, COLLECTION_NAME

2. Eliminación de hardcodeo en langchain_module.py
   - 9 valores hardcoded → variables de entorno
   - Logs expandidos mostrando configuración completa
   - Soporte para configurar estrategia de búsqueda

3. Eliminación de hardcodeo en ingest_file.py
   - 3 valores hardcoded → variables de entorno
   - Logs mejorados con chunk_size y overlap

4. Prompt revertido a versión original
   - Precisión probada: 73% (8/11 tests correctos)
   - Sin meta-información visible en respuestas
   - Respuestas naturales y concisas

🎯 RESULTADO:
- Infraestructura mejorada (configurable)
- Prompt funcional (73% precisión)
- Sistema más flexible y escalable"

# Push
Write-Host ""
Write-Host "Pusheando a origin master..." -ForegroundColor Cyan
git push origin master

Write-Host ""
Write-Host "========================================" -ForegroundColor Green
Write-Host "✅ COMMIT COMPLETADO" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Green
Write-Host ""
Write-Host "📋 PRÓXIMO PASO: Agregar variables en Easypanel" -ForegroundColor Yellow
Write-Host ""
Write-Host "Variables a agregar:" -ForegroundColor White
Write-Host "  MAX_TOKENS=500" -ForegroundColor Gray
Write-Host "  TEMPERATURE=0" -ForegroundColor Gray
Write-Host "  SEARCH_TYPE=mmr" -ForegroundColor Gray
Write-Host "  MMR_FETCH_K_MULTIPLIER=4" -ForegroundColor Gray
Write-Host "  MMR_LAMBDA_MULT=0.5" -ForegroundColor Gray
Write-Host "  CHUNK_SIZE=1000" -ForegroundColor Gray
Write-Host "  CHUNK_OVERLAP=100" -ForegroundColor Gray
Write-Host "  COLLECTION_NAME=vectordb" -ForegroundColor Gray
Write-Host ""
Write-Host "Luego: REBUILD (no Restart)" -ForegroundColor Yellow
