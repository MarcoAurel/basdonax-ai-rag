# Guía de Desarrollo Local

Esta guía te ayudará a ejecutar el proyecto **Basdonax AI RAG** en tu equipo local para pruebas y desarrollo.

## Requisitos Previos

### Obligatorios
- ✅ Docker Desktop instalado y corriendo
- ✅ 8GB+ de RAM disponible
- ✅ 10GB+ de espacio en disco
- ✅ Conexión a internet (para descargar el modelo)

### Opcionales
- Git Bash (si estás en Windows y prefieres scripts bash)
- VS Code o tu editor favorito

## Verificación Inicial

### 1. Verifica que Docker Desktop esté corriendo

**Windows:**
- Busca el ícono de Docker en la bandeja del sistema
- Debe mostrar "Docker Desktop is running"

**Comando de verificación:**
```bash
docker --version
docker-compose --version
```

Deberías ver algo como:
```
Docker version 24.x.x
Docker Compose version 2.x.x
```

## Método Rápido (Recomendado) 🚀

### Paso 1: Iniciar los Servicios

**Windows (PowerShell):**
```powershell
.\start-local.ps1
```

**Mac/Linux/Git Bash:**
```bash
chmod +x start-local.sh
./start-local.sh
```

Esto iniciará:
- 🐋 Ollama (servidor de modelos LLM)
- 🗄️ ChromaDB (base de datos vectorial)
- 🎨 Streamlit UI (interfaz web)

### Paso 2: Descargar el Modelo Phi3

**Windows (PowerShell):**
```powershell
.\setup-model-local.ps1
```

**Mac/Linux/Git Bash:**
```bash
chmod +x setup-model-local.sh
./setup-model-local.sh
```

Espera 5-10 minutos mientras se descarga el modelo (~2.5GB).

### Paso 3: Acceder a la Aplicación

Abre tu navegador en:
```
http://localhost:8080
```

¡Listo! 🎉

## Método Manual (Paso a Paso)

Si prefieres ejecutar los comandos manualmente:

### 1. Iniciar los Contenedores

```bash
docker-compose -f docker-compose.local.yml up -d
```

### 2. Verificar que Estén Corriendo

```bash
docker-compose -f docker-compose.local.yml ps
```

Deberías ver:
```
NAME                      STATUS
basdonax-ollama-local     Up (healthy)
basdonax-chroma-local     Up (healthy)
basdonax-ui-local         Up (healthy)
```

### 3. Descargar el Modelo Phi3

```bash
docker exec basdonax-ollama-local ollama pull phi3
```

### 4. Verificar el Modelo

```bash
docker exec basdonax-ollama-local ollama list
```

Deberías ver:
```
NAME    ID              SIZE    MODIFIED
phi3    latest          2.5 GB  X minutes ago
```

### 5. Acceder a la Aplicación

```
http://localhost:8080
```

## Comandos Útiles

### Ver Logs en Tiempo Real

```bash
# Todos los servicios
docker-compose -f docker-compose.local.yml logs -f

# Solo UI
docker logs basdonax-ui-local -f

# Solo Ollama
docker logs basdonax-ollama-local -f

# Solo ChromaDB
docker logs basdonax-chroma-local -f
```

**Con scripts:**
```powershell
# PowerShell
.\start-local.ps1 -Logs

# Bash
./start-local.sh logs
```

### Detener los Servicios

```bash
docker-compose -f docker-compose.local.yml down
```

**Con scripts:**
```powershell
# PowerShell
.\start-local.ps1 -Stop

# Bash
./start-local.sh stop
```

### Reiniciar un Servicio Específico

```bash
docker restart basdonax-ui-local
docker restart basdonax-ollama-local
docker restart basdonax-chroma-local
```

### Rebuild (después de cambios en el código)

```bash
docker-compose -f docker-compose.local.yml up --build -d
```

**Con scripts:**
```powershell
# PowerShell
.\start-local.ps1 -Build

# Bash
./start-local.sh build
```

### Limpiar Todo (incluyendo volúmenes)

⚠️ **ADVERTENCIA:** Esto eliminará todos los modelos descargados y datos de ChromaDB

```bash
docker-compose -f docker-compose.local.yml down -v
```

**Con scripts:**
```powershell
# PowerShell
.\start-local.ps1 -Clean

# Bash
./start-local.sh clean
```

### Ver Uso de Recursos

```bash
docker stats basdonax-ui-local basdonax-ollama-local basdonax-chroma-local
```

## Desarrollo y Debugging

### Hot Reload

Los archivos en `./app` están montados como volumen, lo que significa que:
- ✅ Los cambios en Python se reflejan automáticamente
- ✅ No necesitas rebuild para cambios en el código
- ⚠️ Streamlit puede requerir un refresh en el navegador

### Modificar el Prompt del Asistente

Edita el archivo:
```
./app/common/assistant_prompt.py
```

Guarda y recarga la página en el navegador.

### Cambiar el Modelo LLM

1. Descarga otro modelo:
   ```bash
   # Ejemplo: Llama3.2 (más grande, mejor calidad)
   docker exec basdonax-ollama-local ollama pull llama3.2

   # Ejemplo: tinyllama (más pequeño, más rápido)
   docker exec basdonax-ollama-local ollama pull tinyllama
   ```

2. Edita `docker-compose.local.yml`:
   ```yaml
   environment:
     - MODEL=llama3.2  # o tinyllama
   ```

3. Reinicia el servicio UI:
   ```bash
   docker restart basdonax-ui-local
   ```

