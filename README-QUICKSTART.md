# Basdonax AI RAG - Quick Start Guide

## Inicio Rápido

### Opción 1: Docker Compose Local (Recomendado para desarrollo)

```bash
# 1. Clonar el repositorio
git clone <tu-repositorio>
cd basdonax-ai-rag

# 2. Copiar archivo de variables de entorno
cp .env.example .env

# 3. Editar .env con tus configuraciones (opcional)
# nano .env

# 4. Iniciar todos los servicios
docker-compose -f docker-compose.prod.yml up -d

# 5. Esperar a que los servicios estén saludables (puede tardar 2-3 minutos)
docker-compose -f docker-compose.prod.yml ps

# 6. Descargar modelo en Ollama (primera vez)
docker-compose -f docker-compose.prod.yml exec ollama ollama pull phi3

# 7. Acceder a la aplicación
# Abre tu navegador en: http://localhost:8080
```

### Opción 2: Easypanel (Producción)

Ver guía completa en [EASYPANEL-DEPLOYMENT.md](EASYPANEL-DEPLOYMENT.md)

**Resumen rápido:**
1. Crea un proyecto en Easypanel
2. Añade servicio "Docker Compose"
3. Apunta a tu repositorio GitHub
4. Selecciona `docker-compose.prod.yml`
5. Configura las variables de entorno
6. Deploy!

## Verificar Estado

### Ver estado de servicios
```bash
docker-compose -f docker-compose.prod.yml ps
```

Deberías ver algo como:
```
NAME               STATUS                PORTS
basdonax-chroma    Up (healthy)         0.0.0.0:8000->8000/tcp
basdonax-ollama    Up (healthy)         0.0.0.0:11434->11434/tcp
basdonax-ui        Up (healthy)         0.0.0.0:8080->8080/tcp
```

### Ejecutar script de healthcheck
```bash
./healthcheck-test.sh
```

Este script verifica:
- ✓ ChromaDB está respondiendo
- ✓ Ollama está respondiendo
- ✓ UI (Streamlit) está respondiendo
- ✓ Modelos disponibles en Ollama
- ✓ Conectividad entre servicios
- ✓ Volúmenes persistentes

### Ver logs
```bash
# Todos los servicios
docker-compose -f docker-compose.prod.yml logs -f

# Solo UI
docker-compose -f docker-compose.prod.yml logs -f ui

# Solo Ollama
docker-compose -f docker-compose.prod.yml logs -f ollama

# Solo ChromaDB
docker-compose -f docker-compose.prod.yml logs -f chroma
```

## Configuración de Modelos

### Modelos Locales (Ollama)

```bash
# Listar modelos disponibles
docker-compose exec ollama ollama list

# Descargar modelos adicionales
docker-compose exec ollama ollama pull llama3
docker-compose exec ollama ollama pull mistral
docker-compose exec ollama ollama pull codellama

# Eliminar un modelo
docker-compose exec ollama ollama rm phi3
```

### Usar APIs en la Nube (alternativa a Ollama)

Edita tu `.env`:
```env
USE_CLOUD_API=true
CLOUD_PROVIDER=groq  # o openai, anthropic, google
GROQ_API_KEY=tu_api_key_aqui
MODEL_NAME=llama-3.1-70b-versatile
```

Reinicia el servicio UI:
```bash
docker-compose -f docker-compose.prod.yml restart ui
```

## Gestión de Documentos

### Subir documentos
1. Accede a http://localhost:8080
2. Ve a la sección "Subir Documentos"
3. Selecciona tus archivos (PDF, DOCX, TXT, etc.)
4. Haz clic en "Procesar"

### Verificar documentos en ChromaDB
```bash
# Conectar a ChromaDB
curl http://localhost:8000/api/v1/collections

# Ver documentos indexados
curl http://localhost:8000/api/v1/collections/your_collection/get
```

## Troubleshooting

### Servicio no inicia
```bash
# Ver logs del servicio
docker-compose -f docker-compose.prod.yml logs servicio_nombre

# Reiniciar servicio específico
docker-compose -f docker-compose.prod.yml restart servicio_nombre

# Reiniciar todo
docker-compose -f docker-compose.prod.yml restart
```

### Healthcheck falla
```bash
# Ejecutar healthcheck manual
./healthcheck-test.sh

# Verificar desde dentro del contenedor
docker-compose exec ui curl -f http://localhost:8080/_stcore/health
docker-compose exec ui curl -f http://ollama:11434/api/tags
docker-compose exec ui curl -f http://chroma:8000/api/v1/heartbeat
```

### Limpiar y reiniciar
```bash
# Parar y eliminar contenedores
docker-compose -f docker-compose.prod.yml down

# Parar, eliminar contenedores Y volúmenes (¡cuidado, pierdes datos!)
docker-compose -f docker-compose.prod.yml down -v

# Reconstruir imágenes
docker-compose -f docker-compose.prod.yml build --no-cache

# Iniciar de nuevo
docker-compose -f docker-compose.prod.yml up -d
```

## Monitoreo

### Recursos del sistema
```bash
# Ver uso de recursos de cada contenedor
docker stats

# Específico para un servicio
docker stats basdonax-ui
```

### Espacio en disco
```bash
# Ver tamaño de volúmenes
docker volume ls
docker system df -v
```

## Backup

### Backup de ChromaDB
```bash
# Backup manual
docker run --rm -v basdonax-ai-rag_chroma_data:/data -v $(pwd)/backups:/backup ubuntu tar czf /backup/chroma-backup-$(date +%Y%m%d-%H%M%S).tar.gz /data
```

### Backup de Ollama Models
```bash
# Backup manual
docker run --rm -v basdonax-ai-rag_ollama_models:/data -v $(pwd)/backups:/backup ubuntu tar czf /backup/ollama-backup-$(date +%Y%m%d-%H%M%S).tar.gz /data
```

### Restaurar Backup
```bash
# Restaurar ChromaDB
docker run --rm -v basdonax-ai-rag_chroma_data:/data -v $(pwd)/backups:/backup ubuntu tar xzf /backup/chroma-backup-YYYYMMDD-HHMMSS.tar.gz -C /data --strip 1

# Restaurar Ollama
docker run --rm -v basdonax-ai-rag_ollama_models:/data -v $(pwd)/backups:/backup ubuntu tar xzf /backup/ollama-backup-YYYYMMDD-HHMMSS.tar.gz -C /data --strip 1
```

## URLs Importantes

| Servicio | URL Local | Puerto |
|----------|-----------|--------|
| **UI (Streamlit)** | http://localhost:8080 | 8080 |
| **Ollama API** | http://localhost:11434 | 11434 |
| **ChromaDB** | http://localhost:8000 | 8000 |

## Siguientes Pasos

1. ✅ Verificar que todos los servicios están healthy
2. ✅ Descargar al menos un modelo en Ollama
3. ✅ Subir documentos a través de la interfaz
4. ✅ Probar el chat con tus documentos
5. 📚 Leer la [documentación completa de Easypanel](EASYPANEL-DEPLOYMENT.md)
6. 🚀 Desplegar en producción

## Soporte

Si tienes problemas:
1. Ejecuta `./healthcheck-test.sh` y comparte el output
2. Revisa los logs: `docker-compose logs -f`
3. Verifica las variables de entorno en `.env`
4. Consulta [EASYPANEL-DEPLOYMENT.md](EASYPANEL-DEPLOYMENT.md) para configuración de producción
