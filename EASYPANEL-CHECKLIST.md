# Checklist de Despliegue Easypanel

Use esta checklist para asegurar un despliegue exitoso en Easypanel.

## Pre-Despliegue

- [ ] **Repositorio GitHub actualizado**
  ```bash
  git add .
  git commit -m "Configuración mejorada para Easypanel"
  git push origin master
  ```

- [ ] **Variables de entorno preparadas**
  - Copia `.env.example` como referencia
  - Prepara los valores necesarios

- [ ] **Servidor Easypanel accesible**
  - URL: http://172.19.5.212 (o tu servidor)
  - Credenciales de acceso listas

- [ ] **Recursos del servidor verificados**
  - Mínimo: 4 CPU cores, 8GB RAM, 16GB disco
  - Recomendado: 8 CPU cores, 16GB RAM, 50GB disco

## Despliegue

### Paso 1: Crear Proyecto

- [ ] Acceder a Easypanel
- [ ] Crear nuevo proyecto
  - Nombre: `basdonax-ai-rag`
- [ ] Proyecto creado exitosamente

### Paso 2: Configurar Docker Compose Service

- [ ] Hacer clic en "Add Service"
- [ ] Seleccionar "Docker Compose"
- [ ] Configurar parámetros:
  - [ ] **Name**: `basdonax-stack`
  - [ ] **Source**: GitHub
  - [ ] **Repository**: (tu repositorio)
  - [ ] **Branch**: `master`
  - [ ] **Compose File**: `docker-compose.prod.yml`

### Paso 3: Variables de Entorno

Añadir en la sección "Environment Variables":

- [ ] `MODEL=phi3`
- [ ] `EMBEDDINGS_MODEL_NAME=all-MiniLM-L6-v2`
- [ ] `TARGET_SOURCE_CHUNKS=5`
- [ ] `USE_CLOUD_API=false`
- [ ] `CHROMA_HOST=chroma`
- [ ] `CHROMA_PORT=8000`
- [ ] `OLLAMA_HOST=http://ollama:11434`

### Paso 4: Configurar Dominio

- [ ] En sección "Domains", configurar dominio para puerto 8080
- [ ] Ejemplo: `basdonax.tudominio.com` → `8080`
- [ ] Guardar configuración de dominio

### Paso 5: Deploy

- [ ] Hacer clic en "Deploy"
- [ ] Esperar a que inicie el despliegue
- [ ] No cerrar la ventana durante el despliegue inicial

## Post-Despliegue (Esperar 3-5 minutos)

### Verificar Servicios

- [ ] **Servicio ChromaDB**
  - Estado: Healthy (verde)
  - Puerto 8000 accesible internamente

- [ ] **Servicio Ollama**
  - Estado: Healthy (verde)
  - Puerto 11434 accesible internamente

- [ ] **Servicio UI**
  - Estado: Healthy (verde)
  - Puerto 8080 expuesto públicamente

### Verificar Logs

- [ ] **ChromaDB logs** - Sin errores críticos
  ```
  Buscar: "Server started"
  No debe haber: "ERROR", "FATAL"
  ```

- [ ] **Ollama logs** - Servidor iniciado
  ```
  Buscar: "Listening on"
  No debe haber: "panic", "fatal"
  ```

- [ ] **UI logs** - Streamlit corriendo
  ```
  Buscar: "You can now view your Streamlit app"
  No debe haber: "ModuleNotFoundError", "ConnectionError"
  ```

### Verificar Conectividad

- [ ] **Acceder a la URL pública**
  - Abrir navegador
  - Ir a tu dominio configurado
  - La página debe cargar

- [ ] **Interfaz visible**
  - Se ve el título "AU-REX"
  - Campo de chat presente
  - Sin errores visibles

- [ ] **Probar chat básico**
  - Escribir: "Hola, ¿cómo estás?"
  - Debe responder (aunque sin contexto RAG aún)

## Configuración Inicial

### Descargar Modelo en Ollama

**Opción A: Desde Easypanel (si tiene terminal)**
- [ ] Abrir terminal del servicio Ollama
- [ ] Ejecutar: `ollama pull phi3`
- [ ] Esperar descarga (puede tardar 5-10 minutos)
- [ ] Verificar: `ollama list` muestra phi3

**Opción B: Desde SSH al servidor**
- [ ] Conectar por SSH al servidor
- [ ] Ejecutar: `docker exec -it basdonax-ollama ollama pull phi3`
- [ ] Esperar descarga
- [ ] Verificar: `docker exec -it basdonax-ollama ollama list`

### Subir Documentos

