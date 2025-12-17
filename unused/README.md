# Archivos No Utilizados

Esta carpeta contiene archivos que estaban en la raíz del proyecto pero que no son necesarios para el funcionamiento actual del sistema.

## Contenido

### Scripts de Debug
Estos scripts fueron utilizados para debugging durante el desarrollo pero no son necesarios en producción:
- `check_chroma.py` - Script para verificar conexión a ChromaDB
- `debug_rag.py` - Script de debugging del sistema RAG
- `debug_rag_retrieval.py` - Script para debug de retrieval

### Documentación Antigua
Estos archivos de documentación han sido reemplazados por versiones más actualizadas y completas:
- `DEPLOYMENT.md` → Reemplazado por `DEPLOYMENT-SUMMARY.md` y `EASYPANEL-DEPLOYMENT.md`
- `EASYPANEL-SETUP.md` → Reemplazado por `EASYPANEL-DEPLOYMENT.md`
- `GUIA-RAPIDA.md` → Reemplazado por `README-QUICKSTART.md`
- `QUICKSTART-EASYPANEL.md` → Reemplazado por `EASYPANEL-CHECKLIST.md`
- `GUIA-API-CLOUD.md` → Información integrada en `.env.example` y documentación principal
- `LOCAL-DEVELOPMENT.md` → Reemplazado por `README-QUICKSTART.md`
- `PERSONALIZACION.md` → Información disponible en documentación principal

### Scripts Obsoletos
Scripts que apuntaban a rutas hardcoded antiguas y ya no son relevantes:
- `open_rag.bat` - Script Windows con ruta hardcoded obsoleta
- `open_rag.sh` - Script Unix con ruta hardcoded obsoleta

**Nota:** Los scripts `start-local.sh/ps1` y `setup-model-local.sh/ps1` se mantienen en la raíz ya que son útiles para desarrollo local.

### Logs
- `logs.txt` - Archivo de logs temporal del desarrollo

## ¿Se pueden eliminar?

**Sí**, estos archivos pueden ser eliminados de forma segura. Se movieron a esta carpeta para:
1. Mantener historial por si se necesita consultar algo
2. Facilitar la limpieza gradual
3. Permitir revisión antes de eliminar permanentemente

## Migración de Documentación

Si buscabas información de alguno de los archivos antiguos, consulta:

| Archivo Antiguo | Nueva Ubicación |
|----------------|-----------------|
| DEPLOYMENT.md | DEPLOYMENT-SUMMARY.md |
| EASYPANEL-SETUP.md | EASYPANEL-DEPLOYMENT.md |
| GUIA-RAPIDA.md | README-QUICKSTART.md |
| QUICKSTART-EASYPANEL.md | EASYPANEL-CHECKLIST.md |
| LOCAL-DEVELOPMENT.md | README-QUICKSTART.md |
| GUIA-API-CLOUD.md | .env.example (comentarios) |

## Fecha de Movimiento

Estos archivos fueron movidos el 17 de diciembre de 2024 durante la reorganización del proyecto para despliegue en Easypanel.
