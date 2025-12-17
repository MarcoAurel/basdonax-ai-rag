# Guía de Uso de APIs en la Nube

Cómo usar modelos de IA en la nube en lugar de modelos locales para obtener respuestas MUCHO más rápidas.

## 🌟 ¿Por Qué Usar APIs en la Nube?

### Ventajas
- ⚡ **Ultra rápido**: 500+ tokens/segundo vs 5-15 tokens/segundo local
- 💻 **Sin GPU necesaria**: No consume recursos locales
- 🎯 **Mejor calidad**: Modelos más grandes y potentes
- 🔄 **Sin instalación**: No necesitas descargar modelos gigantes

### Desventajas
- 💰 Algunos requieren pago (pero hay opciones GRATIS)
- 🌐 Requiere conexión a internet
- 🔒 Tus datos se envían a servicios externos

---

## 🚀 Opción 1: Groq (RECOMENDADO - GRATIS)

### ¿Por Qué Groq?
- ✅ **100% GRATIS** (con límites generosos)
- ✅ **Ultra rápido** (500+ tokens/segundo)
- ✅ **Modelos potentes**: Llama 3.1, Mixtral, Gemma 2
- ✅ **Fácil de configurar**

### Límites Gratuitos
- 30 solicitudes/minuto
- 6,000 tokens/minuto
- **Más que suficiente** para desarrollo y uso personal

### Paso a Paso

#### 1. Obtener API Key

1. Ve a: https://console.groq.com/
2. Haz clic en "Sign Up" o "Get Started"
3. Regístrate con Google/GitHub/Email
4. Una vez dentro, ve a "API Keys" en el menú lateral
5. Haz clic en "Create API Key"
6. Copia tu API key (empieza con `gsk_...`)

#### 2. Configurar .env

Edita el archivo `.env` en la raíz del proyecto:

```env
# Groq API (GRATIS)
USE_CLOUD_API=true
CLOUD_PROVIDER=groq
GROQ_API_KEY=gsk_tu_api_key_aqui_reemplaza_esto

# Modelo a usar (opciones abajo)
MODEL_NAME=llama-3.1-70b-versatile

# Resto de configuración
EMBEDDINGS_MODEL_NAME=all-MiniLM-L6-v2
TARGET_SOURCE_CHUNKS=5
CHROMA_HOST=chroma
CHROMA_PORT=8000
```

**Reemplaza `gsk_tu_api_key_aqui_reemplaza_esto` con tu API key real**

#### 3. Modelos Disponibles en Groq

Cambia `MODEL_NAME` según tu preferencia:

| Modelo | Parámetros | Velocidad | Calidad | Recomendado |
|--------|-----------|-----------|---------|-------------|
| `llama-3.1-70b-versatile` | 70B | ⚡⚡⚡⚡⚡ | ⭐⭐⭐⭐⭐ | ✅ **Mejor balance** |
| `llama-3.1-8b-instant` | 8B | ⚡⚡⚡⚡⚡ | ⭐⭐⭐⭐ | ✅ **Más rápido** |
| `mixtral-8x7b-32768` | 47B | ⚡⚡⚡⚡ | ⭐⭐⭐⭐⭐ | ✅ **Contexto largo** |
| `gemma2-9b-it` | 9B | ⚡⚡⚡⚡⚡ | ⭐⭐⭐⭐ | **Alternativa rápida** |

#### 4. Rebuild y Reiniciar

```bash
# Rebuild para instalar las nuevas dependencias
.\start-local.ps1 -Build

# Espera 2-3 minutos mientras se construye
```

#### 5. Probar

1. Ve a `http://localhost:8080`
2. Haz una pregunta
3. **Deberías ver una respuesta en 1-3 segundos** 🚀

---

## 💬 Opción 2: OpenAI (GPT-3.5 / GPT-4)

### Costos
- GPT-3.5 Turbo: ~$0.002 por 1K tokens
- GPT-4 Turbo: ~$0.03 por 1K tokens
- Aproximadamente $0.01-0.10 por consulta típica

### Paso a Paso

#### 1. Obtener API Key

1. Ve a: https://platform.openai.com/
2. Regístrate/Inicia sesión
3. Ve a "API Keys"
4. Crea una nueva API key
5. Cópiala (empieza con `sk-...`)

