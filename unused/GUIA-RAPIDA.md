# 🚀 Guía Rápida de Inicio

Elige tu camino según lo que necesites:

## 📋 Índice de Guías

### Para Desarrollo Local
- **[LOCAL-DEVELOPMENT.md](LOCAL-DEVELOPMENT.md)** - Guía completa de desarrollo local con Docker Desktop

### Para Despliegue en Easypanel
- **[QUICKSTART-EASYPANEL.md](QUICKSTART-EASYPANEL.md)** - Inicio rápido en Easypanel
- **[EASYPANEL-SETUP.md](EASYPANEL-SETUP.md)** - Configuración paso a paso en Easypanel
- **[DEPLOYMENT.md](DEPLOYMENT.md)** - Documentación técnica completa de despliegue

### Documentación Original
- **[README.md](README.md)** - Documentación original del proyecto

---

## ⚡ Inicio Super Rápido

### Desarrollo Local (en tu PC)

**1. Asegúrate de tener Docker Desktop corriendo**

**2. Inicia el proyecto:**

**Windows (PowerShell):**
```powershell
.\start-local.ps1
.\setup-model-local.ps1
```

**Mac/Linux/Git Bash:**
```bash
chmod +x start-local.sh setup-model-local.sh
./start-local.sh
./setup-model-local.sh
```

**3. Accede a:** `http://localhost:8080`

---

### Despliegue en Easypanel (servidor 172.19.5.212)

**1. Sube el código a GitHub:**
```bash
git add .
git commit -m "Ready for deployment"
git push origin master
```

**2. En Easypanel:**
- Crear proyecto: `basdonax-ai-rag`
- Conectar GitHub
- Usar: `docker-compose.prod.yml`
- Agregar variables de entorno (ver EASYPANEL-SETUP.md)
- Deploy

**3. Descargar modelo:**
```bash
docker exec basdonax-ollama ollama pull phi3
```

**4. Accede a:** `http://172.19.5.212:8080`

---

## 📂 Archivos Importantes

### Configuración
- `docker-compose.local.yml` - Para desarrollo local
- `docker-compose.prod.yml` - Para producción en Easypanel
- `.env.example` - Variables de entorno de ejemplo

### Scripts de Desarrollo Local
- `start-local.ps1` / `start-local.sh` - Iniciar proyecto localmente
- `setup-model-local.ps1` / `setup-model-local.sh` - Configurar modelo Phi3

### Scripts de Despliegue
- `deploy-to-easypanel.ps1` / `deploy-to-easypanel.sh` - Deploy a Easypanel
- `init-ollama.sh` - Inicializar modelo en producción

### Código de la Aplicación
- `app/Inicio.py` - Página principal
- `app/pages/Archivos.py` - Gestión de documentos
- `app/common/assistant_prompt.py` - **Personaliza el prompt aquí**
- `app/common/constants.py` - Configuración
- `app/common/langchain_module.py` - Lógica RAG

---

## 🔧 Comandos Más Usados

### Local (Desarrollo)

```bash
# Iniciar
.\start-local.ps1  # o ./start-local.sh

# Ver logs
.\start-local.ps1 -Logs  # o ./start-local.sh logs

# Detener
.\start-local.ps1 -Stop  # o ./start-local.sh stop

# Rebuild
.\start-local.ps1 -Build  # o ./start-local.sh build
```

### Producción (Easypanel)

```bash
# Ver logs
docker logs basdonax-ui -f

# Reiniciar servicio
docker restart basdonax-ui

# Listar modelos
docker exec basdonax-ollama ollama list

# Descargar modelo
docker exec basdonax-ollama ollama pull phi3
```

---

## 🆘 Problemas Comunes

### Local

| Problema | Solución |
|----------|----------|
| "Docker not running" | Inicia Docker Desktop |
| "Model not found" | Ejecuta `setup-model-local.ps1` |
| Puerto 8080 ocupado | Cambia el puerto en `docker-compose.local.yml` |
| Errores de memoria | Aumenta RAM en Docker Desktop Settings |

### Producción

| Problema | Solución |
|----------|----------|
| UI no conecta a Ollama | Verifica `OLLAMA_HOST=http://ollama:11434` |
| ChromaDB no funciona | Verifica `CHROMA_HOST=chroma` |
| Sin respuesta del chat | Descarga el modelo: `ollama pull phi3` |

---

## 📚 Aprende Más

- **Personalizar el asistente:** Edita `app/common/assistant_prompt.py`
- **Cambiar de modelo:** Ver LOCAL-DEVELOPMENT.md sección "Cambiar el Modelo LLM"
- **Debugging avanzado:** Ver logs con `docker logs -f`
- **Optimización:** Ver DEPLOYMENT.md sección "Monitoreo"

---

## 🎯 Próximos Pasos

1. ✅ Prueba localmente siguiendo **LOCAL-DEVELOPMENT.md**
2. ✅ Personaliza el prompt en `app/common/assistant_prompt.py`
3. ✅ Sube a GitHub
4. ✅ Despliega en Easypanel siguiendo **EASYPANEL-SETUP.md**
5. ✅ Configura HTTPS (opcional, ver DEPLOYMENT.md)

---

**¿Listo para empezar?** Abre [LOCAL-DEVELOPMENT.md](LOCAL-DEVELOPMENT.md) para desarrollo local o [EASYPANEL-SETUP.md](EASYPANEL-SETUP.md) para ir directo a producción.
