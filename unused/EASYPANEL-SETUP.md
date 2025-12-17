# Configuración Paso a Paso en Easypanel

Esta guía te llevará paso a paso por la configuración completa en Easypanel para tu servidor **172.19.5.212**.

## Preparación Previa

### 1. Asegúrate de que el código esté en GitHub

```bash
# Si aún no has subido el código a GitHub
git init
git add .
git commit -m "Initial commit"
git remote add origin https://github.com/TU_USUARIO/TU_REPOSITORIO.git
git push -u origin master
```

### 2. Verifica que los archivos estén listos

Archivos que deben existir:
- ✅ `docker-compose.prod.yml` - Configuración para producción
- ✅ `.env.example` - Variables de entorno de ejemplo
- ✅ `init-ollama.sh` - Script de inicialización
- ✅ `app/Dockerfile` - Imagen de la aplicación

## Configuración en Easypanel

### Paso 1: Acceder a Easypanel

1. Abre tu navegador
2. Navega a: `http://172.19.5.212`
3. Inicia sesión con tus credenciales

### Paso 2: Crear Nuevo Proyecto

1. Haz clic en **"Projects"** en el menú lateral
2. Haz clic en **"Create Project"**
3. Configuración:
   ```
   Project Name: basdonax-ai-rag
   ```
4. Haz clic en **"Create"**

### Paso 3: Conectar GitHub

1. Dentro del proyecto, haz clic en **"Add Service"**
2. Selecciona **"GitHub"**
3. Autoriza la conexión a tu repositorio
4. Configuración:
   ```
   Repository: TU_USUARIO/basdonax-ai-rag
   Branch: master
   ```

### Paso 4: Configurar Docker Compose

1. En el servicio recién creado, ve a **"Settings"**
2. En **"Build Method"**, selecciona **"Docker Compose"**
3. En **"Compose File"**, ingresa: `docker-compose.prod.yml`

### Paso 5: Configurar Variables de Entorno

Ve a la sección **"Environment Variables"** y agrega:

```env
MODEL=phi3
EMBEDDINGS_MODEL_NAME=all-MiniLM-L6-v2
TARGET_SOURCE_CHUNKS=5
OLLAMA_HOST=http://ollama:11434
CHROMA_HOST=chroma
CHROMA_PORT=8000
```

**Nota:** También puedes copiar desde `.env.example`

### Paso 6: Configurar Puertos

Asegúrate de que estos puertos estén expuestos:

- **8080** → UI (Streamlit)
- **8000** → ChromaDB (opcional, para debugging)

### Paso 7: Configurar Auto Deploy (Opcional pero Recomendado)

1. Ve a **"Settings"** → **"General"**
2. Activa **"Auto Deploy"**
3. Configuración:
   ```
   Branch: master
   ```

Ahora cada vez que hagas `git push origin master`, Easypanel redesplegará automáticamente.

### Paso 8: Desplegar

1. Haz clic en **"Deploy"** (botón grande, generalmente arriba a la derecha)
2. Espera 5-10 minutos para el primer despliegue
3. Monitorea los logs en tiempo real

### Paso 9: Verificar el Estado

Deberías ver 3 contenedores corriendo:
- ✅ `basdonax-ollama` (State: Running)
- ✅ `basdonax-chroma` (State: Running)
- ✅ `basdonax-ui` (State: Running)

### Paso 10: Descargar el Modelo Phi3

**IMPORTANTE:** El modelo no se descarga automáticamente. Debes hacerlo manualmente.

**Opción A: Desde Easypanel (Recomendado)**

1. Ve al servicio **"basdonax-ollama"**
2. Haz clic en la pestaña **"Console"** o **"Shell"**
3. Ejecuta:
   ```bash
   ollama pull phi3
   ```
4. Espera ~5-10 minutos (descarga ~2.5GB)

**Opción B: Via SSH al servidor**

```bash
# Conectarse al servidor
ssh usuario@172.19.5.212

# Ejecutar el script de inicialización
cd /ruta/donde/clonaste/el/repo
chmod +x init-ollama.sh
./init-ollama.sh
```

**Opción C: Comando directo desde SSH**

```bash
ssh usuario@172.19.5.212
docker exec basdonax-ollama ollama pull phi3
```

### Paso 11: Verificar que Todo Funciona

1. Abre tu navegador
2. Ve a: `http://172.19.5.212:8080`
3. Deberías ver la interfaz de Basdonax AI RAG
4. Intenta subir un documento PDF o TXT
5. Haz una pregunta sobre el contenido

## Solución de Problemas Durante la Configuración