#### 2. Configurar .env

```env
USE_CLOUD_API=true
CLOUD_PROVIDER=openai
OPENAI_API_KEY=sk-tu_api_key_aqui

# Modelos disponibles
MODEL_NAME=gpt-3.5-turbo  # Más barato
# MODEL_NAME=gpt-4-turbo   # Mejor calidad, más caro
# MODEL_NAME=gpt-4o        # Más nuevo y rápido

EMBEDDINGS_MODEL_NAME=all-MiniLM-L6-v2
TARGET_SOURCE_CHUNKS=5
CHROMA_HOST=chroma
CHROMA_PORT=8000
```

#### 3. Rebuild y Probar

```bash
.\start-local.ps1 -Build
```

---

## 🤖 Opción 3: Anthropic (Claude)

### Costos
- Claude 3 Haiku: ~$0.0025 por 1K tokens (muy barato)
- Claude 3.5 Sonnet: ~$0.003 por 1K tokens
- Claude 3 Opus: ~$0.015 por 1K tokens

### Paso a Paso

#### 1. Obtener API Key

1. Ve a: https://console.anthropic.com/
2. Regístrate
3. Ve a "API Keys"
4. Crea una API key
5. Cópiala (empieza con `sk-ant-...`)

#### 2. Configurar .env

```env
USE_CLOUD_API=true
CLOUD_PROVIDER=anthropic
ANTHROPIC_API_KEY=sk-ant-tu_api_key_aqui

# Modelos disponibles
MODEL_NAME=claude-3-5-sonnet-20241022  # Mejor balance
# MODEL_NAME=claude-3-haiku-20240307   # Más barato
# MODEL_NAME=claude-3-opus-20240229    # Mejor calidad

EMBEDDINGS_MODEL_NAME=all-MiniLM-L6-v2
TARGET_SOURCE_CHUNKS=5
CHROMA_HOST=chroma
CHROMA_PORT=8000
```

#### 3. Rebuild y Probar

```bash
.\start-local.ps1 -Build
```

---

## 🔍 Opción 4: Google Gemini (GRATIS/Pago)

### Tier Gratuito
- 60 solicitudes/minuto
- Gratis hasta cierto límite

### Paso a Paso

#### 1. Obtener API Key

1. Ve a: https://makersuite.google.com/app/apikey
2. Inicia sesión con cuenta Google
3. Crea un proyecto
4. Genera una API key
5. Cópiala

#### 2. Configurar .env

```env
USE_CLOUD_API=true
CLOUD_PROVIDER=google
GOOGLE_API_KEY=tu_api_key_aqui

# Modelos disponibles
MODEL_NAME=gemini-1.5-flash  # Rápido, gratis
# MODEL_NAME=gemini-1.5-pro  # Mejor calidad

EMBEDDINGS_MODEL_NAME=all-MiniLM-L6-v2
TARGET_SOURCE_CHUNKS=5
CHROMA_HOST=chroma
CHROMA_PORT=8000
```

#### 3. Rebuild y Probar

```bash
.\start-local.ps1 -Build
```

---

## 🔄 Cambiar Entre Local y Cloud

### Para Usar API en la Nube

Edita `.env`:
```env
USE_CLOUD_API=true
```

### Para Volver a Local (Ollama)

Edita `.env`:
```env
USE_CLOUD_API=false
```

Luego reinicia:
```bash
docker restart basdonax-ui-local
```

**No necesitas rebuild** para cambiar entre local/cloud, solo reiniciar.

---

## 📊 Comparación de Velocidad

Tiempo promedio de respuesta para una consulta típica:

| Proveedor | Modelo | Tiempo | Costo |
|-----------|--------|--------|-------|
| **Local CPU** | phi3 | ~10-15 seg | GRATIS |
| **Local CPU** | llama3.2:1b | ~3-5 seg | GRATIS |
| **Groq** | llama-3.1-70b | **~1-2 seg** | **GRATIS** ⭐ |
| **Groq** | llama-3.1-8b | **~0.5-1 seg** | **GRATIS** ⭐ |
| **OpenAI** | gpt-3.5-turbo | ~2-3 seg | $0.01-0.05 |
| **OpenAI** | gpt-4-turbo | ~3-5 seg | $0.10-0.30 |
| **Anthropic** | claude-3-haiku | ~2-3 seg | $0.01-0.03 |
| **Anthropic** | claude-3.5-sonnet | ~2-4 seg | $0.05-0.15 |
| **Google** | gemini-1.5-flash | ~2-3 seg | GRATIS/Pago |

