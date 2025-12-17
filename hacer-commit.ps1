# Script para hacer commit de cambios Opción B
Set-Location "D:\Proyectos\basdonax-ai-rag"

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "COMMIT: Opción B + Eliminación Hardcodeo" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# Verificar estado
Write-Host "Estado actual del repositorio:" -ForegroundColor Yellow
git status

Write-Host ""
Write-Host "Archivos que se commitearán:" -ForegroundColor Yellow
Write-Host "  - .env.example (10 variables nuevas)" -ForegroundColor Green
Write-Host "  - app/common/langchain_module.py (sin hardcodeo)" -ForegroundColor Green  
Write-Host "  - app/common/ingest_file.py (sin hardcodeo)" -ForegroundColor Green
Write-Host "  - app/common/assistant_prompt.py (prompt ultra-restrictivo)" -ForegroundColor Green
Write-Host "  - CAMBIOS-APLICADOS.md (documentación)" -ForegroundColor Green
Write-Host ""

# Agregar archivos
Write-Host "Agregando archivos al staging..." -ForegroundColor Cyan
git add .env.example
git add app/common/langchain_module.py
git add app/common/ingest_file.py
git add app/common/assistant_prompt.py
git add CAMBIOS-APLICADOS.md
git add TEST-VALIDACION-RAG.md

# Commit
Write-Host ""
Write-Host "Haciendo commit..." -ForegroundColor Cyan
git commit -m "feat: Eliminar hardcodeo + implementar prompt ultra-restrictivo (Opción B)

- Agregadas 10 variables de entorno en .env.example
  - MAX_TOKENS, TEMPERATURE, SEARCH_TYPE
  - MMR_FETCH_K_MULTIPLIER, MMR_LAMBDA_MULT
  - CHUNK_SIZE, CHUNK_OVERLAP, COLLECTION_NAME
  
- Eliminado hardcodeo en langchain_module.py (9 valores)
  - max_tokens, temperature, ollama_host
  - mmr_lambda_mult, mmr_fetch_k_multiplier, search_type
  
- Eliminado hardcodeo en ingest_file.py (3 valores)
  - chunk_size, chunk_overlap, collection_name
  
- Implementado prompt ultra-restrictivo en assistant_prompt.py
  - Protocolo de 3 pasos: Analizar → Filtrar → Validar
  - Reglas estrictas anti-contaminación
  - Ejemplos concretos de aplicación
  
- Objetivo: Eliminar contaminación cruzada (73% → 90%+)
  - Test 7 fallido: mencionaba Wigos en preguntas generales
  - Test 9 fallido: no identificaba herramientas correctas"

# Push
Write-Host ""
Write-Host "Pusheando a origin master..." -ForegroundColor Cyan
git push origin master

Write-Host ""
Write-Host "========================================" -ForegroundColor Green
Write-Host "✅ COMMIT COMPLETADO" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Green
Write-Host ""
Write-Host "Próximo paso: Agregar variables en Easypanel" -ForegroundColor Yellow
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
