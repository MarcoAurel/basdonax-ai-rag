# Despliegue en Easypanel - Configuración Multi-Servicio

Este documento explica cómo desplegar Basdonax AI RAG en Easypanel con todos sus servicios (UI, Ollama, ChromaDB).

## Problema Identificado

En local, el proyecto funciona correctamente con `docker-compose.prod.yml` que levanta 3 servicios:
- **basdonax-ui**: Interfaz de usuario Streamlit (puerto 8080)
- **ollama**: Servidor de modelos LLM (puerto 11434)
- **chromadb/chroma**: Base de datos vectorial (puerto 8000)

En Easypanel, si solo despliegas el servicio UI con un Dockerfile, los otros servicios (Ollama y ChromaDB) no estarán disponibles, causando que la aplicación no funcione correctamente.

## Solución: Despliegue Multi-Servicio en Easypanel

Easypanel soporta dos métodos para múltiples servicios:

### Opción 1: Docker Compose (Recomendado)

Easypanel soporta docker-compose directamente. Esta es la forma más sencilla de replicar tu configuración local.

#### Paso 1: Crear Proyecto en Easypanel

1. Accede a tu panel de Easypanel
2. Crea un nuevo proyecto llamado `basdonax-ai-rag`

#### Paso 2: Añadir Docker Compose Service

1. Dentro del proyecto, haz clic en "Add Service"
2. Selecciona "Docker Compose"
3. Configura los siguientes parámetros:
   - **Name**: `basdonax-stack`
   - **Source**: GitHub
   - **Repository**: Tu repositorio (ej: `username/basdonax-ai-rag`)
   - **Branch**: `master`
   - **Compose File**: `docker-compose.prod.yml`

4. En "Environment Variables", añade:
   ```
   MODEL=phi3
   EMBEDDINGS_MODEL_NAME=all-MiniLM-L6-v2
   TARGET_SOURCE_CHUNKS=5
   USE_CLOUD_API=false
   ```

5. En "Domains", configura el dominio para el servicio UI (puerto 8080)

6. Haz clic en "Deploy"

#### Paso 3: Verificar Despliegue

Una vez desplegado, Easypanel creará automáticamente los 3 servicios:
- `basdonax-ollama` (interno, puerto 11434)
- `basdonax-chroma` (interno, puerto 8000)
- `basdonax-ui` (expuesto en tu dominio)

### Opción 2: Servicios Separados (Mayor Control)

Si prefieres tener control individual sobre cada servicio:

#### 1. Crear Servicio ChromaDB

1. En tu proyecto, "Add Service" → "Docker Image"
2. Configura:
   - **Name**: `chroma`
   - **Image**: `chromadb/chroma:0.5.1.dev111`
   - **Port**: 8000
   - **Environment Variables**:
     ```
     IS_PERSISTENT=TRUE
     ANONYMIZED_TELEMETRY=FALSE
     ```
   - **Volumes**:
     - Path: `/chroma/chroma`
     - Mount: Crear nuevo volumen `chroma_data`
   - **Healthcheck**:
     - Command: `curl -f http://localhost:8000/api/v1/heartbeat || exit 1`
     - Interval: 15s
     - Timeout: 10s
     - Start Period: 30s
     - Retries: 5

3. Deploy

#### 2. Crear Servicio Ollama

1. "Add Service" → "Docker Image"
2. Configura:
   - **Name**: `ollama`
   - **Image**: `ollama/ollama:latest`
   - **Port**: 11434
   - **Environment Variables**:
     ```
     OLLAMA_HOST=0.0.0.0
     ```
   - **Volumes**:
     - Path: `/root/.ollama`
     - Mount: Crear nuevo volumen `ollama_models`
   - **Resources**:
     - Memory Limit: 4GB
     - Memory Reservation: 2GB
   - **Healthcheck**:
     - Command: `curl -f http://localhost:11434/api/tags || exit 1`
     - Interval: 15s
     - Timeout: 10s
     - Start Period: 60s
     - Retries: 5

3. Deploy

#### 3. Crear Servicio UI

1. "Add Service" → "GitHub"
2. Configura:
   - **Name**: `ui`
   - **Repository**: Tu repositorio
   - **Branch**: `master`
   - **Build Path**: `/`
   - **Dockerfile**: `Dockerfile`
   - **Port**: 8080
   - **Environment Variables**:
     ```
     MODEL=phi3
     EMBEDDINGS_MODEL_NAME=all-MiniLM-L6-v2
     TARGET_SOURCE_CHUNKS=5
     OLLAMA_HOST=http://ollama:11434
     CHROMA_HOST=chroma
     CHROMA_PORT=8000
     USE_CLOUD_API=false
     ```
   - **Depends On**:
     - Añadir dependencia de `ollama` (wait for healthy)
     - Añadir dependencia de `chroma` (wait for healthy)
   - **Resources**:
     - Memory Limit: 2GB
     - Memory Reservation: 1GB

