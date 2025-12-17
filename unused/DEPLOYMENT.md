# Guía de Despliegue en Easypanel

Esta guía detalla cómo desplegar el proyecto Basdonax AI RAG en Easypanel desde GitHub.

## Requisitos del Servidor

- **IP del servidor**: 172.19.5.212
- **Software**: Easypanel instalado y configurado
- **Hardware recomendado**:
  - CPU: 4+ cores
  - RAM: 8GB+ (recomendado 16GB)
  - Almacenamiento: 20GB+ libres (para modelos y datos)
- **Nota**: No requiere GPU (usa modelo Phi3 optimizado para CPU)

## Arquitectura del Sistema

El proyecto consta de 3 servicios:

1. **Ollama** (Puerto interno 11434)
   - Servidor de modelos LLM
   - Modelo: Phi3 (4B parámetros, optimizado para CPU)
   - Requiere ~2.5GB de almacenamiento para el modelo

2. **ChromaDB** (Puerto 8000)
   - Base de datos vectorial para embeddings
   - Almacena los documentos indexados
   - Requiere persistencia de datos

3. **UI - Streamlit** (Puerto 8080)
   - Interfaz web de usuario
   - Aplicación Python con Streamlit

## Opción 1: Despliegue con Docker Compose (Recomendado)

### Paso 1: Conectar Repositorio GitHub en Easypanel

1. Accede a Easypanel: `http://172.19.5.212`
2. Ve a **Projects** → **Create Project**
3. Nombre del proyecto: `basdonax-ai-rag`
4. Conecta tu repositorio de GitHub

### Paso 2: Configurar el Proyecto

1. En Easypanel, selecciona **Docker Compose** como método de despliegue
2. Selecciona el archivo: `docker-compose.prod.yml`
3. Configura las variables de entorno (ver sección Variables de Entorno)

### Paso 3: Configurar Volúmenes Persistentes

En Easypanel, asegúrate de que los volúmenes estén configurados:

- `ollama_models`: Para los modelos LLM (~3GB)
- `chroma_data`: Para los datos de ChromaDB

### Paso 4: Desplegar

1. Haz clic en **Deploy**
2. Espera a que todos los contenedores estén en estado `healthy`
3. Esto puede tomar 5-10 minutos en el primer despliegue

### Paso 5: Inicializar el Modelo Phi3

Una vez desplegado, necesitas descargar el modelo:

**Opción A: Desde la terminal de Easypanel**
```bash
docker exec -it basdonax-ollama ollama pull phi3
```

**Opción B: Usando SSH al servidor**
```bash
ssh usuario@172.19.5.212
cd /ruta/del/proyecto
chmod +x init-ollama.sh
./init-ollama.sh
```

### Paso 6: Verificar Instalación

1. Accede a: `http://172.19.5.212:8080`
2. Deberías ver la interfaz de Basdonax AI RAG
3. Prueba subir un documento y hacer consultas

## Opción 2: Despliegue Manual por Servicios

Si prefieres configurar cada servicio individualmente:

### Servicio 1: Ollama

```yaml
Name: basdonax-ollama
Image: ollama/ollama:latest
Restart Policy: unless-stopped
Networks: basdonax-net
Volumes:
  - ollama_models:/root/.ollama
```

### Servicio 2: ChromaDB

```yaml
Name: basdonax-chroma
Image: chromadb/chroma:0.5.1.dev111
Port Mapping: 8000:8000
Restart Policy: unless-stopped
Networks: basdonax-net
Volumes:
  - chroma_data:/chroma/chroma
Environment:
  - IS_PERSISTENT=TRUE
  - ANONYMIZED_TELEMETRY=FALSE
```

### Servicio 3: UI (Streamlit)

```yaml
Name: basdonax-ui
Build Context: ./app
Port Mapping: 8080:8080
Restart Policy: unless-stopped
Networks: basdonax-net
Depends On:
  - basdonax-ollama
  - basdonax-chroma
Environment Variables: (ver sección Variables de Entorno)
```

## Variables de Entorno

Configura estas variables en Easypanel para el servicio `ui`:

