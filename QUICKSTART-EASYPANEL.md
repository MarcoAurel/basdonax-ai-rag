# Inicio Rápido - Despliegue en Easypanel

Guía express para desplegar Basdonax AI RAG en Easypanel desde GitHub.

## Pre-requisitos

- Servidor: `172.19.5.212` con Easypanel instalado
- Repositorio en GitHub conectado
- Sin GPU (usaremos Phi3 optimizado para CPU)

## Pasos Rápidos

### 1. Crear Proyecto en Easypanel

```
Easypanel → Projects → New Project
- Nombre: basdonax-ai-rag
- Source: GitHub Repository
- Branch: master
```

### 2. Configurar Docker Compose

```
Deployment Method: Docker Compose
File: docker-compose.prod.yml
```

### 3. Variables de Entorno (en Easypanel)

```env
MODEL=phi3
EMBEDDINGS_MODEL_NAME=all-MiniLM-L6-v2
TARGET_SOURCE_CHUNKS=5
OLLAMA_HOST=http://ollama:11434
CHROMA_HOST=chroma
CHROMA_PORT=8000
```

### 4. Deploy

Haz clic en **Deploy** y espera 5-10 minutos.

### 5. Descargar Modelo Phi3

Una vez desplegado, ejecuta en la terminal de Easypanel:

```bash
docker exec -it basdonax-ollama ollama pull phi3
```

O usa el script incluido:
```bash
chmod +x init-ollama.sh
./init-ollama.sh
```

### 6. Acceder a la Aplicación

```
http://172.19.5.212:8080
```

## Estructura de Servicios

- **ollama**: Puerto 11434 (interno) - Servidor de modelos LLM
- **chroma**: Puerto 8000 - Base de datos vectorial
- **ui**: Puerto 8080 - Interfaz Streamlit

## Comandos Útiles

### Ver logs
```bash
docker logs basdonax-ui -f
docker logs basdonax-ollama -f
docker logs basdonax-chroma -f
```

### Verificar estado
```bash
docker ps | grep basdonax
```

### Listar modelos disponibles
```bash
docker exec basdonax-ollama ollama list
```

### Reiniciar servicios
```bash
docker restart basdonax-ui
docker restart basdonax-ollama
docker restart basdonax-chroma
```

## Redeploy Automático

Activa **Auto Deploy** en Easypanel para que cada push a `master` redespiegue automáticamente.

## Recursos del Sistema

**Recomendado:**
- CPU: 4+ cores
- RAM: 8-16GB
- Almacenamiento: 20GB+

**Uso aproximado:**
- Phi3 modelo: ~2.5GB
- Inference: ~4-6GB RAM
- ChromaDB: Variable según documentos

## Solución Rápida de Problemas

| Problema | Solución |
|----------|----------|
| UI no carga | `docker logs basdonax-ui -f` |
| Modelo no encontrado | `docker exec basdonax-ollama ollama pull phi3` |
| Sin respuesta del chat | Verificar que Ollama esté corriendo: `docker ps` |
| Error de memoria | Aumentar RAM del servidor o usar modelo más pequeño |

## Próximos Pasos

1. Personaliza el prompt en: `./app/common/assistant_prompt.py`
2. Configura HTTPS con reverse proxy (Nginx/Traefik)
3. Agrega autenticación si es necesario
4. Programa backups de volúmenes

Para más detalles, consulta: `DEPLOYMENT.md`