- [ ] En la interfaz web, ir a sección "Subir Documentos"
- [ ] Seleccionar archivos de prueba (PDF, DOCX, TXT)
- [ ] Hacer clic en "Procesar"
- [ ] Esperar procesamiento
- [ ] Verificar mensaje de éxito

### Probar RAG Completo

- [ ] En el chat, hacer una pregunta sobre los documentos subidos
- [ ] Verificar que la respuesta incluye información de los documentos
- [ ] La respuesta debe ser coherente y relevante

## Troubleshooting (si algo falla)

### Si ChromaDB no inicia

- [ ] Verificar logs de ChromaDB
- [ ] Verificar que el volumen está creado
- [ ] Aumentar memoria asignada a ChromaDB (mínimo 512MB)
- [ ] Reiniciar servicio ChromaDB

### Si Ollama no inicia

- [ ] Verificar logs de Ollama
- [ ] Verificar recursos del servidor (RAM suficiente)
- [ ] Aumentar start_period a 120s si es necesario
- [ ] Verificar que el volumen ollama_models está creado
- [ ] Reiniciar servicio Ollama

### Si UI no inicia

- [ ] Verificar que ChromaDB y Ollama están healthy primero
- [ ] Verificar variables de entorno (CHROMA_HOST, OLLAMA_HOST)
- [ ] Revisar logs para ver error específico
- [ ] Verificar que el puerto 8080 no está siendo usado por otro servicio
- [ ] Reiniciar servicio UI

### Si los servicios no se comunican

- [ ] Verificar que todos están en el mismo proyecto
- [ ] Verificar nombres de servicio coinciden con variables de entorno
- [ ] Verificar red interna de Docker
- [ ] Reiniciar todos los servicios

### Si healthcheck falla constantemente

- [ ] Ver logs del servicio específico
- [ ] Verificar que curl está disponible en el contenedor
- [ ] Aumentar start_period
- [ ] Aumentar timeout
- [ ] Verificar que el comando healthcheck es correcto

## Monitoreo Continuo

### Diariamente

- [ ] Verificar que todos los servicios están healthy
- [ ] Revisar uso de recursos (CPU, RAM, Disco)
- [ ] Verificar logs por errores

### Semanalmente

- [ ] Revisar logs completos
- [ ] Verificar espacio en disco de volúmenes
- [ ] Probar funcionalidad completa del sistema
- [ ] Backup de volúmenes ChromaDB y Ollama

### Mensualmente

- [ ] Actualizar imágenes Docker si hay nuevas versiones
- [ ] Revisar y actualizar modelos de Ollama
- [ ] Revisar configuración y optimizar si es necesario
- [ ] Probar restore de backups

## Backup (Configurar ASAP)

- [ ] **Configurar backup automático de volúmenes**
  - Script de backup configurado
  - Frecuencia: Diaria
  - Retención: 7 días

- [ ] **Probar restore de backup**
  - Hacer backup de prueba
  - Restaurar en ambiente de test
  - Verificar integridad de datos

## Documentación de Referencia

Para más información, consultar:

- [ ] [DEPLOYMENT-SUMMARY.md](DEPLOYMENT-SUMMARY.md) - Resumen ejecutivo
- [ ] [EASYPANEL-DEPLOYMENT.md](EASYPANEL-DEPLOYMENT.md) - Guía completa
- [ ] [README-QUICKSTART.md](README-QUICKSTART.md) - Inicio rápido
- [ ] [.env.example](.env.example) - Variables de entorno

## Script de Verificación

Si tienes acceso al servidor, ejecutar:

```bash
# Clonar repo en servidor
cd /tmp
git clone [tu-repo]
cd basdonax-ai-rag

# Ejecutar script de verificación
chmod +x healthcheck-test.sh
./healthcheck-test.sh
```

Resultado esperado:
```
✓ ChromaDB Health - OK
✓ Ollama Health - OK
✓ Streamlit Health - OK
✓ Conectividad UI -> Ollama - OK
✓ Conectividad UI -> ChromaDB - OK

Todos los servicios están funcionando correctamente!
```

---

## Estado Final

Una vez completada toda la checklist:

- ✅ **Todos los servicios healthy**
- ✅ **Aplicación accesible públicamente**
- ✅ **Modelos descargados en Ollama**
- ✅ **Documentos subidos a ChromaDB**
- ✅ **Chat RAG funcionando correctamente**
- ✅ **Backups configurados**

**¡Despliegue exitoso!** 🎉

---

**Tiempo estimado total**: 15-30 minutos (dependiendo de velocidad de red para descargas)

**Siguiente paso**: Comenzar a usar la aplicación y documentar casos de uso específicos
