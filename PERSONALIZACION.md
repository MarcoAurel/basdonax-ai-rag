# Guía de Personalización

Cómo personalizar el asistente, cambiar modelos y optimizar para CPU.

## 🎨 Modificar el System Prompt

### Archivo a Editar
```
app/common/assistant_prompt.py
```

### Proceso
1. Abre el archivo en tu editor
2. Modifica el texto dentro de la función `assistant_prompt()`
3. **Guarda el archivo**
4. **Recarga la página en el navegador** (F5 o Ctrl+R)

### ✅ NO Necesitas
- ❌ Rebuild de Docker
- ❌ Reiniciar contenedores
- ❌ Redesplegar

### Ejemplo de Personalización

**Prompt Original:**
```python
def assistant_prompt():
    prompt = ChatPromptTemplate.from_messages(
    ("human", """ # Rol
     Sos la secretaria de PBC, tu nombre es Bastet...
```

**Prompt Personalizado:**
```python
def assistant_prompt():
    prompt = ChatPromptTemplate.from_messages(
    ("human", """ # Rol
     Eres un asistente especializado en analizar documentos técnicos.
     Tu nombre es DocuBot.

    # Tarea
    Analiza el documento y responde de manera clara y precisa.

    Question: {question}
    Context: {context}

    # Instrucciones
    - Sé conciso y directo
    - Usa ejemplos cuando sea necesario
    - Responde solo basándote en el contexto proporcionado
    - Si no sabes algo, admítelo
    """))
    return prompt
```

### Variables Importantes
- `{question}` - La pregunta del usuario
- `{context}` - El contexto recuperado de los documentos

**⚠️ NO elimines estas variables, son necesarias para el RAG**

---

## 🚀 Cambiar el Modelo LLM

### Modelos Recomendados para CPU (Sin GPU)

| Modelo | Tamaño | Velocidad CPU | Calidad | Recomendado |
|--------|--------|---------------|---------|-------------|
| **tinyllama** | ~637MB | ⚡⚡⚡⚡⚡ Muy rápido | ⭐⭐⭐ Buena | ✅ **Mejor para CPU** |
| **phi3:mini** | ~2.3GB | ⚡⚡⚡⚡ Rápido | ⭐⭐⭐⭐ Muy buena | ✅ **Equilibrado** |
| **phi3** | ~2.5GB | ⚡⚡⚡ Moderado | ⭐⭐⭐⭐ Muy buena | Actual |
| **llama3.2:1b** | ~1.3GB | ⚡⚡⚡⚡⚡ Muy rápido | ⭐⭐⭐⭐ Muy buena | ✅ **Rápido y bueno** |
| **gemma2:2b** | ~1.6GB | ⚡⚡⚡⚡ Rápido | ⭐⭐⭐⭐ Muy buena | ✅ **Alternativa** |

### Proceso para Cambiar de Modelo

#### Paso 1: Descargar el Nuevo Modelo

```bash
# TinyLlama (el más rápido)
docker exec basdonax-ollama-local ollama pull tinyllama

# Llama 3.2 1B (rápido y de buena calidad)
docker exec basdonax-ollama-local ollama pull llama3.2:1b

# Gemma2 2B
docker exec basdonax-ollama-local ollama pull gemma2:2b

# Phi3 mini
docker exec basdonax-ollama-local ollama pull phi3:mini
```

#### Paso 2: Verificar Modelos Descargados

```bash
docker exec basdonax-ollama-local ollama list
```

Deberías ver algo como:
```
NAME              ID              SIZE      MODIFIED
phi3              latest          2.5 GB    2 hours ago
tinyllama         latest          637 MB    5 minutes ago
llama3.2:1b       latest          1.3 GB    3 minutes ago
```

#### Paso 3: Cambiar el Modelo en la Configuración

Edita el archivo `docker-compose.local.yml`:

```yaml
environment:
  - MODEL=tinyllama  # Cambia aquí
  - EMBEDDINGS_MODEL_NAME=all-MiniLM-L6-v2
  - TARGET_SOURCE_CHUNKS=5
  - OLLAMA_HOST=http://ollama:11434
  - CHROMA_HOST=chroma
  - CHROMA_PORT=8000
```

**Opciones:**
- `MODEL=tinyllama` - El más rápido
- `MODEL=llama3.2:1b` - Rápido y buena calidad
- `MODEL=gemma2:2b` - Alternativa rápida
- `MODEL=phi3:mini` - Phi3 optimizado

#### Paso 4: Reiniciar el Contenedor UI

```bash
docker restart basdonax-ui-local
```

#### Paso 5: Verificar

Espera 10-20 segundos y recarga la página: `http://localhost:8080`

Prueba haciendo una pregunta para verificar la velocidad.

---

## ⚡ Optimizar Velocidad (Sin Cambiar Modelo)

### Opción 1: Reducir el Contexto

Edita `docker-compose.local.yml`:

```yaml
environment:
  - MODEL=phi3
  - EMBEDDINGS_MODEL_NAME=all-MiniLM-L6-v2
  - TARGET_SOURCE_CHUNKS=3  # Reducir de 5 a 3 (más rápido)
```

Esto reduce la cantidad de información que el modelo procesa.