3. En "Domains", configura tu dominio
4. Deploy

## Healthchecks Implementados

Todos los servicios ahora tienen healthchecks robustos:

### Ollama
```bash
curl -f http://localhost:11434/api/tags || exit 1
```
Verifica que el API de Ollama responde correctamente.

### ChromaDB
```bash
curl -f http://localhost:8000/api/v1/heartbeat || exit 1
```
Verifica que ChromaDB está listo para recibir consultas.

### UI (Streamlit)
```bash
#!/bin/bash
# Verificar que Streamlit está respondiendo
curl -f -s --max-time 5 http://localhost:8080/_stcore/health > /dev/null || exit 1

# Verificar que el proceso de Streamlit está corriendo
if ! pgrep -f "streamlit run" > /dev/null; then
    echo "ERROR: Proceso Streamlit no encontrado"
    exit 1
fi

echo "Healthcheck OK"
exit 0
```

## Networking en Easypanel

Los servicios se comunican entre sí usando sus nombres:
- UI se conecta a Ollama usando `http://ollama:11434`
- UI se conecta a ChromaDB usando `http://chroma:8000`

Easypanel automáticamente configura la red interna para que los servicios se descubran por nombre.

## Recursos Recomendados

Configuración mínima para cada servicio:

| Servicio | CPU | RAM | Almacenamiento |
|----------|-----|-----|----------------|
| Ollama | 2 cores | 4GB | 10GB (modelos) |
| ChromaDB | 1 core | 512MB-2GB | 5GB (índices) |
| UI | 1 core | 1-2GB | 1GB |

**Total recomendado**: 4 cores, 8GB RAM, 16GB almacenamiento

## Troubleshooting

### Los servicios no se encuentran entre sí
- Verifica que todos los servicios están en el mismo proyecto de Easypanel
- Verifica que los nombres de servicio coinciden con las variables de entorno
- Revisa los logs de cada servicio

### UI no se inicia
- Verifica que Ollama y ChromaDB están "healthy" antes de que UI intente conectarse
- Revisa las variables de entorno `OLLAMA_HOST` y `CHROMA_HOST`
- Verifica los logs del servicio UI

### Healthcheck falla constantemente
- Aumenta el `start_period` si el servicio tarda en iniciarse
- Verifica que curl está instalado en la imagen (ya incluido en nuestros Dockerfiles)
- Revisa los logs para ver qué está fallando

### ChromaDB no persiste datos
- Verifica que el volumen está correctamente montado en `/chroma/chroma`
- Verifica que `IS_PERSISTENT=TRUE` está configurado

### Ollama no carga modelos
- Verifica el volumen en `/root/.ollama`
- Puede que necesites ejecutar `ollama pull phi3` manualmente la primera vez
- Conéctate al contenedor: `docker exec -it basdonax-ollama ollama pull phi3`

## Comandos Útiles

### Descargar modelo en Ollama (si usas docker-compose local)
```bash
docker-compose -f docker-compose.prod.yml exec ollama ollama pull phi3
```

### Verificar estado de servicios
```bash
docker-compose -f docker-compose.prod.yml ps
```

### Ver logs de un servicio
```bash
docker-compose -f docker-compose.prod.yml logs -f ui
docker-compose -f docker-compose.prod.yml logs -f ollama
docker-compose -f docker-compose.prod.yml logs -f chroma
```

### Reiniciar servicios
```bash
docker-compose -f docker-compose.prod.yml restart
```

## Próximos Pasos

Después del despliegue:

1. Espera a que todos los healthchecks estén en verde
2. Descarga el modelo necesario en Ollama (si no lo hiciste antes)
3. Sube documentos a través de la interfaz para poblar ChromaDB
4. Prueba el chat para verificar que todo funciona

## Notas Importantes

- **Primer inicio**: Puede tardar 2-5 minutos hasta que todos los servicios estén healthy
- **Modelos**: Ollama descargará modelos bajo demanda, esto puede tardar
- **Persistencia**: Los volúmenes aseguran que los datos persisten entre reinicios
- **Backups**: Considera hacer backups periódicos de los volúmenes `ollama_models` y `chroma_data`