```env
MODEL=phi3
EMBEDDINGS_MODEL_NAME=all-MiniLM-L6-v2
TARGET_SOURCE_CHUNKS=5
OLLAMA_HOST=http://ollama:11434
CHROMA_HOST=chroma
CHROMA_PORT=8000
```

## Despliegue Automático desde GitHub

### Configurar Webhook (Opcional)

Para redespliegue automático cuando haces push a GitHub:

1. En Easypanel, ve a tu proyecto
2. Activa **Auto Deploy** en la configuración
3. Selecciona la rama: `master` (o la que uses)
4. Cada push a esta rama redesplegará automáticamente

### Workflow Recomendado

1. Haces cambios en tu código local
2. Commit y push a GitHub:
   ```bash
   git add .
   git commit -m "Actualización de funcionalidad"
   git push origin master
   ```
3. Easypanel detecta el cambio y redespliega automáticamente
4. Verifica en `http://172.19.5.212:8080`

## Mantenimiento

### Ver Logs

En Easypanel:
- Haz clic en cada servicio
- Ve a la pestaña **Logs**
- Filtra por errores si es necesario

O por SSH:
```bash
docker logs basdonax-ui -f
docker logs basdonax-ollama -f
docker logs basdonax-chroma -f
```

### Actualizar el Modelo

Si quieres cambiar a otro modelo (por ejemplo, llama3.2):

1. Actualiza la variable de entorno `MODEL=llama3.2`
2. Descarga el nuevo modelo:
   ```bash
   docker exec basdonax-ollama ollama pull llama3.2
   ```
3. Reinicia el servicio UI

### Backup de Datos

Respaldar los volúmenes importantes:

```bash
# Backup de modelos Ollama
docker run --rm -v ollama_models:/data -v $(pwd):/backup ubuntu tar czf /backup/ollama-backup.tar.gz /data

# Backup de ChromaDB
docker run --rm -v chroma_data:/data -v $(pwd):/backup ubuntu tar czf /backup/chroma-backup.tar.gz /data
```

## Solución de Problemas

### El servicio UI no se conecta a Ollama

Verifica que Ollama esté corriendo:
```bash
docker ps | grep ollama
docker exec basdonax-ollama ollama list
```

### ChromaDB no persiste los datos

Verifica que el volumen esté montado correctamente:
```bash
docker inspect basdonax-chroma | grep Mounts -A 10
```

### El modelo Phi3 no se encuentra

Descarga manualmente:
```bash
docker exec -it basdonax-ollama ollama pull phi3
docker exec -it basdonax-ollama ollama list
```

### Error de memoria (OOM)

El modelo Phi3 requiere ~4-6GB de RAM durante la inferencia. Si tienes problemas:
- Aumenta la RAM del servidor
- O usa un modelo más pequeño como `tinyllama`

## Monitoreo

### Recursos del Sistema

Monitorea el uso de recursos:
```bash
docker stats basdonax-ui basdonax-ollama basdonax-chroma
```

### Health Checks

Los servicios tienen health checks configurados. En Easypanel verás el estado:
- 🟢 Verde: Servicio saludable
- 🟡 Amarillo: Iniciando
- 🔴 Rojo: Error

## Seguridad

### Recomendaciones

1. **Firewall**: Asegúrate de que solo el puerto 8080 esté expuesto públicamente
2. **Autenticación**: Considera agregar autenticación a Streamlit
3. **HTTPS**: Usa un reverse proxy (Nginx/Traefik) con SSL/TLS
4. **Backups**: Programa backups regulares de los volúmenes

### Ejemplo de Nginx Reverse Proxy

```nginx
server {
    listen 80;
    server_name basdonax.tudominio.com;

    location / {
        proxy_pass http://172.19.5.212:8080;
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection "upgrade";
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
    }
}
```

## Recursos Adicionales

- [Documentación de Ollama](https://ollama.ai/docs)
- [ChromaDB Docs](https://docs.trychroma.com/)
- [Streamlit Docs](https://docs.streamlit.io/)
- [Easypanel Docs](https://easypanel.io/docs)

## Contacto y Soporte

Si encuentras problemas, revisa:
1. Los logs de cada servicio
2. El estado de health checks
3. La documentación de Easypanel

---

**Última actualización**: 2025-12-10