### Opción 2: Ajustar Temperatura

Edita `app/common/langchain_module.py` línea 46:

```python
llm = Ollama(model=model, callbacks=callbacks, temperature=0, base_url='http://ollama:11434')
```

Cambiar `temperature=0` a valores más bajos puede hacer respuestas más rápidas pero menos creativas.

**Después de este cambio, necesitas:**
```bash
docker restart basdonax-ui-local
```

---

## 🔄 Comparación de Velocidad (CPU)

Tiempos aproximados de respuesta en CPU promedio (4 cores):

| Modelo | Tiempo Promedio | Tokens/seg |
|--------|-----------------|------------|
| tinyllama | ~2-4 seg | 30-50 |
| llama3.2:1b | ~3-5 seg | 20-40 |
| gemma2:2b | ~4-6 seg | 15-30 |
| phi3:mini | ~5-8 seg | 10-20 |
| phi3 (actual) | ~8-15 seg | 5-15 |
| llama3 (7B) | ~20-40 seg | 2-5 |

**Recomendación:** Si Phi3 es muy lento, cambia a `llama3.2:1b` o `tinyllama`.

---

## 📊 Otros Parámetros Configurables

### Modelo de Embeddings

En `docker-compose.local.yml`:

```yaml
- EMBEDDINGS_MODEL_NAME=all-MiniLM-L6-v2  # Rápido, ligero
```

**Alternativas:**
- `all-MiniLM-L6-v2` - Rápido, ligero (actual) ✅
- `all-mpnet-base-v2` - Mejor calidad, más lento
- `paraphrase-multilingual-MiniLM-L12-v2` - Multiidioma

### Chunks de Contexto

```yaml
- TARGET_SOURCE_CHUNKS=5  # Cantidad de fragmentos a recuperar
```

- **Más chunks (7-10):** Más contexto, respuestas más completas, MÁS LENTO
- **Menos chunks (2-3):** Menos contexto, respuestas más rápidas, RÁPIDO

---

## 🧪 Probando Diferentes Configuraciones

### Test 1: Modelo Más Rápido

```yaml
environment:
  - MODEL=tinyllama
  - TARGET_SOURCE_CHUNKS=3
```

```bash
docker restart basdonax-ui-local
```

### Test 2: Balance Velocidad/Calidad

```yaml
environment:
  - MODEL=llama3.2:1b
  - TARGET_SOURCE_CHUNKS=4
```

```bash
docker restart basdonax-ui-local
```

### Test 3: Máxima Calidad (Más Lento)

```yaml
environment:
  - MODEL=phi3
  - TARGET_SOURCE_CHUNKS=7
```

```bash
docker restart basdonax-ui-local
```

---

## 🎯 Mi Recomendación para CPU

### Para Desarrollo/Pruebas Rápidas:
```yaml
environment:
  - MODEL=tinyllama
  - EMBEDDINGS_MODEL_NAME=all-MiniLM-L6-v2
  - TARGET_SOURCE_CHUNKS=3
```

### Para Uso Normal:
```yaml
environment:
  - MODEL=llama3.2:1b
  - EMBEDDINGS_MODEL_NAME=all-MiniLM-L6-v2
  - TARGET_SOURCE_CHUNKS=4
```

### Para Mejor Calidad (Más Paciencia):
```yaml
environment:
  - MODEL=phi3:mini
  - EMBEDDINGS_MODEL_NAME=all-MiniLM-L6-v2
  - TARGET_SOURCE_CHUNKS=5
```

---

## 📝 Resumen de Cambios

### ✅ Cambios que NO Requieren Rebuild

- Modificar `assistant_prompt.py` → Solo recarga la página
- Cambiar documentos → Solo recarga

### ⚠️ Cambios que Requieren Reiniciar UI

- Cambiar `MODEL` en docker-compose
- Cambiar `TARGET_SOURCE_CHUNKS`
- Cambiar `EMBEDDINGS_MODEL_NAME`

**Comando:**
```bash
docker restart basdonax-ui-local
```

### 🔨 Cambios que Requieren Rebuild

- Modificar `requirements.txt`
- Modificar `Dockerfile`
- Agregar nuevas dependencias Python

**Comando:**
```bash
.\start-local.ps1 -Build
```

---

## 🚀 Prueba Ahora

**Mi recomendación inmediata para ti:**

```bash
# 1. Descarga Llama 3.2 1B (rápido y buena calidad)
docker exec basdonax-ollama-local ollama pull llama3.2:1b

# 2. Edita docker-compose.local.yml y cambia:
#    - MODEL=llama3.2:1b

# 3. Reinicia
docker restart basdonax-ui-local

# 4. Espera 10-20 segundos y prueba
```

Deberías notar una **mejora significativa en la velocidad** (3-5x más rápido que Phi3).

---

## 📚 Recursos Adicionales

- [Lista completa de modelos Ollama](https://ollama.com/library)
- [Ollama Model Cards](https://ollama.com/library) - Información detallada de cada modelo
- Experimenta con diferentes modelos según tus necesidades

---

**¿Dudas?** Los cambios más comunes son:
1. Prompt: Edita `assistant_prompt.py` → Recarga página
2. Modelo: Edita `docker-compose.local.yml` → Reinicia UI