### Acceder a ChromaDB Directamente

ChromaDB está expuesto en:
```
http://localhost:8000
```

API de heartbeat:
```bash
curl http://localhost:8000/api/v1/heartbeat
```

### Acceder a Ollama Directamente

Ollama está expuesto en:
```
http://localhost:11434
```

Listar modelos via API:
```bash
curl http://localhost:11434/api/tags
```

Probar el modelo:
```bash
curl http://localhost:11434/api/generate -d '{
  "model": "phi3",
  "prompt": "¿Cuál es la capital de Francia?",
  "stream": false
}'
```

## Estructura de Archivos

```
basdonax-ai-rag/
├── app/
│   ├── Dockerfile              # Imagen de la aplicación
│   ├── Inicio.py               # Página principal
│   ├── pages/
│   │   └── Archivos.py         # Gestión de archivos
│   ├── common/
│   │   ├── assistant_prompt.py # Prompt del asistente (EDITAR AQUÍ)
│   │   ├── constants.py        # Configuración
│   │   ├── langchain_module.py # Lógica RAG
│   │   └── ...
│   └── requirements.txt        # Dependencias Python
├── docker-compose.local.yml    # Configuración local
├── start-local.ps1            # Script de inicio (PowerShell)
├── start-local.sh             # Script de inicio (Bash)
├── setup-model-local.ps1      # Setup modelo (PowerShell)
└── setup-model-local.sh       # Setup modelo (Bash)
```

## Solución de Problemas

### Error: "Docker Desktop is not running"

**Solución:**
1. Abre Docker Desktop
2. Espera a que muestre "Docker Desktop is running"
3. Intenta de nuevo

### Error: "Cannot connect to ChromaDB"

**Posibles causas:**
1. ChromaDB no está listo (espera 30 segundos)
2. ChromaDB falló al iniciar

**Solución:**
```bash
# Ver logs de ChromaDB
docker logs basdonax-chroma-local

# Reiniciar ChromaDB
docker restart basdonax-chroma-local

# Esperar y verificar
docker-compose -f docker-compose.local.yml ps
```

### Error: "Model not found"

**Causa:** No descargaste el modelo Phi3

**Solución:**
```bash
docker exec basdonax-ollama-local ollama pull phi3
```

### La página web muestra "Streamlit is starting"

**Causa:** La aplicación aún se está inicializando

**Solución:**
- Espera 30-60 segundos
- Revisa los logs: `docker logs basdonax-ui-local -f`

### Error: "Port 8080 already in use"

**Causa:** Otro servicio está usando el puerto 8080

**Solución:**
1. Detén el otro servicio
2. O edita `docker-compose.local.yml` y cambia el puerto:
   ```yaml
   ports:
     - "8081:8080"  # Ahora accede en localhost:8081
   ```

### Error de memoria / OOM Killed

**Causa:** Insuficiente RAM asignada a Docker Desktop

**Solución:**
1. Abre Docker Desktop
2. Settings → Resources → Memory
3. Asigna al menos 8GB
4. Apply & Restart

### Los cambios en el código no se reflejan

**Solución:**
```bash
# Reiniciar el servicio UI
docker restart basdonax-ui-local

# O rebuild completo
docker-compose -f docker-compose.local.yml up --build -d
```

## Pruebas Recomendadas

### 1. Subir un Documento

1. Ve a la pestaña "Archivos" en la app
2. Sube un PDF o TXT de prueba
3. Espera a que se procese

### 2. Hacer Consultas

1. Vuelve a "Inicio"
2. Haz preguntas sobre el contenido del documento
3. Verifica que las respuestas sean coherentes

### 3. Múltiples Documentos

1. Sube varios documentos
2. Haz preguntas que requieran información de varios archivos
3. Verifica que el RAG recupere contexto relevante

### 4. Probar Diferentes Modelos

```bash
# Descargar otro modelo
docker exec basdonax-ollama-local ollama pull tinyllama

# Actualizar variable de entorno y reiniciar
# (editar docker-compose.local.yml primero)
docker restart basdonax-ui-local
```

## Rendimiento Esperado

### Phi3 (Recomendado para desarrollo)
- **Tamaño:** ~2.5GB
- **RAM:** ~4-6GB durante inferencia
- **Velocidad:** ~15-30 tokens/segundo (depende de tu CPU)
- **Calidad:** Buena para uso general

### TinyLlama (Más rápido)
- **Tamaño:** ~1.1GB
- **RAM:** ~2-3GB
- **Velocidad:** ~30-50 tokens/segundo
- **Calidad:** Aceptable para pruebas rápidas

### Llama3.2 (Mejor calidad, más lento)
- **Tamaño:** ~7GB
- **RAM:** ~8-10GB
- **Velocidad:** ~5-10 tokens/segundo
- **Calidad:** Excelente

## Siguiente Paso

Una vez que hayas probado localmente y todo funcione:

1. ✅ Asegúrate de que los cambios estén guardados
2. ✅ Sube a GitHub:
   ```bash
   git add .
   git commit -m "Local testing completed"
   git push origin master
   ```
3. ✅ Continúa con el despliegue en Easypanel siguiendo **EASYPANEL-SETUP.md**

## Recursos Adicionales

- [Documentación de Ollama](https://ollama.ai/docs)
- [Modelos disponibles](https://ollama.ai/library)
- [ChromaDB Docs](https://docs.trychroma.com/)
- [Streamlit Docs](https://docs.streamlit.io/)

---

**¿Tienes problemas?** Revisa la sección de Solución de Problemas o los logs de los contenedores.