### Error: "Service unhealthy"

**Causa:** Los servicios no están listos

**Solución:**
1. Ve a los logs del servicio que falla
2. Espera un poco más (los health checks tardan ~30 segundos)
3. Si persiste, revisa las variables de entorno

### Error: "Cannot connect to ChromaDB"

**Causa:** Variable de entorno incorrecta

**Solución:**
1. Verifica que `CHROMA_HOST=chroma` (NO "localhost" ni IP)
2. Verifica que `CHROMA_PORT=8000`
3. Redespliega

### Error: "Model not found"

**Causa:** No descargaste el modelo Phi3

**Solución:**
1. Sigue el **Paso 10** arriba
2. Descarga el modelo: `ollama pull phi3`
3. Reinicia el servicio UI

### Error: "Build failed"

**Causa:** Error en el Dockerfile o dependencias

**Solución:**
1. Revisa los logs de build
2. Verifica que `app/requirements.txt` exista
3. Verifica que `app/Dockerfile` exista

### La interfaz carga pero no responde

**Causa:** Ollama no está corriendo o modelo no descargado

**Solución:**
1. Verifica: `docker exec basdonax-ollama ollama list`
2. Si phi3 no aparece, descárgalo: `ollama pull phi3`
3. Reinicia el servicio UI

## Comandos Útiles Post-Despliegue

### Ver logs en tiempo real

Desde Easypanel:
- Haz clic en cada servicio → pestaña "Logs"

Desde SSH:
```bash
docker logs basdonax-ui -f
docker logs basdonax-ollama -f
docker logs basdonax-chroma -f
```

### Verificar estado de contenedores

```bash
docker ps | grep basdonax
```

### Listar modelos descargados

```bash
docker exec basdonax-ollama ollama list
```

### Reiniciar un servicio

Desde Easypanel:
- Servicio → "Restart"

Desde SSH:
```bash
docker restart basdonax-ui
```

### Verificar uso de recursos

```bash
docker stats basdonax-ui basdonax-ollama basdonax-chroma
```

## Workflow de Desarrollo

### Para hacer cambios:

1. **Modificar código localmente**
2. **Probar localmente** (opcional):
   ```bash
   docker-compose -f docker-compose_sin_gpu.yml up
   ```
3. **Commitear y pushear**:
   ```bash
   git add .
   git commit -m "Descripción del cambio"
   git push origin master
   ```
4. **Easypanel redesplegará automáticamente** (si activaste Auto Deploy)
5. **Espera 2-5 minutos** y verifica en `http://172.19.5.212:8080`

### Usando los scripts de despliegue:

**Windows (PowerShell):**
```powershell
.\deploy-to-easypanel.ps1 -Message "Mi actualización"
```

**Linux/Mac/Git Bash:**
```bash
chmod +x deploy-to-easypanel.sh
./deploy-to-easypanel.sh "Mi actualización"
```

## Seguridad y Mejores Prácticas

### 1. Variables de entorno sensibles

Si agregas API keys u otras credenciales:
- Nunca las subas a GitHub
- Agrégalas directamente en Easypanel en "Environment Variables"

### 2. Firewall

Asegúrate de que solo el puerto 8080 esté expuesto públicamente:
```bash
sudo ufw allow 8080/tcp
sudo ufw deny 8000/tcp  # ChromaDB solo interno
```

### 3. Backups

Programa backups regulares de los volúmenes:
```bash
# Backup de modelos Ollama
docker run --rm -v ollama_models:/data -v $(pwd):/backup ubuntu tar czf /backup/ollama-backup-$(date +%F).tar.gz /data

# Backup de ChromaDB
docker run --rm -v chroma_data:/data -v $(pwd):/backup ubuntu tar czf /backup/chroma-backup-$(date +%F).tar.gz /data
```

### 4. Monitoreo

Considera agregar monitoreo con:
- Uptime Robot (monitoreo externo)
- Netdata (monitoreo del servidor)
- Logs centralizados

## Próximos Pasos

1. ✅ Personaliza el prompt en: `app/common/assistant_prompt.py`
2. ✅ Configura HTTPS con Nginx o Traefik
3. ✅ Agrega autenticación (Streamlit Auth)
4. ✅ Optimiza los parámetros del modelo según tus necesidades
5. ✅ Documenta casos de uso específicos para tu equipo

## Recursos Adicionales

- [Documentación completa](./DEPLOYMENT.md)
- [Inicio rápido](./QUICKSTART-EASYPANEL.md)
- [README original](./README.md)

---

**¿Problemas?** Revisa la sección de solución de problemas arriba o consulta los logs detallados.