---

## 💡 Mi Recomendación

### Para Desarrollo y Pruebas
```env
USE_CLOUD_API=true
CLOUD_PROVIDER=groq
GROQ_API_KEY=tu_api_key
MODEL_NAME=llama-3.1-70b-versatile
```

**Por qué:**
- ✅ GRATIS
- ✅ Ultra rápido (1-2 segundos)
- ✅ Excelente calidad
- ✅ Sin límites estrictos

### Para Producción con Presupuesto
```env
USE_CLOUD_API=true
CLOUD_PROVIDER=openai
OPENAI_API_KEY=tu_api_key
MODEL_NAME=gpt-3.5-turbo
```

**Por qué:**
- ⚡ Muy rápido
- 💰 Barato (~$0.01-0.05 por consulta)
- 🏆 Muy buena calidad
- 📈 Escalable

### Para Máxima Calidad
```env
USE_CLOUD_API=true
CLOUD_PROVIDER=anthropic
ANTHROPIC_API_KEY=tu_api_key
MODEL_NAME=claude-3-5-sonnet-20241022
```

**Por qué:**
- 🏆 Mejor calidad en respuestas complejas
- 📚 Excelente para análisis de documentos
- 🎯 Muy preciso

---

## 🔒 Seguridad

### Proteger tu API Key

1. **NUNCA** subas el archivo `.env` a GitHub
   - Ya está en `.gitignore`

2. **Rotar** tus API keys periódicamente

3. **Monitorear** el uso en los dashboards:
   - Groq: https://console.groq.com/
   - OpenAI: https://platform.openai.com/usage
   - Anthropic: https://console.anthropic.com/

4. **Configurar límites** de gasto en los dashboards

---

## 🧪 Probar Ahora (Groq - GRATIS)

```bash
# 1. Obtén tu API key de https://console.groq.com/

# 2. Edita .env y agrega:
#    USE_CLOUD_API=true
#    CLOUD_PROVIDER=groq
#    GROQ_API_KEY=tu_api_key_aqui
#    MODEL_NAME=llama-3.1-70b-versatile

# 3. Rebuild
.\start-local.ps1 -Build

# 4. Espera 2-3 minutos

# 5. Prueba en http://localhost:8080
```

**Deberías ver respuestas en ~1-2 segundos** 🚀

---

## ❓ Solución de Problemas

### Error: "API key no está configurada"

**Solución:** Verifica que agregaste la API key correcta en `.env`:
```env
GROQ_API_KEY=gsk_tu_key_aqui  # Sin comillas
```

### Error: "Rate limit exceeded"

**Causa:** Excediste el límite de solicitudes

**Solución:**
- Groq: Espera 1 minuto
- OpenAI: Revisa tu plan
- Agrega delays entre consultas

### Error: "Invalid API key"

**Solución:**
1. Verifica que copiaste la key completa
2. Genera una nueva key
3. Verifica que no tenga espacios extras

### Las respuestas siguen lentas

**Causa:** Puede que no se haya cargado el .env

**Solución:**
```bash
# Detén todo
.\start-local.ps1 -Stop

# Rebuild
.\start-local.ps1 -Build

# Verifica logs
docker logs basdonax-ui-local -f
```

---

## 📝 Resumen

1. **Groq es GRATIS** y super rápido → **Úsalo para desarrollo**
2. **OpenAI GPT-3.5** es barato y bueno → **Úsalo para producción**
3. **Claude 3.5** es el mejor para análisis complejos → **Úsalo para casos especiales**
4. **NO necesitas** GPU ni modelos locales con APIs en la nube
5. **Respuestas en 1-3 segundos** vs 10-15 segundos local

---

**¿Listo para probarlo?** Empieza con Groq (gratis): https://console.groq.com/
